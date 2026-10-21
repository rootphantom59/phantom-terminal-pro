#!/bin/bash
# PHANTOM - Professional Help Menu

r='\033[1;91m'; p='\033[1;95m'; y='\033[1;93m'; g='\033[1;92m'
n='\033[0m'; b='\033[1;94m'; c='\033[1;96m'; w='\033[1;97m'

CONFIG_DIR="$HOME/.phantom"
CONFIG_FILE="$CONFIG_DIR/config"
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

if command -v getprop &>/dev/null; then
    MODEL=$(getprop ro.product.model)
    VENDOR=$(getprop ro.product.manufacturer)
else
    MODEL=$(hostname)
    VENDOR=$(uname -o)
fi
devicename="${VENDOR} ${MODEL}"

THRESHOLD=100
check_disk_usage() {
    local total_size used_size disk_usage
    total_size=$(df -h "$HOME" | awk 'NR==2 {print $2}')
    used_size=$(df -h "$HOME" | awk 'NR==2 {print $3}')
    disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//g')
    if [ "$disk_usage" -ge "$THRESHOLD" ]; then
        echo -e "${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| ${g}${used_size} ${c}/ ${g}${total_size}"
    else
        echo -e "${y}Disk usage: ${g}${disk_usage}% ${c}| Free: ${g}${used_size}"
    fi
}
data=$(check_disk_usage)

echo -e "\n${c}   ██████╗░██╗░░██╗░█████╗░███╗░░██╗████████╗░█████╗░███╗░░░███╗${n}"
echo -e "${c}   ██╔══██╗██║░░██║██╔══██╗████╗░██║╚══██╔══╝██╔══██╗████╗░████║${n}"
echo -e "${c}   ██████╔╝███████║███████║██╔██╗██║░░░██║░░░██║░░██║██╔████╔██║${n}"
echo -e "${c}   ██╔═══╝░██╔══██║██╔══██║██║╚████║░░░██║░░░██║░░██║██║╚██╔╝██║${n}"
echo -e "${c}   ██║░░░░░██║░░██║██║░░██║██║░╚███║░░░██║░░░╚█████╔╝██║░╚═╝░██║${n}"
echo -e "${c}   ╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝░░░╚═╝░░░░╚════╝░╚═╝░░░░░╚═╝${n}"
echo

# সিস্টেম স্ট্যাটাস
echo -e "${c}┌───[ ${g}SYSTEM STATUS ${c}]───────────────────────────────────┐"
echo -e "${c}│ ${w}DEVICE : ${y}${devicename}${n}"
echo -e "${c}│ ${w}MEMORY : ${g}${data}${n}"
echo -e "${c}│ ${w}ACTIVE : ${c}Hey ${y}\033[1;4m${PHANTOM_USER:-ROOT-PHANTOM}\033[0m ${g}(Online)${n}"
echo -e "${c}└────────────────────────────────────────────────────────┘${n}"
echo

# কমান্ড তালিকা
echo -e "${b}┌───[ ${g}AVAILABLE COMMANDS ${b}]─────────────────────────────┐"
echo -e "${b}│ ${g}pxhelp      ${c}➜  ${w}Show this help menu${n}"
echo -e "${b}│ ${g}pxname      ${c}➜  ${w}Change banner text or prompt user${n}"
echo -e "${b}│ ${g}pxart       ${c}➜  ${w}Generate 3D ASCII block text${n}"
echo -e "${b}│ ${g}cls         ${c}➜  ${w}Clear screen & reload banner${n}"
echo -e "${b}│ ${g}pxdev       ${c}➜  ${p}Contact Developer (Telegram)${n}"
echo -e "${b}│ ${g}pxchannel   ${c}➜  ${p}Join Official Channel (Telegram)${n}"
echo -e "${b}│ ${g}pxunstall   ${c}➜  ${w}Uninstall Phantom setup${n}"
echo -e "${b}└────────────────────────────────────────────────────────┘${n}"
echo