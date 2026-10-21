#!/data/data/com.termux/files/usr/bin/bash

# ========================================================
# PHANTOM - FULL INTERACTIVE INSTALLER
# ========================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
BOLD='\033[1m'

clear
echo -e "${CYAN}====================================================${RESET}"
echo -e "${GREEN}${BOLD}         PHANTOM - INTERACTIVE INSTALLER           ${RESET}"
echo -e "${CYAN}====================================================${RESET}"
echo ""

# 1. Inputs
read -p "[?] Enter banner text (Figlet) [Default: PHANTOM]: " BANNER_TEXT
BANNER_TEXT=${BANNER_TEXT:-PHANTOM}

read -p "[?] Enter prompt username [Default: Root-Phantom]: " USER_NAME
USER_NAME=${USER_NAME:-Root-Phantom}

read -p "[?] Enter host name (default: kali): " HOST_NAME
HOST_NAME=${HOST_NAME:-kali}

echo ""
echo -e "${YELLOW}----------------------------------------------------${RESET}"
echo -e "${CYAN}[*] Banner  :${RESET} ${BOLD}${BANNER_TEXT}${RESET}"
echo -e "${CYAN}[*] Prompt  :${RESET} [${USER_NAME}@${HOST_NAME}]"
echo -e "${YELLOW}----------------------------------------------------${RESET}"
echo ""

# 2. Package Installation
echo -e "${YELLOW}[*] Installing required packages...${RESET}"
pkg update -y && pkg install -y git zsh figlet ruby ncurses-utils termux-tools

if ! command -v lolcat &> /dev/null; then
    gem install lolcat
fi

# 3. Setup Folders and Local Font
echo -e "${YELLOW}[*] Setting up Phantom font and configurations...${RESET}"
PHANTOM_DIR="$HOME/.phantom"
mkdir -p "$PHANTOM_DIR"
mkdir -p "$PREFIX/share/figlet"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy phantom.flf from current cloned folder
if [ -f "$SCRIPT_DIR/phantom.flf" ]; then
    cp "$SCRIPT_DIR/phantom.flf" "$PREFIX/share/figlet/phantom.flf"
    cp "$SCRIPT_DIR/phantom.flf" "$PHANTOM_DIR/phantom.flf"
else
    echo -e "${RED}[!] Error: phantom.flf missing! Downloading fallback...${RESET}"
    curl -s -L "https://raw.githubusercontent.com/xero/figlet-fonts/master/ANSI%20Shadow.flf" -o "$PREFIX/share/figlet/phantom.flf"
fi

# Copy banner.sh to destination
if [ -f "$SCRIPT_DIR/banner.sh" ]; then
    cp "$SCRIPT_DIR/banner.sh" "$PHANTOM_DIR/banner.sh"
fi
chmod +x "$PHANTOM_DIR/banner.sh"

# Save Config
cat <<EOF > "$PHANTOM_DIR/config.sh"
BANNER_TEXT="${BANNER_TEXT}"
USER_NAME="${USER_NAME}"
HOST_NAME="${HOST_NAME}"
EOF

# 4. Plugins Installation (Autosuggestions & Syntax Highlighting)
echo -e "${YELLOW}[*] Configuring Autosuggestions and Syntax Highlighting...${RESET}"
ZSH_PLUGINS="$HOME/.zsh_plugins"
mkdir -p "$ZSH_PLUGINS"

if [ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS/zsh-syntax-highlighting"
fi

# 5. ~/.zshrc Setup
echo -e "${YELLOW}[*] Writing ~/.zshrc profile...${RESET}"

cat << 'EOF' > ~/.zshrc
# Load configuration
if [ -f "$HOME/.phantom/config.sh" ]; then
    source "$HOME/.phantom/config.sh"
fi

# Load plugins
source "$HOME/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Keybind: Right Arrow (→) to paste suggested command
bindkey '^[[C' forward-word
bindkey '^[[OC' forward-word

# Kali style prompt
autoload -Uz colors && colors
setopt PROMPT_SUBST
PROMPT=$'%F{cyan}┌──[%F{red}%B${USER_NAME}%b%F{cyan}@%F{yellow}${HOST_NAME}%F{cyan}]─[%F{white}%~%F{cyan}]\n└──╼ %F{red}$ %f'

# pxhelp Command
pxhelp() {
    echo ""
    echo -e "\033[1;36m==================== [ PHANTOM COMMAND LIST ] ====================\033[0m"
    echo -e "\033[1;32m  pxhelp      \033[0m : Show all custom commands"
    echo -e "\033[1;32m  pxname      \033[0m : Change your Banner, Username, or Hostname"
    echo -e "\033[1;32m  cls         \033[0m : Clear screen and reload banner"
    echo -e "\033[1;32m  sysinfo     \033[0m : Display storage and RAM details"
    echo -e "\033[1;32m  update      \033[0m : Update and upgrade packages"
    echo -e "\033[1;32m  pxuninstall \033[0m : Remove Phantom setup and restore Termux"
    echo -e "\033[1;36m==================================================================\033[0m"
    echo ""
}

# pxname Command (Edit details dynamically)
pxname() {
    read -p "Enter new banner text: " NEW_BANNER
    read -p "Enter new username: " NEW_USER
    read -p "Enter new host (default: kali): " NEW_HOST
    NEW_HOST=${NEW_HOST:-kali}

    cat <<EOC > "$HOME/.phantom/config.sh"
BANNER_TEXT="${NEW_BANNER}"
USER_NAME="${NEW_USER}"
HOST_NAME="${NEW_HOST}"
EOC
    echo -e "\033[0;32m[+] Successfully updated! Reloading...\033[0m"
    exec zsh
}

# Aliases
alias cls='bash $HOME/.phantom/banner.sh'
alias update='pkg update -y && pkg upgrade -y'
alias sysinfo='echo -e "\033[1;33mStorage:\033[0m"; df -h /data; echo -e "\033[1;33mRAM:\033[0m"; free -m'

# Uninstall script
pxuninstall() {
    echo -e "\033[0;31m[*] Reverting back to default Termux shell...\033[0m"
    chsh -s bash
    rm -rf "$HOME/.phantom" "$HOME/.zsh_plugins" "$HOME/.zshrc"
    echo -e "\033[0;32m[+] Uninstalled! Please restart Termux.\033[0m"
}

# Auto load banner on start
bash "$HOME/.phantom/banner.sh"
EOF

# 6. Change default shell to ZSH
if [ "$SHELL" != "/data/data/com.termux/files/usr/bin/zsh" ]; then
    chsh -s zsh
fi

echo ""
echo -e "${GREEN}${BOLD}[+] PHANTOM Setup Installed Successfully!${RESET}"
echo -e "${MAGENTA}Restart Termux or type 'zsh' to launch your banner.${RESET}"
