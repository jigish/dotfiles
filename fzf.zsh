# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/jigishp/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/jigishp/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/jigishp/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/jigishp/.fzf/shell/key-bindings.zsh"
