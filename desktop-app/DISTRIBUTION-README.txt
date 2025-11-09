╔══════════════════════════════════════════════════════════════╗
║                        lan-mine                              ║
║                  Network Device Scanner                      ║
╚══════════════════════════════════════════════════════════════╝

Quick start guide for recipients

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPER EASY INSTALLATION (recommended)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Linux:
1. Make sure launch-linux.sh and lan-mine-1.0.0-linux.tar.gz 
   are in the same folder
2. Double-click launch-linux.sh
3. Follow the prompts

macOS:
1. Make sure launch-macos.command and lan-mine-1.0.0-macos.tar.gz 
   are in the same folder
2. Double-click launch-macos.command
3. Follow the prompts

That's it! The launcher will:
• Extract the package
• Install nmap if needed (you may need to enter your password)
• Start lan-mine automatically
• Open your browser to http://localhost:5000

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MANUAL INSTALLATION (if you prefer terminal)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Linux/macOS:
$ tar -xzf lan-mine-1.0.0-linux.tar.gz
$ cd lan-mine-1.0.0-linux
$ ./install.sh
$ sudo ./lan-mine

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WHAT IS LAN-MINE?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A simple, terminal-style web UI that scans your local network and
displays all connected devices with their IP addresses, hostnames, 
MAC addresses, and vendor information.

Features:
• Quick network scanning - Discover devices in seconds
• Terminal-style dark UI with cyan accents
• Real-time activity log
• Gateway detection
• No installation on your system - runs as standalone executable

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• nmap (installed automatically by launcher or install.sh)
• Modern web browser
• sudo/administrator access (optional but recommended)

Note: lan-mine works without sudo but with limited functionality:
  ✓ With sudo: Full detection including MAC addresses and vendors
  ⚠ Without sudo: IP addresses and hostnames only (no MAC/vendor info)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TROUBLESHOOTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Launcher won't run:
→ Make sure it's executable: chmod +x launch-linux.sh
→ Run from terminal to see error messages

Browser doesn't open:
→ Manually open http://localhost:5000

Don't have sudo access:
→ lan-mine will run in limited mode automatically
→ You'll see IP addresses and hostnames
→ MAC addresses and vendor info won't be available

Already extracted but want to run again:
→ Just double-click the launcher again
→ Or run: sudo ./lan-mine (or ./lan-mine without sudo)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECURITY NOTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• This tool is designed for LOCAL network use only
• Always run on trusted networks
• Scanning networks you don't own may be illegal

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For more info: https://github.com/sam-grant/lan-mine
Version: 1.0.0
