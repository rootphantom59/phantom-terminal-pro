#!/usr/bin/env python3
"""Phantom Terminal Pro rainbow block banner. Python standard library only."""
import os
import shutil
import sys

RESET = "\033[0m"
CYAN = "\033[38;2;0;235;235m"
GREEN = "\033[38;2;105;255;145m"
YELLOW = "\033[38;2;255;230;60m"
WHITE = "\033[97m"
MAGENTA = "\033[95m"
RED = "\033[91m"

# Fixed 5-row font for every supported English letter, digit, and common symbol.
# Every user-provided banner name is rendered through this same font.
FONT = {
"A":[" ### ","#   #","#   #","#####","#   #"],
"B":["#### ","#   #","#### ","#   #","#### "],
"C":[" ####","#    ","#    ","#    "," ####"],
"D":["#### ","#   #","#   #","#   #","#### "],
"E":["#####","#    ","#### ","#    ","#####"],
"F":["#####","#    ","#### ","#    ","#    "],
"G":[" ####","#    ","# ###","#   #"," ####"],
"H":["#   #","#   #","#####","#   #","#   #"],
"I":["#####","  #  ","  #  ","  #  ","#####"],
"J":["#####","   # ","   # ","#  # "," ##  "],
"K":["#   #","#  # ","###  ","#  # ","#   #"],
"L":["#    ","#    ","#    ","#    ","#####"],
"M":["#   #","## ##","# # #","#   #","#   #"],
"N":["#   #","##  #","# # #","#  ##","#   #"],
"O":[" ### ","#   #","#   #","#   #"," ### "],
"P":["#### ","#   #","#### ","#    ","#    "],
"Q":[" ### ","#   #","# # #","#  ##"," ####"],
"R":["#### ","#   #","#### ","#  # ","#   #"],
"S":[" ####","#    "," ### ","    #","#### "],
"T":["#####","  #  ","  #  ","  #  ","  #  "],
"U":["#   #","#   #","#   #","#   #"," ### "],
"V":["#   #","#   #","#   #"," # # ","  #  "],
"W":["#   #","#   #","# # #","## ##","#   #"],
"X":["#   #"," # # ","  #  "," # # ","#   #"],
"Y":["#   #"," # # ","  #  ","  #  ","  #  "],
"Z":["#####","   # ","  #  "," #   ","#####"],
"0":[" ### ","#  ##","# # #","##  #"," ### "],
"1":["  #  "," ##  ","  #  ","  #  ","#####"],
"2":[" ### ","#   #","   # ","  #  ","#####"],
"3":["#### ","    #"," ### ","    #","#### "],
"4":["#   #","#   #","#####","    #","    #"],
"5":["#####","#    ","#### ","    #","#### "],
"6":[" ### ","#    ","#### ","#   #"," ### "],
"7":["#####","   # ","  #  "," #   ","#    "],
"8":[" ### ","#   #"," ### ","#   #"," ### "],
"9":[" ### ","#   #"," ####","    #"," ### "],
" ":["     ","     ","     ","     ","     "],
"-":["     ","     ","#####","     ","     "],
"_":["     ","     ","     ","     ","#####"],
".":["     ","     ","     ","     ","  #  "],
"!":["  #  ","  #  ","  #  ","     ","  #  "],
"?":[" ### ","#   #","   # ","     ","  #  "],
":":["     ","  #  ","     ","  #  ","     "],
"+":["     ","  #  ","#####","  #  ","     "],
"/":["    #","   # ","  #  "," #   ","#    "],
"@":[" ### ","# ###","# # #","# ###"," ### "],
}
RAINBOW = [
    (255, 40, 70), (255, 115, 25), (255, 220, 30),
    (95, 255, 40), (0, 245, 150), (0, 220, 255),
    (40, 110, 255), (160, 35, 255), (255, 35, 180),
]

def color(text, rgb):
    r, g, b = rgb
    return f"\033[38;2;{r};{g};{b}m{text}{RESET}"

def mix_color(index, total):
    if total < 2:
        return RAINBOW[0]
    pos = index * (len(RAINBOW) - 1) / (total - 1)
    lo = int(pos)
    hi = min(lo + 1, len(RAINBOW) - 1)
    t = pos - lo
    return tuple(round(RAINBOW[lo][j] * (1 - t) + RAINBOW[hi][j] * t) for j in range(3))

def render(name):
    name = name.upper()
    # Unsupported punctuation is replaced with a space instead of breaking the script.
    name = "".join(ch if ch in FONT else " " for ch in name)
    cols = shutil.get_terminal_size((80, 24)).columns
    max_chars = max(1, min(18, (cols - 4) // 6))
    if len(name) > max_chars:
        name = name[:max_chars]
    width = len(name) * 6
    print(CYAN + "╔" + "═" * (width + 2) + "╗" + RESET)
    for row in range(5):
        pieces = []
        for idx, ch in enumerate(name):
            glyph = FONT[ch][row]
            # Multi-layer offset outline for a dimensional, neon-terminal feel.
            pieces.append(color(glyph, mix_color(idx, len(name))))
        print(CYAN + "║ " + RESET + " ".join(pieces) + CYAN + " ║" + RESET)
    print(CYAN + "╚" + "═" * (width + 2) + "╝" + RESET)

def main():
    banner_name = os.environ.get("PHANTOM_BANNER_NAME", "PHANTOM")
    username = os.environ.get("PHANTOM_USER", "ROOT-PHANTOM")
    hostname = os.environ.get("PHANTOM_HOST", "termux")
    help_name = os.environ.get("PHANTOM_HELP", "pxhelp")
    print()
    render(banner_name)
    print()
    print(f"{CYAN}System : {GREEN}Online{RESET}                 {CYAN}User : {GREEN}{username}{RESET}")
    print(f"{CYAN}Host   : {GREEN}{hostname}{RESET}")
    print(f"{CYAN}Type   : {YELLOW}{help_name}{WHITE} for Command List{RESET}")
    print()

if __name__ == "__main__":
    main()
