#!/bin/sh

source variables.sh

set_bash_file() {
    if [ "$SHELL" == "/bin/bash" ]; then
        BASH_FILE="$HOME/.bashrc"
    elif [ "$SHELL" == "/bin/zsh" ]; then
        BASH_FILE="$HOME/.zshrc"
    elsecd 
        return 0
    fi
    return 1
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
            return 1
        else 
            printf "${BPurple}[!] $CAIRO_VERSION is not installed, please use 'source installer.sh $CAIRO_VERSION' ${NC}\\n"
        fi
    else
        printf "${BRed}[!] Cannot find Cairo '$1', supported versions: ${BWhite}$SUPPORTED_VERSIONS_STR ${NC}\\n"
    fi
    return 0
}

get_installed_versions() {
    # La subcadena que se va a buscar
    search="string_to_search"

    # Usamos el comando grep para buscar la subcadena
    grep "$search" $file

    # Verificamos si grep encontró algo
    if [ $? -eq 0 ]; then
    echo "Subcadena encontrada"
    else
    echo "Subcadena no encontrada"
    fi
}

modify_cairo_env() {
    installed_version=""
    replace="replacement_string"
    sed -i "s/$search/$replace/g" $file
}

version_is_installed $1