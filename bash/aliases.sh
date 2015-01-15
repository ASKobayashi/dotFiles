# Aliases
###################################################################

# Standard Navigation and File Manipulation
alias cd..='cd ..'
alias ..='cd ..'
alias cp='cp -i'
alias mv='mv -i'
alias su='su -'
alias pa='ps aux'
alias mroe="less -E"
alias more="less -E"
alias h='history'
alias vi='vim'
alias grep='grep --directories=skip -i --color=auto'

# Development Aliases
alias gitx='gitx -c'
alias gs='git status'
alias gl='git pull'
alias gp='git push'

alias ctags_gen='ctags --fields=+lS --c-kinds=+p'
alias cscope_gen="find -E . -iregex '.*\.(c|cc|cpp|hpp|h|m|mm)' -exec echo '\"{}\"' \; > cscope.files && cscope -b -q"

# Custom ls functionality
alias ls='~/.bash/ls.sh'
alias ll='ls -lA'
alias la='ls -Ax'

# Use the gnu versions of utilities where available
command -v gdircolors >/dev/null && alias dircolors='gdircolors'
command -v grm >/dev/null && alias rm='grm'

alias sl="pbpaste | sed -e 's/\(..\)/\\\\x\1/g' | pbcopy"

getProcPid() {
    ps aux | \grep $1 | \grep -v grep | awk '{print $2}'
}

alias getpid=getProcPid

alias startWebServer="python -m SimpleHTTPServer 8000"

# Local aliases if they exist (Private aliases here)
[ -f ~/.bash/aliases.local.sh ] && . ~/.bash/aliases.local.sh

