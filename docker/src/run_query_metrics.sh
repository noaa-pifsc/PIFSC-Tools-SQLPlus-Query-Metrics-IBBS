#!/usr/bin/bash

# load the project configuration script to set the runtime variable values
. ../sh_script_config/project_config.sh


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
filename_w_date_time=$filename$(date "+_%Y-%m-%d_%H.%M.%S")

# execute the sqlplus script for the current SQL file/query
eval "sqlplus /nolog @query_metrics_calling_script.sql \"$filename\" \"$filename_w_date_time\" \"$value\""

filesize=$(ls -l ../data_exports/$filename_w_date_time.csv | awk '{print $5}')
# echo $filesize

# replace the [FILE_SIZE] placeholder with the actual size of the exported data file for the sqlplus query
sed -i -e "s/\[FILE_SIZE\]/$filesize/g" ../data_exports/$csv_output_file_name

); done
