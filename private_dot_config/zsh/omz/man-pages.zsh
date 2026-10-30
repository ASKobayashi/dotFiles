# Colors for the colored-man-pages plugin (ported from colored_man_pages.fish)
less_termcap[md]=$'\e[1m\e[38;2;2;128;165m'    # bold: teal
less_termcap[us]=$'\e[4m\e[38;2;91;165;2m'     # underline: green
less_termcap[so]=$'\e[48;2;240;203;2m\e[30m'   # standout: black on yellow

# `cless <command>`: run any less-based command with the same colors
alias cless=colored
