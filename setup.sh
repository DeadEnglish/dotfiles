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

# run Brewfile
brew bundle

# Cleanup brew install
brew cleanup

# Run post setup
sh ./post-setup.sh
