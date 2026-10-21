#!/usr/bin/env python3
import os
import sys
import json

try:
    import pyfiglet
    from colorama import Fore, Style, init
    init(autoreset=True)
except Exception as e:
    print(f"[-] Error loading dependencies: {e}")
    print("[-] Please run: pip install pyfiglet colorama --break-system-packages")
    sys.exit(1)

CONFIG_FILE = os.path.expanduser("~/.phantom_config.json")

def generate_gradient_text(text, start_color=(255, 0, 128), end_color=(0, 255, 0)):
    lines = text.split('\n')
    result = ""
    total_lines = len(lines)
    for i, line in enumerate(lines):
        r = int(start_color[0] + (end_color[0] - start_color[0]) * (i / max(1, total_lines)))
        g = int(start_color[1] + (end_color[1] - start_color[1]) * (i / max(1, total_lines)))
        b = int(start_color[2] + (end_color[2] - start_color[2]) * (i / max(1, total_lines)))
        
        for char in line:
            if char != ' ':
                result += f"\033[38;2;{r};{g};{b}m{char}"
            else:
                result += char
        result += "\n"
    return result + Style.RESET_ALL

def setup_wizard():
    os.system('clear')
    print(Fore.CYAN + "╔" + "═" * 50 + "╗")
    print(Fore.CYAN + "║ " + Fore.YELLOW + "PHANTOM TERMUX SETUP WIZARD".ljust(48) + Fore.CYAN + " ║")
    print(Fore.CYAN + "╚" + "═" * 50 + "╝\n")
    
    banner = input(Fore.CYAN + "[?] Enter Banner Name (English, max 10 chars): " + Fore.WHITE).strip()
    if not banner: banner = "PHANTOM"
    
    user = input(Fore.CYAN + "[?] Enter Username: " + Fore.WHITE).strip()
    if not user: user = "ROOT"
    
    host = input(Fore.CYAN + "[?] Enter Hostname: " + Fore.WHITE).strip()
    if not host: host = "termux"

    config = {"banner": banner, "user": user, "host": host}
    
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f)
        
    print(Fore.GREEN + "\n[+] Configuration saved successfully!")

def display_banner():
    if not os.path.exists(CONFIG_FILE):
        return

    with open(CONFIG_FILE, "r") as f:
        config = json.load(f)

    os.system('clear')
    
    # Using banner3-D font for thicker text
    ascii_art = pyfiglet.figlet_format(config["banner"], font="banner3-D")
    gradient_banner = generate_gradient_text(ascii_art)
    
    lines = gradient_banner.split('\n')

    print(Fore.CYAN + "╔" + "═" * 74 + "╗")
    for line in lines:
        if line.strip():
            print("║ " + line.ljust(72) + " ║")
    print(Fore.CYAN + "╚" + "═" * 74 + "╝")

    print(Fore.CYAN + "╔" + "═" * 74 + "╗")
    print(Fore.CYAN + "║ " + Fore.BLUE + "System : Online" + " " * 28 + Fore.YELLOW + f"User : {config['user']}".ljust(23) + " " + Fore.CYAN + "║")
    print(Fore.CYAN + "║ " + Fore.BLUE + f"Host   : {config['host']}".ljust(47) + " " + Fore.CYAN + "║")
    print(Fore.CYAN + "║ " + Fore.GREEN + "Type   : Pxhelp For Command List".ljust(47) + " " + Fore.CYAN + "║")
    print(Fore.CYAN + "╚" + "═" * 74 + "╝\n")

def display_help():
    os.system('clear')
    print(Fore.CYAN + "╔" + "═" * 60 + "╗")
    print(Fore.CYAN + "║ " + Fore.YELLOW + "PHANTOM COMMAND LIST".ljust(58) + Fore.CYAN + " ║")
    print(Fore.CYAN + "╚" + "═" * 60 + "╝\n")
    
    commands = [
        ("pxhelp", "Show this command list"),
        ("clear", "Clear the terminal screen"),
        ("pkg update", "Update Termux packages"),
        ("pkg install <pkg>", "Install a new package"),
        ("ls", "List files in current directory"),
        ("cd <dir>", "Change directory"),
        ("python <file>", "Run a Python script"),
        ("exit", "Exit Termux session")
    ]
    
    for cmd, desc in commands:
        print(f" {Fore.GREEN}{cmd.ljust(25)} {Fore.WHITE}- {desc}")
    print()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        if sys.argv[1] == "--setup":
            setup_wizard()
        elif sys.argv[1] == "--banner":
            display_banner()
        elif sys.argv[1] == "--pxhelp":
            display_help()
    else:
        print("Usage: python phantom.py [--setup | --banner | --pxhelp]")