#!/usr/bin/bash

# load the project configuration script to set the runtime variable values
. ../scripts/sh_script_config/project_runtime_config.sh
. ../scripts/sh_script_config/project_scenario_config.sh



# check the location of the DB and container:

if [ "$database_location" = "local" ]  && [ "$container_location" = "local" ];
then
# local DB and container

echo "this is a local DB and container, run the local traceroute script in a loop"

# spawn the local traceroute script that runs in a loop
. ../scripts/traceroute_loop.sh $local_traceroute_destination "local" $traceroute_wait_in_s & 



elif [ "$database_location" = "remote" ]  && [ "$container_location" = "local" ];
then
# remote DB and local container


echo "this is a remote DB and local container, run the local traceroute script once and then run the remote traceroute in a loop"

# spawn the local traceroute script that runs in a loop
. ../scripts/traceroute_loop.sh $local_traceroute_destination "local" $traceroute_wait_in_s &



# spawn the remote traceroute script that runs in a loop
. ../scripts/traceroute_loop.sh $remote_traceroute_destination "remote" $traceroute_wait_in_s &


else
# remote DB and container

echo "this is a remote DB and container, run the local traceroute script in a loop"

# spawn the local traceroute script that runs in a loop
. ../scripts/traceroute_loop.sh $remote_traceroute_destination "remote" $traceroute_wait_in_s &


fi 




# copy the Oracle configuration files into the Oracle configuration directory
ORACLE_CONFIG_PATH=`find / -regex '/usr/lib/oracle/[0-9]+\.[0-9]+/client64/lib/network/admin'`
cp ../oracle_configuration/* ${ORACLE_CONFIG_PATH}

# check if the .csv metrics file already exists, if not create it with the appropriate headers:
if ! test -f ../data_exports/$csv_output_file_name; then
	# the file does not exist, create it:
	echo "\"DB Name\",\"DB Location\",\"App Location\",\"Query Name\",\"Date/Time\",\"Cost\",\"# Rows\",\"SQL\",\"Response Time (s)\",\"Result Set Size (bytes)\"" > ../data_exports/$csv_output_file_name

fi

# read the automated_tests directory and loop through each .sql file:
for dir in ./automated_tests/*.sql; do (

# process the current sql file:
# echo "$dir"

# store the contents of the current sql file
value=$(<$dir)
# echo "$value"

# parse the filename from the file path
filename=$(basename $dir)

# store the filename without the file extension
filename="${filename%.*}"

# store the filename with the date/time
# filename_w_date_time=$filename$(date "+_%Y-%m-%d_%H.%M.%S")

# execute the sqlplus script for the current SQL file/query
eval "sqlplus /nolog @query_metrics_calling_script.sql \"$filename\" \"$value\""

filesize=$(ls -l ../data_exports/$filename.csv | awk '{print $5}')
# echo $filesize

# replace the [FILE_SIZE] placeholder with the actual size of the exported data file for the sqlplus query
sed -i -e "s/\[FILE_SIZE\]/$filesize/g" ../data_exports/$csv_output_file_name

); done


echo "The parent script has finished executing, kill the child process(es)"

# kill the child process
kill 0
