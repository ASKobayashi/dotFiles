if command -v nvim >/dev/null 2>&1; then
	export EDITOR="nvim"
else
	export EDITOR="vim"
fi

alias vi > /dev/null 2>&1 || alias vi="$EDITOR"
