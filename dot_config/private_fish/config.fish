if status is-interactive

end

fish_add_path /opt/homebrew/bin

# other tools
alias vi=nvim
alias vim=nvim
alias find=fd
alias cat=bat
alias cm=chezmoi
alias top=btm

# lsd
alias ls=lsd
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Env vars
set -gx EDITOR nvim

# Update gazorby/fish-abbreviation-tips definitions
#__abbr_tips_init
