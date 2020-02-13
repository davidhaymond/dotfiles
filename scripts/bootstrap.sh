#!/bin/bash

# Handle WSL's bad default permissions
if [[ "$(uname)" = "0000" ]]; then
    umask 0022
fi

# Delete any existing .gitconfig symlink
# to prevent Git errors caused by broken links
if [ -L ~/.gitconfig ]; then
    rm -f ~/.gitconfig
fi


# Update package cache
# --------------------

sudo apt-get update -qy


# Add Nodesource repository
# -------------------------

if [ ! -f /etc/apt/trusted.gpg.d/nodesource.gpg ]; then
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | \
        sudo apt-key --keyring /etc/apt/trusted.gpg.d/nodesource.gpg add - &> /dev/null
fi

NODESOURCE_PATH="/etc/apt/sources.list.d/nodesource.list"
sudo apt-get install lsb-release -qy
VERSION="node_12.x"
DISTRO="$(lsb_release -cs)"
echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee $NODESOURCE_PATH > /dev/null
echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a $NODESOURCE_PATH /dev/null


# Install packages
# ----------------

sudo apt-get update -qy
sudo apt-get dist-upgrade -qy
sudo apt-get install git nodejs tmux vim xdg-utils -qy   # xdg-utils is needed for vim-instant-markdown plugin
sudo npm install -gq npm instant-markdown-d browser-sync netlify-cli


# Configure system Git settings
# -----------------------------
sudo git config --system core.autocrlf input


# Clone or update dotfiles repo
# -----------------------------

if [ ! -d ~/.dotfiles ]; then
    pushd ~ > /dev/null

    # Clone with HTTPS so no password is required,
    # and then change the remote push URL to SSH
    git clone -q https://github.com/davidhaymond/dotfiles.git .dotfiles
    cd .dotfiles
    git remote set-url --push origin git@github.com:davidhaymond/dotfiles.git
else
    pushd ~/.dotfiles > /dev/null
fi

bash scripts/install.sh
popd > /dev/null
