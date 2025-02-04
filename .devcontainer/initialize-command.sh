#!/bin/bash

repo_root="$(realpath $(git rev-parse --show-toplevel))"

if [ ! -f ~/.gitconfig ]; then
    touch ~/.gitconfig && echo "Creation of .gitconfig file succesfull!" || { echo "Creation of .gitconfig file failed!"; exit -1; }
else
	echo ".gitconfig file already exists under /home/$(whoami)"
fi

## create credentials file in case [credential] helper = store '--file=/home/<user>/mycredentials' is configured in .gitconfig
if [ ! -f ~/mycredentials ]; then
    touch ~/mycredentials && echo "Creation of mycredentials file succesfull!" || { echo "Creation of mycredentials file failed!"; exit -1; }
else
	echo "mycredentials file already exists under /home/$(whoami)"
fi

env_path="$repo_root/.env"
SOURCE_COMMAND="source $env_path"
touch "$env_path"
## Update configuration file
cat <<EOT >"$env_path"
export CONTAINER_USER=$(whoami)
export CONTAINER_UID=$(id -u)
export CONTAINER_GID=$(id -g)
EOT
exit 0