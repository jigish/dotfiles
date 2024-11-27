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

# fix reverse history
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey '^N' down-line-or-history
bindkey '^P' up-line-or-history

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
  if [[ -z $2 ]]; then
    curl -s wttr.in/$1
  else
    curl -s "wttr.in/$1?format=$2"
  fi
}

# zoxide
eval "$(zoxide init zsh)"

# rust
. "$HOME/.cargo/env"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# source os/airbnb/local stuff
export UNAME_S=$(uname | tr '[[:upper:]]' '[[:lower:]]')
[[ -s "${HOME}/.zshrc.${UNAME_S}" ]] && source "${HOME}/.zshrc.${UNAME_S}"
[[ -s "${HOME}/.zshrc.airbnb" ]] && source "${HOME}/.zshrc.airbnb"
[[ -s "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"

# fzf
[[ -f "${HOME}/.fzf.zsh" ]] && source ~/.fzf.zsh

# explicit completions
which kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)

# python3
alias python=python3
alias pydoc=pydoc3
alias pip=pip3
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# direnv
eval "$(direnv hook zsh)"

# powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ -o login ]]; then
  if type 'postlogin' 2>/dev/null | grep -q 'function'; then
    postlogin
  fi
fi
