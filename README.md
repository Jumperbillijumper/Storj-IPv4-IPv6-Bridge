# Storj IPv4-to-IPv6 Bridge (TCP & QUIC/UDP)

[English Version](#english-version) | [Deutsche Version](#deutsche-version)

---

<a name="english-version"></a>
## English Version

A powerful solution to make Storj nodes behind IPv6 connections (DS-Lite) accessible via a cheap IPv4 VPS. Optimized for maximum performance with **TCP** and **QUIC (UDP)**.

### 💎 Support the Project
To support this script and future development, you can book your VPS via this link (available starting at only **1€/month**!):

👉 **[Get a cheap 1€ VPS at IONOS](https://acn.ionos.de/aff_c?offer_id=2&aff_id=11294&url_id=64)**  
*(Affiliate Link - Thank you for your support!)*

### 🚀 Features
- **TCP & QUIC (UDP) Support:** Optimized forwarding for maximum rewards.
- **Reboot-ready:** Automatic `systemd` services ensure permanent accessibility after a VPS restart.
- **Firewall Automation:** Automatically detects and configures `ufw`, `firewalld`, or `iptables`.
- **Idempotent:** Script can be safely re-run at any time to update or fix settings.

### 🛠️ Installation (One-Liner)
Log in to your VPS via SSH and run this command:

```bash
wget -O storj-bridge.sh https://raw.githubusercontent.com/Jumperbillijumper/Storj-IPv4-IPv6-Bridge/main/storj-bridge.sh && chmod +x storj-bridge.sh && sudo ./storj-bridge.sh
```

### 📝 Configuration Checklist
1. **Storj Node (Home):**
   - In `config.yaml`, set `contact.external-address` to your **VPS IPv4 and Port** (e.g., `1.2.3.4:28967`).
   - Open port (Default: 28967) in local firewall (Windows/Linux) for **IPv6**.
2. **Router (e.g. FritzBox):**
   - Create IPv6 port sharing for the device (TCP & UDP).
3. **VPS (Hoster Dashboard):**
   - **IMPORTANT:** Open the port for **TCP** and **UDP** in your hoster's web panel (e.g., Oracle Security Lists, IONOS Firewall). The script cannot control the external firewall of your provider.

### 🔍 Troubleshooting (QUIC)
QUIC (UDP) often takes up to 60 minutes to show "OK" in the dashboard. Check the service status:
```bash
systemctl status storj-tcp-28967
systemctl status storj-udp-28967
```

### 🤝 Community & Support
Created by [Jumperbillijumper](https://youtube.com/@Jumperbillijumper).

---

<a name="deutsche-version"></a>
## Deutsche Version

Eine leistungsstarke Lösung, um Storj-Nodes hinter IPv6-Anschlüssen (DS-Lite) über einen günstigen IPv4-VPS erreichbar zu machen. Optimiert für maximale Performance mit **TCP** und **QUIC (UDP)**.

### 💎 Unterstütze das Projekt
Um dieses Skript und zukünftige Entwicklungen zu unterstützen, kannst du deinen VPS über diesen Link buchen (schon ab **1€/Monat** verfügbar!):

👉 **[Günstigen 1€ VPS bei IONOS sichern](https://acn.ionos.de/aff_c?offer_id=2&aff_id=11294&url_id=64)**  
*(Affiliate Link - Danke für deine Unterstützung!)*

### 🚀 Features
- **TCP & QUIC (UDP) Support:** Optimierte Weiterleitung für maximale Einnahmen.
- **Reboot-sicher:** Automatische `systemd`-Dienste sorgen für dauerhafte Erreichbarkeit nach einem VPS-Neustart.
- **Firewall-Automatisierung:** Erkennt und konfiguriert `ufw`, `firewalld` oder `iptables` automatisch.
- **Idempotent:** Skript kann jederzeit sicher neu ausgeführt werden, um Einstellungen zu aktualisieren oder zu reparieren.

### 🛠️ Installation (One-Liner)
Logge dich per SSH auf deinen VPS ein und führe diesen Befehl aus:

```bash
wget -O storj-bridge.sh https://raw.githubusercontent.com/Jumperbillijumper/Storj-IPv4-IPv6-Bridge/main/storj-bridge.sh && chmod +x storj-bridge.sh && sudo ./storj-bridge.sh
```

### 📝 Konfigurations-Checkliste
1. **Storj Node (Zuhause):**
   - In der `config.yaml` muss unter `contact.external-address` die **IPv4-Adresse deines V-Servers** inkl. Port stehen (z.B. `1.2.3.4:28967`).
   - Port (Standard: 28967) in der lokalen Firewall (Windows/Linux) für **IPv6** freigeben.
2. **Router (z.B. FritzBox):**
   - IPv6-Freigabe für das Gerät erstellen (TCP & UDP).
3. **VPS (Hoster Dashboard):**
   - **WICHTIG:** Öffne den Port für **TCP** und **UDP** im Web-Panel deines Hosters (z.B. Oracle Security Lists, IONOS Firewall). Das Skript kann diese externe Firewall nicht steuern!

### 🔍 Troubleshooting (QUIC)
QUIC (UDP) braucht oft bis zu 60 Minuten, um im Dashboard "OK" anzuzeigen. Prüfe den Dienst-Status:
```bash
systemctl status storj-tcp-28967
systemctl status storj-udp-28967
```

### 🤝 Community & Support
Erstellt von [Jumperbillijumper](https://youtube.com/@Jumperbillijumper).

---

*Disclaimer: Use at your own risk. / Nutzung auf eigene Gefahr.*
