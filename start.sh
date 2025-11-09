#!/bin/bash
# lan-mine start script

# Colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}      Starting lan-mine${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Check if already running
if [ -f .lan-mine.pid ]; then
    PID=$(cat .lan-mine.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo -e "${RED}Error: lan-mine is already running (PID: $PID)${NC}"
        echo -e "Use ${CYAN}./stop.sh${NC} to stop it first"
        exit 1
    else
        # Stale PID file
        rm .lan-mine.pid
    fi
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo -e "${RED}Error: Virtual environment not found${NC}"
    echo -e "Run: ${CYAN}python3 -m venv venv && source venv/bin/activate && pip install .${NC}"
    exit 1
fi

# Check for nmap
if ! command -v nmap &> /dev/null; then
    echo -e "${RED}Warning: nmap not found${NC}"
    echo -e "Install with: ${CYAN}sudo apt-get install nmap${NC}"
fi

# Start the server
echo -e "${GREEN}Starting server...${NC}"
echo ""

# Use sudo if requested
if [ "$1" == "--sudo" ] || [ "$1" == "-s" ]; then
    echo -e "${CYAN}Running with sudo for enhanced MAC detection${NC}"
    echo -e "${YELLOW}You will be prompted for your password...${NC}"
    echo ""
    
    # Get absolute path to python
    PYTHON_PATH="$(pwd)/venv/bin/python3"
    
    # First authenticate sudo (this waits for password)
    if ! sudo -v; then
        echo -e "${RED}✗ Failed to authenticate${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Starting server...${NC}"
    
    # Now start the server in background
    sudo -E "$PYTHON_PATH" app.py > lan-mine.log 2>&1 &
    SUDO_PID=$!
    
    # Wait for actual python process
    sleep 3
    
    # Find the actual python process (child of sudo)
    PID=$(pgrep -P $SUDO_PID)
    if [ -z "$PID" ]; then
        PID=$SUDO_PID
    fi
    
    echo $PID > .lan-mine.pid
    
    if ps -p $PID > /dev/null 2>&1; then
        echo -e "${GREEN}✓ lan-mine started successfully (PID: $PID)${NC}"
        echo -e "${GREEN}✓ Running with elevated privileges${NC}"
    else
        echo -e "${RED}✗ Failed to start lan-mine${NC}"
        echo -e "${YELLOW}Check lan-mine.log for details${NC}"
        rm .lan-mine.pid
        exit 1
    fi
else
    venv/bin/python3 app.py > lan-mine.log 2>&1 &
    PID=$!
    echo $PID > .lan-mine.pid
    
    # Wait a moment to check if it started
    sleep 2
    if ps -p $PID > /dev/null 2>&1; then
        echo -e "${GREEN}✓ lan-mine started successfully (PID: $PID)${NC}"
        echo -e "${CYAN}Note: Run with --sudo for enhanced MAC detection${NC}"
    else
        echo -e "${RED}✗ Failed to start lan-mine${NC}"
        echo -e "${YELLOW}Check lan-mine.log for details${NC}"
        rm .lan-mine.pid
        exit 1
    fi
fi

echo ""
echo -e "${CYAN}Access the web UI at:${NC}"
echo -e "  • ${GREEN}http://localhost:5000${NC}"
echo -e "  • ${GREEN}http://$(hostname -I | awk '{print $1}'):5000${NC}"
echo ""
echo -e "${CYAN}Commands:${NC}"
echo -e "  • View logs: ${GREEN}tail -f lan-mine.log${NC}"
echo -e "  • Stop server: ${GREEN}./stop.sh${NC}"
echo ""
