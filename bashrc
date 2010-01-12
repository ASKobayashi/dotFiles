# Aaron Kobayashi's .bashrc
# Stored in dreamhost.  To clone with git:
# cd ~
# git clone ssh://askobayashi@ASKobayashi.com/~/git/shellFiles.git
###################################################################

# Global Defs
[ -f /etc/bashrc ] && . /etc/bashrc 

# Exports
[ -f ~/.bash/exports.sh ] && . ~/.bash/exports.sh

# Aliases 
[ -f ~/.bash/aliases.sh ] && . ~/.bash/aliases.sh

# dircolors
eval `dircolors -b ~/.bash/dircoloursrc` # ls Colors

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Bash custom auto completion
[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -f ~/.bash/git-bash-completion.sh ] && . ~/.bash/git-bash-completion.sh
[ -f ~/.bash/git-prompt.sh ] && . ~/.bash/git-prompt.sh 
