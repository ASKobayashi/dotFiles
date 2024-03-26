if status is-interactive

end

fish_add_path /opt/homebrew/bin

# other tools
alias find=fd
alias cat=bat

# lsd
alias ls=lsd
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Update gazorby/fish-abbreviation-tips definitions
__abbr_tips_init
