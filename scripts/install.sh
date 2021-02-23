#!/bin/bash
function link () {
    if [ -L "$2" ]; then
        ln --symbolic --no-dereference --force "$1" "$2"
    else
        ln --symbolic --no-dereference --backup "$1" "$2"
    fi
}

# Update dotfiles repo
pushd ~/.dotfiles > /dev/null
if ! git pull -q --ff-only ; then
    echo -e "\e[33mUnable to update dotfiles without merging.\e[0m"
fi

# Install symlinks
cd ~
if [ ! -e .ssh ]; then
    mkdir .ssh
fi
link    .dotfiles/gitconfig         .gitconfig
link    .dotfiles/vimrc             .vimrc
link    ../.dotfiles/ssh_config     .ssh/config
link    ../../.dotfiles/terminator-config .config/terminator/config
link    ../../../.dotfiles/vscode-settings.json .config/Code/User/settings.json

popd > /dev/null
