#! /bin/bash

# load the project configuration script to set the runtime variable values
. ../docker/src/scripts/sh_script_config/project_deploy_config.sh

# determine the scenario by using the values in the variables $database_location and $container_location
if [[ "$database_location" == "local" ]] && [[ "$container_location" == "local" ]]; then
	# this is a local database and container, this is a local scenario

	# set the value of $testing_scenario to "local"
	testing_scenario="local"
	
	# define the inactive scenarios (the two that are not stored in $testing_scenario)
	inactive_scenarios=("hybrid" "remote")
	

elif [[ "$database_location" == "remote" ]] && [[ "$container_location" == "remote" ]]; then
	# this is a remote database and container, this is a remote scenario

	# set the value of $testing_scenario to "remote"
	testing_scenario="remote"

	# define the inactive scenarios (the two that are not stored in $testing_scenario)
	inactive_scenarios=("local" "hybrid")

else
	# this is a remote database and local container, this is a hybrid scenario
	
	# set the value of $testing_scenario to "hybrid"
	testing_scenario="hybrid"

	# define the inactive scenarios (the two that are not stored in $testing_scenario)
	inactive_scenarios=("local" "remote")
fi


#deployment script for local scenario
echo "running $testing_scenario scenario deployment script"

# check if the base_docker_directory environment variable has been defined
if [[ -z "${base_docker_directory}" ]]; then
	# the base_docker_directory environment variable has not been defined

	# prompt the user for the preparation folder base directory
	echo "A \$base_docker_directory environment variable has not been defined."
	echo "You must specify the base docker directory that will be used as the directory that builds and executes the container (e.g. /c/docker for Windows, /home/webd/docker for Linux)"
	echo 
	echo 
	echo "Specify the base docker directory: "

	# define the base directory for the prepared working directory (the directory that will be used to build and execute the docker container)
	read base_docker_directory

fi 
# the value of $base_docker_directory is defined, proceed with the preparation script

# echo "the value of \$base_docker_directory is \"$base_docker_directory\" that will be used to build and execute the docker container"


# construct the project folder name based on the configuration variables:
project_folder_name=$project_path"-"$testing_scenario

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

echo "rename corresponding configuration files to make them active"

#rename the query_metrics_calling_script.$testing_scenario.sql to query_metrics_calling_script.sql so it can be used as the active configuration file
mv $full_project_path/SQL/query_metrics_calling_script.$testing_scenario.sql $full_project_path/SQL/query_metrics_calling_script.sql

#rename the $testing_scenario oracle configuration file to be the active configuration file
mv $full_project_path/oracle_configuration/tnsnames.$testing_scenario.ora $full_project_path/oracle_configuration/tnsnames.ora

#rename the project_scenario_config.$testing_scenario.sh to project_scenario_config.sh so it can be used as the active configuration file
mv $full_project_path/scripts/sh_script_config/project_scenario_config.$testing_scenario.sh $full_project_path/scripts/sh_script_config/project_scenario_config.sh


echo "remove unused bash scripts based on the current testing scenario to prevent confusion"

# remove the main preparation bash script to prevent confusion
rm $base_docker_directory"/"$project_folder_name"/deployment_scripts/prepare_docker_project"*

# loop through the inactive scenarios and delete the corresponding configuration files and automated SQL scripts
for current_inactive_scenario in ${inactive_scenarios[@]}
do

#	echo "the current inactive scenario is: $current_inactive_scenario"

	# remove the current inactive scenario's query calling script
	rm $full_project_path"/SQL/query_metrics_calling_script."$current_inactive_scenario".sql"


	# remove the current inactive scenario's oracle configuration files
	rm $full_project_path"/oracle_configuration/tnsnames."$current_inactive_scenario".ora"

	# remove the current inactive scenario's bash configuration scripts
	rm $full_project_path"/scripts/sh_script_config/project_scenario_config."$current_inactive_scenario".sh"

done



echo ""
echo "the $testing_scenario docker project files are now ready for configuration and image building/deployment"
echo ""
echo ""
echo "press Enter key to continue"

read
