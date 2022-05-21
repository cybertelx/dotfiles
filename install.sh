#!/bin/bash -i

# Install all the dotfiles,
# set up symlinks,
# etc etc.

declare -A custom_path_dotfiles

dotfiles=(
    profile bashrc bash_logout
)

custom_path_dotfiles=(
    ["vscodium/settings.json"]="$HOME/.config/VSCodium/User"
)

for i in "${dotfiles[@]}"
do
    # hope no programs are using it in the meantime
    rm $HOME/.$i > /dev/null
    # automagically add a dot before it
    ln -s $HOME/.dotfiles/dotfiles/$i ~/.$i
done

for i in "${!custom_path_dotfiles[@]}"
do
    mkdir -p ${custom_path_dotfiles[$i]}
    ln -nsfr dotfiles/$i ${custom_path_dotfiles[$i]}
done

# Bash-It framework

# Symlink bash-it extensions
rm $HOME/.bash_it_scripts > /dev/null
ln -nsfr dotfiles/bash-it $HOME/.bash_it_scripts

# Update/install bash-it
if [ -d "$HOME/.bash_it" ]
then
    # I like to live on the edge
    # Dev update brrrrrrrrrrrrrrr
    bash-it update dev --silent
else
    echo "bash-it could not be found, performing installation"
    # Install Bash-It
    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
    
    ~/.bash_it/install.sh -f --silent --append-to-config
fi