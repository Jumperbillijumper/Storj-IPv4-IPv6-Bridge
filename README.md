# Storj IPv4-to-IPv6 Bridge (TCP & QUIC/UDP)

[DE] Eine leistungsstarke Lösung, um Storj-Nodes hinter IPv6-Anschlüssen (DS-Lite) über einen IPv4-VPS erreichbar zu machen.  
[EN] A powerful solution to make Storj nodes behind IPv6 connections (DS-Lite) accessible via an IPv4 VPS.

---

## 💎 Support the Project / Unterstütze das Projekt

[DE] Um dieses Skript und zukünftige Entwicklungen zu unterstützen, kannst du deinen VPS über diesen Link buchen (schon ab 1€/Monat verfügbar!):  
[EN] To support this script and future development, you can book your VPS via this link (available starting at 1€/month!):

👉 **[Get a cheap 1€ VPS at IONOS / Günstigen 1€ VPS bei IONOS sichern](https://acn.ionos.de/aff_c?offer_id=2&aff_id=11294&url_id=64)**  
*(Affiliate Link - Thank you for your support! / Danke für deine Unterstützung!)*

---

## 🚀 Features

-   **[DE] TCP & QUIC (UDP) Support:** Optimierte Weiterleitung für maximale Einnahmen.
-   **[EN] TCP & QUIC (UDP) Support:** Optimized forwarding for maximum rewards.
-   **[DE] Reboot-sicher:** Automatische `systemd`-Dienste sorgen für dauerhafte Erreichbarkeit.
-   **[EN] Reboot-ready:** Automatic `systemd` services ensure permanent accessibility.
-   **[DE] Firewall-Automatisierung:** Erkennt und konfiguriert `ufw`, `firewalld` oder `iptables` automatisch.
-   **[EN] Firewall Automation:** Automatically detects and configures `ufw`, `firewalld`, or `iptables`.
-   **[DE] Idempotent:** Skript kann jederzeit sicher neu ausgeführt werden.
-   **[EN] Idempotent:** Script can be safely re-run at any time.

---

## 🛠️ Installation (One-Liner)

[DE] Logge dich per SSH auf deinen VPS ein und führe diesen Befehl aus:  
[EN] Log in to your VPS via SSH and run this command:

```bash
wget -O storj-bridge.sh https://raw.githubusercontent.com/Jumperbillijumper/Storj-IPv4-IPv6-Bridge/main/storj-bridge.sh && chmod +x storj-bridge.sh && sudo ./storj-bridge.sh
```

---

## 📝 Configuration Checklist / Konfigurations-Checkliste

### 1. Storj Node (Home)
-   **[DE]** IPv6-Adresse in der `config.yaml` hinterlegen.
-   **[EN]** Add your IPv6 address to `config.yaml`.
-   **[DE]** Port (Standard: 28967) in der lokalen Firewall (Windows/Linux) für **IPv6** freigeben.
-   **[EN]** Open port (Default: 28967) in local firewall (Windows/Linux) for **IPv6**.

### 2. Router (e.g. FritzBox)
-   **[DE]** IPv6-Freigabe für das Gerät erstellen (TCP & UDP).
-   **[EN]** Create IPv6 port sharing for the device (TCP & UDP).

### 3. VPS (Hoster Dashboard)
-   **[DE] WICHTIG:** Öffne den Port für **TCP** und **UDP** im Web-Panel deines Hosters (z.B. Oracle Security Lists, IONOS Firewall).
-   **[EN] IMPORTANT:** Open the port for **TCP** and **UDP** in your hoster's web panel (e.g., Oracle Security Lists, IONOS Firewall).

---

## 🔍 Troubleshooting (QUIC)

[DE] QUIC (UDP) braucht oft bis zu 60 Minuten, um im Dashboard "OK" anzuzeigen. Prüfe den Dienst-Status:  
[EN] QUIC (UDP) often takes up to 60 minutes to show "OK" in the dashboard. Check the service status:

```bash
systemctl status storj-tcp-28967
systemctl status storj-udp-28967
```

---

## 🤝 Community & Support

[DE] Erstellt von [Jumperbillijumper](https://youtube.com/@Jumperbillijumper).  
[EN] Created by [Jumperbillijumper](https://youtube.com/@Jumperbillijumper).

---

*Disclaimer: Use at your own risk. / Nutzung auf eigene Gefahr.*
