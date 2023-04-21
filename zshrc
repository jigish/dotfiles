# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
[ -x "$(which lsd)" ] && alias ls='lsd'
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
[[ -f "$HOME/.fzf.zsh" ]] && source ~/.fzf.zsh

setopt prompt_sp

which kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)

eval $(thefuck --alias)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
