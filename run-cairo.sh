#!/bin/sh

BPurple='\033[1;35m'      # Purple
NC='\033[0m'              # Text Reset

run_cairo() {
    printf "${BPurple}[!] Trying to run Hello World..${NC}\\n"
    printf "${BPurple}[!] You may need to run 'source $BASH_FILE' (or restart console) for the changes to take effect${NC}\\n"
    if [ ! -z "$1" ]; then
        $1/cairo-compile --version
        $1/cairo-run -p ./src/hello_world.cairo               
    else ! command "-h" "cairo-compile" > /dev/null 2>&1;
        cairo-compile --version
        cairo-run -p ./src/hello_world.cairo               
    fi
}

run_cairo $1