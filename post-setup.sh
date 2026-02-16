#!/usr/bin/env bash

set -euo pipefail

load_nvm() {
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"
    return
  fi

  if command -v brew >/dev/null 2>&1; then
    local brew_nvm
    brew_nvm="$(brew --prefix nvm 2>/dev/null || true)/nvm.sh"
    if [[ -s "$brew_nvm" ]]; then
      # shellcheck disable=SC1090
      . "$brew_nvm"
      return
    fi
  fi

  echo "Unable to load nvm in post-setup.sh" >&2
  exit 1
}

#####################
# Setup npm using nvm
#####################
load_nvm
nvm install 24
nvm alias default 24
nvm use default

# install globals
npm install -g prettier
npm install -g typescript
