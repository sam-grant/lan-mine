#!/bin/bash
# Build script for lan-mine desktop app

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}  Building lan-mine Desktop App${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Check if we're in desktop-app directory
if [ ! -f "main.py" ]; then
    echo -e "${RED}Error: Run this from desktop-app directory${NC}"
    exit 1
fi

# Check if venv exists, create if not
if [ ! -d "venv" ]; then
    echo -e "${CYAN}Creating virtual environment...${NC}"
    python3 -m venv venv
fi

# Activate venv
source venv/bin/activate

# Install dependencies
echo -e "${CYAN}Installing dependencies...${NC}"
pip install -q --upgrade pip
pip install -q -r requirements.txt

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Failed to install dependencies${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Build with PyInstaller
echo -e "${CYAN}Building executable with PyInstaller...${NC}"
echo -e "${YELLOW}This may take a few minutes...${NC}"
echo ""

pyinstaller --clean --noconfirm \
    --name="lan-mine" \
    --onefile \
    --add-data="../app.py:." \
    --add-data="../templates:templates" \
    --add-data="../static:static" \
    --hidden-import="flask" \
    --hidden-import="flask.cli" \
    --hidden-import="flask.json" \
    --hidden-import="werkzeug" \
    --hidden-import="jinja2" \
    --hidden-import="click" \
    --hidden-import="netifaces" \
    --hidden-import="ipaddress" \
    --hidden-import="subprocess" \
    --hidden-import="datetime" \
    --hidden-import="socket" \
    --hidden-import="re" \
    --collect-all flask \
    --collect-all werkzeug \
    main.py

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}  Build Successful!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo -e "${CYAN}Executable location:${NC}"
    echo -e "  ${GREEN}$(pwd)/dist/lan-mine${NC}"
    echo ""
    
    # Get file size
    SIZE=$(du -h dist/lan-mine | cut -f1)
    echo -e "${CYAN}File size: ${GREEN}${SIZE}${NC}"
    echo ""
    
    echo -e "${CYAN}To run:${NC}"
    echo -e "  ${GREEN}sudo ./dist/lan-mine${NC}"
    echo -e "${YELLOW}  (sudo required for nmap network scanning)${NC}"
    echo ""
    
    echo -e "${CYAN}To share:${NC}"
    echo -e "  Copy ${GREEN}dist/lan-mine${NC} to another machine"
    echo -e "  Recipients need: nmap installed, run with sudo"
    echo ""
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi
