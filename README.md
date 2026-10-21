# Phantom Terminal Pro

A Termux customization project. During installation, users are asked for these details in English and in this order:

1. Banner name
2. Username
3. Host name

The banner name is rendered with the same included 5-row font for A-Z, 0-9, and common symbols. The rainbow palette and font style are fixed so users only need to enter their own text. Unsupported symbols become spaces; the banner is automatically shortened if it is too wide for the terminal.

## Install on Termux

Upload this project to a GitHub repository. Users can then run:

```bash
pkg update -y
pkg install -y git
git clone https://github.com/YOUR_USERNAME/phantom-terminal-pro.git
cd phantom-terminal-pro
bash install.sh
```

The installer asks for the banner name, username, and host name, installs Python/Zsh and plugins, and saves the settings locally. Close and reopen Termux to see the banner automatically.

## Commands

Type `pxhelp` or `ph` for the command guide.

Previously used commands can appear as grey autosuggestions. Press the Right Arrow to accept a suggestion. Suggestions come from each user's own Zsh history.

## Notes

- All setup prompts and built-in help are in English.
- The banner is a terminal text design inspired by the reference; it is not a pixel-perfect copy of the original layered 3D font.
- Syntax highlighting is only a visual hint, not a safety or correctness guarantee.
- The installer backs up an existing `.zshrc` before adding its managed configuration block.
