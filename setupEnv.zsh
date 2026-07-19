#!/usr/bin/env zsh

set -e

DOTFILES_DIR=${0:A:h}

link_config()
{
  local source_path=$1
  local destination_path=$2

  if [[ -L "$destination_path" ]]; then
    if [[ "${destination_path:A}" == "${source_path:A}" ]]; then
      echo "Already linked: $destination_path"
      return
    fi

    ln -sfn "$source_path" "$destination_path"
    echo "Updated link: $destination_path -> $source_path"
  elif [[ -e "$destination_path" ]]; then
    echo "Refusing to replace existing file: $destination_path"
    echo "Move it aside, then run this script again."
    return 1
  else
    ln -s "$source_path" "$destination_path"
    echo "Linked: $destination_path -> $source_path"
  fi
}

# Link configuration files from wherever this repository was cloned.
link_config "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config/nvim"
link_config "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# Install Homebrew when necessary, then ensure it is available in this shell
# and future login shells on either Apple Silicon or Intel Macs.
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  brew_bin=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
  brew_bin=/usr/local/bin/brew
else
  brew_bin=$(command -v brew)
fi

brew_init="eval \"\$($brew_bin shellenv)\""
touch "$HOME/.zprofile"
if ! grep -Fqx "$brew_init" "$HOME/.zprofile"; then
  echo "$brew_init" >> "$HOME/.zprofile"
fi
eval "$($brew_bin shellenv)"

packages=()
command -v nvim >/dev/null 2>&1 || packages+=(neovim)
command -v bat >/dev/null 2>&1 || packages+=(bat)
command -v eza >/dev/null 2>&1 || packages+=(eza)
$brew_bin list --formula zsh-syntax-highlighting >/dev/null 2>&1 || packages+=(zsh-syntax-highlighting)

if (( ${#packages[@]} > 0 )); then
  $brew_bin install "${packages[@]}"
else
  echo "Shell tools are already installed"
fi

# Configure Git identity and SSH commit signing when a public key is present.
if command -v git >/dev/null 2>&1; then
  git config --global user.name "Olijujuan Green"
  git config --global user.email "117129713+olijujuangreen@users.noreply.github.com"

  signing_key=""
  for key_path in "$HOME/.ssh/id_ed25519_github.pub" "$HOME/.ssh/id_ed25519.pub"; do
    if [[ -f "$key_path" ]]; then
      signing_key=$key_path
      break
    fi
  done

  if [[ -n "$signing_key" ]]; then
    git config --global gpg.format ssh
    git config --global user.signingKey "$signing_key"
    git config --global commit.gpgsign true
    echo "Git configured with SSH commit signing"
  else
    echo "No SSH public key found; commit signing was not enabled"
  fi
fi

echo "Environment setup complete. Run: source ~/.zshrc"
