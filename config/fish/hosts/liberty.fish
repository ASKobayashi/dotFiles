# Path
set -ga PATH ~/opt/scripts
set -ga fish_function_path "opt/dotFiles/config/fish/opt/fish-ssh-agent/functions"

# # ssh agent
# if test -z "$SSH_ENV"
#     set -xg SSH_ENV $HOME/.ssh/environment
# end
#
# if not __ssh_agent_is_started
#     __ssh_agent_start
# end


