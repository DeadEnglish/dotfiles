# Set prompt to bottom and alias clear to set to bottom 
printf "\e[H\ec\e[9999B"

#Set prompt to bottom and alias clear to set to bottom 
printf "\e[H\ec\e[9999B"
alias clear="clear && printf \"\e[H\ec\e[9999B\""

# Theme
ZSH_THEME="robbyrussell"

# Path to customs
ZSH_CUSTOM="$HOME/.config/zsh-custom/"

# Plugins
plugins=(git z)

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# GPG_TTY
export GPG_TTY=$(tty)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# GO
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"
