# Move prompt to bottom on shell start
printf "\e[H\ec\e[9999B"

export EDITOR='nvim'

export GPG_TTY=$(tty)

export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"
