#!/bin/bash

# Fix bad default permissions in WSL
if [[ "$(umask)" = "0000" ]]; then
    umask 0022
fi

# Source .bashrc
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
