#!/bin/bash

set -e  # Exit on error

# === Update & Upgrade ===
echo "Updating system..."
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update && sudo apt upgrade -y

# === Install Essential Packages ===

echo "Starting package installation..."

packages=(
  build-essential
  curl
  wget
  gnupg
  software-properties-common
  ca-certificates
  lsb-release
  zsh
  tmux
  htop
  neofetch
  tree
  ripgrep
  fd-find
  git
  vim
  neovim
  gcc
  make
  cmake
  cmake-curses-gui
  gdb
  python3
  python3-pip
  python3-venv
  nodejs
  npm
  docker.io
  docker-compose
  gh
  net-tools
  nmap
  openssh-client
  fonts-powerline
  unzip
  xclip
  fonts-noto-color-emoji
)

for pkg in "${packages[@]}"; do
  echo "Installing $pkg..."
  if sudo apt install -y "$pkg"; then
    echo "✅ $pkg installed successfully"
  else
    echo "❌ Failed to install $pkg. Skipping."
  fi
done

echo "Package installation complete."


# === Setup Git ===
git config --global user.name "Dominik"
git config --global user.email "rolfes1dominik@gmail.com"

# === Zsh & Oh My Zsh ===
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# === Clone dotfiles or configs ===
#echo "Cloning dotfiles..."
#git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
#cd ~/dotfiles && ./install.sh

# === Neovim kickstart ===
# Set default if XDG_CONFIG_HOME is not set
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Check if the Neovim config directory exists
if [ ! -d "$XDG_CONFIG_HOME/nvim" ]; then
  echo "Creating Neovim config directory and cloning kickstart.nvim..."
  mkdir -p "$XDG_CONFIG_HOME/nvim"
  git clone https://github.com/djrolfes/kickstart.nvim.git "$XDG_CONFIG_HOME/nvim"
else
  echo "Neovim config directory already exists. Skipping clone."
fi


# === Add aliases or environment variables ===

echo "Setup complete!"

