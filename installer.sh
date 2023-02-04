#!/bin/sh

BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White
NC='\033[0m'              # Text Reset

SUPPORTED_VERSIONS=("1.0.0-alpha-2" "1.0.0-alpha-3")
SUPPORTED_VERSIONS_STR="[ 1.0.0-alpha-2, 1.0.0-alpha-3 ]"
CAIRO_TAR_PATH="$HOME/$CAIRO_VERSION.tar.gz"
CAIRO_PATH="~/cairo/bin"

CAIRO_ENV="export PATH=\"$CAIRO_PATH:\$PATH\""
CARGO_ENV="export PATH=\"\$PATH:$HOME/.cargo/bin\""

# Cairo versions
CAIRO100_ALPHA_2='https://github.com/starkware-libs/cairo/releases/download/v1.0.0-alpha.2/cairo-lang-1.0.0-alpha.2-x86_64-unknown-linux-musl.tar.gz'

# Map with relations between version and URL
declare -A VERSIONS_URL
VERSIONS_URL=( ["1.0.0-alpha-2"]=$CAIRO100_ALPHA_2 )
# VERSIONS_URL=( ["1.0.0-alpha-2"]=$CAIRO100_ALPHA_2 ["1.0.0-alpha-3"]=$CAIRO100_ALPHA_3 ... )

CAIRO_URL=""

set_cairo_version() {
    supported_versions_found=0
    for i in "${SUPPORTED_VERSIONS[@]}"; do
        if [[ $i == $1 ]]; then
            supported_versions_found=1
            break
        fi
    done
    if [[ $supported_versions_found == 1 ]]; then
        CAIRO_VERSION=$1
        CAIRO_URL=${VERSIONS_URL[$CAIRO_VERSION]}
        return 1
    else
        printf "${BRed}[ERROR] The version $1 is not in the supported versions: ${BWhite}$SUPPORTED_VERSIONS_STR. ${NC}\\n"
        return 0
    fi
}

set_bash_file() {
    if [ -f "$HOME/.bashrc" ]; then
        BASH_FILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        BASH_FILE="$HOME/.bash_profile"
    else
        printf "${BRed}[ERROR] Bash file cannot be found.${NC}\\n"
        exit 1
    fi
}

install_curl() {
    if ! command -v "curl" > /dev/null 2>&1; then
        printf "${BPurple}[!] Curl was not found, installing..${NC}\\n"
        sudo apt install curl -y
    else
        printf "${BGreen}[OK] Curl was found, skipping install..${NC}\\n"
    fi
}

install_cargo() {
    if ! command -v "cargo" > /dev/null 2>&1; then
        printf "${BPurple}[!] Cargo was not found, installing..${NC}\\n"
        curl https://sh.rustup.rs -sSf | sh -s -- -y
        
        printf "${BCyan}[!] Check Cargo env..${NC}\\n"
        if grep -q "$CARGO_ENV" "$BASH_FILE"; then
            printf "${BGreen}[!] $CARGO_ENV is already setted in $BASH_FILE.${NC}\\n"
        else
            printf "${BPurple}[!] $CARGO_ENV is not setted, trying to set into $BASH_FILE..${NC}\\n"
            echo >> $BASH_FILE
            echo $CARGO_ENV >> $BASH_FILE
        fi

        return
    else
        printf "${BGreen}[OK] Cargo was found, skipping install..${NC}\\n"
    fi    
}

download_cairo() {
    printf "${BCyan}[!] Downloading Cairo ($CAIRO_VERSION) from GitHub..${NC}\\n"

    curl -LJ "$CAIRO_URL" -o "$CAIRO_TAR_PATH"

    if test -f "$CAIRO_TAR_PATH"; then
        printf "${BGreen}[!] Download success file path $CAIRO_TAR_PATH.${NC}\\n"
    else
        printf "${BRed}[!] An error occurs trying to download Cairo from Github  :(${NC}\\n"
        exit 1
    fi

    printf "${BCyan}[!] Decompressing.. ${NC}\\n"
    tar -xzvf "$CAIRO_TAR_PATH" -C "$HOME" > temp
}

check_envs() {
    printf "${BCyan}[!] Check Cargo env..${NC}\\n"
    if grep -q "$CARGO_ENV" "$BASH_FILE"; then
        printf "${BGreen}[!] $CARGO_ENV is already setted in $BASH_FILE.${NC}\\n"
    else
        printf "${BPurple}[!] $CARGO_ENV is not setted, trying to set into $BASH_FILE..${NC}\\n"
        echo >> $BASH_FILE
        echo $CARGO_ENV >> $BASH_FILE
    fi

    printf "${BCyan}[!] Check Cairo env ($CAIRO_PATH)..${NC}\\n"
    if grep -q "$CAIRO_ENV" "$BASH_FILE"; then
        printf "${BGreen}[!] $CAIRO_ENV is already setted in $BASH_FILE.${NC}\\n"
    else
        printf "${BPurple}[!] $CAIRO_ENV is not setted, trying to set into $BASH_FILE..${NC}\\n"
        echo >> $BASH_FILE
        echo $CAIRO_ENV >> $BASH_FILE
    fi
    source $BASH_FILE
}

clean() {
    printf "${BCyan}[!] Clean..${NC}\\n"
    rm ./temp
    rm $CAIRO_TAR_PATH
}

run_cairo_version() {
    if ! command --version "cairo-compile" > /dev/null 2>&1; then
        printf "${BGreen}[!] Cairo installation was successful! (v$CAIRO_VERSION)${NC}\\n"
        printf "${BPurple}\\n[!] Trying to run Hello World..${NC}\\n"
        cargo run --bin cairo-run -- -p ./example/hello_world.cairo         
    fi
}


# START OF SCRIPT
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

set_cairo_version $1
version_is_supported=$?
 if [[ $supported_versions_found == 1 ]]; then

    if [ -n "$CAIRO_URL" ]; then
        printf "${BCyan}Installing Cairo ($CAIRO_VERSION) for Ubuntu${NC}\\n"
        set_bash_file
        install_curl
        install_cargo
        download_cairo
        check_envs
        clean

        run_cairo_version 
    else
        printf "${BRed}[!] Cannot set the URL for download Cairo, are you trying to install one of this versions? ${BWhite}$SUPPORTED_VERSIONS_STR ${NC}\\n"
    fi  
 fi
