export CLICOLOR=1
export TERM="xterm-256color"
export HISTSIZE=1000000
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth

set -o vi

export EDITOR=vim

alias vi='vim'
alias l='ls'
alias la='ls -alh'
alias lt='ls -alrth'
alias g='git'

export PATH=${PATH}:~/bin

# Colorized Prompt
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
CYAN="\[\033[0;36m\]"
RED="\[\033[0;31m\]"
PURPLE="\[\033[0;35m\]"
BROWN="\[\033[0;33m\]"
LGRAY="\[\033[0;37m\]"
DGRAY="\[\033[1;30m\]"
LBLUE="\[\033[1;34m\]"
LGREEN="\[\033[1;32m\]"
LCYAN="\[\033[1;36m\]"
LRED="\[\033[1;31m\]"
LPURPLE="\[\033[1;35m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
NOCOLOR="\[\033[0m\]"
PS1="$BLUE[\t] \u \W \!$ $NOCOLOR"

[[ -s "$HOME/.bashrc.ooyala" ]] && source "$HOME/.bashrc.ooyala"
