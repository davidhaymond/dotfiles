#!/bin/bash

# Delete any existing .gitconfig symlink
# to prevent Git errors caused by broken links
if [ -L ~/.gitconfig ]; then
    rm -f ~/.gitconfig
fi

# Clone or update dotfiles repo
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

# Source the shell scripts
cat << EOF >> ~/.bashrc

# Load custom shell scripts from dotfiles
for f in ~/.dotfiles/shell/*
    do source $f
done
EOF

popd > /dev/null
