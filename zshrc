#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# editor stuff
export VISUAL=nvim
export EDITOR=$VISUAL
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias e='nvim'
alias l='ls -alh'
alias la='ls -alh'
alias lt='ls -alrth'

# Paths
export GOPATH=$HOME/code/go
export PATH=$HOME/bin:${PATH}:/usr/local/go/bin:${GOPATH}/bin:$HOME/.cargo/bin
# Expected working dir for code
export CODE=$HOME/code

# rg > pt > ag > ack
alias ack=rg

# hub > git
[ -z "$(which hub)" ] && eval "$(hub alias -s)"
alias g='git'
alias gbranch='git rev-parse --abbrev-ref HEAD'
function gclone {
  git clone ssh://git@github.com/$1
}

# z!
. $HOME/bin/z.sh

# Weather :)
function weather {
  curl -s wttr.in/$1
}

[[ -s "$HOME/.zshrc.`uname`" ]] && source "$HOME/.zshrc.`uname`"
[[ -s "$HOME/.zshrc.netflix" ]] && source "$HOME/.zshrc.netflix"
[[ -s "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

setopt prompt_sp

which kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)

eval $(thefuck --alias)
