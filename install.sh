#!/bin/bash -i
# Now for Fedora

sudo dnf install -y dnf-plugins-core curl wget git-all

# download repo from git
git clone https://github.com/cybertelx/dotfiles.git "$HOME/.dotfiles"

declare -A custom_path_dotfiles

dotfiles=(
    bash_logout
)

defaults=(
    profile bashrc
)

custom_path_dotfiles=(
    ["vscodium/settings.json"]="$HOME/.config/VSCodium/User"
    ["vscodium/product.json"]="$HOME/.config/VSCodium"
)

for i in "${dotfiles[@]}"
do
    # hope no programs are using it in the meantime
    rm "$HOME/.$i" > /dev/null
    # automagically add a dot before it
    ln -s "$HOME/.dotfiles/dotfiles/$i" "$HOME"/."$i"
done

for i in "${defaults[@]}"
do
    # hope no programs are using it in the meantime
    rm "$HOME/.$i" > /dev/null
    # automagically add a dot before it
    cp "$HOME/.dotfiles/dotfiles/$i" "$HOME/.$i"
done

for i in "${!custom_path_dotfiles[@]}"
do
    mkdir -p "${custom_path_dotfiles[$i]}"
    ln -nsfr "$HOME/.dotfiles/dotfiles/$i" "${custom_path_dotfiles[$i]}"
done

# Bash-It framework

# Symlink bash-it extensions
rm "$HOME"/.bash_it_scripts > /dev/null
ln -nsfr dotfiles/bash-it "$HOME"/.bash_it_scripts

# Update/install bash-it
if [ -d "$HOME/.bash_it" ]
then
    bash-it update dev --silent
else
    echo "bash-it could not be found, performing installation"
    # Install Bash-It
    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
    
    ~/.bash_it/install.sh -f --silent --no-modify-config
fi

# Install programs: VSCodium, Brave, etc.

# FNM nodejs
curl -fsSL https://fnm.vercel.app/install | bash

# codium
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo

# brave
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# github cli
sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo

sudo dnf install gh brave-browser codium python3.11 python3-pip flatpak
pip3 install slither-analyzer

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
    dbaeumer.vscode-eslint
    tintinweb.graphviz-interactive-preview
    tintinweb.solidity-visual-auditor
    tintinweb.vscode-ethover
    tintinweb.vscode-inline-bookmarks
    tintinweb.vscode-solidity-flattener
    tintinweb.vscode-solidity-language
    tomoki1207.pdf
    oderwat.indent-rainbow
    IgorSbitnev.error-gutters
    planbcoding.vscode-react-refactor
    usernamehw.errorlens
    trailofbits.slither-vscode
    xyc.vscode-mdx-preview
    timonwong.shellcheck
)

for i in "${codium_extensions[@]}"
do
    codium --install-extension "$i"
done

# github authentication
gh auth login
gh auth setup-git

# git set email & user
git config --global user.name "cybertelx"
git config --global user.email "cybertelx@protonmail.com"

echo "$(tput setaf 2)you should be good to go."
echo "$(tput setaf 3)things to set up:"
echo "$(tput setaf 3) - configure the extensions with password & stuff"
echo "$(tput setaf 3) - make new gpg/ssh keys"
echo "$(tput setaf 3) - make desktop look cool"
echo "$(tput setaf 3) - install other apps"
echo "$(tput setaf 3) - sync brave"
echo "$(tput setaf 6)install these dotfiles in the future with this command:"
echo "$(tput setaf 3)curl https://raw.githubusercontent.com/cybertelx/dotfiles/master/install.sh | sudo bash"
