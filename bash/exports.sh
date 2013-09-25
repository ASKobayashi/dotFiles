# Exports
###################################################################

# Standard Bash stuff
export PATH=\
~/opt/bin:\
~/.bash/path_scripts:\
/usr/local/bin:\
/usr/local/sbin:\
/opt/local/bin:\
/usr/texbin:\
/usr/bin:\
/usr/pkg/bin:\
/usr/sbin:\
/bin:\
$PATH

export HISTCONTROL=ignoreboth # don't put duplicate lines in the history and
                              # ignore same sucessive entries.

# Development
export SVN_EDITOR="vim"

# Code Building Paths
export LD_LIBRARY_PATH=\
/opt/local/lib:\
~/opt/lib:\
/usr/lib:\
$LD_LIBRARY_PATH\

export CPATH=\
/opt/local/include:\
/usr/include:\
~/opt/include:\
$CPATH

export MANPATH=\
/opt/local/man:\
~/opt/man:\
/usr/share/man:\
$MANPATH

export PYTHONSTARTUP=~/.pystartup

export GREP_OPTIONS="--directories=skip -n -i --color=auto"
export GREP_COLOR='31'

# Local exports if they exist Overides
[ -f ~/.bash/exports.local.sh ] && . ~/.bash/exports.local.sh

