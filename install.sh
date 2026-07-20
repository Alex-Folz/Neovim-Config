#!/bin/bash
set -e

ARCH=$(uname -m)
case $ARCH in
  x86_64)  NVIM_ARCH="x86_64" ;;
  aarch64) NVIM_ARCH="arm64" ;;
  arm64)   NVIM_ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
INSTALL_DIR="$HOME/.local/share"
BIN_DIR="$HOME/.local/bin"

echo "Installing nvim ($NVIM_ARCH)..."
mkdir -p "$BIN_DIR" "$INSTALL_DIR"
curl -fLo /tmp/nvim.tar.gz "$NVIM_URL"
tar -xzf /tmp/nvim.tar.gz -C "$INSTALL_DIR/"
rm /tmp/nvim.tar.gz
ln -sf "$INSTALL_DIR/nvim-linux-${NVIM_ARCH}/bin/nvim" "$BIN_DIR/nvim"

# Add ~/.local/bin to PATH if not already there
SHELL_RC=""
case $(basename "$SHELL") in
  bash) SHELL_RC="$HOME/.bashrc" ;;
  zsh)  SHELL_RC="$HOME/.zshrc" ;;
esac

if [ -n "$SHELL_RC" ] && ! grep -q 'local/bin' "$SHELL_RC" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
  echo "Added ~/.local/bin to PATH in $SHELL_RC"
fi

export PATH="$BIN_DIR:$PATH"

echo "Cloning nvim config..."
if [ -d "$HOME/.config/nvim" ]; then
  echo "~/.config/nvim already exists, pulling latest..."
  git -C "$HOME/.config/nvim" pull
else
  git clone https://github.com/Alex-Folz/Neovim-Config.git "$HOME/.config/nvim"
fi

echo "Done. Run 'nvim' to finish plugin installation."
echo "You may need to run: source $SHELL_RC"
