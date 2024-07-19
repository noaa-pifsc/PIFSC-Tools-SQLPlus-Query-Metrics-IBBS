#! /bin/sh

# load the project configuration script to set the runtime variable values
. ../docker/src/scripts/sh_script_config/project_deploy_config.sh

#deployment script for remote scenario

echo "running remote scenario deployment script"

root_directory="/c"

# construct the project folder name:
project_folder_name=$project_path"-remote"

# construct the full project path
full_project_path=$root_directory"/docker/"$project_folder_name"/docker/src"

mkdir $root_directory/docker
rm -rf $root_directory/docker/$project_folder_name
mkdir $root_directory/docker/$project_folder_name

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone  $git_url $root_directory/docker/$project_folder_name

echo "rename configuration files"

#rename the query_metrics_calling_script.remote.sql to query_metrics_calling_script.sql so it can be used as the active configuration file
mv $full_project_path/SQL/query_metrics_calling_script.remote.sql $full_project_path/SQL/query_metrics_calling_script.sql

# remove the local and hybrid scripts
rm $full_project_path/src/SQL/query_metrics_calling_script.local.sql

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


echo ""
echo "the remote docker project files are now ready for configuration and image building/deployment"

read
