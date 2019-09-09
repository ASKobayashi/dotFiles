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
alias grep='grep --directories=skip -i --color=auto'
alias xsel='xsel -i'  # For echo "foo" | xsel

# Development Aliases
alias gitx='gitx -c'
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias gc='git commit -v'
alias gca='git commit -v -a'

alias ctags_gen='ctags --recurse --fields=+lS --c-kinds=+p .'
alias cscope_gen="cscope -Rb"
alias preproc_gen="clang -Imyinclude -P -E -nostdinc -nobuiltininc "

# Custom ls functionality
alias ls='~/.bash/ls.sh'
alias ll='ls -lA'
alias la='ls -Ax'

# Use the gnu versions of utilities where available
command -v gdircolors >/dev/null && alias dircolors='gdircolors'
command -v grm >/dev/null && alias rm='grm'

getProcPid() {
    ps aux | \grep $1 | \grep -v grep | awk '{print $2}'
}

alias getpid=getProcPid

alias python=python3
alias pip=pip3

alias startWebServer="python -m SimpleHTTPServer 8000"

if [ ! $(uname -s) = "Darwin" ]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi


# Local aliases if they exist (Private aliases here)
[ -f ~/.bash/aliases.local.sh ] && . ~/.bash/aliases.local.sh

