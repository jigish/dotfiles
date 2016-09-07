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

set -o vi

export EDITOR=vim

#bind "set completion-ignore-case on"
shopt -s cdspell
shopt -s checkwinsize

if [ -x /usr/bin/dircolors ]; then
    test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

function ovim {
  /usr/local/bin/vim
}
alias vim='e'
alias vi='e'
alias v='e'
alias l='ls -alh'
alias la='ls -alh'
alias lt='ls -alrth'
alias h='history |grep'
alias b='cat ~/.bashrc |grep'

# i fucking hate godep
export GOPATH=$HOME/code/go

export ECLIPSE_HOME=$HOME/eclipse/jee-neon/Eclipse.app/Contents/Eclipse

export PATH=$HOME/bin:${PATH}:/usr/local/go/bin:${SCALA_HOME}/bin:${GOPATH}/bin:/usr/local/sbin:${ECLIPSE_HOME}

# proper ctags man
export MANPATH=$HOME/bin/ctags-root/share/man:$MANPATH

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
PS1="$BLUE[\t] \u@$(if [[ -x /usr/local/bin/my-instance-name ]]; then echo "$RED$(/usr/local/bin/my-instance-name)$BLUE"; elif [[ -f ~/.homed ]]; then echo "$RED$(hostname -s)$BLUE"; else hostname -s; fi) "
  [[ $(type -t __git_ps1) = "function" ]] && PS1="${PS1}$(__git_ps1 '%s:')"
  PS1="${PS1}\W \!$ $NOCOLOR"
}

PROMPT_COMMAND=cool_prompt

# z!
. $HOME/bin/z.sh

# Expected working dir for code
export CODE=$HOME/code
alias cdcode='z $CODE'
alias cdslate='z $CODE/slate'
alias zcode='z $CODE'
alias zslate='z $CODE/slate'

# Other Aliases
alias svim='sudo vim'
alias rmswap='rm ~/.vim/tmp/swap/*'

# AWS Aliases
alias adil='aws describe-instances'
function adi-ctl {
  adil $@ |awk -F "|" '{ print $2 " " $6 " " $9 " " $12 " " $13; }'
}
alias adi='adi-ctl'
function adia-ctl {
  adil $@ --region ap-northeast-1 |awk -F "|" '{ print $2 " " $6 " " $9 " " $12 " " $13; }'
}
alias adia='adia-ctl'
function adie-ctl {
  adil $@ --region eu-west-1 |awk -F "|" '{ print $2 " " $6 " " $9 " " $12 " " $13; }'
}
alias adie='adie-ctl'
alias adg='aws describe-groups'

# Pt > Ag > Ack
alias ack=pt

# hub > git
[ ! $(which hub) == "" ] && eval "$(hub alias -s)"
alias g='git'
alias gbranch='git rev-parse --abbrev-ref HEAD'
function gclone {
  git clone ssh://git@github.com/$1
}

# Chruby
if [ -f /usr/local/share/chruby/chruby.sh ]; then
  source /usr/local/share/chruby/chruby.sh
  chruby 2.3.1
fi

# The Fuck
eval "$(thefuck --alias)"

[[ -s "$HOME/.bashrc.`uname`" ]] && source "$HOME/.bashrc.`uname`"
[[ -s "$HOME/.bashrc.netflix" ]] && source "$HOME/.bashrc.netflix"
[[ -s "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
