#!/bin/bash
pushd ~/.dotfiles > /dev/null

# Update dotfiles repo
git pull

# Install symlinks
backups=0
if [ ! -L ~/.gitconfig ]; then
    mv --interactive --verbose ~/.gitconfig ~/.gitconfig.bak
    backups=1
fi

if [ ! -L ~/.vimrc ]; then
    mv --interactive --verbose ~/.vimrc ~/.vimrc.bak
    backups=1
fi

if [ ! -L ~/.tmux.conf ]; then
    mv --interactive --verbose ~/.tmux.conf ~/.tmux.conf.bak
    backups=1
fi

if [ ! -L ~/.bashrc ]; then
    mv --interactive --verbose ~/.bashrc ~/.bashrc.bak
    backups=1
fi

if [ ! -L ~/.bash_profile ]; then
    mv --interactive --verbose ~/.bash_profile ~/.bash_profile.bak
    backups=1
fi

ln --force --no-dereference --symbolic --verbose .gitconfig ~/.gitconfig
ln --force --no-dereference --symbolic --verbose .vimrc ~/.vimrc
ln --force --no-dereference --symbolic --verbose .tmux.conf ~/.tmux.conf
ln --force --no-dereference --symbolic --verbose .bashrc ~/.bashrc
ln --force --no-dereference --symbolic --verbose .bash_profile ~/.bash_profile
ln --force --no-dereference --symbolic --verbose shell ~/.shell

# Install vim plugins
if [ ! -d ~/.vim/autoload ]; then
    curl --create-dirs -o ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim -c "PlugInstall | quit | quit"
else
    vim -c "PlugUpgrade | PlugUpdate | quit | quit"
fi

if [ "$backups" -eq 1 ]; then
    printf "%b\n" "\e[32mUse \e[35;1mrm -ir ~/.*.bak\e[0;32m to remove backups.\e[0m"
fi

popd > /dev/null
printf "%b\n" "\e[32mDotfile installation completed. Restart the shell or type \e[35;1m. ~/.bashrc\e[0;32m to load shell environment.\e[0m"
