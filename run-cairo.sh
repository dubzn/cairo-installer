#!/bin/sh

BPurple='\033[1;35m'      # Purple
NC='\033[0m'              # Text Reset

run_cairo() {
    printf "${BPurple}[!] Trying to run Hello World..${NC}\\n"
    if [ ! -z "$1" ]; then
        $1/cairo-compile --version
        $1/cairo-run -p ./src/hello_world.cairo               
    else 
        cairo-compile --version
        cairo-run ./src/hello_world.cairo               
    fi
}

run_cairo $1
