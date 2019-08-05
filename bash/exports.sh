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
export GREP_COLOR='31'

export TZ='America/Chicago'

# Local exports if they exist Overides
[ -f ~/.bash/exports.local.sh ] && . ~/.bash/exports.local.sh


# PS1
set_prompt () {
    Last_Command=$? # Must come first!
    Red='\[\e[01;31m\]'
    RedDark='\[\e[0;31m\]'
    LightBlue='\[\e[0;94m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'

    # Add a bright white exit status for the last command
    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    PS1="$Reset"

    if [[ $Last_Command != 0 ]]; then
        PS1+="$RedBold\$? "
    fi

    PS1+="$Green\\u$Reset@$Red\\h"

    if [[ $VIRTUAL_ENV ]]; then
        PS1="$LightBlue($(echo $VIRTUAL_ENV | sed 's/.*\///' | sed 's/-.*//' ))"
    fi
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$Reset\\$ "

}
PROMPT_COMMAND='set_prompt'

