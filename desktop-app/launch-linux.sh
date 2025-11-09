#!/bin/bash
# lan-mine launcher for Linux
# Double-click this script to extract, install, and run lan-mine

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         lan-mine Launcher                ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# Find the tar.gz file
TARBALL=$(ls lan-mine-*-linux.tar.gz 2>/dev/null | head -1)

if [ -z "$TARBALL" ]; then
    echo -e "${RED}✗ Error: No lan-mine package found${NC}"
    echo -e "${YELLOW}Please place this script in the same directory as:${NC}"
    echo -e "  lan-mine-1.0.0-linux.tar.gz"
    echo ""
    read -p "Press Enter to exit..."
    exit 1
fi

# Extract version and directory name from tarball
DIR_NAME="${TARBALL%.tar.gz}"

echo -e "${CYAN}Found package: ${GREEN}$TARBALL${NC}"
echo ""

# Check if already extracted
if [ -d "$DIR_NAME" ]; then
    echo -e "${YELLOW}⚠ Directory already exists: $DIR_NAME${NC}"
    read -p "Delete and re-extract? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$DIR_NAME"
    else
        echo -e "${CYAN}Using existing directory${NC}"
        cd "$DIR_NAME"
        echo ""
        echo -e "${CYAN}Starting lan-mine...${NC}"
        echo ""
        # Check sudo access and run appropriately
        if sudo -n true 2>/dev/null || sudo -v 2>/dev/null; then
            sudo ./lan-mine
        else
            echo -e "${YELLOW}⚠ No sudo access - running in limited mode${NC}"
            ./lan-mine
        fi
        exit 0
    fi
fi

# Extract
echo -e "${CYAN}Extracting package...${NC}"
tar -xzf "$TARBALL"

if [ ! -d "$DIR_NAME" ]; then
    echo -e "${RED}✗ Extraction failed${NC}"
    read -p "Press Enter to exit..."
    exit 1
fi

echo -e "${GREEN}✓ Package extracted${NC}"
echo ""

# Change to extracted directory
cd "$DIR_NAME"

# Run installer
echo -e "${CYAN}Running installer...${NC}"
echo ""
./install.sh

if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}✗ Installation failed${NC}"
    read -p "Press Enter to exit..."
    exit 1
fi

# Run lan-mine
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║      Starting lan-mine...                ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Your browser will open automatically${NC}"
echo -e "${CYAN}If not, navigate to: ${GREEN}http://localhost:5000${NC}"
echo ""

# Check if user has sudo access
if sudo -n true 2>/dev/null; then
    # Can use sudo without password
    echo -e "${GREEN}✓ Running with sudo (full functionality)${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop lan-mine${NC}"
    echo ""
    sleep 2
    sudo ./lan-mine
elif sudo -v 2>/dev/null; then
    # Prompted for password and succeeded
    echo -e "${GREEN}✓ Running with sudo (full functionality)${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop lan-mine${NC}"
    echo ""
    sleep 2
    sudo ./lan-mine
else
    # No sudo access
    echo -e "${YELLOW}⚠ No sudo access - running in limited mode${NC}"
    echo -e "${CYAN}MAC addresses and vendor info will not be available${NC}"
    echo -e "${CYAN}IP addresses and hostnames will still be detected${NC}"
    echo ""
    echo -e "${YELLOW}Press Ctrl+C to stop lan-mine${NC}"
    echo ""
    sleep 2
    ./lan-mine
fi
