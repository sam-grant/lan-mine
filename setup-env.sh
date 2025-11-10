#!/bin/bash
# Setup virtual environment and install dependencies for lan-mine

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   lan-mine Environment Setup            ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗ Python 3 not found${NC}"
    echo -e "${YELLOW}Please install Python 3.7 or later${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo -e "${CYAN}Python version: ${GREEN}${PYTHON_VERSION}${NC}"

# Check for Python development headers (needed for netifaces compilation)
if ! dpkg -s python3-dev >/dev/null 2>&1 && ! rpm -q python3-devel >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠ Python development headers not found${NC}"
    echo -e "${CYAN}Installing python3-dev...${NC}"
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y python3-dev gcc
        if [ $? -ne 0 ]; then
            echo -e "${RED}✗ Failed to install python3-dev${NC}"
            echo -e "${YELLOW}Please run: ${CYAN}sudo apt-get install python3-dev gcc${NC}"
            exit 1
        fi
    elif command -v yum &> /dev/null; then
        sudo yum install -y python3-devel gcc
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm python gcc
    else
        echo -e "${RED}✗ Could not install python3-dev automatically${NC}"
        echo -e "${YELLOW}Please install manually:${NC}"
        echo -e "  Debian/Ubuntu/Raspberry Pi: ${CYAN}sudo apt-get install python3-dev gcc${NC}"
        echo -e "  Fedora/RHEL:                ${CYAN}sudo yum install python3-devel gcc${NC}"
        echo -e "  Arch:                       ${CYAN}sudo pacman -S python gcc${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Python development headers installed${NC}"
fi
echo ""

# Check if venv already exists
if [ -d "venv" ]; then
    echo -e "${YELLOW}⚠ Virtual environment already exists${NC}"
    read -p "Delete and recreate? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Removing existing venv...${NC}"
        rm -rf venv
    else
        echo -e "${GREEN}✓ Using existing venv${NC}"
        echo ""
        echo -e "${CYAN}To activate:${NC}"
        echo -e "  ${GREEN}source venv/bin/activate${NC}"
        echo ""
        echo -e "${CYAN}To run lan-mine:${NC}"
        echo -e "  ${GREEN}sudo venv/bin/python3 app.py${NC}"
        exit 0
    fi
fi

# Create virtual environment
echo -e "${CYAN}Creating virtual environment...${NC}"
python3 -m venv venv

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Failed to create virtual environment${NC}"
    echo -e "${YELLOW}You may need to install python3-venv:${NC}"
    echo -e "  Debian/Ubuntu: ${CYAN}sudo apt-get install python3-venv${NC}"
    echo -e "  Fedora/RHEL:   ${CYAN}sudo yum install python3-virtualenv${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Virtual environment created${NC}"
echo ""

# Activate virtual environment
echo -e "${CYAN}Installing dependencies...${NC}"
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip > /dev/null 2>&1

# Install dependencies
if [ -f "pyproject.toml" ]; then
    pip install . > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Dependencies installed from pyproject.toml${NC}"
    else
        echo -e "${RED}✗ Failed to install dependencies${NC}"
        exit 1
    fi
elif [ -f "requirements.txt" ]; then
    pip install -r requirements.txt > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Dependencies installed from requirements.txt${NC}"
    else
        echo -e "${RED}✗ Failed to install dependencies${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ No pyproject.toml or requirements.txt found${NC}"
    exit 1
fi

# Deactivate
deactivate

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Setup Complete!                     ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Virtual environment ready at: ${GREEN}venv/${NC}"
echo ""
echo -e "${CYAN}To activate the virtual environment:${NC}"
echo -e "  ${GREEN}source venv/bin/activate${NC}"
echo ""
echo -e "${CYAN}To run lan-mine:${NC}"
echo -e "  ${GREEN}sudo venv/bin/python3 app.py${NC}"
echo -e "  ${CYAN}or${NC}"
echo -e "  ${GREEN}sudo -E env PATH=\$PATH python3 app.py${NC} ${YELLOW}(after activating)${NC}"
echo ""
echo -e "${CYAN}To deactivate when done:${NC}"
echo -e "  ${GREEN}deactivate${NC}"
echo ""
