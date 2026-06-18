#!/bin/bash
clear
mkdir -p $HOME/.T-BANNER
mkdir -p $HOME/.T-BANNER-NX
mkdir -p $HOME/.toolx

# Colors
r='\033[1;91m'
p='\033[1;95m'
y='\033[1;93m'
g='\033[1;92m'
n='\033[1;0m'
b='\033[1;94m'
c='\033[1;96m'
    

# Symbols
X='\033[1;92m[\033[1;00mT-BANNER\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m◇\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;92m]\033[92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m◇\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m◇\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'

# Icons
OS="\uf6a6"
HOST="\uf6c3"
KER="\uf83c"
UPT="\uf49b"
PKGS="\uf8d6"
SH="\ue7a2"
TERMINAL="\uf489"
CHIP="\uf2db"
CPUI="\ue266"
HOMES="\uf015"

# Device Detection
MODEL=$(getprop ro.product.model)
VENDOR=$(getprop ro.product.manufacturer)
devicename="${VENDOR} ${MODEL}"
THRESHOLD=100
random_number=$(( RANDOM % 2 ))

# Exit handler
exit_script() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo -e "\n ${g}[${n}${KER}${g}] ${c}Exiting ${g}T-BANNER"
    echo
    cd "$HOME"
    rm -rf "$HOME/T-BANNER"
    kill -9 $PPID 2>/dev/null
    exit 0
}

# Install ncurses-utils first
if ! command -v tput &>/dev/null; then
    echo -e " ${C} ${g}Waiting for setup Screen!${n}"
    pkg install ncurses-utils -y >/dev/null 2>&1
    clear
fi

# Install curl if not present
if ! command -v curl &>/dev/null; then
    pkg install curl -y >/dev/null 2>&1
    clear
fi

trap exit_script SIGINT SIGTSTP

# Check disk usage
check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size=$(df -h "$HOME" | awk 'NR==2 {print $2}')
    local used_size=$(df -h "$HOME" | awk 'NR==2 {print $3}')
    local disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//g')

    if [ "$disk_usage" -ge "$threshold" ]; then
        echo -e "${g}[${n}\uf0a0${g}] ${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    else
        echo -e "${y}Disk usage: ${g}${disk_usage}% ${c}| ${g}${used_size}"
    fi
}
data=$(check_disk_usage)

