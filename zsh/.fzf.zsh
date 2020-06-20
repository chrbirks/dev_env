# Setup fzf
# ---------
if [[ ! "$PATH" == */home/cbs/github/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/cbs/github/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/cbs/github/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/cbs/github/fzf/shell/key-bindings.zsh"
