#!/usr/bin/env bash
set -e # Exit immediately if any command fails

echo "=================================================="
echo "🚀 STARTING COMPREHENSIVE CODESPACE LINUX BOOTSTRAP"
echo "=================================================="

# Ensure apt package list is refreshed
sudo apt-get update

# --------------------------------------------------------
# PHASE 1: CORE PLATFORM UTILITIES
# --------------------------------------------------------
echo "📦 Installing core platform utilities..."
# Installs 7zip, jq, git, curl, ffmpeg, imagemagick, ripgrep, fzf
sudo apt-get install -y \
    p7zip-full \
    jq \
    git \
    curl \
    ffmpeg \
    imagemagick \
    ripgrep \
    fzf \
    unzip \
    build-essential

# Fix 'fd' naming quirk on Ubuntu Linux
if ! command -v fd &> /dev/null; then
    sudo apt-get install -y fd-find
    sudo ln -sf $(which fdfind) /usr/local/bin/fd || true
fi

# --------------------------------------------------------
# PHASE 2: STARSHIP PROMPT (From your winget.yaml)
# --------------------------------------------------------
echo "🚀 Installing Starship Cross-Shell Prompt..."
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# --------------------------------------------------------
# PHASE 3: GLOBAL NODE & CLAUDE CODE TOOLS
# --------------------------------------------------------
echo "🤖 Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# --------------------------------------------------------
# PHASE 4: ADVANCED POWER-USER CLI TOOLS
# --------------------------------------------------------
echo "⚡ Provisioning advanced developer tool binaries..."

# 1. Latest Stable Neovim
echo "-> Installing Neovim..."
sudo curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-x86_64.tar.gz

# 2. Tree-Sitter CLI (Syntax compiler for Neovim)
echo "-> Installing Tree-Sitter..."
sudo curl -LO https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz
gunzip -f tree-sitter-linux-x64.gz || true
chmod +x tree-sitter-linux-x64
sudo mv tree-sitter-linux-x64 /usr/local/bin/tree-sitter

# 3. Zoxide (Smarter cd)
echo "-> Installing Zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
sudo ln -sf $HOME/.local/bin/zoxide /usr/local/bin/zoxide

# 4. Yazi & Resvg (File Manager + Image Preview Canvas)
echo "-> Installing Yazi..."
sudo curl -LO https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip
unzip -o yazi-x86_64-unknown-linux-musl.zip
sudo mv yazi-x86_64-unknown-linux-musl/yazi yazi-x86_64-unknown-linux-musl/ya /usr/local/bin/
rm -rf yazi-x86_64-unknown-linux-musl*

echo "-> Installing resvg..."
sudo curl -LO https://github.com/RazrFalcon/resvg/releases/latest/download/resvg-linux-x64.tar.gz
tar -xzf resvg-linux-x64.tar.gz
sudo mv resvg-linux-x64/resvg /usr/local/bin/
rm -rf resvg-linux-x64*

# --------------------------------------------------------
# PHASE 5: LOCAL DOTFILES DEPLOYMENT VIA DOTTER
# --------------------------------------------------------
echo "🦀 Resolving Dotfiles paths relative to script location..."

# 1. Determine exactly where this script lives inside the container
# SCRIPT_DIR will evaluate to: $HOME/dotfiles-temp/bootstrap/linux
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 2. Derive the root of your dotfiles repo by moving up two directory levels
# DOTFILES_ROOT will evaluate to: $HOME/dotfiles-temp
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"

echo "📍 Dotfiles Repository root discovered at: $DOTFILES_ROOT"

# 3. Setup Dotter binary relative to your repo root
DOTTER_BIN="$DOTFILES_ROOT/dotter"

if [ ! -f "$DOTTER_BIN" ]; then
    echo "⬇️ Downloading pre-compiled Dotter binary..."
    curl -L https://github.com/SuperCuber/dotter/releases/latest/download/dotter-linux-musl -o "$DOTTER_BIN"
    chmod +x "$DOTTER_BIN"
fi

# 4. Step to your dotfiles root to ensure dotter.toml maps its config relative paths correctly
cd "$DOTFILES_ROOT"

echo "🎨 Applying Dotter templates via Linux profile..."

# use cloud-linux deployment file
cp "$SCRIPT_DIR/cloud-linux.toml" "$DOTFILES_ROOT/local.toml"

# Executes Dotter directly utilizing relative paths derived from the script runtime context
"$DOTTER_BIN" deploy --local-config dotter.toml
