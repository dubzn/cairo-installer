#!/bin/sh

BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White
NC='\033[0m'              # Text Reset

CAIRO_VERSION=$1
CAIRO_TAR_PATH=$2
CAIRO_URL=$3

CAIRO_ENV="export $4"
CARGO_ENV="export $5"

BASH_FILE=$6

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
    printf "${BCyan}[!] Cleaning up..${NC}\\n"
    rm ./temp
    rm $CAIRO_TAR_PATH
}

run_cairo_version() {
    if ! command -V "cairo-compile" > /dev/null 2>&1; then
        printf "${BGreen}[!] Cairo installation was successful! (v$CAIRO_VERSION)${NC}\\n"
        printf "${BPurple}\\n[!] Trying to run Hello World..${NC}\\n"
        source $BASH_FILE
        echo $PATH
    else 
        printf "${BRed}[!] Cairo installation failed!${NC}\\n"
    fi
}

main() {
    install_curl
    install_cargo
    download_cairo
    check_envs
    clean
    run_cairo_version
}

main
