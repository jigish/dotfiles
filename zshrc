. ~/bin/z.sh
function precmd () {
  _z --add "$(pwd -P)"
}


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
