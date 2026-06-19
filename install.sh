#!/bin/bash
clear
mkdir -p $HOME/.T-BANNER
mkdir -p $HOME/.T-BANNER-simu
mkdir -p $HOME/.toolx

# color
r='\033[1;91m'
p='\033[1;95m'
y='\033[1;93m'
g='\033[1;92m'
n='\033[1;0m'
b='\033[1;94m'
c='\033[1;96m'

# Symbol
X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;92m]\033[92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'

# icon
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

# Check if Termux
if [ ! -d "/data/data/com.termux/files/usr/" ]; then
    echo -e "${r}╔════════════════════════════════════╗"
    echo -e "${r}║                                    ║"
    echo -e "${r}║  ${c}✖ ${r}This script only works on   ║"
    echo -e "${r}║  ${c}✖ ${r}Termux for Android!         ║"
    echo -e "${r}║                                    ║"
    echo -e "${r}║  ${y}◉ ${g}Please use Termux app        ║"
    echo -e "${r}║                                    ║"
    echo -e "${r}╚════════════════════════════════════╝${n}"
    echo
    exit 1
fi


exit_script() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"              
    echo -e "\n ${g}[${n}${KER}${g}] ${c}Exiting ${g}T-BANNER Banner \033[1;36m"
    echo
    cd "$HOME"
    rm -rf "$HOME/T-BANNER"
    kill -9 $PPID 2>/dev/null
    exit 0
}

if command -v tput &>/dev/null; then
    echo ""
else
    echo -e " ${C} ${g}Waiting for setup Screen!¡${n}"
    pkg install ncurses-utils -y >/dev/null 2>&1
    clear
fi

if command -v curl &>/dev/null; then
    echo ""
else
    pkg install curl -y >/dev/null 2>&1
    clear
fi

trap exit_script SIGINT SIGTSTP

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

start() {
    clear
    tput civis
    LIME='\e[38;5;154m'
    C='\e[38;5;51m'
    BLINK='\e[5m'
    N='\e[0m'
    TOTAL_CHARS=0
    texts=(
        "「 T-BANNER STARTED 」"
        "「 HELLO DEAR USER I'M DX-SIMU 」"
        "「 T-BANNER WILL PROTECT YOU 」"
        "「 GOODBYE 」"
        "「 ENJOY OUR T-BANNER 」"
        "「............... 」"
    )
    for t in "${texts[@]}"; do
        TOTAL_CHARS=$((TOTAL_CHARS + ${#t}))
    done
    CURRENT_CHAR=0
    update_progress() {
        local percentage=$(( CURRENT_CHAR * 100 / TOTAL_CHARS ))
        if [ "$percentage" -gt 100 ]; then percentage=100; fi
        local term_width=$(tput cols)
        local bar_width=$((term_width - 20))
        if [ "$bar_width" -gt 50 ]; then bar_width=50; fi
        local padding=$(( (term_width - bar_width - 10) / 2 ))
        local filled=$(( percentage * bar_width / 100 ))
        local empty=$(( bar_width - filled ))
        local f_bar=$(printf "%${filled}s" "")
        local e_bar=$(printf "%${empty}s" "")
        tput sc
        tput cup 2 0
        tput el
        printf "%${padding}s${LIME}[\e[48;5;154m%s\e[0m\e[48;5;236m%s\e[0m${LIME}] ${C}%3d%%${N}" "" "$f_bar" "$e_bar" "$percentage"
        tput rc
    }
    type_effect() {
        local text="$1"
        local delay="$2"
        local term_width=$(tput cols)
        local text_length=${#text}
        local padding=$(( (term_width - text_length) / 2 ))
        printf "%${padding}s" ""
        for ((i=0; i<${#text}; i++)); do
            CURRENT_CHAR=$((CURRENT_CHAR + 1))
            update_progress
            printf "${LIME}${BLINK}${text:$i:1}${N}"
            if (( RANDOM % 1 == 0 )); then
                printf "\e[48;5;51m \e[0m"
                printf "\b \b"
            fi
            sleep "$delay"
        done
        echo
        echo
    }
    tput cup 5 0
    type_effect "${texts[0]}" 0.01
    sleep 0.1
    type_effect "${texts[1]}" 0.02
    sleep 0.1
    type_effect "${texts[2]}" 0.02
    sleep 0.1
    type_effect "${texts[3]}" 0.02
    sleep 0.1
    type_effect "${texts[4]}" 0.02
    sleep 0.1
    type_effect "${texts[5]}" 0.02
    sleep 1
    tput cnorm
    clear 
}
start

tr() {
    if ! command -v curl &>/dev/null; then
        pkg install curl -y &>/dev/null 2>&1
    fi
}

spin() {
    echo
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

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

    pkg update >/dev/null 2>&1
    pkg upgrade -y >/dev/null 2>&1
    
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
    termux-reload-settings
}

dxnetcheck() {
    clear
    echo
    echo -e "		              ${g}Uhu"
    echo -e "${c}                        (\_/)"
    echo -e "                        (${y}^_^${c})"
    echo -e "                       ⊂(___)づ"
    echo
    echo -e "                ${g}╔════════════════╗"
    echo -e "                ${g}║ ${n}</>  ${c}T-BANNER-X${g}   ║"
    echo -e "                ${g}╚════════════════╝"
    echo -e "  ${g}╔════════════════════════════════════════════╗"
    echo -e "  ${g}║  ${y} Checking Your Internet Connection¡ ${g}      ║"
    echo -e "  ${g}╚════════════════════════════════════════════╝${n}"
    
    local attempts=0
    while [ $attempts -lt 5 ]; do
        if curl --silent --head --fail --connect-timeout 3 https://github.com > /dev/null 2>&1; then
            clear
            return 0
        fi
        attempts=$((attempts + 1))
        echo -e "              ${g}╔══════════════════╗"
        echo -e "              ${g}║${C} ${r}No Internet ${g}║"
        echo -e "              ${g}╚══════════════════╝"
        sleep 1
    done
    
    echo -e "\n${r}No internet after 5 attempts. Exiting...${n}"
    exit 1
}

sync_id() {
    UPDATE_LOG="$HOME/.t-banner_update_id.txt"
    if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
        # T-BANNER_URL define korte hobe
        local T-BANNER_URL="https://api.github.com/repos/your-repo/your-branch"
        local sid=$(curl -s --connect-timeout 5 "$T-BANNER_URL/update" 2>/dev/null | jq -r '.id' 2>/dev/null | tr -d '[:space:]')
        [ -n "$sid" ] && [ "$sid" != "null" ] && echo "$sid" > "$UPDATE_LOG"
    fi
}

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
        echo -e " ${A} ${c}Your Banner created ${g}Successfully¡${c}"
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

setupx() {
    tr
    dxnetcheck
    banner
    
    echo -e " ${C} ${y}Detected Termux on Android¡"
    echo -e " ${lm}"
    echo -e " ${A} ${g}Updating Package..¡"
    echo -e " ${dm}"
    echo -e " ${A} ${g}Wait a few minutes.${n}"
    echo -e " ${lm}"
    spin

    if [ -d "$HOME/T-BANNER" ]; then
        sleep 2
        clear
        banner
        echo -e " ${A} ${p}Updating Completed...!¡"
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
        echo -e " ${C} ${c}Type ${g}exit ${c} then ${g}enter ${c}Now Open Your Terminal¡¡ ${g}[${n}${HOMES}${g}]${n}"
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

# Direct setup start - No menu
setupx