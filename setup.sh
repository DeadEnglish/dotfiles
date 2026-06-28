#!/bin/bash

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="Brewfile"

## Parse args
for arg in "$@"; do
  case $arg in
    --work)
      BREWFILE="Brewfile.work"
      shift
      ;;
  esac
done

ensure_custom_zshrc() {
  local zshrc_file="$HOME/.zshrc"
  local custom_config_file="$REPO_ROOT/zsh-custom/.zshrc.config"
  local source_line="source \"$custom_config_file\""

  if ! grep -Fqx "$source_line" "$zshrc_file"; then
    printf '\n%s\n' "$source_line" >> "$zshrc_file"
  fi
}

#####################
# Dependencies
#####################
# Xcode
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
fi
# Omzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ensure_custom_zshrc
# Bun
curl -fsSL https://bun.sh/install | bash
# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# Homebrew
which -s brew
if [[ $? != 0 ]] ; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	brew update
	brew upgrade
fi

# Run brewfile
brew bundle --file="$BREWFILE"

# Cleanup brew install
brew cleanup

# Git global config
git config --global user.name Liam Canetti
git config --global user.email git@liamcanetti.co.uk
git config --global commit.gpgsign true

# Claude Code global config symlink
CLAUDE_CONFIG_DIR="$HOME/.config/claude"
CLAUDE_TARGET="$HOME/.claude/CLAUDE.md"

# Back up existing ~/.claude/CLAUDE.md if it's a real file (not already a symlink)
if [ -f "$CLAUDE_TARGET" ] && [ ! -L "$CLAUDE_TARGET" ]; then
  cp "$CLAUDE_TARGET" "$CLAUDE_TARGET.backup-$(date +%Y%m%d)"
fi

mkdir -p "$CLAUDE_CONFIG_DIR"
ln -sf "$CLAUDE_CONFIG_DIR/CLAUDE.md" "$CLAUDE_TARGET"

# Run post setup in a fresh shell so newly installed tooling is available
bash -lc 'bash ./post-setup.sh'
