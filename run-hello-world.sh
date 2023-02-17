#!/bin/sh

run_cairo_version() {
    if ! command "--version" "cairo-compile" > /dev/null 2>&1; then
        printf "${BGreen}[!] Cairo installation was successful! (v$CAIRO_VERSION)${NC}\\n"
        printf "${BPurple}[!] Trying to run Hello World..${NC}\\n"
        cairo-run -p $APP_PATH/src/hello_world.cairo               
    else 
        printf "${BRed}[!] Cairo installation failed!${NC}\\n"
    fi
}

run_cairo_version