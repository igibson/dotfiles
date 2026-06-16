#!/usr/bin/env bash
set -e

# Establish local binary workspace pathway structures
export PATH="$HOME/.local/bin:$PATH"
mkdir -p "$HOME/.local/bin"

echo "☁️  Dev Container detected. Executing runtime configurations..."

# 1. Yazi Deployment (Fetches the pre-compiled binary instantly)
if ! command -v yazi &> /dev/null; then
    echo "📥 Installing Yazi standalone binary..."
    curl -L "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip" -o /tmp/yazi.zip
    unzip -q /tmp/yazi.zip -d /tmp/yazi-extract
    mv /tmp/yazi-extract/yazi-*/yazi /tmp/yazi-extract/yazi-*/ya "$HOME/.local/bin/"
    rm -rf /tmp/yazi.zip /tmp/yazi-extract
fi

# 2. Dotter Deployment (Fetches the compiled single executable instantly)
if ! command -v dotter &> /dev/null; then
    echo "📥 Installing Dotter deployment engine..."
    curl -L "https://github.com/SuperCuber/dotter/releases/latest/download/dotter-x86_64-unknown-linux-musl" -o "$HOME/.local/bin/dotter"
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
cp "$DOTFILES_ROOT/.dotter/cloud-linux.toml" "$DOTFILES_ROOT/.dotter/local.toml"

echo "🚀 Deploying Symlinks via Dotter..."
dotter deploy --local-config dotter.toml

echo "✨ Cloud workspace initialization fully complete!"
