#!/data/data/com.termux/files/usr/bin/bash
# ==================================================================
#   PHANTOM - Ultimate Terminal Setup (Interactive Installer)
#   - Custom figlet banner, zsh theme, oh-my-zsh plugins
#   - pxhelp / pxname / pxart / pxunstall commands
# ==================================================================
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
OBJ="$DIR/files"
G="\033[1;32m"; C="\033[1;36m"; R="\033[1;31m"; W="\033[1;37m"; Y="\033[1;33m"; RS="\033[0m"

IS_TERMUX=false
[ -d "/data/data/com.termux/files/usr/" ] && IS_TERMUX=true

clear
echo -e "${C}══════════════════════════════════════════════${RS}"
echo -e "${G}         PHANTOM — INTERACTIVE INSTALLER${RS}"
echo -e "${C}══════════════════════════════════════════════${RS}"
echo ""

# ---------- 1. Ask user for inputs ----------
read -p "$(echo -e ${W}"[?] Enter banner text (Figlet): "${RS})" banner_text
[ -z "$banner_text" ] && banner_text="PHANTOM"

read -p "$(echo -e ${W}"[?] Enter prompt username: "${RS})" prompt_user
[ -z "$prompt_user" ] && prompt_user="ROOT-PHANTOM"
prompt_user="${prompt_user^^}"
prompt_user="${prompt_user// /-}"

read -p "$(echo -e ${W}"[?] Enter host name (default: termux): "${RS})" prompt_host
[ -z "$prompt_host" ] && prompt_host="termux"

echo ""
echo -e "${Y}[*] Banner : ${banner_text}${RS}"
echo -e "${Y}[*] Prompt : [${prompt_user}@${prompt_host}]${RS}"
echo ""

# ---------- 2. Install packages ----------
echo -e "${C}[*] Installing required packages...${RS}"
if $IS_TERMUX; then
    pkg update -y >/dev/null 2>&1
    pkg install -y zsh figlet git curl ruby ncurses-utils >/dev/null 2>&1
else
    sudo apt update -y >/dev/null 2>&1
    sudo apt install -y zsh figlet git curl ruby ncurses-bin >/dev/null 2>&1
fi
if ! command -v lolcat >/dev/null 2>&1; then
    gem install lolcat >/dev/null 2>&1 || echo -e "${R}[!] Failed to install lolcat. Banner will use plain colors.${RS}"
fi

# ---------- 3. oh-my-zsh + plugins ----------
echo -e "${C}[*] Installing Oh My Zsh, Autosuggestions and Syntax Highlighting...${RS}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" >/dev/null 2>&1
fi
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" >/dev/null 2>&1
fi
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" >/dev/null 2>&1
fi

# ---------- 4. Figlet font ----------
if $IS_TERMUX; then
    FIGLET_DIR="$PREFIX/share/figlet"
else
    FIGLET_DIR="/usr/share/figlet"
    sudo mkdir -p "$FIGLET_DIR"
fi
mkdir -p "$FIGLET_DIR" 2>/dev/null || sudo mkdir -p "$FIGLET_DIR"

if [ -f "$OBJ/phantom.flf" ]; then
    cp "$OBJ/phantom.flf" "$FIGLET_DIR/phantom.flf" 2>/dev/null || sudo cp "$OBJ/phantom.flf" "$FIGLET_DIR/phantom.flf"
elif [ -f "$OBJ/ANSI Shadow.flf" ]; then
    cp "$OBJ/ANSI Shadow.flf" "$FIGLET_DIR/phantom.flf" 2>/dev/null || sudo cp "$OBJ/ANSI Shadow.flf" "$FIGLET_DIR/phantom.flf"
fi

# ---------- 5. Termux properties (colors + extra keys) ----------
if $IS_TERMUX; then
    mkdir -p "$HOME/.termux"
    cp "$OBJ/colors.properties" "$HOME/.termux/colors.properties" 2>/dev/null || true
    cp "$OBJ/termux.properties" "$HOME/.termux/termux.properties" 2>/dev/null || true
    termux-reload-settings 2>/dev/null || true
fi

# ---------- 6. PHANTOM config + command scripts ----------
CONFIG_DIR="$HOME/.phantom"
mkdir -p "$CONFIG_DIR/bin"
cat > "$CONFIG_DIR/config" << EOF
PHANTOM_USER="$prompt_user"
PHANTOM_HOST="$prompt_host"
PHANTOM_BANNER="$banner_text"
EOF

