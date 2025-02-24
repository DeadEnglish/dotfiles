alias c="clear"
alias nuke="sudo rm -r ${1}"
alias vim="nvim"
alias pinentry='pinentry-mac'
alias kap="killAtPort"

# Git
alias gg="lazygit"
alias gitrekt="git reset HEAD --hard"
alias gitclean="git branch | grep -v "main" | xargs git branch -D"
alias gP="git push"
alias gp="git pull"
alias gcm="git checkout main"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
