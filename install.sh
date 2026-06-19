#!/bin/bash
# Detect the actual folder this script is running from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
clear

# Color
r='\033[1;91m'
p='\033[1;95m'
y='\033[1;93m'
g='\033[1;92m'
n='\033[1;0m'
b='\033[1;94m'
c='\033[1;96m'

# Symbol
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;92m]\033[92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'

# icon
HOST="\uf6c3"
KER="\uf83c"
HOMES="\uf015"

MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
VENDOR=$(getprop ro.product.manufacturer 2>/dev/null || echo "Unknown")
THRESHOLD=100

exit_script() {
    clear
    echo
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo -e "\n ${g}Exiting ${g}T-BANNER"
    echo
    cd "$HOME"
    rm -rf "$SCRIPT_DIR"
    exit 0
}

# Install ncurses-utils first so tput works
if ! command -v ncurses-utils &>/dev/null; then
    pkg install ncurses-utils -y >/dev/null 2>&1
fi

trap exit_script SIGINT SIGTSTP

check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size used_size disk_usage
    total_size=$(df -h "$HOME" | awk 'NR==2 {print $2}')
    used_size=$(df -h "$HOME" | awk 'NR==2 {print $3}')
    disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//g')
    if [ "$disk_usage" -ge "$threshold" ]; then
        echo -e "${g}[\uf0a0] ${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| U${g}${used_size} ${c}of T${g}${total_size}"
    else
        echo -e "${y}Disk: ${g}${disk_usage}% ${c}| ${g}${used_size}"
    fi
}
data=$(check_disk_usage)

