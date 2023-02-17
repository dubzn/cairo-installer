#!/bin/sh

source variables.sh

NEW_VERSION=""
ACTUAL_VERSION=""

set_bash_file() {
    if [ "$SHELL" == "/bin/bash" ]; then
        BASH_FILE="$HOME/.bashrc"
    elif [ "$SHELL" == "/bin/zsh" ]; then
        BASH_FILE="$HOME/.zshrc"
    else
        echo "TERMINAL_SUPPORTED=0" >> supports.txt
        return 
    fi
    echo "TERMINAL_SUPPORTED=1" >> supports.txt
    return 
}

version_is_installed() {
    CAIRO_VERSION=$1
    supported_versions_found=0

    for i in "${SUPPORTED_VERSIONS[@]}"; do
        if [[ $i == $CAIRO_VERSION ]]; then
            supported_versions_found=1
            break
        fi
    done

    if [[ $supported_versions_found == 1 ]]; then
        if [ -d "$CAIRO_FOLDER/$CAIRO_VERSION" ]; then
            NEW_VERSION=$CAIRO_VERSION
            echo "VERSION_SUPPORTED=1" >> supports.txt
            return 
        else 
            printf "${BPurple}[!] $CAIRO_VERSION is not installed, please use 'source installer.sh $CAIRO_VERSION' ${NC}\\n"
        fi
    else
        printf "${BRed}[!] Cannot find Cairo '$1', supported versions: ${BWhite}$SUPPORTED_VERSIONS_STR ${NC}\\n"
    fi
    echo "VERSION_SUPPORTED=0" >> supports.txt
}

modify_cairo_env() {
    NEW_CAIRO_ENV="export PATH=\"$HOME/cairo/$NEW_VERSION/bin:\$PATH"\"
    OLD_CAIRO_ENV_REGEX='[^/]*/cairo/[^/]*/bin'
    
    if grep -q "$OLD_CAIRO_ENV_REGEX" $BASH_FILE; then
        printf "${BPurple}[!] Changing to version ${BWhite}$NEW_VERSION${BPurple}.. ${NC}\\n"
        grep -v "$OLD_CAIRO_ENV_REGEX" $BASH_FILE > $BASH_FILE.tmp
        mv $BASH_FILE.tmp $BASH_FILE

        echo $NEW_CAIRO_ENV >> $BASH_FILE
    else
        printf "${BYellow}[!] No set variable found in $BASH_FILE, you can manually add the following line $NEW_CAIRO_ENV${NC}\\n"
    fi

    if grep -q "^$NEW_CAIRO_ENV" $BASH_FILE; then
        printf "${BGreen}[!] Version ${BWhite}$NEW_VERSION${BGreen} has been successfully configured ${NC}\\n"
        source $BASH_FILE
    fi
    printf "${BPurple}[!] You may need to run 'source $BASH_FILE' for the changes to take effect${NC}\\n"
}

create_bash_file_backup() {
    printf "${BCyan}[!] Creating a backup of your $BASH_FILE in $BASH_FILE.backup ${NC}\\n"
    cp $BASH_FILE $BASH_FILE.backup
}

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

printf "${BCyan}Changing Cairo version for ($1) ${NC}\\n"
version_is_installed $1
set_bash_file

if grep -q "VERSION_SUPPORTED=1" supports.txt; then
    printf "${BGreen}[!] Cairo version ($CAIRO_VERSION) is supported ${NC}\\n"
    create_bash_file_backup
    modify_cairo_env
fi

# Clean
rm ./supports.txt