cp "$OBJ/help.sh"    "$CONFIG_DIR/bin/help.sh" 2>/dev/null || true
cp "$OBJ/bname.sh"   "$CONFIG_DIR/bin/bname.sh" 2>/dev/null || true
cp "$OBJ/unstall.sh" "$CONFIG_DIR/bin/unstall.sh" 2>/dev/null || true
cp "$OBJ/art.sh"     "$CONFIG_DIR/bin/art.sh" 2>/dev/null || true
chmod +x "$CONFIG_DIR/bin/"*.sh 2>/dev/null || true

# ---------- 7. Banner script (বক্স ফ্রেম সহ) ----------
BANNER_SCRIPT="$CONFIG_DIR/banner.sh"
cat > "$BANNER_SCRIPT" << EOF
#!/data/data/com.termux/files/usr/bin/bash

clear
FIGLET_DIR="$FIGLET_DIR"
W=\$COLUMNS
[ -z "\$W" ] && W=80
BOX_TOP="╔\$(printf '═%.0s' \$(seq 1 \$((W-2))))╗"
BOX_BOT="╚\$(printf '═%.0s' \$(seq 1 \$((W-2))))╝"

if command -v figlet >/dev/null 2>&1; then
    BANNER=\$(figlet -d "\$FIGLET_DIR" -c -f phantom -w \$W "$banner_text" 2>/dev/null)
else
    BANNER="  $banner_text"
fi

echo -e "\033[1;36m\${BOX_TOP}\033[0m"
if command -v lolcat >/dev/null 2>&1; then
    echo "\$BANNER" | lolcat -F 0.3 2>/dev/null
else
    echo -e "\033[1;32m\${BANNER}\033[0m"
fi
printf "\n\033[1;37m   SYSTEM: \033[1;32mONLINE\033[1;37m   |   USER: \033[1;31m$prompt_user\033[0m\n"
printf "\033[1;37m   HOST   : \033[1;36m$prompt_host\033[0m\n"
printf "\033[1;37m   TYPE '\033[1;33mpxhelp\033[1;37m' FOR COMMAND LIST\033[0m\n"
echo -e "\033[1;36m\${BOX_BOT}\033[0m"
echo ""
EOF
chmod +x "$BANNER_SCRIPT"

# ---------- 8. zsh theme (অরিজিনাল মোটা ডাবল-লাইন প্রম্পট) ----------
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
THEME_FILE="$HOME/.oh-my-zsh/custom/themes/phantom.zsh-theme"
cat > "$THEME_FILE" << EOF
autoload -U colors && colors
setopt prompt_subst

local user_info="%{\$fg_bold[red]%}[%{\$fg_bold[green]%}$prompt_user%{\$fg_bold[red]%}@%{\$fg_bold[white]%}$prompt_host%{\$fg_bold[red]%}]"

PROMPT="
%{\$fg_bold[red]%}╔══\${user_info}
%{\$fg_bold[red]%}╚══➤ %{\$reset_color%}"
EOF

# ---------- 9. .zshrc ----------
ZSHRC="$HOME/.zshrc"
cat > "$ZSHRC" << EOF
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="phantom"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source \$ZSH/oh-my-zsh.sh

# PHANTOM commands
alias pxhelp="bash \$HOME/.phantom/bin/help.sh"
alias pxname="bash \$HOME/.phantom/bin/bname.sh"
alias pxunstall="bash \$HOME/.phantom/bin/unstall.sh"
alias pxart="bash \$HOME/.phantom/bin/art.sh"

bash \$HOME/.phantom/banner.sh
EOF

# ---------- 10. Set zsh as default shell ----------
chsh -s zsh >/dev/null 2>&1 || true

echo ""
echo -e "${G}[+] PHANTOM installed successfully!${RS}"
echo -e "${W}[*] Banner  : ${banner_text}${RS}"
echo -e "${W}[*] Prompt  : [${prompt_user}@${prompt_host}] >>>${RS}"
echo -e "${W}[*] Shell   : Zsh (Autosuggestions & Syntax Highlighting)${RS}"
echo -e "${W}[*] Commands: pxhelp, pxname, pxart, pxunstall${RS}"
echo -e "${Y}[*] Restart Termux/terminal or run: zsh${RS}"
echo ""