# ── Intro animation ──
start() {
    clear
    local LIME='\e[38;5;154m'
    local CYAN='\e[36m'
    local NC='\e[0m'
    local width
    width=$(tput cols 2>/dev/null || echo 40)

    _type() {
        local text="$1"
        local delay="${2:-0.05}"
        local len=${#text}
        local pad=$(( (width - len) / 2 ))
        [ $pad -lt 0 ] && pad=0
        printf "%${pad}s" ""
        for (( i=0; i<len; i++ )); do
            printf "${LIME}${text:$i:1}${NC}"
            sleep "$delay"
        done
        echo
    }

    echo
    echo
    _type "[ T-BANNER STARTED ]"        0.01
    sleep 0.01
    _type "HELLO DEAR USER — I'M T-BANNER" 0.01
    sleep 0.01
    _type "T-BANNER WILL PROTECT YOU"   0.01
    sleep 0.01
    _type "ENJOY OUR T-BANNER BANNER"   0.01
    sleep 0.01
    _type "! . . . . . . . . . . ¡" 0.01
    echo
    sleep 0.01
    clear
}
start

mkdir -p .T-BANNER

# ── Helpers ──
ensure_curl() {
    if ! command -v curl &>/dev/null; then
        pkg install curl -y &>/dev/null 2>&1
    fi
}



# ── Spinner for installs ──
spin() {
    echo
    local delay=0.30
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    show_spinner() {
        local pid=$!
        while ps -p $pid > /dev/null 2>&1; do
            for i in "${spinner[@]}"; do
                tput civis 2>/dev/null
                echo -ne "\033[1;96m\r [+] Installing $1 ... \e[33m[\033[1;92m$i\033[1;93m]\033[0m   "
                sleep $delay
            done
        done
        tput cnorm 2>/dev/null
        echo -e "\r\e[1;92m [✓] Done: $1\e[0m          "
        echo
    }

    apt update >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1

    local packages=("git" "python" "ncurses-utils" "jq" "figlet" "termux-api" "lsd" "zsh" "ruby" "exa")
    for package in "${packages[@]}"; do
        if ! dpkg -l 2>/dev/null | grep -q "^ii  $package "; then
            pkg install "$package" -y >/dev/null 2>&1 &
            show_spinner "$package"
        fi
    done

    if ! command -v lolcat >/dev/null 2>&1; then
        pip install lolcat >/dev/null 2>&1 &
        show_spinner "lolcat"
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh >/dev/null 2>&1 &
        show_spinner "oh-my-zsh"
    fi

    rm -rf /data/data/com.termux/files/usr/etc/motd >/dev/null 2>&1

    if [ "$SHELL" != "/data/data/com.termux/files/usr/bin/zsh" ]; then
        chsh -s zsh >/dev/null 2>&1 &
        show_spinner "zsh-shell"
    fi

    if [ ! -f "$HOME/.zshrc" ]; then
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &
        show_spinner "zshrc"
    fi

    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" >/dev/null 2>&1 &
        show_spinner "zsh-autosuggestions"
    fi

    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" >/dev/null 2>&1 &
        show_spinner "zsh-syntax-highlighting"
    fi

    if ! gem list lolcat 2>/dev/null | grep -q lolcat; then
        echo "y" | gem install lolcat >/dev/null 2>&1 &
        show_spinner "lolcat (gem)"
    fi
}

# ── Copy files ──
setup() {
    local ds="$HOME/.termux"
    mkdir -p "$ds"

    [ ! -f "$ds/font.ttf" ]           && cp "$SCRIPT_DIR/files/font.ttf" "$ds/"
    [ ! -f "$ds/colors.properties" ]  && cp "$SCRIPT_DIR/files/colors.properties" "$ds/"

    cp "$SCRIPT_DIR/files/ASCII-Shadow.flf" "$PREFIX/share/figlet/" 2>/dev/null
    cp "$SCRIPT_DIR/files/remove" "/data/data/com.termux/files/usr/bin/remove"
    chmod +x "/data/data/com.termux/files/usr/bin/remove"
    termux-reload-settings 2>/dev/null
}

# ── Internet check ──
netcheck() {
    clear
    echo
    echo -e "  ${g}╔══════════════════════════════════════╗"
    echo -e "  ${g}║  ${C} ${y}Checking internet connection...${g}  ║"
    echo -e "  ${g}╚══════════════════════════════════════╝${n}"
    while true; do
        if curl --silent --head --fail https://github.com > /dev/null 2>&1; then
            break
        fi
        echo -e "  ${E} ${r}No internet — retrying...${n}"
        sleep 2.5
    done
    clear
}

# ── Banner name setup ──
donotchange() {
    clear
    echo
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo
    echo -e " ${A} ${c}Please Enter Your ${g}Banner Name ${y}(1-8 chars)${c}"
    echo

    while true; do
        read -rp "[+]──[Enter Your Name]────► " name
        echo
        if [[ ${#name} -ge 1 && ${#name} -le 8 ]]; then
            break
        fi
        echo -e " ${E} ${r}Name must be 1-8 characters. Try again.${n}"
        echo
    done

    local D1="$HOME/.termux"
    mkdir -p "$D1"

    local TEMP_FILE="$HOME/temp_t-banner.zshrc"
    sed "s/D1D4X/$name/g" "$SCRIPT_DIR/files/.zshrc"       > "$TEMP_FILE"
    sed "s/D1D4X/$name/g" "$SCRIPT_DIR/files/.t-banner.zsh-theme" \
        > "$HOME/.oh-my-zsh/themes/t-banner.zsh-theme" 2>/dev/null

    echo "$name" > "$D1/usernames.txt"
    echo ""      > "$D1/dx.txt"
    echo ""      > "$D1/ads.txt"

    if mv "$TEMP_FILE" "$HOME/.zshrc"; then
        clear
        echo
        echo -e "          ${g}Hey ${y}$name  ${g}✓ Banner created!"
        echo -e "${c}              (\_/)"
        echo -e "              (${y}^ω^${c})     ${g}I'm T-BANNER${c}"
        echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
        echo
        sleep 2
    else
        echo -e " ${E} ${r}Error creating banner.${n}"
        rm -f "$TEMP_FILE"
        sleep 1
    fi
    clear
}

# ── Banner display ──
banner() {
    clear
    echo -e "${c}
╔════════════════════════════════════════════════╗
║     ╔════╗────╔══╗╔═══╦═╗─╔╦═╗─╔╦═══╦═══╗      ║
║     ║╔╗╔╗║────║╔╗║║╔═╗║║╚╗║║║╚╗║║╔══╣╔═╗║      ║
║     ╚╝║║╚╝────║╚╝╚╣║─║║╔╗╚╝║╔╗╚╝║╚══╣╚═╝║      ║
║     ──║║──╔══╗║╔═╗║╚═╝║║╚╗║║║╚╗║║╔══╣╔╗╔╝      ║
║     ──║║──╚══╝║╚═╝║╔═╗║║─║║║║─║║║╚══╣║║╚╗      ║
║     ──╚╝──────╚═══╩╝─╚╩╝─╚═╩╝─╚═╩═══╩╝╚═╝      ║
╚════════════════════════════════════════════════╝
${n}
╭════════════════════════════════════════════════╮
┃ ${g}[ム] ${c}Name    : ${y}TERMUX-BANNER${n}                   ┃
┃ ${g}[ム] ${c}Version : ${y}1.0.0${n}                           ┃
┃ ${g}[ム] ${c}Author  : ${y}MOHAMMAD ALAMIN${n}                 ┃
┃ ${g}[ム] ${c}Website : ${y}https://alamin2k7.bio.link${n}      ┃
╰════════════════════════════════════════════════╯

"
}

# ── Main install flow ──
setupx() {
    if [ ! -d "/data/data/com.termux/files/usr/" ]; then
        echo -e " ${E} ${r}This script only works on Termux (Android).${n}"
        sleep 3
        exit 1
    fi

    ensure_curl
    netcheck
    banner
    echo -e " ${C} ${y}Termux detected — starting setup...${n}"
    echo -e " ${lm}"
    echo -e " ${A} ${g}Installing packages, please wait...${n}"
    echo -e " ${dm}"
    spin
    clear
    banner
    echo -e " ${A} ${p}Packages installed successfully!${n}"
    echo -e " ${dm}"
    sleep 1
    clear
    banner
    echo -e " ${C} ${c}Setting up files...${n}"
    setup
    donotchange
    clear
    banner
    echo -e " ${C} ${c}All done! Type ${g}exit${c} then reopen Termux.${n}"
    echo
    sleep 3
    cd "$HOME"
    rm -rf "$SCRIPT_DIR"
    exit 0
}


# ── Start directly ──
setupx