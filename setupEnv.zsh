#!/usr/bin zsh

#setup symbolic links
ln -s ~/.dotfiles/ssh/config ~/.ssh/config  
ln -s ~/.dotfiles/zshrc ~/.zshrc

#install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/olijujuan.green/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

