#!/usr/bin/env bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use minimalistic PS1
PS1="> \\w "

# Add sleep command which supports ms
BASH_LOADABLES_PATH=$(pkg-config bash --variable=loadablesdir 2>/dev/null)
enable -f sleep sleep > /dev/null 2>&1

##################################
##### <<-- alias section -->> ####
##################################

# Add ls alias for terminals other than urxvt 
#(it isn't required in bash-it)
alias ls='ls --color=auto'

# Add alias for nano to disable file wrapping
alias nano='nano --nowrap'

# Add alias for reloading Xdefaults
alias reloadXvar='$HOME/.config/tim241/bin/lxdef'

# Aliases related to vim
if command -v vim-huge > /dev/null 2>&1; then
	alias vim='vim-huge'
	VIM_HUGE=true
else
	VIM_HUGE=false
fi

alias v='vim'
alias vb='vim ~/.bashrc'
alias vr='vim ~/.vimrc'
alias vimr='vim +Ranger'

# Add alias for starting ranger
alias r='ranger'

# Add newline to all curl output
alias curl='curl -w "\n"'

# terminal pastebin
alias tb='nc termbin.com 9999'

# Add alias for tty-clock
alias clock='tty-clock -cD'

# Add alias for sourcing bashrc
alias sb='source ~/.bashrc'

# Add alias for theme command
if [ -f "$HOME/.config/tim241/bin/theme" ]; then
	alias theme='~/.config/tim241/bin/theme'
fi

# Add alias for ncmpcpp
alias music='ncmpcpp'

#####################################
##### <<-- function section -->> ####
#####################################

# Change this CITY variable as needed
export CITY=Heerlen

# Display weather when we have internet
function weather {
	if command -v curl > /dev/null 2>&1; then
		curl=$(which curl)
	else
		echo curl is not installed!
		return
	fi
	if [ ! "$XDG_CACHE_HOME" ]; then
		XDG_CACHE_HOME="$HOME/.cache"
	fi
	local WD="$XDG_CACHE_HOME/weather"
	local SYNCED=false
	local SYNC=false
	local NEW=false
	if [ ! -d "$WD" ]; then
                mkdir -p "$WD"
	fi
	if [ ! -f "$WD"/time ] || [ ! -f "$WD"/weather ]; then
		NEW=true
		SYNC=true
	fi
	if [ -f "$WD"/time ]; then
		if [ "$(date +%H%y%m%d)" != "$(cat "$WD"/time)" ]; then
			SYNC=true
		fi
	fi
	if (( $(tput lines) >= 32 )) && (( $(tput cols) >= 127 )); then SHORT=0; else SHORT=1; fi
	for arg in $@; do
		case $arg in
			--full | -f ) SHORT=0;;
			--short | -s ) SHORT=1;;
			--reset | -r ) rm -rf "$WD"; mkdir -p "$WD"; NEW=true; SYNC=true;;
			--help | -h ) 
				echo "weather [] for autodetecting the terminal size and changing accordingly"
				echo "weather [-s/--short] for the short version"
				echo "weather [-f/--full] for the full weather forecast"
				echo "weather [-r/--reset] removes the cache and refreshes the weather"
				return
				;;
			*);;
		esac
	done
	if ping -q -c 1 -W 1 wttr.in >/dev/null 2>&1; then
		if [ "$SYNC" = "true" ]; then 
			"$curl" http://wttr.in/$CITY --silent > "$WD"/tmp 
			if [ -f "$WD"/tmp ]; then
				if [ "$(wc -l "$WD"/tmp | cut -d' ' -f1)" = 40 ]; then 
					cp "$WD"/tmp "$WD"/weather
					rm "$WD"/tmp
					echo "$(date +%H%y%m%d)" > "$WD"/time
					SYNCED=true
				fi
			fi
		fi
	fi	
	if [ "$NEW" != "true" ] || [ "$SYNCED" = "true" ] ; then
		if [ "$SHORT" = "1" ]; then
                        cat "$WD"/weather | head -7
		else
                        cat "$WD"/weather | head -n -2 | sed -e '1,7d'
		fi
	fi
}
# Display the date in a pretty way
function showdate {
	if command -v toilet > /dev/null 2>&1; then
		echo -e "\n$(date '+%D %T' | toilet -f term -F border --gay)\n"
	else
		echo -e "\n$(date '+%D %T')\n"
	fi
} 
# Autocompletion for the theme script
_theme(){
	cur="${COMP_WORDS[COMP_CWORD]}"
	opts="help list set keep restore get"
	if [ ${COMP_WORDS[COMP_CWORD-1]} != "set" ] &&  [ ${COMP_WORDS[COMP_CWORD-1]} != "keep" ]; then
		COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
	else
		COMPREPLY=($(compgen -W "$(theme list)" -- ${cur}))
	fi
}
complete -F _theme theme

# Source script file from theme, if exists
if [ -f "$HOME/.config/tim241/themes/$DESKTOP_THEME/source.sh" ]; then
	source "$HOME/.config/tim241/themes/$DESKTOP_THEME/source.sh"
fi

#######################################
##### <<-- preference section -->> ####
#######################################

# Set desktop theme
if [ -f "$HOME/.config/tim241/bin/theme" ]; then
        export DESKTOP_THEME=$(theme get)
fi

# Set default text editor to vim
if [ "$VIM_HUGE" = "true" ]; then
	export VISUAL=vim-huge
else
	export VISUAL=vim
fi
export EDITOR=$VISUAL

# Add $HOME/bin to your PATH
export PATH="$HOME/bin:$PATH"

# Start X in tty1
if [ "$(tty)" = "/dev/tty1" ] && [ -f "$HOME/.xinitrc" ]; then
	startx
fi

# Display the weather forecast(the short version)
weather --short

# Display the time
showdate
