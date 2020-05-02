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
link    .dotfiles/.gitconfig        .gitconfig
link    .dotfiles/.vimrc            .vimrc
link    .dotfiles/.tmux.conf        .tmux.conf
link    .dotfiles/.bashrc           .bashrc
link    .dotfiles/.bash_profile     .bash_profile
link    .dotfiles/shell             .shell
link    ../.dotfiles/ssh_config     .ssh/config

# Install vim plugins
if [ ! -d ~/.vim/autoload ]; then
    curl -sSL --create-dirs -o ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim -c "PlugInstall | quit | quit"
else
    vim -c "PlugUpgrade | PlugUpdate | quit | quit"
fi

popd > /dev/null
