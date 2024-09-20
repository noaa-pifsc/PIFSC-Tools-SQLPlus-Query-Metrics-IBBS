#! /bin/bash


#deployment script for remote scenario
echo "running remote scenario deployment script"




# check if the base_docker_directory environment variable has been defined
if [[ -z "${base_docker_directory}" ]]; then
	# the base_docker_directory environment variable has not been defined

	# prompt the user for the preparation folder base directory
	echo "A \$base_docker_directory environment variable has not been defined."
	echo "You must specify the base directory as an environment variable that will be used for the preparation folder (where the docker container will be built and executed from - e.g. /c/docker for Windows, /home/webd/docker for Linux)"

	# define the base directory for the prepared working directory (the directory that will be used to build and execute the docker container)
	read base_docker_directory

fi 
# the value of $base_docker_directory is defined, proceed with the preparation script

echo "the value of \$base_docker_directory is defined, the docker container will be prepared for execution"


# change directory to the folder this script is in to ensure the include .sh script reference is valid
cd "$(dirname "$0")"

# load the project configuration script to set the runtime variable values
. ../docker/src/scripts/sh_script_config/project_deploy_config.sh



# construct the project folder name:
project_folder_name=$project_path"-remote"

# construct the full project path
full_project_path=$base_docker_directory"/"$project_folder_name"/docker/src"

# create the base directory
mkdir -p $base_docker_directory

#remove any files already in the $project_folder_name
rm -rf $base_docker_directory/$project_folder_name

# create the $project_folder_name
mkdir $base_docker_directory/$project_folder_name

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone  $git_url $base_docker_directory/$project_folder_name

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

# remove the remote and hybrid scripts
rm $full_project_path/scripts/sh_script_config/project_scenario_config.local.sh

rm $full_project_path/scripts/sh_script_config/project_scenario_config.hybrid.sh

# remove the preparation scripts:
rm $base_docker_directory"/"$project_folder_name"/deployment_scripts/prepare_docker_project.local.sh"
rm $base_docker_directory"/"$project_folder_name"/deployment_scripts/prepare_docker_project.hybrid.sh"
rm $base_docker_directory"/"$project_folder_name"/deployment_scripts/prepare_docker_project.remote.sh"

echo ""
echo "the remote docker project files are now ready for configuration and image building/deployment (press Enter key to continue)"

read
