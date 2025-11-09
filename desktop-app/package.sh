#!/bin/bash
# Package distribution script for lan-mine

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  Creating Distribution Packages${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Check if executable exists
if [ ! -f "dist/lan-mine" ]; then
    echo -e "${RED}Error: Executable not found${NC}"
    echo -e "Run ${CYAN}./build.sh${NC} first"
    exit 1
fi

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     PLATFORM="linux";;
    Darwin*)    PLATFORM="macos";;
    *)          echo -e "${RED}Unsupported OS: $OS${NC}"; exit 1;;
esac

VERSION="1.0.0"
PACKAGE_NAME="lan-mine-${VERSION}-${PLATFORM}"
PACKAGE_DIR="packages/${PACKAGE_NAME}"

echo -e "${CYAN}Building package for: ${GREEN}${PLATFORM}${NC}"
echo ""

# Clean and create package directory
rm -rf packages
mkdir -p "$PACKAGE_DIR"

# Copy executable
echo -e "${CYAN}Copying executable...${NC}"
cp dist/lan-mine "$PACKAGE_DIR/"
chmod +x "$PACKAGE_DIR/lan-mine"

# Copy appropriate launcher script
echo -e "${CYAN}Copying launcher script...${NC}"
if [ "$PLATFORM" == "linux" ]; then
    cp launch-linux.sh "$PACKAGE_DIR/"
    chmod +x "$PACKAGE_DIR/launch-linux.sh"
else
    cp launch-macos.command "$PACKAGE_DIR/"
    chmod +x "$PACKAGE_DIR/launch-macos.command"
fi

# Create README
echo -e "${CYAN}Creating README...${NC}"
cat > "$PACKAGE_DIR/README.txt" << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                        lan-mine                              ║
║                  Network Device Scanner                      ║
╚══════════════════════════════════════════════════════════════╝

A simple, terminal-style web UI for scanning and monitoring all
devices on your local network.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUICK START
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Install nmap (if not already installed):
   
   Linux (Debian/Ubuntu):
   $ sudo apt-get install nmap
   
   macOS:
   $ brew install nmap

2. Run lan-mine:
   
   $ sudo ./lan-mine
   
   (sudo is required for full network scanning capabilities)

3. Your browser will open automatically to http://localhost:5000
   
   If it doesn't open, manually navigate to:
   http://localhost:5000

4. Click "Scan Network" to discover devices

5. Press Ctrl+C in the terminal to stop

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FEATURES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• Quick network scanning - Discover all devices in seconds
• Device information - IP addresses, hostnames, MAC addresses, vendors
• Terminal-style UI - Dark theme with cyan accents
• Activity log - Monitor network scanning activity in real-time
• Gateway detection - Automatically identifies your router
• Status badges - Color-coded device status indicators

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Runtime:
• nmap (network scanning tool)
• Modern web browser
• sudo/administrator access for network scanning

The executable includes:
✓ Python runtime
✓ Flask web server
✓ All dependencies

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TROUBLESHOOTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Browser doesn't open automatically:
→ Manually open http://localhost:5000

"nmap not found" error:
→ Install nmap (see Quick Start step 1)

Permission denied:
→ Run with sudo: sudo ./lan-mine

Port 5000 already in use:
→ Stop other services using port 5000
→ Or modify the port in the executable

Can't detect some devices:
→ Ensure you're running with sudo
→ Some devices may have firewalls blocking discovery

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECURITY NOTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• This tool is designed for LOCAL network use only
• Always run on trusted networks
• Scanning networks you don't own may be illegal
• The web interface is accessible to anyone on your network

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
LICENSE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MIT License - Free to use, modify, and distribute

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUPPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

For issues and updates, visit:
https://github.com/sam/lan-mine

Version: 1.0.0
EOF

# Create install script
echo -e "${CYAN}Creating install script...${NC}"
if [ "$PLATFORM" == "linux" ]; then
    cat > "$PACKAGE_DIR/install.sh" << 'EOF'
#!/bin/bash
# lan-mine installer for Linux

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         lan-mine Installer               ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# Check if nmap is installed
if command -v nmap &> /dev/null; then
    echo -e "${GREEN}✓ nmap is already installed${NC}"
