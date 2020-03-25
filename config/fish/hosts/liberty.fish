# Path
set -ga PATH ~/opt/scripts
set -ga fish_function_path "opt/dotFiles/config/fish/opt/fish-ssh-agent/functions"

#set VIRTUAL_ENV_DISABLE_PROMPT 1
#. ~/opt/user_venv/bin/activate.fish

abbr -a pbpull copy.sh from wrangler
abbr -a pbpush copy.sh to wrangler

abbr -a pip2 /Users/askobayashi/Library/Python/2.7/bin/pip
