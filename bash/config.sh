###########
# general #
###########
export EDITOR="vim"

# Autocorrect mispelled directories
shopt -s cdspell

# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# dircolors
command -v dircolors >/dev/null && eval `dircolors -b ~/.bash/dircoloursrc` # ls Colors

# Switch to a gem directory, trying to match your name the best
function cdgem {
  gem_dir=`gem env | grep INSTALLATION | cut -d' ' -f6`
  cd $gem_dir/gems
  cd `ls|grep $1|sort|tail -1`
}

#####################
#  ssh-agent stuff  #
#####################
# get the ssh agent started
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
	echo "Initialising new SSH agent..."
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	echo succeeded
	chmod 600 "${SSH_ENV}"
	. "${SSH_ENV}" > /dev/null
	/usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
	. "${SSH_ENV}" > /dev/null
	ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
	start_agent;
	}
else
	start_agent;
fi