else
    echo -e "${YELLOW}⚠ nmap not found${NC}"
    echo -e "${CYAN}Installing nmap...${NC}"
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y nmap
    elif command -v yum &> /dev/null; then
        sudo yum install -y nmap
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm nmap
    else
        echo -e "${RED}✗ Could not install nmap automatically${NC}"
        echo -e "${YELLOW}Please install nmap manually:${NC}"
        echo -e "  Debian/Ubuntu: ${CYAN}sudo apt-get install nmap${NC}"
        echo -e "  Fedora/RHEL:   ${CYAN}sudo yum install nmap${NC}"
        echo -e "  Arch:          ${CYAN}sudo pacman -S nmap${NC}"
        exit 1
    fi
    
    if command -v nmap &> /dev/null; then
        echo -e "${GREEN}✓ nmap installed successfully${NC}"
    else
        echo -e "${RED}✗ nmap installation failed${NC}"
        exit 1
    fi
fi

# Make executable
chmod +x lan-mine

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Installation Complete!              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}To run lan-mine:${NC}"
echo -e "  ${GREEN}sudo ./lan-mine${NC}"
echo ""
echo -e "${CYAN}See README.txt for more information${NC}"
echo ""
EOF
    chmod +x "$PACKAGE_DIR/install.sh"

else  # macOS
    cat > "$PACKAGE_DIR/install.sh" << 'EOF'
#!/bin/bash
# lan-mine installer for macOS

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         lan-mine Installer               ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}⚠ Homebrew not found${NC}"
    echo -e "${CYAN}Install Homebrew from: ${GREEN}https://brew.sh${NC}"
    echo ""
    echo -e "${CYAN}Then install nmap:${NC}"
    echo -e "  ${GREEN}brew install nmap${NC}"
    exit 1
fi

# Check if nmap is installed
if command -v nmap &> /dev/null; then
    echo -e "${GREEN}✓ nmap is already installed${NC}"
else
    echo -e "${YELLOW}⚠ nmap not found${NC}"
    echo -e "${CYAN}Installing nmap via Homebrew...${NC}"
    brew install nmap
    
    if command -v nmap &> /dev/null; then
        echo -e "${GREEN}✓ nmap installed successfully${NC}"
    else
        echo -e "${RED}✗ nmap installation failed${NC}"
        exit 1
    fi
fi

# Make executable
chmod +x lan-mine

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Installation Complete!              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}To run lan-mine:${NC}"
echo -e "  ${GREEN}sudo ./lan-mine${NC}"
echo ""
echo -e "${CYAN}See README.txt for more information${NC}"
echo ""
EOF
    chmod +x "$PACKAGE_DIR/install.sh"
fi

# Create tarball
echo -e "${CYAN}Creating archive...${NC}"
cd packages
tar -czf "${PACKAGE_NAME}.tar.gz" "$PACKAGE_NAME"
cd ..

# Get file size
SIZE=$(du -h "packages/${PACKAGE_NAME}.tar.gz" | cut -f1)

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Package Created Successfully!       ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Package:${NC} ${GREEN}packages/${PACKAGE_NAME}.tar.gz${NC}"
echo -e "${CYAN}Size:${NC}    ${GREEN}${SIZE}${NC}"
echo ""
echo -e "${CYAN}To distribute:${NC}"
echo -e "  1. Share the package: ${GREEN}packages/${PACKAGE_NAME}.tar.gz${NC}"
if [ "$PLATFORM" == "linux" ]; then
    echo -e "  2. Include launcher: ${GREEN}launch-linux.sh${NC}"
    echo -e "  3. Users double-click: ${GREEN}launch-linux.sh${NC}"
else
    echo -e "  2. Include launcher: ${GREEN}launch-macos.command${NC}"
    echo -e "  3. Users double-click: ${GREEN}launch-macos.command${NC}"
fi
echo ""
echo -e "${CYAN}The launcher script will:${NC}"
echo -e "  • Extract the package"
echo -e "  • Install nmap if needed"
echo -e "  • Run lan-mine automatically"
echo ""
