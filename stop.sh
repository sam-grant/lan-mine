#!/bin/bash
# lan-mine stop script

# Colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}      Stopping lan-mine${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

# Check if PID file exists
if [ ! -f .lan-mine.pid ]; then
    echo -e "${YELLOW}No PID file found${NC}"
    
    # Try to find the process anyway
    PIDS=$(pgrep -f "python.*app.py")
    if [ -z "$PIDS" ]; then
        echo -e "${RED}lan-mine is not running${NC}"
        exit 1
    else
        echo -e "${YELLOW}Found running process(es): $PIDS${NC}"
        echo -e "${CYAN}Killing process(es)...${NC}"
        kill $PIDS 2>/dev/null
        sleep 1
        
        # Force kill if still running
        PIDS=$(pgrep -f "python.*app.py")
        if [ ! -z "$PIDS" ]; then
            echo -e "${YELLOW}Force killing...${NC}"
            kill -9 $PIDS 2>/dev/null
        fi
        
        echo -e "${GREEN}✓ lan-mine stopped${NC}"
        exit 0
    fi
fi

# Read PID from file
PID=$(cat .lan-mine.pid)

# Check if process is running
if ! ps -p $PID > /dev/null 2>&1; then
    echo -e "${YELLOW}Process (PID: $PID) not found${NC}"
    echo -e "${GREEN}Cleaning up PID file...${NC}"
    rm .lan-mine.pid
    echo -e "${GREEN}✓ Done${NC}"
    exit 0
fi

# Stop the process
echo -e "${CYAN}Stopping lan-mine (PID: $PID)...${NC}"
kill $PID 2>/dev/null

# Wait for graceful shutdown
for i in {1..5}; do
    if ! ps -p $PID > /dev/null 2>&1; then
        echo -e "${GREEN}✓ lan-mine stopped successfully${NC}"
        rm .lan-mine.pid
        exit 0
    fi
    sleep 1
done

# Force kill if still running
if ps -p $PID > /dev/null 2>&1; then
    echo -e "${YELLOW}Force stopping...${NC}"
    kill -9 $PID 2>/dev/null
    sleep 1
fi

# Verify stopped
if ps -p $PID > /dev/null 2>&1; then
    echo -e "${RED}✗ Failed to stop lan-mine${NC}"
    exit 1
else
    echo -e "${GREEN}✓ lan-mine stopped${NC}"
    rm .lan-mine.pid
fi

echo ""
