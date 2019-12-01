#!/bin/sh

# Install symlinks
printf "%b\n" "\e[36;1mBacking up existing dotfiles...\e[0m"
if [ ! -L ~/.gitconfig ]; then
    mv --interactive --verbose ~/.gitconfig ~/.gitconfig.bak
fi

if [ ! -L ~/.vimrc ]
then
    mv --interactive --verbose ~/.vimrc ~/.vimrc.bak
fi

if [ ! -L ~/.tmux.conf ]
then
    mv --interactive --verbose ~/.tmux.conf ~/.tmux.conf.bak
fi

printf "%b\n" "\e[36;1mCreating symlinks...\e[0m"
if [ ! -d ~/.shell ]; then
    mkdir ~/.shell
fi

ln --force --no-dereference --symbolic --verbose $PWD/.gitconfig ~/.gitconfig
ln --force --no-dereference --symbolic --verbose $PWD/.vimrc ~/.vimrc
ln --force --no-dereference --symbolic --verbose $PWD/.tmux.conf ~/.tmux.conf
ln --force --no-dereference --symbolic --verbose $PWD/bash/.bashrc ~/.bashrc
ln --force --no-dereference --symbolic --verbose $PWD/bash/functions ~/.shell/functions
ln --force --no-dereference --symbolic --verbose $PWD/bash/aliases ~/.shell/aliases
. ~/.bashrc

# Install vim plugins
printf "%b\n" "\e[36;1mInstalling Vim plugins...\e[0m"
if [ ! -d ~/.vim/autoload ]; then
    curl --create-dirs -o ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim -c "PlugInstall | quit | quit"
else
    vim -c "PlugUpgrade | PlugUpdate | quit | quit"
fi

printf "%b\n" "\e[33;1mUse \e[35;1mrm -ir ~/.*.bak\e[33;1m to remove backups.\e[0m"
printf "%b\n" "\e[32mDotfile installation completed.\e[0m"
