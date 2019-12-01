#!/bin/bash


# Update package cache
# --------------------

sudo apt-get update -y


# Add Nodesource repository
# -------------------------

if [ ! -f /etc/apt/trusted.gpg.d/nodesource.gpg ]; then
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | \
	    sudo apt-key --keyring /etc/apt/trusted.gpg.d/nodesource.gpg add -
fi

NODESOURCE_PATH="/etc/apt/sources.list.d/nodesource.list"
if [ ! -f $NODESOURCE_PATH ]; then
    sudo apt-get install lsb-release -y
    VERSION="node_10.x"
    DISTRO="$(lsb_release -cs)"
    echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee $NODESOURCE_PATH
    echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a $NODESOURCE_PATH
fi


# Install packages
# ----------------

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install git nodejs tmux vim xdg-utils -y   # xdg-utils is needed for vim-instant-markdown plugin
sudo npm install -g instant-markdown-d


# Install dotfiles
# ----------------

if [ -d ~/.dotfiles ]; then
    pushd ~/.dotfiles
    git pull
else
    # Clone with HTTPS so no password is required,
    # and then change the remote URL to SSH
    pushd ~
    git clone https://github.com/davidhaymond/dotfiles.git .dotfiles
    cd .dotfiles
    git remote set-url origin git@github.com:davidhaymond/dotfiles.git
fi

bash install.sh
popd
