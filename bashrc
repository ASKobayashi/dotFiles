# Aaron Kobayashi's .bashrc
# Stored in dreamhost.  To clone with git:
# git clone ssh://askobayashi@ASKobayashi.com/~/git/shellFiles.git
# Then run the linkdotfiles script
###################################################################

# VI mode
#set -o vi

[ -f /etc/bashrc ] && . /etc/bashrc
[ -f ~/.bash/aliases.sh ] && . ~/.bash/aliases.sh
[ -f ~/.bash/completions.sh ] && . ~/.bash/completions.sh
[ -f ~/.bash/exports.sh ] && . ~/.bash/exports.sh
[ -f ~/.bash/config.sh ] && . ~/.bash/config.sh

# Bash custom auto completion
[ -f ~/.bash/git-prompt.sh ] && . ~/.bash/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=

# Ruby/RVM
if [ -f ~/.rvm/scripts/rvm ]; then
  . ~/.rvm/scripts/rvm
  gemdoc=`gem environment gemdir`/doc
fi

# Virtualenv
if [ -f ~/opt/python/python/bin/activate ]; then
  . ~/opt/python/python/bin/activate
fi
