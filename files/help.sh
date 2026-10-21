#!/bin/bash
# PHANTOM - Help Menu

r='\033[1;91m'; p='\033[1;95m'; y='\033[1;93m'; g='\033[1;92m'
n='\033[0m'; b='\033[1;94m'; c='\033[1;96m'

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
        echo -e "${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| U${g}${used_size} ${c}of T${g}${total_size}"
    else
        echo -e "${y}Disk usage: ${g}${disk_usage}% ${c}| ${g}${used_size}"
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

echo -e "${b}╭══ ${g}〄 ${y}ᴘʜᴀɴᴛᴏᴍ ${g}〄"
echo -e "${b}┃❁ ${g}ᴅᴇᴠɪᴄᴇ: ${y}${devicename}"
echo -e "${b}┃❁ ${g}ᴅɪꜱᴋ: ${y}${data}"
echo -e "${b}╰┈➤ ${g}Hey ${y}${PHANTOM_USER:-friend}"
echo

echo -e "${b}╭═════❂ ${g}ᴄᴏᴍᴍᴀɴᴅ ${b}❂═════⊷"
echo -e "${b}┃ ${p}❏ ${g}pxhelp     ${p}[help menu]"
echo -e "${b}┃ ${p}❏ ${g}pxname     ${p}[change banner name/prompt]"
echo -e "${b}┃ ${p}❏ ${g}pxart      ${p}[ascii art text generator]"
echo -e "${b}┃ ${p}❏ ${g}pxunstall  ${p}[uninstall PHANTOM]"
echo -e "${b}╰═══════════════════════⊷${n}"
echo
