# Oh My Zsh provides clipcopy/clippaste, but only uses xclip when $DISPLAY is
# set. On a headless machine whose xclip forwards to the local clipboard, use
# xclip anyway.
if [[ $OSTYPE != darwin* && -z $DISPLAY && -z $WAYLAND_DISPLAY ]] && (( $+commands[xclip] )); then
  clipcopy() { command cat "${1:-/dev/stdin}" | xclip -selection clipboard; }
  clippaste() { xclip -selection clipboard -o; }
fi
