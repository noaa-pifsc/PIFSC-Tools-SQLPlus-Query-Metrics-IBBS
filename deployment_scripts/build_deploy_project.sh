#! /bin/sh

# change directory to the folder this script is in to ensure the include .sh script reference is valid
cd "$(dirname "$0")"

# load the project configuration script to set the runtime variable values
. ../docker/src/scripts/sh_script_config/project_deploy_config.sh

# change directory to the working directory
cd ../docker

# check if this is windows or linux
if [[ "$OSTYPE" == "msys" ]]; then
	#this is windows, don't include the sudo command

	# build and execute the docker container for the current scenario
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build

else
	# this is linux, include the sudo command:

	# build and execute the docker container for the current scenario
	sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build

fi

# notify the user that the container has finished executing
echo "The docker container has finished building and is running"
