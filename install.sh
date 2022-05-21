#!/bin/bash -i

# Install all the dotfiles,
# set up symlinks,
# etc etc.

# Try to get wget, curl, etc.
sudo apt-get install curl wget git

declare -A custom_path_dotfiles

dotfiles=(
    profile bashrc bash_logout
)

custom_path_dotfiles=(
    ["vscodium/settings.json"]="$HOME/.config/VSCodium/User"
    ["vscodium/product.json"]="$HOME/.config/VSCodium"
)

for i in "${dotfiles[@]}"
do
    # hope no programs are using it in the meantime
    rm $HOME/.$i > /dev/null
    # automagically add a dot before it
    ln -s $HOME/.dotfiles/dotfiles/$i $HOME/.$i
done

for i in "${!custom_path_dotfiles[@]}"
do
    mkdir -p ${custom_path_dotfiles[$i]}
    ln -nsfr $HOME/.dotfiles/dotfiles/$i ${custom_path_dotfiles[$i]}
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
    
    ~/.bash_it/install.sh -f --silent --no-modify-config
fi

# Install programs: VSCodium, Brave, etc.

sudo apt install python3 python3-pip aptitude gh
pip3 install slither-analyzer

# FNM node
curl -fsSL https://fnm.vercel.app/install | bash

# codium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
| gpg --dearmor \
| sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
| sudo tee /etc/apt/sources.list.d/vscodium.list

# brave
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update && sudo apt install -y codium apt-transport-https curl brave-browser

# github cli
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# install codium extensions

codium_extensions=(
    astro-build.astro-vscode
    bradlc.vscode-tailwindcss
    eamodio.gitlens
    esbenp.prettier-vscode
    felipecaputo.git-project-manager
    GitHub.vscode-pull-request-github
    heybourn.headwind
    jebbs.plantuml
    JuanBlanco.solidity
    mhutchie.git-graph
    pinage404.git-extension-pack
    quick-lint.quick-lint-js
    reduckted.vscode-gitweblinks
    robole.javascript-snippets
    shakram02.bash-beautify
    silvenon.mdx
    steoates.autoimport
    tintinweb.graphviz-interactive-preview
    tintinweb.solidity-visual-auditor
    tintinweb.vscode-ethover
    tintinweb.vscode-inline-bookmarks
    tintinweb.vscode-solidity-flattener
    tintinweb.vscode-solidity-language
    tomoki1207.pdf
    trailofbits.slither-vscode
    xyc.vscode-mdx-preview
)

for i in "${codium_extensions[@]}"
do
    codium --install-extension $i
done

echo "$(tput setaf 2)you should be good to go."
echo "$(tput setaf 3)things to set up:"
echo "$(tput setaf 3) - configure the extensions with password & stuff"
echo "$(tput setaf 3) - make new gpg/ssh keys"
echo "$(tput setaf 3) - make desktop look cool"
echo "$(tput setaf 3) - install other apps"
echo "$(tput setaf 3) - sync brave"
echo "$(tput setaf 6)install these dotfiles in the future with this command:"
echo "$(tput setaf 3)git clone https://github.com/cybertelx/dotfiles ~/.dotfiles && chmod +x ~/.dotfiles/install.sh && ~/.dotfiles/install.sh"