# Start animation
start() {
    clear
    tput civis
    
    # Get terminal width
    width=$(tput cols)
    center=$((width / 2))
    
    # Circle spinner frames
    spin=('◐' '◓' '◑' '◒')
    
    # Text messages
    messages=(
        "T-BANNER STARTED"
        "HELLO DEAR USER"
        "I'M TERMUX BANNER TOOL"
        "ENJOY OUR BANNER"
        "LOADING COMPLETE"
    )
    
    # Circle position (line 2)
    circle_line=2
    text_line=5
    
    for i in "${!messages[@]}"; do
        msg="${messages[$i]}"
        msg_len=${#msg}
        msg_center=$(( (width - msg_len) / 2 ))
        
        # 4 frames per message
        for frame in {0..3}; do
            tput sc
            tput cup $circle_line 0
            tput el
            printf "%$((center - 2))s" ""
            echo -ne "${g}╭─${y}${spin[$frame]}${g}─╮${n}"
            
            tput cup $((circle_line + 1)) 0
            tput el
            printf "%$((center - 2))s" ""
            echo -ne "${g}│${c}●${p}◆${c}●${g}│${n}"
            
            tput cup $((circle_line + 2)) 0
            tput el
            printf "%$((center - 2))s" ""
            echo -ne "${g}╰─${y}${spin[$frame]}${g}─╯${n}"
            
            tput cup $text_line 0
            tput el
            printf "%${msg_center}s" ""
            echo -e "${c}${msg}${n}"
            
            tput rc
            sleep 0.08
        done
    done
    
    # Final animation
    for frame in {0..7}; do
        tput cup $circle_line 0
        tput el
        printf "%$((center - 2))s" ""
        echo -ne "${g}╭─${y}${spin[$((frame % 4))]}${g}─╮${n}"
        
        tput cup $((circle_line + 1)) 0
        tput el
        printf "%$((center - 2))s" ""
        echo -ne "${g}│${g}✔${c}✔${g}✔${c}│${n}"
        
        tput cup $((circle_line + 2)) 0
        tput el
        printf "%$((center - 2))s" ""
        echo -ne "${g}╰─${y}${spin[$((frame % 4))]}${g}─╯${n}"
        
        sleep 0.1
    done
    
    sleep 0.5
    tput cnorm
    clear
}
start

# Ensure curl
tr() {
    if ! command -v curl &>/dev/null; then
        pkg install curl -y >/dev/null 2>&1
    fi
}

# Spinner for installations
spin() {
    echo
    local delay=0.40
    local spinner=('█░░░░' '░█░░░' '░░█░░' '░░░█░' '░░░░█')

    show_spinner() {
        local pid=$!
        while ps -p $pid > /dev/null; do
            for i in "${spinner[@]}"; do
                tput civis
                echo -ne "\033[1;96m\r [+] Installing $1 please wait \e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
                sleep $delay
                printf "\b\b\b\b\b\b\b\b"
            done
        done
        printf "   \b\b\b\b\b"
        tput cnorm
        printf "\e[1;93m [Done $1]\e[0m\n"
        echo
        sleep 1
    }

    apt update >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1
    
    packages=("git" "python" "ncurses-utils" "jq" "figlet" "termux-api" "lsd" "zsh" "ruby" "exa")

    for package in "${packages[@]}"; do
        if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "ok installed"; then
            pkg install "$package" -y >/dev/null 2>&1 &
            show_spinner "$package"
        fi
    done

    if ! command -v lolcat >/dev/null 2>&1 || ! pip show lolcat >/dev/null 2>&1; then
        pip install lolcat >/dev/null 2>&1 &
        show_spinner "lolcat(pip)"
    fi
    
    rm -rf /data/data/com.termux/files/usr/bin/chat >/dev/null 2>&1

    if [ ! -d "$HOME/.toolx/" ]; then
        mkdir -p "$HOME/.toolx"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh >/dev/null 2>&1 &
        show_spinner "oh-my-zsh"
    fi
    
    if [ "$SHELL" != "/data/data/com.termux/files/usr/bin/zsh" ]; then
        chsh -s zsh >/dev/null 2>&1 &
        show_spinner "zsh-shell"
    fi
    
    if [ ! -f "$HOME/.zshrc" ]; then
        rm -rf ~/.zshrc >/dev/null 2>&1
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &
        show_spinner "zshrc"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions >/dev/null 2>&1 &
        show_spinner "zsh-autosuggestions"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1 &
        show_spinner "zsh-syntax"
    fi
}

# Setup Termux paths
setup_termux_paths() {
    mkdir -p $HOME/.toolx
    ds="$HOME/.termux"
    dx="$ds/font.ttf"
    simu="$ds/colors.properties"
    if [ ! -f "$dx" ]; then
        cp $HOME/T-BANNER/files/font.ttf "$ds"
    fi
    if [ ! -f "$simu" ]; then
        cp $HOME/T-BANNER/files/colors.properties "$ds"
    fi
    mv $HOME/T-BANNER/files/chat $HOME/.toolx/
    chmod +x $HOME/.toolx/chat
    mv $HOME/T-BANNER/files/unstall $HOME/.toolx/
    chmod +x $HOME/.toolx/unstall
    mv $HOME/T-BANNER/files/bname $HOME/.toolx/
    chmod +x $HOME/.toolx/bname
    mv $HOME/T-BANNER/files/simu $PREFIX/bin/
    chmod +x $PREFIX/bin/simu
    mv $HOME/T-BANNER/files/dev $HOME/.toolx/
    chmod +x $HOME/.toolx/dev
    mv $HOME/T-BANNER/files/update $HOME/.toolx/
    chmod +x $HOME/.toolx/update
    mv $HOME/T-BANNER/files/help $HOME/.toolx/
    chmod +x $HOME/.toolx/help
    mv $HOME/T-BANNER/files/code $PREFIX/bin/
    chmod +x $PREFIX/bin/code
    termux-reload-settings
}

# Check internet connection
dxnetcheck() {
    clear
    echo
    echo -e "		            ${g}Uhu"
    echo -e "${c}                      (\_/)"
    echo -e "                      (${y}^_^${c})"
    echo -e "                     ⊂(___)づ"
    echo
    echo -e "               ${g}╔═════════════════╗"
    echo -e "               ${g}║ ${n}</>  ${c}T-BANNER${g}   ║"
    echo -e "               ${g}╚═════════════════╝"
    echo -e "  ${g}╔════════════════════════════════════════════╗"
    echo -e "  ${g}║     ${y} Checking Your Internet Connection¡ ${g}   ║"
    echo -e "  ${g}╚════════════════════════════════════════════╝${n}"
    while true; do
        curl --silent --head --fail https://github.com > /dev/null
        if [ "$?" != 0 ]; then
            echo -e "              ${g}╔══════════════════╗"
            echo -e "              ${g}║${C} ${r}No Internet ${g}║"
            echo -e "              ${g}╚══════════════════╝"
            sleep 2.5
        else
            break
        fi
    done
    clear
}

# Sync ID
sync_id() {
    UPDATE_LOG="$HOME/.t-banner_update_id.txt"
    if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
        local sid=$(curl -s --connect-timeout 5 "$T-BANNER/update" 2>/dev/null | jq -r '.id' 2>/dev/null | tr -d '[:space:]')
        [ -n "$sid" ] && [ "$sid" != "null" ] && echo "$sid" > "$UPDATE_LOG"
    fi
}

# Banner name setup
donotchange() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo
    echo -e " ${A} ${c}Please Enter Your ${g}Banner Name${c}"
    echo
    while true; do
        read -p "$(echo -e ${c}${A}──[Enter Your Name]────► ${n})" name
        echo
        
        if [[ -z "$name" ]]; then
            echo -e " ${E} ${r}Name cannot be empty!${c}"
            echo
            continue
        fi
        
        if [[ ! "$name" =~ ^[a-zA-Z0-9[:space:]-]+$ ]]; then
            echo -e " ${E} ${r}Invalid Input! No fancy fonts or symbols.\n ${E} ${r}Use letters, numbers, hyphens & spaces only.${c}"
            echo
            continue
        fi

        name="${name^^}"
        name="${name// /-}"

        len=${#name}
        if [[ $len -ge 1 && $len -le 8 ]]; then
            break
        else
            echo -e " ${E} ${r}Name must be between ${g}1 and 8${r} characters.\n ${y}Current length is: ${g}$len${c}"
            echo
        fi
    done

    D1="$HOME/.termux"
    mkdir -p "$D1"
    
    USERNAME_FILE="$D1/usernames.txt"
    INPUT_FILE="$HOME/T-BANNER/files/.zshrc"
    THEME_INPUT="$HOME/T-BANNER/files/.t-banner.zsh-theme"
    OUTPUT_ZSHRC="$HOME/.zshrc"
    OUTPUT_THEME="$HOME/.oh-my-zsh/themes/t-banner.zsh-theme"
    TEMP_FILE="$HOME/temp.zshrc"
    sed "s/DX-SIMU/$name/g" "$INPUT_FILE" > "$TEMP_FILE" &&
    sed "s/DX-SIMU/$name/g" "$THEME_INPUT" > "$OUTPUT_THEME" &&
 
    if [[ $? -eq 0 ]]; then
        mv "$TEMP_FILE" "$OUTPUT_ZSHRC"
        clear
        echo
        echo
        echo -e "		        ${g}Hey ${y}$name"
        echo -e "${c}              (\_/)"
        echo -e "              (${y}^ω^${c})     ${g}I'm Dx-Simu${c}"
        echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
        echo
        echo -e " ${A} ${c}Your Banner created ${g}Successfully!${c}"
        echo
        sleep 1
        sync_id
    else
        echo
        echo -e " ${E} ${r}Error occurred while processing the file."
        sleep 1
        rm -f "$TEMP_FILE"
    fi
    clear
}

# Main banner display
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
${n}╭════════════════════════════════════════════════╮
┃ ${g}[ム] ${c}Name    : ${y}TERMUX-BANNER${n}                   ┃
┃ ${g}[ム] ${c}Version : ${y}1.0.0${n}                           ┃
┃ ${g}[ム] ${c}Author  : ${y}MOHAMMAD ALAMIN${n}                 ┃
┃ ${g}[ム] ${c}Website : ${y}https://alamin2k7.bio.link${n}      ┃
╰════════════════════════════════════════════════╯

"
}



