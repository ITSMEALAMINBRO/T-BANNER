# ============================================
# T-BANNER ZSHRC - Termux Only
# ============================================

ZSH_THEME="t-banner"
export ZSH=$HOME/.oh-my-zsh
plugins=(git)

# ============================================
# Termux Specific Setup
# ============================================
TOOLX_DIR="$HOME/.toolx"
D1="$HOME/.termux"
PLUGINS_DIR="$HOME/.oh-my-zsh/plugins"
alias rd='termux-reload-settings'

# ============================================
# Load Oh-My-Zsh
# ============================================
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source "$ZSH/oh-my-zsh.sh" >/dev/null 2>&1
fi

# ============================================
# Load Plugins
# ============================================
if [ -f "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" >/dev/null 2>&1
fi

if [ -f "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >/dev/null 2>&1
fi

# ============================================
# Alias for lsd (if installed)
# ============================================
if command -v lsd >/dev/null 2>&1; then
    alias la='lsd -l --blocks size,name --color always | column -c $(tput cols)'
    alias ls='lsd -l --blocks size,name --color always'
    alias lt='lsd --tree --blocks size,name --color always --icon always'
fi

# ============================================
# Colors & Symbols
# ============================================
r='\033[91m'
p='\033[1;95m'
y='\033[93m'
g='\033[92m'
n='\033[0m'
b='\033[94m'
c='\033[96m'

X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;32m]\033[1;92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
aHELL="\uf489"
USER="\uf007"
TERMINAL="\ue7a2"
PKGS="\uf8d6"
UPT="\uf49b"
CAL="\uf073"

bol='\033[1m'
bold="${bol}\e[4m"
THRESHOLD=100

# ============================================
# Check Disk Usage
# ============================================
check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size
    local used_size
    local disk_usage
    
    total_size=$(df -h "$HOME" | awk 'NR==2 {print $2}')
    used_size=$(df -h "$HOME" | awk 'NR==2 {print $3}')
    disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//g')

    if [ -z "$disk_usage" ]; then disk_usage=0; fi 

    if [ "$disk_usage" -ge "$threshold" ]; then
        echo -e " ${g}[${n}\uf0a0${g}] ${r}WARN: ${c}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    else
        echo -e " ${g}[${n}\uf0e7${g}] ${c}Disk usage: ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    fi
}

# ============================================
# Banner Display
# ============================================
banner() {
    command clear
    echo
    echo -e "    ${y}░█████╗░░█████╗░██████╗░███████╗██╗░░██╗"
    echo -e "    ${y}██╔══██╗██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝"
    echo -e "    ${y}██║░░╚═╝██║░░██║██║░░██║█████╗░░░╚███╔╝░"
    echo -e "    ${c}██║░░██╗██║░░██║██║░░██║██╔══╝░░░██╔██╗░"
    echo -e "    ${c}╚█████╔╝╚█████╔╝██████╔╝███████╗██╔╝╚██╗"
    echo -e "    ${c}░╚════╝░░╚════╝░╚═════╝░╚══════╝╚═╝░░╚═╝${n}"
    echo
}

# ============================================
# Dashboard Drawing Functions
# ============================================
PUT() { echo -en "\033[${1};${2}H"; }
HIDECURSOR() { echo -en "\033[?25l"; }
NORM() { echo -en "\033[?12l\033[?25h"; }

draw_dashboard() {
    local data=$(check_disk_usage)
    local widths=$(stty size 2>/dev/null | awk '{print $2}')
    if [ -z "$widths" ] || [ "$widths" -lt 10 ]; then widths=$(tput cols 2>/dev/null || echo 80); fi

    local width=$widths
    local var=$((width - 2))
    local var2=$(printf '═%.0s' $(seq 1 $var))
    local var3=$(printf ' %.0s' $(seq 1 $var))
    local var4=$((width - 20))
    if [ $var4 -lt 1 ]; then var4=1; fi

    local prefix="${TERMINAL}${r}●${y}●${b}●${n}"
    local clean_prefix=$(echo -e "$prefix" | sed 's/\x1b\[[0-9;]*m//g')
    local prefix_len=${#clean_prefix}
    local clean_data=$(echo -e "${data}" | sed 's/\x1b\[[0-9;]*m//g')
    local data_len=${#clean_data}

    local data_start=$(((width - data_len) / 2))
    local padding=$((data_start - prefix_len))
    if [ $padding -lt 0 ]; then padding=0; fi

    local spaces=$(printf '%*s' $padding "")

    PUT 1 1
    echo -e "${prefix}${spaces}${data}${c}"

    PUT 2 1
    echo -e "\033[36;1m╔${var2}╗\033[0m"
    for ((i=3; i<=10; i++)); do
        PUT $i 1
        echo -e "\033[36;1m║${var3}║\033[0m"
    done
    PUT 11 1
    echo -e "\033[36;1m╚${var2}╝\033[0m"

    PUT 4 1
    if command -v simu >/dev/null 2>&1; then
        simu -w $width "DX-SIMU" | lolcat -f 2>/dev/null || simu -w $width "DX-SIMU"
    fi

    PUT 2 1
    echo -e "\033[36;1m╔${var2}╗\033[0m"
    for ((i=3; i<=10; i++)); do
        PUT $i 1
        echo -e "\033[36;1m║\033[0m"
        PUT $i $width
        echo -e "\033[36;1m║\033[0m"
    done
    PUT 11 1
    echo -e "\033[36;1m╚${var2}╝\033[0m"

    PUT 10 ${var4}
    echo -e "\e[32m[\e[0m\uf489\e[32m] \e[36mT-BANNER \e[36m1.5\e[0m"

    # ============================================
    # Show Date & Time (No Internet/Ads)
    # ============================================
    PUT 12 1
    local DATE=$(date +"%Y-%b-%a ${g}—${c} %d")
    local TM=$(date +"%I:%M:%S ${g}— ${c}%p")
    echo -e " ${g}[${n}${CAL}${g}] ${c}${TM} ${g}| ${c}${DATE}"

    PUT 13 1
    NORM
}

# ============================================
# Custom Clear Command
# ============================================
smart_clear() {
    if [ "$1" = "n" ]; then
        command clear
    else
        command clear
        draw_dashboard
    fi
}
alias clear='smart_clear'

# ============================================
# Load Animation (Simple)
# ============================================
load() {
    command clear
    echo -e "${TERMINAL}${r}●${n}"
    sleep 0.15
    command clear
    echo -e "${TERMINAL}${r}●${y}●${n}"
    sleep 0.15
    command clear
    echo -e "${TERMINAL}${r}●${y}●${b}●${n}"
    sleep 0.15
    command clear
}

# ============================================
# Startup
# ============================================
HIDECURSOR
load
command clear
draw_dashboard
