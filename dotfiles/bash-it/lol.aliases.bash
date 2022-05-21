#!/bin/bash

please() {
    echo "Since you asked nicely, I'll try."
    /usr/bin/sudo -p "[please] please enter your password: " "$@"
}

fucking() {
    echo "Fine, you little shit."
    /usr/bin/sudo -p "[fucking] shut the fuck up and say the $USER password:" "$@"
}

just() {
    echo "Yes, I'll do it."
    /usr/bin/sudo -p "[just] give your ($USER) password you fucker:" "$@"
}

argh() {
    echo "Stop being so pissed, you little shit."
    /usr/bin/sudo -p "[argh] say your password, $USER, you shit:" "$@"
}

sudo() {
    echo "Fun fact: It's su-DOOO, not su-DOH."
    /usr/bin/sudo -p "[sudo] (say it correctly) password for $USER:" "$@"
}

# the many variations of AAAARGH
alias aargh=argh
alias aaargh=argh
alias aaaargh=argh
alias aaaaargh=argh
alias aaaaaargh=argh
alias aaaaaaargh=argh
alias arghh=argh
alias arghhh=argh
alias arghhhh=argh
alias arghhhhh=argh
alias arghhhhhh=argh
alias arghhhhhhh=argh
alias arghhhhhhhh=argh
alias aarghh=argh
alias aaarghhh=argh
alias aaarghhhh=argh
alias aaaarghhhhh=argh
alias aaaaarghhhhhh=argh
alias aaaaaarghhhhhhh=argh
alias aaaaaaarghhhhhhhh=argh