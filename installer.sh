#!/bin/sh

source variables.sh

set_cairo_version() {
    # User dont send a version parameter, so take latest supported.
    if [[ -z $1 ]]; then
        CAIRO_VERSION=$LATEST_VERSION
        CAIRO_URL=${VERSIONS_URL[$CAIRO_VERSION]}
        CAIRO_TAR_PATH="$HOME/$CAIRO_VERSION.tar.gz"
        CAIRO_PATH="~/cairo/$CAIRO_VERSION/bin"
        CAIRO_ENV="PATH=\"$CAIRO_PATH:\$PATH\""
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
        CAIRO_PATH="~/cairo/$CAIRO_VERSION/bin"
        CAIRO_ENV="PATH=\"$CAIRO_PATH:\$PATH\""
        return 1
    else
        return 0
    fi
}

set_bash_file() {
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

    set_cairo_version $1
    version_is_supported=$?
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
        source os/linux.sh $CAIRO_VERSION $CAIRO_TAR_PATH $CAIRO_URL $CAIRO_ENV $CARGO_ENV $BASH_FILE
    fi

}

main $1