# Aliases (ported from config.fish). Replacements for standard tools are only
# set when the tool is installed, and only in shells a person is typing into:
# scripts and coding agents keep the standard tools they expect.

(( $+commands[nvim] )) && alias vi=nvim vim=nvim
alias cm=chezmoi

# chezmoi abbreviations (ported from fish-chezmoi)
alias cma='chezmoi add'
alias cmap='chezmoi apply'
alias cmea='chezmoi edit --apply'
alias cmu='chezmoi update'
alias cmd='chezmoi diff'

# Debian/Ubuntu package fd as fdfind
(( $+commands[fd] )) || { (( $+commands[fdfind] )) && alias fd=fdfind; }

if [[ -t 1 && -z $CLAUDECODE ]]; then
  (( $+commands[fd] || $+commands[fdfind] )) && alias find=fd  # use `command find` for the real one
  (( $+commands[bat] )) && alias cat=bat
  (( $+commands[btm] )) && alias top=btm
  if (( $+commands[lsd] )); then
    alias ls=lsd
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls --tree'
  fi
fi
