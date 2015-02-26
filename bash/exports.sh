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

export GREP_COLOR='31'

export TZ='America/Chicago'

# Local exports if they exist Overides
[ -f ~/.bash/exports.local.sh ] && . ~/.bash/exports.local.sh

# export PYTHONSTARTUP=~/.pystartup
# export PYTHONPATH="/System/Library/PrivateFrameworks/LLDB.framework/Resources/Python:$(brew --prefix)/lib/python2.7/site-packages:/Library/Python/2.7/site-packages/"

