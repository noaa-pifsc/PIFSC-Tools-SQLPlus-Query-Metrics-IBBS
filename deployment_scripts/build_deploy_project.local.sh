#! /bin/sh

# load the project configuration script to set the runtime variable values
. ../docker/src/scripts/sh_script_config/project_deploy_config.sh

root_directory="/c"

# change directory to the working directory for the local scenario
cd $root_directory/docker/$project_path-local/docker

# build and execute the docker container for the local scenario
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build

# notify the user that the container has finished executing
echo "The docker container for the local scenario has finished executing"
