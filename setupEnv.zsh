#!/usr/bin zsh

#setup symbolic links
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/nvim/init.lua ~/.config/nvim/init.lua     

#install homebrew
if ( which brew >/dev/null 2>&1 ); then
	echo "homebrew already installed"
else 	
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/olijujuangreen/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#install neovim
if ( which nvim >/dev/null 2>&1 ); then
  echo "neovim already installed"
else 
  brew install neovim
fi

#install bat
if ( which bat >/dev/null 2>&1 ); then
  echo "bat already installed"
else
  brew install bat
fi

#install eza
if ( which eza >/dev/null 2>&1 ); then
  echo "eza already installed"
else
  brew install eza
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
  popd
fi

if ( which git >/dev/null 2>&1 ); then 
git config --global user.name "Olijujuan Green"
git config --global user.email "117129713+olijujuangreen@users.noreply.github.com"
git config --global --unset gpg.format
git config --global gpg.format ssh
git config --global user.signingKey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
echo "Repo configured successfully! 🎉"
else 
echo "git not installed"
fi
