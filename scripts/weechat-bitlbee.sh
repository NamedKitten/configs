#!/bin/sh
if [ ! -f install.sh ] && [ ! -f ../install.sh ]; then
	echo Error: install.sh is missing
	exit 1
fi
if [ -f install.sh ]; then
	install_sh="./install.sh"
else
	install_sh="../install.sh"
fi
source $install_sh --source
EOR
ask_sudo
EOF sudo pacman -S weechat bitlbee aspell-en --noconfirm --needed
EOF sudo systemctl start bitlbee
EOF sudo systemctl enable bitlbee
print Enter your bitlbee password
read password
clear; clear; clear; clear; clear; clear
print Generating weechat command...
weechat -r "/server add im localhost -autoconnect;/set irc.server.im.sasl_username $USER; /set irc.server.im.sasl_password $password; /set irc.server.im.command '/msg &bitlbee register $password'; /save; /connect im; /set aspell.check.default_dict en; /aspell enable; /save"
weechat -r "/set irc.server.im.command ''; /save; /quit"
unset password
