
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
prune_branches()
{
current_branch=$(git symbolic-ref --short HEAD)
if [ $current_branch != "main" ] && [ $current_branch != "master" ]; then
    echo "You must be on main or master to prune branches"
    exit 1
fi

for branch in $(git branch --format="%(refname:short)"); do
    #if branch is merged into current branch
    if [ "$branch" != "master" ] && [ "$branch" != "main" ] && ! git log --oneline --no-merges master..$branch | grep -q "$branch"; then
        # if branch has been deleted on GitHub
        if ! git ls-remote --heads origin "$branch" &> /dev/null; then
            git branch -d "$branch"
            echo "Deleted local branch: $branch"
        fi
    fi
done
}

#add syntax highlighting for terminal
#must remain at the bottom of file
source /Users/olijujuangreen/.zsh-packages/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
