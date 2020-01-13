# Setup fzf
# ---------
if [[ ! "$PATH" == */home/cbs/github/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/cbs/github/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/cbs/github/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/cbs/github/fzf/shell/key-bindings.bash"

# Personal config
# ------------
# Use ripgrep and search dotfiles but not dotdirectories
#export FZF_DEFAULT_COMMAND='command rg --files --hidden -g '!.*/' -l ""';

# function fzf { command fzf --ansi --tabstop=3 "$@" ;}
function fzf { command fzf --tabstop=3 "$@" ;}

# function fzfrg {
#    local OLD=$FZF_DEFAULT_COMMAND;
#    export FZF_DEFAULT_COMMAND='rg --files --hidden -g '!.*/' -l ""';
#    #export FZF_DEFAULT_COMMAND='$rg(-l "")';
#    command fzf --ansi --tabstop=3 "$@";
#    export FZF_DEFAULT_COMMAND=$OLD
# }

# Spawn tmux tiles using fzf
tt() {
    if [ $# -lt 1 ]; then
        echo 'usage: tt <commands...>'
        return 1
    fi

    local head="$1"
    local tail='echo -n Press enter to finish.; read'

    while [ $# -gt 1 ]; do
        shift
        tmux split-window "$SHELL -ci \"$1; $tail\""
        tmux select-layout tiled > /dev/null
    done

    tmux set-window-option synchronize-panes on > /dev/null
    $SHELL -ci "$head; $tail"
}

export FZF_DEFAULT_OPTS='--color "preview-bg:237"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"

command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Switch tmux-sessions
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --height 40% --reverse --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}
