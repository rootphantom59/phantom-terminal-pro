#!/bin/bash

# ANSI Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}[*] Updating packages and installing dependencies...${NC}"
pkg update -y > /dev/null 2>&1
pkg install python git -y > /dev/null 2>&1

echo -e "${CYAN}[*] Installing Python requirements...${NC}"
pip install -r requirements.txt --break-system-packages > /dev/null 2>&1

echo -e "${CYAN}[*] Making phantom.py executable...${NC}"
chmod +x phantom.py

echo -e "${CYAN}[*] Running configuration wizard...${NC}"
python phantom.py --setup

echo -e "${CYAN}[*] Injecting into .bashrc...${NC}"
if ! grep -q "phantom.py --banner" ~/.bashrc; then
    echo "python $PWD/phantom.py --banner" >> ~/.bashrc
    echo "alias pxhelp='python $PWD/phantom.py --pxhelp'" >> ~/.bashrc
fi

echo -e "${GREEN}[+] Installation complete!${NC}"
echo -e "${GREEN}[+] Restart Termux or run 'source ~/.bashrc' to see the banner.${NC}"