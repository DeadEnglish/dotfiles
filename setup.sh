#!/bin/bash

#####################
# Dependencies
#####################
# Xcode
xcode-select --install
# Omzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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

#####################
# Brew installs
#####################
brew install --cask ghostty
brew install awscli
brew install bat
brew install fastfetch
brew install git
brew install gnupg
brew install gpg2
brew install imagemagick --with-webp
brew install lazygit
brew install multi-gitter
brew install neovim
brew install pinentry-mac
brew install pinentry-touchid
brew install ripgrep
brew install tmux
brew install tree-sitter
brew install wget --with-iri

# Cleanup brew install
brew cleanup

# Run post setup
sh ./post-setup.sh
