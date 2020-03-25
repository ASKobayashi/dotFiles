# Per-Host settings
set -l host (hostname -s)
set -l host_specific_file ~/.config/fish/hosts/$host.fish
if test -f $host_specific_file
    source $host_specific_file
else
    echo "Creating host specific config file: $host_specific_file"
    mkdir -p (dirname $host_specific_file)
    touch $host_specific_file
end

set -x FISH_DIR $HOME/.config/fish


# Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# System check functions
function sysmac
    test (uname -s) = "Darwin"
end
function syslinux
    test (uname -s) = "Linux"
end
set -l is_ssh (who am i | grep -E '\([0-9.]+\)$')

# System Variables
set LC_CTYPE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
if [ -z "$TMPDIR" ]
    set -g TMPDIR /tmp
end

if test (which nvim)
    set -gx EDITOR nvim
	set -gx VISUAL nvim
    set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1
    set -x NVIM_TUI_ENABLE_TRUE_COLOR 1
	alias vimdiff="nvim -d"
	alias vi="nvim"
	alias vim="nvim"
else if test (which vim)
    set -gx EDITOR vim
else
    set -gx EDITOR vi
end

# GPG - Use yubikey for ssh auth
# To enable, put "set use_gpg 1" in your hosts config

if [ $use_gpg ]
    if type -q gpgconf 2>/dev/null
        set -x GPG_TTY (tty)
        set -gx SSH_AUTH_SOCK "$HOME/.gnupg/S.gpg-agent.ssh"
        gpgconf --launch gpg-agent
    end
else
    set -ga fish_function_path "opt/dotFiles/config/fish/opt/fish-ssh-agent/functions"

    if type -q __ssh_agent_is_started
        # ssh agent
        if test -z "$SSH_ENV"
            set -xg SSH_ENV $HOME/.ssh/environment
        end

        if not __ssh_agent_is_started
            __ssh_agent_start
        end
    end
end

# Use dircolors
if type -q -f gdircolors 2>/dev/null
    eval (gdircolors -b $HOME/.dircolors -c )
end

# Colors
set -g fish_color_user green --bold
set -g fish_color_host red --bold

# Personal Helpers
test -e $FISH_DIR/abbreviations.fish; and source $FISH_DIR/abbreviations.fish
test -e $FISH_DIR/helpers.fish; and source $FISH_DIR/helpers.fish
test -e $FISH_DIR/tools.fish; and source $FISH_DIR/tools.fish

function fish_greeting -d "Greeting message on shell session start up"
    if [ $is_ssh ]
        set -l platform (uname -mrs)
        set -l uptime (uptime | sed 's/.*up \([^,]*\), .*/\1/')
        set -l users (w | sed '1,2d' | cut -f1 -d' ' | sort | uniq -c)
        echo -en $platform "up" $uptime"\n"
        echo -en $users "\n"
        ifconfig | grep inet | grep -v 127.0.0.1 | grep -v inet6 | sort -r
    end
end
