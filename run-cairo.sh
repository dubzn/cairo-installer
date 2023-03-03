#!/bin/sh

BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BPurple='\033[1;35m'      # Purple
NC='\033[0m'              # Text Reset

run_cairo() {
    if ! command "--version" "cairo-compile" > /dev/null 2>&1; then
        printf "${BPurple}[!] Trying to run Hello World..${NC}\\n"
        cairo-run -p ./src/hello_world.cairo               
    else 
        printf "${BRed}[!] Cairo installation failed!${NC}\\n"
    fi
}

run_cairo