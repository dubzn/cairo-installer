#!/bin/sh

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
CAIRO_FOLDER="$HOME/cairo"

CAIRO_VERSION=$1
CAIRO_TAR_PATH=$2
CAIRO_URL=$3

CAIRO_ENV="export $4"
CAIRO_ENV_TEMP=$4
CARGO_ENV="export $5"

BASH_FILE=$6

DEBUG=0 # change to 1 for extra messages

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

create_cairo_folder() {
    if [ ! -d "$CAIRO_FOLDER" ]; then
        printf "${BPurple}[!] Cairo folder does not exist, creating in $CAIRO_FOLDER ${NC}\\n"
        mkdir "$CAIRO_FOLDER"
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
    tar -xzvf "$CAIRO_TAR_PATH" -C "$CAIRO_FOLDER" > temp
    mv "$CAIRO_FOLDER/cairo" "$CAIRO_FOLDER/$CAIRO_VERSION" 
}

check_envs() {
    set_cargo_env
    set_cairo_env
}

set_cargo_env() {
    printf "${BCyan}[!] Check Cargo env..${NC}\\n"
    if grep -q "$CARGO_ENV" "$BASH_FILE"; then
        printf "${BGreen}[!] $CARGO_ENV is already setted in $BASH_FILE.${NC}\\n"
    else
        printf "${BPurple}[!] $CARGO_ENV is not setted, trying to set into $BASH_FILE..${NC}\\n"
        echo >> $BASH_FILE
        echo $CARGO_ENV >> $BASH_FILE
    fi
}

set_cairo_env() {
    printf "${BCyan}[!] Check Cairo env..${NC}\\n"
    if grep -q "$CAIRO_ENV" "$BASH_FILE"; then
        printf "${BGreen}[!] $CAIRO_ENV is already setted in $BASH_FILE.${NC}\\n"
    else
        printf "${BPurple}[!] $CAIRO_ENV is not setted, trying to set into $BASH_FILE..${NC}\\n"
        echo >> $BASH_FILE
        echo $CAIRO_ENV >> $BASH_FILE
    fi
}

clean() {
    printf "${BCyan}[!] Cleaning up..${NC}\\n"
    rm ./temp 2> /dev/null || true
    rm ./supports.txt 2> /dev/null || true
}

clean_cairo_path() {
    rm $CAIRO_TAR_PATH 2> /dev/null || true
}

create_folder() {
    if [  ! -d "$CAIRO_FOLDER/$1" ]; then
        printf "${BPurple}[!] Cairo version folder does not exist, creating in $CAIRO_FOLDER ${NC}\\n"
        mkdir "$CAIRO_FOLDER/$1"
    fi
}

install_latest() {
    printf "${BCyan}[!] Clonning Cairo (starkware-libs/cairo branch main)..${NC}\\n"
    # Save the path to later be able to execute hello world
    APP_PATH=$(pwd)
    
    # Clone from the main branch the last changes of cairo repository
    clone_cairo

    # Generate the release with the cargo command
    cargo build --all --release

    # Override latest folder
    rm $CAIRO_FOLDER/latest 2> /dev/null || true
    mv $CAIRO_FOLDER/cairo $CAIRO_FOLDER/latest

    cd $APP_PATH
}

clone_cairo() {
    cd $CAIRO_FOLDER
    git clone $CAIRO_REPOSITORY 
    cd cairo
}

run_cairo() {
    printf "${BPurple}[!] Trying to run Hello World..${NC}\\n"
    if [ ! -z "$1" ]; then
        $1/cairo-compile --version
        $1/cairo-run -p ./src/hello_world.cairo               
    else 
        cairo-compile --version
        cairo-run -p ./src/hello_world.cairo               
    fi
}

main() {
    if [ "$DEBUG" -eq 1 ]; then
        printf "[linux] CAIRO_VERSION=$CAIRO_VERSION ${NC}\\n"
        printf "[linux] CAIRO_TAR_PATH=$CAIRO_TAR_PATH ${NC}\\n"
        printf "[linux] CAIRO_URL=$CAIRO_URL ${NC}\\n"
        printf "[linux] CAIRO_ENV=$CAIRO_ENV ${NC}\\n"
        printf "[linux] CARGO_ENV=$CARGO_ENV ${NC}\\n"
        printf "[linux] BASH_FILE=$BASH_FILE ${NC}\\n"
    fi
    
    install_curl
    install_cargo
    create_cairo_folder

    if [ "$CAIRO_ENV"=*"latest"* ]; then
        printf "[linux] Installing latest${NC}\\n"
        install_latest
        export PATH=$HOME/cairo/latest/target/release:$PATH
        CAIRO_PATH=$HOME/cairo/latest/target/release
    else 
        printf "[linux] Installing specific version${NC}\\n"
        download_cairo
        export PATH=$HOME/cairo/$CAIRO_VERSION:$PATH
        CAIRO_PATH=$HOME/cairo/$CAIRO_VERSION
    fi
    check_envs
    
    printf "${BPurple}[!] You may need to run 'source $BASH_FILE' for the changes to take effect${NC}\\n"
    run_cairo $CAIRO_PATH

    printf "${BPurple}[!] You may need to run 'source $BASH_FILE' for the changes to take effect${NC}\\n"
    clean
    clean_cairo_path
}

main
