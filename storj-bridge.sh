#!/bin/bash
# =========================================================================
# Storj IPv4-to-IPv6 Bridge (TCP & QUIC/UDP)
# Optimiert für YouTube Rollout & GitHub
# Autor: Jumperbillijumper
# =========================================================================

set -e

# 1. Root-Check
if [[ $EUID -ne 0 ]]; then
   echo "==============================================================="
   echo " FEHLER: Dieses Skript muss als ROOT ausgeführt werden!"
   echo " Bitte nutze: sudo ./$(basename "$0")"
   echo "==============================================================="
   exit 1
fi

echo "==============================================================="
echo "   Storj IPv4-to-IPv6 Port Forwarder (Universal Version)       "
echo "   Optimiert für TCP und QUIC (UDP) Performance                "
echo "==============================================================="
echo

# 2. Abhängigkeiten prüfen/installieren
echo "[+] Prüfe Abhängigkeiten (socat)..."
if ! command -v socat &> /dev/null; then
    echo "[!] Socat nicht gefunden. Installiere..."
    if command -v apt-get &> /dev/null; then
        apt-get update -y && apt-get install socat -y
    elif command -v yum &> /dev/null; then
        yum install socat -y
    else
        echo "FEHLER: Paketmanager nicht unterstützt. Bitte installiere 'socat' manuell."
        exit 1
    fi
fi

# 3. Benutzereingaben
echo "--- KONFIGURATION ---"

# Versuche die öffentliche IPv4 für die Anzeige zu ermitteln (Optional)
VPS_IPV4=$(curl -s -4 https://ifconfig.me || hostname -I | awk '{print $1}')
echo "VPS IPv4 (erkannt): $VPS_IPV4 (Script wird auf allen Interfaces horchen)"

read -rp "IPv6 deiner Storj-Node (z.B. fdc0:...): " STORJ_IPV6
read -rp "Storj Port (Standard 28967): " STORJ_PORT
STORJ_PORT=${STORJ_PORT:-28967}

# Validierung
if [[ -z "$STORJ_IPV6" ]]; then
    echo "[!] FEHLER: Keine IPv6 angegeben. Skript abgebrochen."
    exit 1
fi

echo
echo "Zusammenfassung:"
echo "VPS Eingang (IPv4) : $VPS_IPV4:$STORJ_PORT (0.0.0.0)"
echo "Ziel Node (IPv6)    : [$STORJ_IPV6]"
echo "Ziel Port (IPv6)    : $STORJ_PORT"
echo "----------------------"
echo

read -rp "Konfiguration jetzt anwenden? (y/n): " CONFIRM
[[ "$CONFIRM" != "y" ]] && exit 1

# 4. BEREINIGUNG (Wichtig für das Update von der alten Version)
echo "[+] Bereinige alte Socat-Dienste (falls vorhanden)..."
# Alte Namen aus der Vorversion stoppen
systemctl stop storj-forward-tcp storj-forward-udp 2>/dev/null || true
systemctl disable storj-forward-tcp storj-forward-udp 2>/dev/null || true
rm -f /etc/systemd/system/storj-forward-tcp.service /etc/systemd/system/storj-forward-udp.service

# Dienste dieser Version stoppen (falls Re-Run)
systemctl stop "storj-tcp-$STORJ_PORT" "storj-udp-$STORJ_PORT" 2>/dev/null || true

# 5. Firewall konfigurieren (Intern)
echo "[+] Öffne Firewall-Ports (intern)..."
if command -v ufw &> /dev/null; then
    ufw allow "$STORJ_PORT"/tcp >/dev/null 2>&1
    ufw allow "$STORJ_PORT"/udp >/dev/null 2>&1
elif command -v firewall-cmd &> /dev/null; then
    firewall-cmd --add-port="$STORJ_PORT"/tcp --permanent >/dev/null 2>&1
    firewall-cmd --add-port="$STORJ_PORT"/udp --permanent >/dev/null 2>&1
    firewall-cmd --reload >/dev/null 2>&1
else
    # Fallback zu direktem iptables
    iptables -I INPUT -p tcp --dport "$STORJ_PORT" -j ACCEPT 2>/dev/null || true
    iptables -I INPUT -p udp --dport "$STORJ_PORT" -j ACCEPT 2>/dev/null || true
fi

# 6. Systemd Services erstellen (Reboot-fest)
echo "[+] Erstelle Systemd-Dienste..."

# TCP Service
cat <<EOF > "/etc/systemd/system/storj-tcp-$STORJ_PORT.service"
[Unit]
Description=Storj TCP Forwarder (Port $STORJ_PORT)
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat TCP4-LISTEN:${STORJ_PORT},fork,reuseaddr TCP6:[${STORJ_IPV6}]:${STORJ_PORT}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# UDP (QUIC) Service - OPTIMIERT FÜR STABILITÄT
cat <<EOF > "/etc/systemd/system/storj-udp-$STORJ_PORT.service"
[Unit]
Description=Storj UDP QUIC Forwarder (Port $STORJ_PORT)
After=network.target

[Service]
Type=simple
# QUIC Optimierung: fork erlaubt parallele Streams, reuseaddr verhindert Bind-Fehler
ExecStart=/usr/bin/socat UDP4-LISTEN:${STORJ_PORT},fork,reuseaddr UDP6:[${STORJ_IPV6}]:${STORJ_PORT}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 7. Aktivieren und Starten
echo "[+] Starte Dienste..."
systemctl daemon-reload
systemctl enable "storj-tcp-$STORJ_PORT.service" >/dev/null 2>&1
systemctl enable "storj-udp-$STORJ_PORT.service" >/dev/null 2>&1
systemctl start "storj-tcp-$STORJ_PORT.service"
systemctl start "storj-udp-$STORJ_PORT.service"

echo
echo "==============================================================="
echo "   [✓] SETUP ERFOLGREICH ABGESCHLOSSEN!                        "
echo "==============================================================="
echo " Status TCP: $(systemctl is-active "storj-tcp-$STORJ_PORT")"
echo " Status UDP: $(systemctl is-active "storj-udp-$STORJ_PORT")"
echo
echo "--- WICHTIGE HINWEISE FÜR DEN ERFOLG ---"
echo "1. STORJ CONFIG: Trage in deiner config.yaml (zuhause) die IP deines"
echo "   V-Servers als external-address ein! (z.B. $VPS_IPV4:$STORJ_PORT)"
echo "2. EXTERNE FIREWALL: Prüfe das Web-Panel deines Hosters (Oracle, Ionos, etc.)"
echo "   Dort muss der Port $STORJ_PORT für TCP UND UDP (!!!) offen sein."
echo "3. LOKALE FIREWALL: Dein PC/Server muss IPv6 Traffic auf Port $STORJ_PORT erlauben."
echo "4. FRITZBOX: IPv6-Freigabe für UDP $STORJ_PORT muss aktiv sein."
echo "5. GEDULD: QUIC kann bis zu 60 Minuten dauern, bis es im Dashboard grün wird."
echo "==============================================================="
