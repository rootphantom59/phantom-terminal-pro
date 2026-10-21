#!/data/data/com.termux/files/usr/bin/bash
set -eu

command -v pkg >/dev/null 2>&1 || { echo "This installer is for Termux."; exit 1; }

clear
printf '\033[96m===============================================\033[0m\n'
printf '\033[92m         PHANTOM TERMINAL PRO SETUP\033[0m\n'
printf '\033[96m===============================================\033[0m\n\n'

# These are the only three personal details requested, in the requested order.
read -r -p "Banner name (English): " BANNER_NAME
read -r -p "Username: " USER_NAME
read -r -p "Host name: " HOST_NAME

BANNER_NAME="${BANNER_NAME:-PHANTOM}"
USER_NAME="${USER_NAME:-ROOT-PHANTOM}"
HOST_NAME="${HOST_NAME:-termux}"

echo
echo "[1/4] Updating package lists..."
pkg update -y
echo "[2/4] Installing Zsh and prompt plugins..."
pkg install -y python zsh zsh-autosuggestions zsh-syntax-highlighting

APP_DIR="$HOME/.phantom-terminal-pro"
mkdir -p "$APP_DIR"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/banner.py" "$APP_DIR/banner.py"

# Safely write the chosen values as shell-escaped strings.
python - "$APP_DIR/config.zsh" "$BANNER_NAME" "$USER_NAME" "$HOST_NAME" <<'PY'
import shlex, sys
path, banner, user, host = sys.argv[1:]
with open(path, "w", encoding="utf-8") as f:
    f.write("export PHANTOM_BANNER_NAME=" + shlex.quote(banner) + "\n")
    f.write("export PHANTOM_USER=" + shlex.quote(user) + "\n")
    f.write("export PHANTOM_HOST=" + shlex.quote(host) + "\n")
    f.write("export PHANTOM_HELP=pxhelp\n")
PY

ZSHRC="$HOME/.zshrc"
STAMP="$(date +%Y%m%d%H%M%S)"
if [ -f "$ZSHRC" ] && ! grep -q "PHANTOM TERMINAL PRO START" "$ZSHRC"; then
  cp "$ZSHRC" "$ZSHRC.phantom-backup-$STAMP"
fi

# Remove a previous managed block, if reinstalling, then append a fresh block.
if [ -f "$ZSHRC" ]; then
  sed '/# PHANTOM TERMINAL PRO START/,/# PHANTOM TERMINAL PRO END/d' "$ZSHRC" > "$ZSHRC.tmp"
  mv "$ZSHRC.tmp" "$ZSHRC"
fi

cat >> "$ZSHRC" <<'ZSHRC_EOF'
# PHANTOM TERMINAL PRO START
source "$HOME/.phantom-terminal-pro/config.zsh"

autoload -Uz colors && colors
setopt PROMPT_SUBST
PROMPT='%F{red}┌─[%F{green}${PHANTOM_USER}%F{red}@%F{white}${PHANTOM_HOST}%F{red}]─[%F{magenta}%~%F{red}]%f
%F{red}➜ %f'

# Previously used commands appear as dim grey suggestions; press Right Arrow to accept.
if [ -r "$PREFIX/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$PREFIX/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
  ZSH_AUTOSUGGEST_STRATEGY=(history)
  bindkey '^[[C' autosuggest-accept
  bindkey '^[OC' autosuggest-accept
fi

if [ -r "$PREFIX/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$PREFIX/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

pxhelp() {
  print -P '%F{cyan}╭──────────── PHANTOM QUICK HELP ────────────╮%f'
  print -P '%F{green}Navigation%f'
  print -P '  %F{yellow}pwd%f                 Show current directory'
  print -P '  %F{yellow}ls -la%f              List files'
  print -P '  %F{yellow}cd <folder>%f         Enter a folder'
  print -P '  %F{yellow}cd ..%f               Go up one folder'
  print -P ''
  print -P '%F{green}Files%f'
  print -P '  %F{yellow}mkdir <name>%f        Create a folder'
  print -P '  %F{yellow}cp <source> <dest>%f  Copy a file'
  print -P '  %F{yellow}mv <source> <dest>%f  Move or rename a file'
  print -P '  %F{yellow}rm <file>%f           Delete a file (careful)'
  print -P '  %F{yellow}cat <file>%f          Read a text file'
  print -P '  %F{yellow}nano <file>%f         Edit a text file'
  print -P ''
  print -P '%F{green}Termux / Python%f'
  print -P '  %F{yellow}pkg update%f          Refresh package lists'
  print -P '  %F{yellow}pkg upgrade%f         Upgrade packages'
  print -P '  %F{yellow}pkg install <name>%f  Install a package'
  print -P '  %F{yellow}python file.py%f      Run a Python script'
  print -P '  %F{yellow}history%f             Show command history'
  print -P '  %F{yellow}clear%f               Clear terminal'
  print -P '  %F{yellow}exit%f                Exit Zsh'
  print -P '%F{cyan}╰────────────────────────────────────────────╯%f'
}
alias ph='pxhelp'

# Banner appears automatically whenever a new interactive Zsh session starts.
if [[ -o interactive ]] && command -v python >/dev/null 2>&1; then
  python "$HOME/.phantom-terminal-pro/banner.py"
fi
# PHANTOM TERMINAL PRO END
ZSHRC_EOF

echo "[3/4] Setting Zsh as the default shell..."
if command -v chsh >/dev/null 2>&1; then
  chsh -s zsh || echo "Start Zsh manually with: zsh"
else
  echo "Start Zsh manually with: zsh"
fi
echo "[4/4] Setup complete."
echo
echo "Close and reopen Termux, or run: zsh"
echo "Then type: pxhelp"
