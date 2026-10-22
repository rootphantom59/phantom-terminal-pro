#!/data/data/com.termux/files/usr/bin/bash
# ==================================================================
#   PHANTOM - Ultimate Terminal Setup (Interactive Installer)
#   - Dynamic Random Color changing banner on every launch
#   - Thick double-line prompt with live folder navigation
#   - Offline phantom.flf font handling
#   - Telegram shortcuts (pxdev / pxchannel)
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

# ---------- ১. ইউজার থেকে ইনপুট নেওয়া ----------
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

# ---------- ২. প্রয়োজনীয় প্যাকেজ ইনস্টলেশন ----------
echo -e "${C}[*] Installing required packages...${RS}"
if $IS_TERMUX; then
    pkg update -y >/dev/null 2>&1
    pkg install -y zsh figlet git curl ruby ncurses-utils termux-tools >/dev/null 2>&1
else
    sudo apt update -y >/dev/null 2>&1
    sudo apt install -y zsh figlet git curl ruby ncurses-bin >/dev/null 2>&1
fi
if ! command -v lolcat >/dev/null 2>&1; then
    gem install lolcat >/dev/null 2>&1 || true
fi

# ---------- ৩. Oh-My-Zsh ও প্লাগইন সেটআপ ----------
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

# ---------- ৪. ফন্ট সেটআপ ----------
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

# ---------- ৫. কালার ও কীবোর্ড প্রোপার্টিজ ----------
if $IS_TERMUX; then
    mkdir -p "$HOME/.termux"
    cp "$OBJ/colors.properties" "$HOME/.termux/colors.properties" 2>/dev/null || true
    cp "$OBJ/termux.properties" "$HOME/.termux/termux.properties" 2>/dev/null || true
    termux-reload-settings 2>/dev/null || true
fi

# ---------- ৬. কনফিগারেশন সংরক্ষণ ----------
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

# ---------- ৭. স্বয়ংক্রিয় কালার পরিবর্তনকারী ব্যানার স্ক্রিপ্ট ----------
BANNER_SCRIPT="$CONFIG_DIR/banner.sh"
cat > "$BANNER_SCRIPT" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

CONFIG_FILE="$HOME/.phantom/config"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    PHANTOM_BANNER="PHANTOM"
    PHANTOM_USER="ROOT-PHANTOM"
    PHANTOM_HOST="termux"
fi

clear
FIGLET_DIR="$PREFIX/share/figlet"
W=$COLUMNS
[ -z "$W" ] && W=80

# বিভিন্ন আকর্ষণীয় নিয়ন কালারের তালিকা
THEME_COLORS=(
    "\033[1;36m" # Neon Cyan
    "\033[1;35m" # Neon Pink / Magenta
    "\033[1;32m" # Electric Green
    "\033[1;33m" # Golden Yellow
    "\033[1;31m" # Crimson Red
    "\033[1;94m" # Cyber Blue
    "\033[1;95m" # Light Purple
)

# প্রতিবার রিস্টার্ট বা ওপেন করলে নতুন কালার সিলেক্ট হবে
RAND_COLOR=${THEME_COLORS[$RANDOM % ${#THEME_COLORS[@]}]}
RESET="\033[0m"

BOX_TOP="╔$(printf '═%.0s' $(seq 1 $((W-2))))╗"
BOX_BOT="╚$(printf '═%.0s' $(seq 1 $((W-2))))╝"

if command -v figlet >/dev/null 2>&1; then
    BANNER=$(figlet -d "$FIGLET_DIR" -c -f phantom -w $W "$PHANTOM_BANNER" 2>/dev/null)
else
    BANNER="  $PHANTOM_BANNER"
fi

# ফ্রেম প্রিন্ট
echo -e "${RAND_COLOR}${BOX_TOP}${RESET}"

# র‍্যান্ডম কালার সিড সহ ব্যানার প্রিন্ট
if command -v lolcat >/dev/null 2>&1; then
    echo "$BANNER" | lolcat -S $RANDOM -F 0.3 2>/dev/null
else
    echo -e "${RAND_COLOR}${BANNER}${RESET}"
fi

printf "\n\033[1;37m   SYSTEM: \033[1;32mONLINE\033[1;37m   |   USER: \033[1;93m$PHANTOM_USER\033[0m\n"
printf "\033[1;37m   HOST   : \033[1;36m$PHANTOM_HOST\033[0m\n"
printf "\033[1;35m   TYPE '\033[1;33mpxhelp\033[1;35m' FOR COMMAND LIST\033[0m\n"
echo -e "${RAND_COLOR}${BOX_BOT}${RESET}"
echo ""
EOF
chmod +x "$BANNER_SCRIPT"

# ---------- ৮. লাইভ ডিরেক্টরি পাথ সহ মোটা লাল প্রম্পট ----------
mkdir -p "$HOME/.oh-my-zsh/custom/themes"
THEME_FILE="$HOME/.oh-my-zsh/custom/themes/phantom.zsh-theme"
cat > "$THEME_FILE" << EOF
autoload -U colors && colors
setopt prompt_subst

local user_info="%{\$fg_bold[red]%}[%{\$fg_bold[yellow]%}$prompt_user%{\$fg_bold[red]%}@%{\$fg_bold[white]%}$prompt_host%{\$fg_bold[red]%}]"
local current_dir="%{\$fg_bold[red]%}══[%{\$fg_bold[cyan]%}%~%{\$fg_bold[red]%}]"

PROMPT="
%{\$fg_bold[red]%}╔══\${user_info}\${current_dir}
%{\$fg_bold[red]%}╚══➤ %{\$reset_color%}"
EOF

# ---------- ৯. ~/.zshrc কনফিগারেশন ----------
ZSHRC="$HOME/.zshrc"
cat > "$ZSHRC" << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="phantom"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# সরাসরি টেলিগ্রাম লিংক ওপেন করার ফাংশন
open_url() {
    local target="$1"
    if command -v termux-open-url &>/dev/null; then
        termux-open-url "$target"
    elif command -v am &>/dev/null; then
        am start -a android.intent.action.VIEW -d "$target" >/dev/null 2>&1
    else
        xdg-open "$target" >/dev/null 2>&1
    fi
}

# প্রয়োজনীয় কমান্ড ও শর্টকাট
alias pxhelp="bash $HOME/.phantom/bin/help.sh"
alias help="bash $HOME/.phantom/bin/help.sh"
alias pxname="bash $HOME/.phantom/bin/bname.sh"
alias pxunstall="bash $HOME/.phantom/bin/unstall.sh"
alias pxart="bash $HOME/.phantom/bin/art.sh"
alias cls="bash $HOME/.phantom/banner.sh"

# সরাসরি টেলিগ্রাম ওপেন করার কমান্ড
alias pxdev='open_url "https://t.me/ROOT_PHANTOM_BPBD"'
alias pxchannel='open_url "https://t.me/Anonymous_Phantom_BD"'

# কীবোর্ডের রাইট অ্যারো (→) চাপলে সাজেস্টেড কমান্ড পেস্ট হবে
bindkey '^[[C' forward-word
bindkey '^[[OC' forward-word

bash $HOME/.phantom/banner.sh
EOF

# ---------- ১০. ডিফল্ট শেল Zsh সেট করা ----------
chsh -s zsh >/dev/null 2>&1 || true

echo ""
echo -e "${G}[+] PHANTOM Setup Installed Successfully!${RS}"
echo -e "${Y}[*] Restart Termux or type 'zsh' to launch.${RS}"
echo ""