
#--- ZSH Options ----------#
autoload -Uz compinit && compinit

#--- Customize Prompts ----------#
# Set Prompt to show current directory in Bright Yellow
PROMPT='%B%F{39}┌[%2~]
└─[%#]%f%b '

# Set Right Prompt to show last command status
RPROMPT='%B%F{39}[%f%b%(?.%F{green}√.%F{red}?%?)%f%B%F{39}]%f%b'

#--- Aliases  ----------#
alias ls="eza"
alias la="eza -la"
alias cat="bat"
alias vim="nvim"
alias vi="nvim"

#--- Functions  ----------#
setupRepo ()
{
  if ( which git >/dev/null 2>&1 ); then 
    git config user.name "Olijujuan Green"
    git config user.email "117129713+olijujuangreen@users.noreply.github.com"
    git config --unset gpg.format
    git config gpg.format ssh
    git config user.signingKey ~/.ssh/personal_25519.pub
    git config commit.gpgsign true
    echo "Repo configured successfully! 🎉"
  else 
    echo "git not installed"
  fi
}

#add syntax highlighting for terminal
#must remain at the bottom of file
source /Users/olijujuan.green/.zsh-packages/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
