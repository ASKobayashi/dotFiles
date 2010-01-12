# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/

export PATH
unset USERNAME

history -c

#Apple X11 from Terminal.app
#if this is an apple machine
#if [  'uname -a | grep arwin' ]; then
#	# if we're NOT ssh'd in
#	if [ ! ${SSH_TTY} ]; then
#		# make sure X is running
#		if [ "`ps -x | awk '{print $5}' | grep X11`" = "" ]; then
#			open /Applications/Development/X11.app
#			# then refocus Terminal.app
#			osascript -e 'tell application "Terminal" to activate'
#			fi
#		# if DISPLAY isn't set
#		if [ x${DISPLAY} = x ]; then
#			export DISPLAY=:0
#		fi
#	fi
#fi
