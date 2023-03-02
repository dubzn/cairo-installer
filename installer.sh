#!/bin/sh

# DEBUGGER
DEBUG=1 # change to 1 for extra messages

# VARIABLES

# CLI Colors
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White
NC='\033[0m'              # Text Reset

CAIRO_REPOSITORY="https://github.com/starkware-libs/cairo.git"

# Versions
LATEST_VERSION="1.0.0-alpha-2"
SUPPORTED_VERSIONS="1.0.0-alpha-2"
SUPPORTED_VERSIONS_STR="[ 1.0.0-alpha-2 ]"

# Envs
CAIRO_ENV=""
CARGO_ENV="PATH=\"\$PATH:$HOME/.cargo/bin\""
CAIRO_FOLDER="$HOME/cairo"

CAIRO_PATH=""
CAIRO_TAR_PATH=""
CAIRO_URL=""
CAIRO_VERSION=""

BASH_FILE=""
OS=""

VERSIONS="1.0.0-alpha-2:https://github.com/starkware-libs/cairo/releases/download/v1.0.0-alpha.2/cairo-lang-1.0.0-alpha.2-x86_64-unknown-linux-musl.tar.gz"
set_url_by_version() {
    for version in "$VERSIONS"; do
        KEY=${version%%:*}
        VALUE=${version#*:}
    if [ "$1" = "$KEY" ]; then
        CAIRO_URL=$VALUE
    fi
    done
}

# UTILS
clean() {
    printf "${BCyan}[!] Cleaning up..${NC}\\n"
    rm ./temp 2> /dev/null || true
    rm ./supports.txt 2> /dev/null || true
}

clean_cairo_path() {
    rm $CAIRO_TAR_PATH 2> /dev/null || true
}

# FUNCTIONS
set_cairo_version() {
    # User dont send a version parameter, so take latest supported.
    if [ -z "$1" ]; then
        CAIRO_VERSION=$LATEST_VERSION
        set_url_by_version $CAIRO_VERSION
        CAIRO_TAR_PATH="$HOME/$CAIRO_VERSION.tar.gz"
        CAIRO_ENV="PATH=\"$HOME/cairo/latest/target/release:\$PATH\""
        echo "VERSION_SUPPORTED=1" >> supports.txt
        return 
    fi

    # User send a version parameter, so check if is supported.
    supported_versions_found=0
    for i in "${SUPPORTED_VERSIONS[@]}"; do
        if [ "$i" == "$1" ]; then
            supported_versions_found=1
            break
        fi
    done
    if [ "$supported_versions_found" == 1 ]; then
        CAIRO_VERSION=$1
        set_url_by_version $CAIRO_VERSION
        CAIRO_TAR_PATH="$HOME/$CAIRO_VERSION.tar.gz"
        CAIRO_ENV="$HOME/cairo/$CAIRO_VERSION/bin:\$PATH"
        echo "VERSION_SUPPORTED=1" >> supports.txt
        return 
    else
        printf "[set_cairo_version] returns 0 \\n"
        echo "VERSION_SUPPORTED=0" >> supports.txt
        return 
    fi
}

set_bash_file() {
    if [ "$SHELL"=="/bin/bash" ]; then
        BASH_FILE="$HOME/.bashrc"
    elif [ "$SHELL"=="/bin/zsh" ]; then
        BASH_FILE="$HOME/.zshrc"
    else
        echo "TERMINAL_SUPPORTED=0" >> supports.txt
        return 
    fi
    echo "TERMINAL_SUPPORTED=1" >> supports.txt
}

set_os() {
    OS=$(uname -s)
    if [ "$OS"=="Linux" ] || [ "$OS"=="Darwin" ]; then
        echo "OS_SUPPORTED=1" >> supports.txt
        return
    else
        echo "OS_SUPPORTED=0" >> supports.txt
        return 
    fi
}

main() {
    printf "${BCyan} 
    ############################################################################
    | _____         _               _         *    _          _  _            +|
    |/  __ \   *   (_)      *      (_)            | |        | || |   +    *   |
    || /  \/  __ _  _  _ __  ___    _  _ __   ___ | |_  __ _ | || |  ___  _ __ |
    || |     / _' || || '__|/ _ \  | || '_ \ / __|| __|/ _' || || | / _ \| '__||
    || \__/\| (_| || || |  | (_) | | || | | |\__ \| |_| (_| || || ||  __/| |   |
    | \____/ \__,_||_||_|   \___/  |_||_| |_||___/ \__|\__,_||_||_| \___||_|   |
    |+                           +                      *        by @dub_zn    |
    ############################################################################
    ${NC}\\n"

    clean 
    set_os
    if [ "$DEBUG" -eq 1 ]; then
        printf "[main] OS: $OS ${NC}\\n"
    fi
    if grep -q "OS_SUPPORTED=0" supports.txt; then
         printf "${BRed}[!] The OS is not supported $OS.\\n${NC}"
    fi

    set_cairo_version $1
    if [ "$DEBUG" -eq 1 ]; then
        printf "[main] CAIRO_VERSION: $CAIRO_VERSION ${NC}\\n"
        printf "[main] CAIRO_URL: $CAIRO_URL ${NC}\\n"
        printf "[main] CAIRO_TAR_PATH: $CAIRO_TAR_PATH ${NC}\\n"
        printf "[main] CAIRO_ENV: $CAIRO_ENV ${NC}\\n"
        printf "[main] CARGO_ENV: $CARGO_ENV ${NC}\\n"
    fi
    if grep -q "VERSION_SUPPORTED=0" supports.txt; then
        printf "${BRed}[!] Cannot set the URL for download Cairo, are you trying to install one of this versions? ${BWhite}$SUPPORTED_VERSIONS_STR ${NC}\\n"
    fi
    
    set_bash_file
    if [ "$DEBUG" -eq 1 ]; then
        printf "[main] BASH_FILE: $BASH_FILE ${NC}\\n"
    fi
    if grep -q "TERMINAL_SUPPORTED=0" supports.txt; then
         printf "${BRed}[!] The terminals supported by the script are: bash and zsh.\\n${NC}"
    fi

    if [ "$OS" = "Darwin" ]; then
        ./os/mac.sh $CAIRO_VERSION $CAIRO_TAR_PATH $CAIRO_URL $CAIRO_ENV $CARGO_ENV $BASH_FILE
    elif [ "$OS" = "Linux" ]; then
        ./os/linux.sh $CAIRO_VERSION $CAIRO_TAR_PATH $CAIRO_URL $CAIRO_ENV $CARGO_ENV $BASH_FILE
    fi
}

main $1