# Main setup - DIRECT START (no menu)
setupx() {
    tr
    dxnetcheck
    banner
    
    echo -e " ${C} ${y}Detected Termux on Android!"
    echo -e " ${lm}"
    echo -e " ${A} ${g}Updating Package..!"
    echo -e " ${dm}"
    echo -e " ${A} ${g}Wait a few minutes.${n}"
    echo -e " ${lm}"
    spin

    if [ -d "$HOME/T-BANNER" ]; then
        sleep 2
        clear
        banner
        echo -e " ${A} ${p}Updating Completed...!!"
        echo -e " ${dm}"
        clear
        banner
        echo -e " ${C} ${c}Package Setup Your System..${n}"
        echo
        echo -e " ${A} ${g}Wait a few minutes.${n}"
        
        setup_termux_paths
        donotchange
        clear
        banner
        echo -e " ${C} ${c}Type ${g}exit ${c} then ${g}enter ${c}Now Open Your Terminal!! ${g}[${n}${HOMES}${g}]${n}"
        echo
        sleep 3
        cd "$HOME"
        rm -rf "$HOME/T-BANNER"
        kill -9 $PPID 2>/dev/null
        exit 0
    else
        clear
        banner
        echo -e " ${E} ${r}Tools Not Exits Your Terminal.."
        echo
        echo
        sleep 3
        exit
    fi
}

# Start directly
setupx