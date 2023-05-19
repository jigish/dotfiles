# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-${HOME}/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
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

# zsh options
setopt prompt_sp

# editor stuff
export VISUAL=nvim
export EDITOR=$VISUAL
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias e='nvim'

# ripgrep config
export RIPGREP_CONFIG_PATH=${HOME}/.config/ripgrep/config

# helpful aliases
[ -x "$(which lsd)" ] && alias ls='lsd'
alias l='ls -alh'
alias la='ls -alh'
alias lt='ls -alrth'
alias gits='git s' # lol

# paths
export GOPATH=${HOME}/code/go
if [[ ":${PATH}:" != *":${HOME}/bin:"* ]]; then
  export PATH=${HOME}/bin:${PATH}
fi
if [[ ":${PATH}:" != *":${GOPATH}/bin:"* ]]; then
  export PATH=${PATH}:${GOPATH}/bin
fi
# expected working dir for code
export CODE=${HOME}/code

# rg > pt > ag > ack
alias pt=rg
alias ag=rg
alias ack=rg

# hub > git
[ -z "$(which hub)" ] && eval "$(hub alias -s)"
alias g='git'
alias gbranch='git rev-parse --abbrev-ref HEAD'
function gclone {
  git clone git@github.com:$1
}

# weather :)
function weather {
  curl -s wttr.in/$1
}

# zoxide
eval "$(zoxide init zsh)"

# source os/nflx/local stuff
export UNAME_S=$(uname | tr '[[:upper:]]' '[[:lower:]]')
[[ -s "${HOME}/.zshrc.${UNAME_S}" ]] && source "${HOME}/.zshrc.${UNAME_S}"
[[ -s "${HOME}/.zshrc.netflix" ]] && source "${HOME}/.zshrc.netflix"
[[ -s "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"

# fzf
[[ -f "${HOME}/.fzf.zsh" ]] && source ~/.fzf.zsh

# explicit completions
which kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)

# powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ -o login ]]; then
  if type 'postlogin' 2>/dev/null | grep -q 'function'; then
    postlogin
  fi
fi
