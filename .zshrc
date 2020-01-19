#setopt prompt_subst; zmodload zsh/datetime; PS4='+[$EPOCHREALTIME]%N:%1> '; set -x
#zmodload zsh/zprof
DEFAULT_USER=wayne
ZSH_TMUX_FIXTERM_WITH_256COLOR=true

export ZSH=/home/wayne/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(fast-syntax-highlighting zle-vi-visual docker zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export VISUAL="/usr/local/bin/vim"
export EDITOR=vim

if command -v tmux>/dev/null; then
	[[ ! $TERM =~ screen-256color ]] && [ -z $TMUX ] && export TERM=rxvt-unicode-256color #&& export COLORTERM=rxvt-unicode-256color
fi

export GIT_EDITOR=vim

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# export PATH="/home/wayne/node-v8.2.1-linux-x64/bin:$PATH"
export PATH="$PATH:/home/wayne/.local/bin"

alias o="xdg-open"
alias calc="noglob ~/bin/calc"
alias vi="/home/wayne/bin/ranger_vi tab "

# Go
export GOPATH="/home/wayne/go"
export GOROOT="/usr/local/go"
export PATH="$PATH:$GOROOT/bin:/home/wayne/go/bin"
export GO111MODULE=on

export PATH="$PATH:/home/wayne/clipster"
export PATH="$PATH:/home/wayne/Downloads/Postman"
export PATH="$PATH:/home/wayne/.script"
export PATH="$PATH:/home/wayne/i3blocks/scripts"
export PATH="$PATH:/home/wayne/bin"
export PATH="$PATH:/snap/bin"
export PATH="$PATH:/home/wayne/.cargo/bin"

export RANGER_LOAD_DEFAULT_RC="FALSE"

# Wayne
# zsh -is eval "tmux -2" (?)
if [[ $1 == eval ]]
then
	"$@"
	set --
fi
setopt NO_HUP
setopt NO_CHECK_JOBS

export NO_AT_BRIDGE=1

#set -o noglob

export LESS='-XRS'
bindkey -v

# Fake slow localhost
alias veryslowerlocalhost="sudo tc qdisc add dev lo root netem delay 150ms 100ms 25%"
# alias slowlocalhost="sudo tc qdisc add dev lo root netem delay 100ms 50ms 25%"
# alias slightlyslowerlocalhost="sudo tc qdisc add dev lo root netem delay 50ms 30ms 25%"
alias restorelocalhost="sudo tc qdisc del dev lo root"

# alias mem="sudo ps_mem"

# bindkey '^x' fasd-complete    # C-x C-a to do fasd-complete (files and directories)
bindkey '^f' fasd-complete    # C-x C-a to do fasd-complete (files and directories)
# bindkey '^x^f' fasd-complete-f  # C-x C-f to do fasd-complete-f (only files)
# bindkey '^x^d' fasd-complete-d  # C-x C-d to do fasd-complete-d (only directories)

function visualToClipboard() {
	local -i mark=${MARK}
	local -i cursor=${CURSOR}
	local -i start
	local -i finish
	#if [[ cursor -ge mark ]]; then
	#	start=mark && finish=cursor
	#else
	#	start=cursor && finish=mark
	#fi
	[[ cursor -ge mark ]] && start=mark && finish=cursor
	[[ cursor -lt mark ]] && start=cursor && finish=mark
	#local -i length=finish-start
	local new=${BUFFER[start+1,finish+1]}
	echo -n ${new} | xclip -se c -i
	#BUFFER="Start:${start} Final:${finish} Length:${length} New:${new}\nMark: ${mark} Cursor:${cursor} Mode:${mode}"
	zle -U "\e"
}
zle -N visualToClipboard
bindkey -M visual Y visualToClipboard

setopt no_hist_verify

bindkey -M viins '^w' backward-kill-word
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^l' vi-forward-blank-word
bindkey -M viins '^[^[' vi-cmd-mode
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins '^[^M' self-insert-unmeta

# Enabling Zle vim functions

# Text object for matching characters between a particular delimiter
# So for example, given "text", the vi command vi" will select
# all the text between the double quotes
# The following is an example of how to enable this:
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
	for c in {a,i}{\',\",\`}; do
		bindkey -M $m $c select-quoted
	done
done

# Implementation of some functionality of the popular vim surround plugin.
# Allows "surroundings" to be changes: parentheses, brackets and quotes.

# To use
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

#  This doesn't allow yss to operate on a line but VS will work

### buku
alias b="buku"
alias ba="buku -a"

### fasd cache
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache"  ]; then
	fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

function exitshell () {
	exit
}
zle -N exitshell

function ranger_checkexit() {
	# bindkey -rpM viins '^['
	bindkey -rpM vicmd "^["
	bindkey -M vicmd "^[" exitshell
	bindkey -M viins "^[^[" exitshell
}

function oneshot_ranger_exit() {
	# bindkey -rpM viins '^['
	bindkey -rpM vicmd "^["
	bindkey -M vicmd "^[" exitshell
	bindkey -M viins "^[^[" exitshell
	# ranger --choosefiles=$RANGER_CHOOSEFILES --selectfile=$RANGER_SELECTFILE
	ranger --choosefiles=$RANGER_CHOOSEFILES --cmd="cd $RANGER_CD"
	exit
}

function one_command_checkexit() {
	# bindkey -rpM viins '^['
	bindkey -rpM vicmd "^["
	bindkey -M vicmd "^[" exitshell
	bindkey -M viins "^[^[" exitshell
	[ -v ONE_COMMAND_DONE ] && echo -n 'Done.' && read && exit
	ONE_COMMAND_DONE=1
}

function oneshot_exit() {
	# bindkey -rpM viins '^['
	bindkey -rpM vicmd "^["
	bindkey -M vicmd "^[" exitshell
	bindkey -M viins "^[^[" exitshell
	[ -v ONE_COMMAND_DONE ] && exit
	ONE_COMMAND_DONE=1
}

[ -v VIM_RANGER_SHELL ] && precmd() { oneshot_ranger_exit }
[ -v ONE_COMMAND_SHELL ] && precmd() { one_command_checkexit }
[ -v ONESHOT_EXIT_SHELL ] && precmd() { oneshot_exit } && preexec() { i3-msg "move scratchpad" }
[ -v RANGER_LEVEL ]	&& bindkey -M vicmd "qq" exitshell && bindkey -M viins "qq" exitshell


# alias ranger=". ranger"
# alias r="/home/wayne/bin/ranger_wrapper2"

function ctrlp_peco_popup () {
  /usr/bin/urxvt -name one_command_shell_big -e /home/wayne/bin/peco_popup
}
zle -N ctrlp_peco_popup
bindkey -M vicmd "^p" ctrlp_peco_popup
bindkey -M viins "^p" ctrlp_peco_popup

function vim_wiki () {
  BUFFER="vim /home/wayne/my_site/index.md"
  zle accept-line
}
zle -N vim_wiki
bindkey -M viins ",ww" vim_wiki

function copy_path_to_ranger () {
  echo -n $PWD | xclip -se c -i
  i3-msg '[con_mark="r"] focus' >/dev/null 2>&1
}
zle -N copy_path_to_ranger
bindkey -M viins "^g" copy_path_to_ranger

export DISPLAY=192.168.43.89:0.0
export LIBGL_ALWAYS_INDIRECT=1
export PULSE_SERVER=tcp:192.168.43.89

# cd 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#zprof
