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

LATEST_VERSION="1.0.0-alpha-2"
SUPPORTED_VERSIONS=("1.0.0-alpha-2")
SUPPORTED_VERSIONS_STR="[ 1.0.0-alpha-2 ]"
CAIRO_PATH="~/cairo/bin"

CAIRO_ENV="PATH=\"$CAIRO_PATH:\$PATH\""
CARGO_ENV="PATH=\"\$PATH:$HOME/.cargo/bin\""

# Cairo versions
CAIRO100_ALPHA_2='https://github.com/starkware-libs/cairo/releases/download/v1.0.0-alpha.2/cairo-lang-1.0.0-alpha.2-x86_64-unknown-linux-musl.tar.gz'

# Map with relations between version and URL
declare -A VERSIONS_URL
VERSIONS_URL=( ["1.0.0-alpha-2"]=$CAIRO100_ALPHA_2 )

CAIRO_TAR_PATH=""
CAIRO_URL=""
CAIRO_VERSION=""

BASH_FILE=""
OS=""

set_cairo_version() {
    printf "[set_cairo_version] init\\n"
    # User dont send a version parameter, so take latest supported.
    if [[ -z $1 ]]; then
        printf "[set_cairo_version] User dont send a version parameter, so take latest supported\\n"
        CAIRO_VERSION=$LATEST_VERSION
        CAIRO_URL=${VERSIONS_URL[$CAIRO_VERSION]}
        CAIRO_TAR_PATH="$HOME/$CAIRO_VERSION.tar.gz"
        
        printf "[set_cairo_version] version=$CAIRO_VERSION, url: $CAIRO_URL, tar_path=$CAIRO_TAR_PATH \\n"
        printf "[set_cairo_version] returns 1 \\n"
        return 1
    fi

    # User send a version parameter, so check if is supported.
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
        CAIRO_TAR_PATH="$HOME/$CAIRO_VERSION.tar.gz"
        printf "[set_cairo_version] returns 1 \\n"
        return 1
    else
        printf "[set_cairo_version] returns 0 \\n"
        return 0
    fi
}

set_bash_file() {
    printf "[set_bash_file] init\\n"
    if [ "$SHELL" == "/bin/bash" ]; then
        BASH_FILE="$HOME/.bashrc"
    elif [ "$SHELL" == "/bin/zsh" ]; then
        BASH_FILE="$HOME/.zshrc"
    else
        return 0
    fi
    return 1
}

set_os() {
    printf "[set_os] init\\n"
    if [ "$(uname -s)" == "Linux" ]; then
        OS="Linux"
    # elif [ "$(uname -s)" == "Darwin" ]; then
    #     OS="Mac"
    else
        return 0
    fi
    return 1
}

main() {
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

    version_is_supported=$(set_cairo_version)
    printf "[main] version_is_supported=$version_is_supported \\n"
    set_bash_file
    terminal_supported=$?
    set_os
    os_is_supported=$?

    if [[ $supported_versions_found == 0 ]]; then
        printf "${BRed}[!] Cannot set the URL for download Cairo, are you trying to install one of this versions? ${BWhite}$SUPPORTED_VERSIONS_STR ${NC}\\n"
    fi

    if [[ $terminal_supported == 0 ]]; then
        printf "${BRed}[!] The terminals supported by the script are: bash and zsh.\\n${NC}"
    fi

    if [[ $os_is_supported == 0 ]]; then
        printf "${BRed}[!] The OS is not supported $OS.\\n${NC}"
    fi

    printf "${BCyan}Installing Cairo ($CAIRO_VERSION) for $OS ${NC}\\n"
    # if [[ $OS == 'Mac' ]]; then
    #     source mac.sh $CAIRO_VERSION $CAIRO_TAR_PATH $CAIRO_URL $CAIRO_ENV $CARGO_ENV $BASH_FILE
    if [[ $OS == 'Linux' ]]; then
        source linux.sh $CAIRO_VERSION $CAIRO_TAR_PATH $CAIRO_URL $CAIRO_ENV $CARGO_ENV $BASH_FILE
    fi

}

main $1
