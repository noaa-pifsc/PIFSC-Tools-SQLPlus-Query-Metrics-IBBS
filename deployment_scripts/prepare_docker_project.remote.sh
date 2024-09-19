#! /bin/bash

# change directory to the folder this script is in to ensure the include .sh script reference is valid
cd "$(dirname "$0")"

# load the project configuration script to set the runtime variable values
. ../docker/src/scripts/sh_script_config/project_deploy_config.sh

# prompt the user for the preparation folder base directory
echo "Please specify the base directory that will be used for the preparation folder (where the docker container will be built and executed from - e.g. /c for Windows, /home/webd/docker for Linux)"
echo 
echo "Preparation Folder Base Directory: "

# define the base directory for the prepared working directory (the directory that will be used to build and execute the docker container)
read base_directory

# base_directory="/c"

#deployment script for remote scenario
echo "running remote scenario deployment script"

# construct the project folder name:
project_folder_name=$project_path"-remote"

# construct the full project path
full_project_path=$base_directory"/docker/"$project_folder_name"/docker/src"

mkdir $base_directory/docker
rm -rf $base_directory/docker/$project_folder_name
mkdir $base_directory/docker/$project_folder_name

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone  $git_url $base_directory/docker/$project_folder_name

echo "rename configuration files"

#rename the query_metrics_calling_script.remote.sql to query_metrics_calling_script.sql so it can be used as the active configuration file
mv $full_project_path/SQL/query_metrics_calling_script.remote.sql $full_project_path/SQL/query_metrics_calling_script.sql

# remove the local and hybrid scripts
rm $full_project_path/SQL/query_metrics_calling_script.local.sql

rm $full_project_path/SQL/query_metrics_calling_script.hybrid.sql

#rename the remote oracle configuration file to be the active configuration file
mv $full_project_path/oracle_configuration/tnsnames.remote.ora $full_project_path/oracle_configuration/tnsnames.ora

# remove the local and hybrid oracle configuration files
rm $full_project_path/oracle_configuration/tnsnames.local.ora

rm $full_project_path/oracle_configuration/tnsnames.hybrid.ora


#rename the project_scenario_config.remote.sh to project_scenario_config.sh so it can be used as the active configuration file
mv $full_project_path/scripts/sh_script_config/project_scenario_config.remote.sh $full_project_path/scripts/sh_script_config/project_scenario_config.sh

# remove the local and hybrid scripts
rm $full_project_path/scripts/sh_script_config/project_scenario_config.local.sh

rm $full_project_path/scripts/sh_script_config/project_scenario_config.hybrid.sh

# remove the preparation scripts:
rm $base_directory"/docker/"$project_folder_name"/deployment_scripts/prepare_docker_project.local.sh"
rm $base_directory"/docker/"$project_folder_name"/deployment_scripts/prepare_docker_project.hybrid.sh"
rm $base_directory"/docker/"$project_folder_name"/deployment_scripts/prepare_docker_project.remote.sh"

echo ""
echo "the remote docker project files are now ready for configuration and image building/deployment"

read
