#!/bin/sh

source variables.sh

CAIRO_VERSION=$1
CAIRO_TAR_PATH=$2
CAIRO_URL=$3

CAIRO_ENV="export $4"
CAIRO_ENV_TEMP=$4
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
    cd $HOME
    git clone https://github.com/starkware-libs/cairo.git
    cd cairo
    cargo build --all --release
    cd target/release  
    pwd
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

run_cairo_version() {
    printf "${BPurple}[!] You may need to run 'source $BASH_FILE' for the changes to take effect${NC}\\n"
    if ! command "--version" "cairo-compile" > /dev/null 2>&1; then
        printf "${BGreen}[!] Cairo installation was successful! (v$CAIRO_VERSION)${NC}\\n"
        printf "${BPurple}\\n[!] Trying to run Hello World..${NC}\\n"
        export PATH=$HOME/cairo/$CAIRO_VERSION/bin:$PATH
        cairo-run -p ./src/hello_world.cairo         
    else 
        printf "${BRed}[!] Cairo installation failed!${NC}\\n"
    fi
}

main() {
    install_curl
    install_cargo
    download_cairo
    check_envs
    run_cairo_version
}

main