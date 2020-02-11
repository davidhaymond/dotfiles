#!/bin/bash
function link () {
    local target=".dotfiles/$1"
    if [ ! "$2" ]; then
        local linkname="$1"
    else
        local linkname="$2"
    fi
    if [ -L "$linkname" ]; then
        ln --symbolic --no-dereference --force "$target" "$linkname"
    else
        ln --symbolic --no-dereference --backup "$target" "$linkname"
    fi
}

# Update dotfiles repo
pushd ~/.dotfiles > /dev/null
if ! git pull -q --ff-only ; then
    echo -e "\e[33mUnable to update dotfiles without merging.\e[0m"
fi

# Install symlinks
cd ~

link .gitconfig
link .vimrc
link .tmux.conf
link .bashrc
link .bash_profile
link shell .shell

# Install vim plugins
if [ ! -d ~/.vim/autoload ]; then
    curl -sSL --create-dirs -o ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim -c "PlugInstall | quit | quit"
else
    vim -c "PlugUpgrade | PlugUpdate | quit | quit"
fi

popd > /dev/null
