# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

#ZSH_THEME="robbyrussell"

# Remove extra space between right prompt right edge of terminal
export ZLE_RPROMPT_INDENT=0

# default: #POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(host dir vcs)
# default: #POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(virtualenv status root_indicator background_jobs time)

# powerline10k theme installed from https://github.com/romkatv/powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_MODE="awesome-patched"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# (tmux tab titles are constantly set to cwd otherwise)
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# Plugin notes:
#   command-not-found: Needs "sudo pacman -S pkgfile && sudo pkgfile --update" on Arch
# Third-party plugins:
#   zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions
#   zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting.git (must be last in plugins list)
plugins=(colored-man-pages colorize fzf git command-not-found zsh-autosuggestions zsh-syntax-highlighting)

export FZF_BASE=/usr/share/fzf

# Save aliases before sourcing oh-my-zsh
save_aliases=$(alias -L)

# Source all oh-my-zsh code
source $ZSH/oh-my-zsh.sh

# Remove all aliases set by oh-my-zsh and restore old
unalias -m '*'
eval $save_aliases; unset save_aliases

# User configuration
export PAGER='less -F -X -R'

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ..='cd ..'
alias tmux='tmux -2'
alias ccat='colorize_cat' # From 'colorize' plugin. Depends on 'pygments' or 'chroma'.
alias cless='colorize_less' # From 'colorize' plugin. Depends on 'pygments' or 'chroma'.
alias cp='nocorrect cp'
alias hg='nocorrect hg'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias history=omz_history
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias sudo='nocorrect sudo'
alias gnomon='gnomon --real-time=1000 --type=elapsed-total --format="H:i:s"'
alias w=' w' # Don't save in history. Requires 'setopt HIST_IGNORE_SPACE'
alias qtail='multitail -D -CS quartus_log --retry-all --mergeall'
alias sshagent='eval $(ssh-agent) && ssh-add'
alias ydl='youtube-dl --write-sub --audio-quality 0 -ci --xattrs'
alias sshsilicom='ssh -YC cbs@10.100.1.42'
alias doomupdate='~/doom_install/bin/doom --doomdir /home/chrbirks/.config/doom refresh && ~/doom_install/bin/doom --doomdir /home/chrbirks/.config/doom update && ~/doom_install/bin/doom --doomdir /home/chrbirks/.config/doom upgrade'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=critical -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#function ll { command ls -l --color=always "$@" | less -F -X -R ;}
function ll { {echo "" & command ls -l --color=always "$@";} | less -F -X -R ;} # Echo empty line at top. Usefull when using double-height zsh prompt and output is more than one screen.
function llt { command ls -alFt --color=always "$@" | less -F -X -R ;}
function dfh { command df -h -x tmpfs "$@" | command grep -v "/snap/" | command grep -v "Mounted on" | sort -k6 ;}
function tree { command tree -C "$@" | less -F -X -R ;}
function find { command find "$1" -regextype posix-extended "${@:2:$#}" | less -F -X ; }
less() { command less -F -X -R "$@" ;}

# Ripgrep search dotfiles but not dotdirectories
rg() {
    command rg --pretty --hidden \
	    -g '!.*/' \
	    "$@" \
	    | less -F -X -R ;
}

# Color print of users logged into local machine
umon() {
	who | awk '
	## Color myself green using whole line match
	# /.\(10\.100\.1\.42\)/ {print "\033[32m" $0 "\033 [39m"}
	# /.\(\:1\)/ {print "\033[32m" $0 "\033[39m"}
	#
	## Color myself green using second field match
	$2 ~ /\:1/ {print "\033[32m" $0 "\033[39m"}
	#
	## Color other users red using whole line match
	# !/.\(\:1\)/ {print "\033[31m" $0 "\033[39m"}
	#
	## Color other users red using second field match
	$2 !~ /\:1/ {print "\033[31m" $0 "\033[39m"}
	'
}

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Don't make cd push the old dir onto the stack
unsetopt AUTO_PUSHD
# Required for pushd/popd to work after unsetopt AUTO_PUSHD
unsetopt PUSHD_IGNORE_DUPS
# Suppress output from pushd/popd
setopt PUSHD_SILENT

# don't put duplicate lines or lines starting with space in the history.
# # See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
setopt histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

if [[ -v TMUX_PANE ]]; then
   HISTFILE=~/.zsh_history_${TMUX_PANE}
else
   HISTFILE=~/.zsh_history
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#setopt checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#setopt globstar

# Enable command completion
autoload -Uz compinit
compinit

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Opt out of .NET Core tools telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Add path to installed snaps
export PATH="/snap/bin:$PATH"

# Add path to rust compiler
export PATH="$HOME/.cargo/bin:$PATH"

# Configure broot to launch using a shell function
# TODO: Check that broot is installed before running
source /home/cbs/.config/broot/launcher/bash/br

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Setup for fzf
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='40%'
export FZF_COMPLETION_TRIGGER='**'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load work related env
[[ ! -f ~/.config/zsh/.silicom_env.zsh ]] || source ~/.config/zsh/.silicom_env.zsh
