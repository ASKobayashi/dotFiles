[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -f ~/.bash/completion_scripts/git_completion ] && . ~/.bash/completion_scripts/git_completion
[ -f ~/.bash/completion_scripts/rake_completion ] && complete -C ~/.bash/completion_scripts/rake_completion -o default rake
