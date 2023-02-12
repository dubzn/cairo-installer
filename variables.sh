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

# Versions
LATEST_VERSION="1.0.0-alpha-2"
SUPPORTED_VERSIONS=("1.0.0-alpha-2")
SUPPORTED_VERSIONS_STR="[ 1.0.0-alpha-2 ]"

# Envs
CAIRO_ENV=""
CARGO_ENV="PATH=\"\$PATH:$HOME/.cargo/bin\""
CAIRO_FOLDER="$HOME/cairo"

# GitHub Cairo Links
CAIRO100_ALPHA_2='https://github.com/starkware-libs/cairo/releases/download/v1.0.0-alpha.2/cairo-lang-1.0.0-alpha.2-x86_64-unknown-linux-musl.tar.gz'

# Map with relations between version and URL
declare -A VERSIONS_URL
VERSIONS_URL=( ["1.0.0-alpha-2"]=$CAIRO100_ALPHA_2 )

CAIRO_PATH=""
CAIRO_TAR_PATH=""
CAIRO_URL=""
CAIRO_VERSION=""

BASH_FILE=""
OS=""