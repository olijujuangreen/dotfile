
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
  local current_branch branch upstream_status
  local deleted=0

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not inside a Git repository"
    return 1
  fi

  current_branch=$(git branch --show-current)
  if [[ -z "$current_branch" ]]; then
    echo "Cannot prune branches from a detached HEAD"
    return 1
  fi

  if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
    echo "You must be on main or master to prune branches"
    return 1
  fi

  if [[ -z "$(git remote)" ]]; then
    echo "No Git remotes are configured"
    return 1
  fi

  echo "Fetching and pruning remotes..."
  if ! git fetch --all --prune; then
    echo "Unable to fetch remotes; no local branches were deleted"
    return 1
  fi

  while IFS=$'\t' read -r branch upstream_status; do
    [[ "$branch" == "$current_branch" ]] && continue

    # Only remove branches merged into the current branch whose upstream was
    # deleted from its remote. Branches without an upstream are left alone.
    if [[ "$upstream_status" == "[gone]" ]]; then
      if git branch -d -- "$branch"; then
        echo "Deleted local branch: $branch"
        ((deleted += 1))
      fi
    fi
  done < <(git for-each-ref \
    --merged="$current_branch" \
    --format='%(refname:short)%09%(upstream:track)' \
    refs/heads/)

  if (( deleted == 0 )); then
    echo "No merged branches with deleted upstreams found"
  else
    echo "Pruned $deleted local branch(es)"
  fi
}

#add syntax highlighting for terminal
#must remain at the bottom of file
source /Users/olijujuangreen/.zsh-packages/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
