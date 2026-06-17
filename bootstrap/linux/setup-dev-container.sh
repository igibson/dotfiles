#!/usr/bin/env bash
set -e

# Establish local binary workspace pathway structures
export PATH="$HOME/.local/bin:$PATH"
mkdir -p "$HOME/.local/bin"

echo "📦 Installing core system dependencies via apt..."
# These are essential system packages, media decoders, and compilers
sudo apt-get update && sudo apt-get install -y \
    build-essential \
    curl \
    git \
    unzip \
    p7zip-full \
    jq \
    ffmpeg \
    imagemagick \
    fzf \
    ripgrep \
    clang \
    ca-certificates \
    docker.io


# 1. Yazi Deployment (Fetches the pre-compiled binary instantly)
if ! command -v yazi &> /dev/null; then
    echo "📥 Installing Yazi standalone binary..."
    curl -L "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip" -o /tmp/yazi.zip
    unzip -q /tmp/yazi.zip -d /tmp/yazi-extract
    mv /tmp/yazi-extract/yazi-*/yazi /tmp/yazi-extract/yazi-*/ya "$HOME/.local/bin/"
    rm -rf /tmp/yazi.zip /tmp/yazi-extract
fi


echo "Installing latest Neovim..."

NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
TMP_DIR="/tmp/nvim-install"
INSTALL_DIR="/opt/nvim"

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "Downloading Neovim..."
curl -L "$NVIM_URL" -o "$TMP_DIR/nvim.tar.gz"

echo "Extracting..."
tar -xzf "$TMP_DIR/nvim.tar.gz" -C "$TMP_DIR"

echo "Installing..."
sudo rm -rf "$INSTALL_DIR"
sudo mv "$TMP_DIR"/nvim-linux-x86_64 "$INSTALL_DIR"

echo "Creating symlink..."
sudo ln -sf "$INSTALL_DIR/bin/nvim" /usr/local/bin/nvim

echo "Cleaning up..."
rm -rf "$TMP_DIR"


# 2. Dotter Deployment (Strict file contents validation check)
if [ ! -f "$HOME/.local/bin/dotter" ] || grep -q "Not Found" "$HOME/.local/bin/dotter"; then
    echo "📥 Installing pristine Dotter deployment engine..."
    mkdir -p "$HOME/.local/bin"
    curl -L "https://github.com/SuperCuber/dotter/releases/download/v0.13.4/dotter-linux-x64-musl" -o "$HOME/.local/bin/dotter"
    chmod +x "$HOME/.local/bin/dotter"
fi

# --------------------------------------------------------
# 🎨 PHASE 3: CONFIGURATION SYMLINK DEPLOYMENT
# --------------------------------------------------------
echo "📂 Resolving workspace pathways..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

cd "$DOTFILES_ROOT"

echo "⚙️  Overwriting local profile mappings..."
cp "$DOTFILES_ROOT/.dotter/local-cloud-linux.toml" "$DOTFILES_ROOT/.dotter/local.toml"

echo "🚀 Deploying Symlinks via Dotter..."
dotter deploy 

echo "✨ Cloud workspace initialization fully complete!"
