#! /bin/sh

#deployment script for hybrid scenario

echo "running hybrid scenario deployment script"

root_directory="/c"

mkdir $root_directory/docker
rm -rf $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid
mkdir $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone git@picgitlab.nmfs.local:query-metrics/sqlplus-query-metrics-ibbs.git $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid

echo "rename configuration files"

#rename the app_instance_config.dev.php to app_instance_config.php so it can be used as the active configuration file
mv $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid/docker/src/SQL/query_metrics_calling_script.hybrid.sql $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid/docker/src/SQL/query_metrics_calling_script.sql

# remove the local and remote scripts
rm $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid/docker/src/SQL/query_metrics_calling_script.local.sql

rm $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid/docker/src/SQL/query_metrics_calling_script.remote.sql

#rename the hybrid oracle configuration file to be the active configuration file
mv $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid/docker/src/oracle_configuration/tnsnames.hybrid.ora $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid/docker/src/oracle_configuration/tnsnames.ora

# remove the local and remote oracle configuration files
rm $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid/docker/src/oracle_configuration/tnsnames.local.ora

rm $root_directory/docker/sqlplus-query-metrics-ibbs-hybrid/docker/src/oracle_configuration/tnsnames.remote.ora

echo ""
echo "the remote docker project files are now ready for configuration and image building/deployment"

read
