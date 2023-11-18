#!/usr/bin zsh

#setup symbolic links
ln -s ~/.dotfiles/ssh/config ~/.ssh/config  
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/nvim/init.lua ~/.config/nvim/init.lua     

#install homebrew
if ( which brew >/dev/null 2>&1 ); then
	echo "homebrew already installed"
else 	
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/olijujuan.green/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#syntax highlighting for terminal
if [ -f "~/.zsh-packages/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then 
  echo "syntax highlighting already installed"
else
	if [ -d "~/.zsh-packages" ]; then
		echo "zsh packages directory already exists"
	else 
		mkdir ~/.zsh-packages
	fi

	pushd ~/.zsh-packages 
	
	if [ -d "zsh-syntax-highlighting" ]; then
		echo "syntax highlighting package already cloned"
	else 
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
	fi

	if ( cat ${ZDOTDIR:-$HOME}/.zshrc | grep "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ); then
		echo "source file already added"
	else
		echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
	fi
fi
