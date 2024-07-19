#! /bin/sh

# load the project configuration script to set the runtime variable values
. ../docker/src/scripts/sh_script_config/project_deploy_config.sh

root_directory="/c"


echo "running docker project in: $root_directory/docker/$project_path-hybrid/docker"

# change directory to the working directory for the hybrid scenario
cd $root_directory/docker/$project_path-hybrid/docker

# build and execute the docker container for the hybrid scenario
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build

# notify the user that the container has finished executing
echo "The docker container for the hybrid scenario has finished executing"
