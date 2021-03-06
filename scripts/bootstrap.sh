#!/bin/bash

# Delete any existing .gitconfig symlink
# to prevent Git errors caused by broken links
if [ -L $HOME/.gitconfig ]; then
    rm -f $HOME/.gitconfig
fi

# Clone or update dotfiles repo
if [ ! -d $HOME/.dotfiles ]; then
    pushd $HOME > /dev/null
    # Clone with HTTPS so no password is required,
    # and then change the remote push URL to SSH
    git clone -q https://github.com/davidhaymond/dotfiles.git .dotfiles
    cd .dotfiles
    git remote set-url --push origin git@github.com:davidhaymond/dotfiles.git
else
    pushd $HOME/.dotfiles > /dev/null
fi

bash scripts/install.sh

popd > /dev/null

cat << 'EOF' >> $HOME/.bashrc

# Load custom shell scripts from dotfiles
for f in $HOME/.dotfiles/shell/*; do
    source $f
done
EOF
