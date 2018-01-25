#!/usr/bin/env bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use minimalistic PS1
PS1="> \w "

# Add sleep command which supports ms
BASH_LOADABLES_PATH=$(pkg-config bash --variable=loadablesdir 2>/dev/null)
enable -f sleep sleep

##################################
##### <<-- alias section -->> ####
##################################

# Add ls alias for terminals other than urxvt 
#(it isn't required in bash-it)
alias ls='ls --color=auto'

# Use vim instead of nano
#(due to my urxvt keybindings, you cannot quit nano)
alias nano='vim'

# Add alias for reloading Xdefaults
alias reloadXvar='$HOME/.config/tim241/bin/lxdef'

# Aliases related to vim
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
alias clock='tty-clock -c'

# Add alias for sourcing bashrc
alias sb='source ~/.bashrc'


#####################################
##### <<-- function section -->> ####
#####################################

# Change this CITY variable as needed
export CITY=Heerlen

# Display weather when we have internet
function weather {
	curl=$(which curl)
	WD=$HOME/.weather
	ONLINE=false
	SYNC=false
	if [ ! -d $WD ]; then
                mkdir $HOME/.weather
	fi
	if [ ! -f $WD/time ] || [ ! -f $WD/weather ]; then
	        echo $(date +%H%y%m%d) > $WD/time
		NEW=true
		SYNC=true
	fi
	if [ "$(date +%H%y%m%d)" != "$(cat $WD/time)" ]; then
		SYNC=true
	fi
	if (( $(tput lines) >= 32 )) && (( $(tput cols) >= 127 )); then SHORT=0; else SHORT=1; fi
	case $1 in
		--full ) SHORT=0;;
		--short | -s ) SHORT=1;;
		--help | -h ) 
			echo "weather [] for autodetecting the terminal size and changing accordingly"
			echo "weather [-s/--short] for the short version"
			echo "weather [-f/--full] for the full weather forecast"
			return
			;;
		*);;
	esac
	if ping -q -c 1 -W 1 google.com >/dev/null 2>&1; then
		if [ "$SYNC" = "true" ]; then 
			$curl http://wttr.in/$CITY --silent > $WD/tmp 
			if [ $(wc -l $WD/tmp | cut -d' ' -f1) = 40 ]; then 
				cp $WD/tmp $WD/weather
				rm $WD/tmp
				echo $(date +%H%y%m%d) > $WD/time
			fi
		fi
		ONLINE=true
	fi	
	if [ "$NEW" != "true" ] || [ "$ONLINE" = "true" ] ; then
		if [ "$SHORT" = "1" ]; then
                        cat $HOME/.weather/weather | head -7
		else
                        cat $HOME/.weather/weather | head -n -2 | sed -e '1,7d'
	        fi
	fi
}
# Display the date in a pretty way
function showdate {
	if which toilet > /dev/null 2>&1; then
		echo -e "\n$(date '+%D %T' | toilet -f term -F border --gay)\n"
	else
		echo -e "\n$(date '+%D %T')\n"
	fi
} 

# Source script file from theme, if exists
if [ -f "$HOME/.config/tim241/themes/$DESKTOP_THEME/source.sh" ]; then
	source $HOME/.config/tim241/themes/$DESKTOP_THEME/source.sh
fi

#######################################
##### <<-- preference section -->> ####
#######################################
# Set desktop theme
export DESKTOP_THEME=space

# Set default text editor to nano
export VISUAL=vim
export EDITOR=$VISUAL

# Add $HOME/bin to your PATH
export PATH="$HOME/bin:$PATH"

# Display the weather forecast(the short version)
weather --short

# Display the time
showdate
