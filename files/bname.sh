#!/bin/bash
# PHANTOM - Change banner/prompt name
clear

r='\033[1;91m'; g='\033[1;92m'; y='\033[1;93m'; c='\033[1;96m'; n='\033[0m'
E="${r}[×]${n}"

CONFIG_DIR="$HOME/.phantom"
CONFIG_FILE="$CONFIG_DIR/config"
BANNER_SCRIPT="$CONFIG_DIR/banner.sh"
THEME="$HOME/.oh-my-zsh/custom/themes/phantom.zsh-theme"

if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "\n ${r}[×] Error: PHANTOM is not installed yet. Run install.sh first.${n}"
    exit 1
fi

source "$CONFIG_FILE"
CURRENT_NAME="$PHANTOM_USER"
CURRENT_BANNER="$PHANTOM_BANNER"

echo -e " ${c}[+] Current Prompt User: ${g}${CURRENT_NAME}${n}"
echo -e " ${c}[+] Current Banner Text: ${g}${CURRENT_BANNER}${n}"
echo

# New Banner Text
read -p "$(echo -e ${g}[${n}+${g}]──[${n}Enter New Banner (Figlet)${g}]────►${n} )" new_banner
[ -z "$new_banner" ] && new_banner="$CURRENT_BANNER"

# New Username
while true; do
    read -p "$(echo -e ${g}[${n}+${g}]──[${n}Enter New Prompt Username${g}]────►${n} )" name
    echo
    if [[ -z "$name" ]]; then
        name="$CURRENT_NAME"
        break
    fi
    if [[ ! "$name" =~ ^[a-zA-Z0-9[:space:]-]+$ ]]; then
        echo -e " ${E} Invalid input! Use letters, numbers, hyphens & spaces only."
        continue
    fi
    name="${name^^}"
    name="${name// /-}"
    len=${#name}
    if [[ $len -ge 1 && $len -le 16 ]]; then
        break
    else
        echo -e " ${E} Name must be 1-16 characters. Current length: $len"
    fi
done

# Update Config & Banner
sed -i "s/^PHANTOM_USER=.*/PHANTOM_USER=\"$name\"/" "$CONFIG_FILE"
sed -i "s/^PHANTOM_BANNER=.*/PHANTOM_BANNER=\"$new_banner\"/" "$CONFIG_FILE"
[ -f "$THEME" ] && sed -i "s/$CURRENT_NAME/$name/g" "$THEME"
[ -f "$BANNER_SCRIPT" ] && sed -i "s/$CURRENT_BANNER/$new_banner/g" "$BANNER_SCRIPT"
[ -f "$BANNER_SCRIPT" ] && sed -i "s/$CURRENT_NAME/$name/g" "$BANNER_SCRIPT"

echo -e " ${g}[+] Setup successfully updated!${n}"
echo -e " ${y}[*] Banner: $new_banner | User: $name${n}"
echo -e " ${c}[!] Restart your terminal or run 'zsh' to see the changes.${n}"
echo