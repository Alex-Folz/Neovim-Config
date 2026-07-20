#!/bin/bash
set -e

ARCH=$(uname -m)
case $ARCH in
  x86_64)  NVIM_ARCH="x86_64" ;;
  aarch64|arm64) NVIM_ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

NVIM_BIN="$HOME/.local/share/nvim-linux-${NVIM_ARCH}/bin/nvim"

if [ ! -f "$NVIM_BIN" ]; then
  echo "Installing nvim..."
  mkdir -p "$HOME/.local/share"
  curl -fLo /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
  tar -xzf /tmp/nvim.tar.gz -C "$HOME/.local/share/"
  rm /tmp/nvim.tar.gz
  echo "nvim installed."
fi

if [ -d "$HOME/.config/nvim" ]; then
  git -C "$HOME/.config/nvim" pull --quiet
else
  echo "Cloning nvim config..."
  git clone --quiet https://github.com/Alex-Folz/Neovim-Config.git "$HOME/.config/nvim"
fi

exec "$NVIM_BIN" "$@"
