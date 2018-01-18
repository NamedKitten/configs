#!/usr/bin/env bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Add ls alias for terminals other than urxvt ( it isn't required in bash-it )
alias ls='ls --color=auto'

# Disable nano file wrapping
alias nano='nano --nowrap'

# Add alias for reloading Xdefaults
alias reloadXvar='$HOME/.config/tim241/bin/lxdef'

# Add alias for starting vim with ranger
alias vimr='vim +Ranger'

# Only export this when we're in bashrc 
export BASHRC=1

# Change this CITY variable as needed
export CITY=Heerlen
# Display weather when we have internet
function weather {
	if ping -q -c 1 -W 1 google.com >/dev/null; then
		if [ "$BASHRC" = "1" ]; then
	                curl http://wttr.in/$CITY --silent | head -7
	        else
	                curl http://wttr.in/$CITY --silent
	        fi
	else
		alias weather='echo "The network is down"'	
	fi
}
# Switch WM (opnbox -> i3-gaps, i3-gaps -> openbox)
function switchWM () {
	if [ "x`cat ~/.xinitrc`" != "xexec openbox-session" ]; then
		echo Setting openbox as WM
		echo "exec openbox-session" > ~/.xinitrc
	else
		echo Setting i3 as WM
		echo "exec i3" > ~/.xinitrc
	fi
}
# Set default text editor to nano
export VISUAL=nano
export EDITOR=$VISUAL

# Bash it variables
export BASH_IT="$HOME/.bash_it"
export BASH_IT_THEME='powerline'
export SCM_CHECK=true
if [ "$TERM" = "rxvt-unicode-256color" ]; then
	# Load Bash-It when you are running urxvt
	source "$BASH_IT"/bash_it.sh
fi

# Add $HOME/bin to your PATH
export PATH="$HOME/bin:$PATH"

weather


# --> END OF BASHRC <--
unset BASHRC
