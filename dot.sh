#!/bin/sh

# Update the repo
git pull

printf "%b\n" "\e[36;1mBacking up existing dotfiles...\e[0m"
if [ ! -L ~/.gitconfig ]
then
    mv --interactive --verbose ~/.gitconfig ~/.gitconfig.bak
fi

if [ ! -L ~/.vimrc ]
then
    mv --interactive --verbose ~/.vimrc ~/.vimrc.bak
fi

printf "%b\n" "\e[36;1mCreating symlinks...\e[0m"
ln --force --no-dereference --symbolic --verbose $PWD/.gitconfig ~/.gitconfig
ln --force --no-dereference --symbolic --verbose $PWD/.vimrc ~/.vimrc

printf "%b\n" "\e[33;1mUse \e[35;1mrm -ir ~/.*.bak\e[33;1m to remove backups.\e[0m"
printf "%b\n" "\e[32mDotfile installation completed.\e[0m"
