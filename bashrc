# Terminal Colors
export CLICOLOR=1
export TERM="xterm-256color"

# Bash History Options
export HISTSIZE=1000000
export HISTCONTROL='ignoreboth'
export HISTIGNORE='&:ls:[bf]g:exit'
export HISTTIMEFORMAT='%b %d %H:%M:%S: '
shopt -s histappend
set cmdhist

#set -o vi

export EDITOR=vim

# MacPorts Bash Completion
if [ -f /opt/local/etc/bash_completion ]; then
  . /opt/local/etc/bash_completion
fi

#bind "set completion-ignore-case on"
shopt -s cdspell

alias vi='vim'
alias v='vim'
alias l='ls -alh'
alias la='ls -alh'
alias lt='ls -alrth'
alias g='git'
alias h='history |grep'
alias b='cat ~/.bashrc |grep'

export PATH=${PATH}:~/bin:/usr/local/go/bin

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

function cool_prompt {
  PS1="$BLUE[\t] \u "
  [[ $(type -t __git_ps1) = "function" ]] && PS1="${PS1}$(__git_ps1 '%s:')"
  PS1="${PS1}\W \!$ $NOCOLOR"
}

PROMPT_COMMAND=cool_prompt

# Default Mac Web Server
export DOCROOT=/Library/WebServer/Documents

# z!
. ~/bin/z.sh

# Expected working dir for code
export CODE=~/code
export GOPATH=${CODE}/goroot
alias cdcode='z $CODE'
alias cdslate='z $CODE/slate'
alias zcode='z $CODE'
alias zslate='z $CODE/slate'
dropbox-ctl() {
  open "http://dl.dropbox.com/u/56340597/$1"
}
alias dropbox=dropbox-ctl
alias jsonpp=/usr/local/Cellar/jsonpp/86.64/bin/jsonpp
[[ -s "$HOME/.bashrc.ooyala" ]] && source "$HOME/.bashrc.ooyala"
