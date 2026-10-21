#!/bin/bash
# PHANTOM - Uninstaller
clear

r='\033[1;91m'; g='\033[1;92m'; y='\033[1;93m'; c='\033[1;96m'; n='\033[0m'

echo -e " ${y}Do you want to restore the default terminal? (y/n)${n}"
read -p "$(echo -e ${g}[${n}+${g}]──[${n}Select${g}]────►${n} )" choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

if [[ "$choice" != "y" && "$choice" != "yes" ]]; then
    echo -e "\n ${r}Cancelled.${n}"
    exit 1
fi

echo -e "\n ${c}Restoring default terminal...${n}"

# Revert shell
if [ -d "/data/data/com.termux/files/usr/" ]; then
    chsh -s bash >/dev/null 2>&1
else
    sudo chsh -s "$(command -v bash)" "$USER" >/dev/null 2>&1
fi

rm -rf "$HOME/.oh-my-zsh" "$HOME/.zshrc" "$HOME/.zsh_history"
rm -rf "$HOME/.phantom"

if [ -d "/data/data/com.termux/files/usr/" ]; then
    rm -f "$HOME/.termux/colors.properties" "$HOME/.termux/termux.properties"
    rm -f "$PREFIX/share/figlet/phantom.flf"
    termux-reload-settings 2>/dev/null || true
else
    sudo rm -f /usr/share/figlet/phantom.flf
fi

echo -e "\n ${g}[+] PHANTOM removed successfully!${n}"
echo -e " ${y}[!] Please restart your terminal.${n}"
echo
