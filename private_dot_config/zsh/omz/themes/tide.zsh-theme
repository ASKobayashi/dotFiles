# tide.zsh-theme — two-line framed prompt in the style of fish's tide, built
# from Oh My Zsh's git, virtualenv and async prompt helpers.
#
#   ╭─ ~/src/project │ main ⇡ ! ? ─────────────────────────────────────────
#   ╰─❮                                     ✘ 1 │ 4s │ venv │ 12:34:56
#
# Colors are ANSI palette indexes, so the terminal theme picks the shades.
# Glyphs need a Nerd Font.
#
# Git status runs in the background, so a slow repo never blocks the prompt.
# To skip the working-tree scan in a very large repo (the branch still shows):
#   git config oh-my-zsh.hide-status 1

# git: branch and any rebase/merge in progress (gitfast's git_prompt_info),
# then one symbol per kind of change (git_prompt_status).
ZSH_THEME_GIT_PROMPT_PREFIX=" %F{8}│ %F{10}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""  # the status symbols already say this
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_BEHIND="%F{10} ⇣"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{10} ⇡"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{9} ~"
ZSH_THEME_GIT_PROMPT_STASHED="%F{10} *"
ZSH_THEME_GIT_PROMPT_DELETED="%F{11} -"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{11} »"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{11} !"
ZSH_THEME_GIT_PROMPT_ADDED="%F{11} +"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{12} ?"

ZSH_THEME_VIRTUALENV_PREFIX=" %F{6}"$'\U000f0320'" "
ZSH_THEME_VIRTUALENV_SUFFIX=" %F{8}│"

# user@host as root; just a server icon over SSH (the window title has user@host)
typeset -g _tide_ssh=""
[[ -n $SSH_CONNECTION || -n $SSH_TTY ]] && _tide_ssh=" %F{3}"$'\U000f048b'" %F{8}│"

# Duration of the last command, from 3s. (Oh My Zsh's timer plugin prints over
# the previous line, which collides with a right-hand prompt.)
zmodload zsh/datetime
autoload -Uz add-zsh-hook
typeset -g _tide_start=0 _tide_took=""
_tide_preexec() { _tide_start=$EPOCHREALTIME }
_tide_precmd() {
  local -i t=$(( _tide_start ? EPOCHREALTIME - _tide_start : 0 ))
  local d="$(( t / 3600 ))h $(( t % 3600 / 60 ))m $(( t % 60 ))s"
  _tide_start=0
  _tide_took=""
  (( t >= 3 )) && _tide_took=" %F{8}${${d#0h }#0m } %F{8}│"
}
add-zsh-hook preexec _tide_preexec
add-zsh-hook precmd _tide_precmd

# Line 1 is clipped to the terminal width, so the rule after the left segment
# always ends exactly at the edge. The path is clipped from the left to half
# the width first; it sits in its own %(l...) group (always true) so the two
# clips don't cancel each other.
PROMPT='%${COLUMNS}>>%F{8}╭─%F{0}'$'''%K{0} %B%F{14}%(l.%$(( COLUMNS / 2 ))<…<%~%<<.)%b$(git_prompt_info)$(git_prompt_status) %k%F{0}'$'''%F{8}${(l:COLUMNS::─:)}%>>
%F{8}╰─%(?.%F{10}.%F{9})❮%f '

RPROMPT='%F{0}'$'''%K{0}%(?.. %F{1}✘ %? %F{8}│)${_tide_took}%(!. %F{11}%n@%m %F{8}│.${_tide_ssh})%(1j. %F{2}'$''' %F{8}│.)$(virtualenv_prompt_info) %F{8}%D{%H:%M:%S} %k%F{0}'$'''%f'
