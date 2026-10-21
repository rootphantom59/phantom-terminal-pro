#!/data/data/com.termux/files/usr/bin/bash

# Load Configuration
CONFIG_FILE="$HOME/.phantom/config.sh"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    BANNER_TEXT="PHANTOM"
    USER_NAME="Root-Phantom"
    HOST_NAME="kali"
fi

clear

# Display Figlet with Phantom Font & Rainbow Colors
figlet -f "phantom" "$BANNER_TEXT" | lolcat

echo -e "\033[0;36mSYSTEM: \033[0;32mONLINE\033[0;36m  | USER: \033[0;33m${USER_NAME}\033[0m"
echo -e "\033[0;36mHOST  : \033[0;37m${HOST_NAME}\033[0m"
echo -e "\033[0;35mTYPE '\033[1;32mpxhelp\033[0;35m' FOR COMMAND LIST\033[0m"
echo -e "\033[0;36m─────────────────────────────────────────────────────────────\033[0m"