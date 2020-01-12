#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	      # We have color support; assume it's compliant with Ecma-48
	      # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	      # a case would tend to support setf rather than setaf.)
	      color_prompt=yes
    else
	      color_prompt=
    fi
fi

[[ -f ~/.extend.bashrc ]] && . ~/.extend.bashrc

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# autojump support
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

[ -z "$TMPDIR" ] && TMPDIR=/tmp

export EDITOR=vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# --------------------------------------------------------------------
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias ..='cd ..'
alias tmux='tmux -2'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

function ll { command ls -l --color=always "$@" | less -F -X -R ;}
function llr { command ls -alFtr --color=always "$@" | less -F -X -R +G ;}
function tree { command tree -C "$@" | less -F -X -R ;}
function find { command find "$@" -regextype egrep | less -F -X ;}

# Ripgrep search dotfiles but not dotdirectories
function rg {
    # command rg --hidden -g '!.*/' "$@" | less -F -X -R ;
    command rg --hidden -g '!.*/' "$@";
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# --------------------------------------------------------------------
# fzf (https://github.com/junegunn/fzf)

if command -v fzf > /dev/null; then
   # Set key bindings such ash C-t (preview), C-r (history) and **
   source /usr/share/fzf/key-bindings.bash
   source /usr/share/fzf/completion.bash

   # Use ripgrep and search dotfiles but not dotdirectories
   export FZF_DEFAULT_COMMAND='rg --files --hidden -g '!.*/' -l ""';

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

   # Rg() {
   #   local selected=$(
   #     rg --column --line-number --no-heading --color=always --smart-case "$1" |
   #       fzf --ansi --preview "~/.vim/plugged/fzf.vim/bin/preview.sh {}"
   #   )
   #   [ -n "$selected" ] && $EDITOR "$selected"
   # }

   # RG() {
   #   RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
   #   INITIAL_QUERY="$1"
   #   local selected=$(
   #     FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' || true" \
   #       fzf --bind "change:reload:$RG_PREFIX {q} || true" \
   #           --ansi --phony --query "$INITIAL_QUERY" \
   #           --preview "~/.vim/plugged/fzf.vim/bin/preview.sh {}"
   #   )
   #   [ -n "$selected" ] && $EDITOR "$selected"
   # }

   # fzf-down() {
   #   fzf --height 50% "$@" --border
   # }

   export FZF_DEFAULT_OPTS='--color "preview-bg:237"'
   export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"

   command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

   # # fco - checkout git branch/tag
   # fco() {
   #   local tags branches target
   #   tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
   #   branches=$(
   #     git branch --all | grep -v HEAD             |
   #     sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
   #     sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
   #   target=$(
   #     (echo "$tags"; echo "$branches") | sed '/^$/d' |
   #     fzf-down --no-hscroll --reverse --ansi +m -d "\t" -n 2 -q "$*") || return
   #   git checkout $(echo "$target" | awk '{print $2}')
   # }

   # Switch tmux-sessions
   fs() {
     local session
     session=$(tmux list-sessions -F "#{session_name}" | \
       fzf --height 40% --reverse --query="$1" --select-1 --exit-0) &&
     tmux switch-client -t "$session"
   }
fi

# --------------------------------------------------------------------
# Powerline for bash setup
if command -v powerline-daemon > /dev/null; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    #. /usr/lib/python3.7/site-packages/powerline/bindings/bash/powerline.sh
    . /usr/share/powerline/bindings/bash/powerline.sh
fi
