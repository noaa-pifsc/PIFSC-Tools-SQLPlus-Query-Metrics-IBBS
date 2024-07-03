#! /bin/sh

# load the project configuration script to set the runtime variable values
. ../docker/src/sh_script_config/project_config.sh

#deployment script for local scenario

echo "running local scenario deployment script"

root_directory="/c"

mkdir $root_directory/docker
rm -rf $root_directory/docker/$project_path-local
mkdir $root_directory/docker/$project_path-local

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone $git_url $root_directory/docker/$project_path-local

echo "rename configuration files"

#rename the app_instance_config.dev.php to app_instance_config.php so it can be used as the active configuration file
mv $root_directory/docker/$project_path-local/docker/src/SQL/query_metrics_calling_script.local.sql $root_directory/docker/$project_path-local/docker/src/SQL/query_metrics_calling_script.sql

# remove the remote and hybrid scripts
rm $root_directory/docker/$project_path-local/docker/src/SQL/query_metrics_calling_script.remote.sql

rm $root_directory/docker/$project_path-local/docker/src/SQL/query_metrics_calling_script.hybrid.sql

#rename the local oracle configuration file to be the active configuration file
mv $root_directory/docker/$project_path-local/docker/src/oracle_configuration/tnsnames.local.ora $root_directory/docker/$project_path-local/docker/src/oracle_configuration/tnsnames.ora

# remove the remote and hybrid oracle configuration files
rm $root_directory/docker/$project_path-local/docker/src/oracle_configuration/tnsnames.remote.ora

rm $root_directory/docker/$project_path-local/docker/src/oracle_configuration/tnsnames.hybrid.ora


echo ""
echo "the local docker project files are now ready for configuration and image building/deployment"

read
