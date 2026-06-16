#!/usr/bin/env bash
set -e

# Ensure standard user binary paths are prioritized in the active shell environment
export PATH="$HOME/.local/bin:$PATH"

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
    imagemagick

# --------------------------------------------------------
# HOMEBREW SETUP & INSTALLATION
# --------------------------------------------------------
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🤖 Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# Activate Homebrew instantly for the remainder of this script execution
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "🔄 Installing cutting-edge tools via Homebrew..."
# These tools are best managed by Brew to ensure you get the absolute latest versions
brew install \
    neovim \
    tree-sitter \
    yazi \
    zoxide \
    starship \
    ripgrep \
    fzf

echo "✅ System tools and developer utilities successfully provisioned!"

# --------------------------------------------------------
# PHASE 5: LOCAL DOTFILES DEPLOYMENT VIA DOTTER
# --------------------------------------------------------
echo "🦀 Resolving Dotfiles paths relative to script location..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

if ! command -v dotter &> /dev/null; then
    brew install dotter
fi

cd "$DOTFILES_ROOT"

echo "⚙️  Overwriting local.toml with cloud-linux profile assets..."
cp "$SCRIPT_DIR/cloud-linux.toml" "$DOTFILES_ROOT/local.toml"

echo "🎨 Applying Dotter templates..."
dotter deploy --local-config dotter.toml
