#!/usr/bin/env bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Add ls alias for terminals other than urxvt ( it isn't required in bash-it )
alias ls='ls --color=auto'

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
