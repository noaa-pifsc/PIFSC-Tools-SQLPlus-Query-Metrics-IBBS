#!/usr/bin/bash

# first argument is the desination database hostname/IP address for the traceroute command
# second argument is the location of the database (local or remote)
# third argument is the wait time in seconds between traceroute executions

# echo "running $2 traceroute loop calling code"

# process an infinite loop to run traceroute on the specified server until the parent process is finished executing
for ((i=1; ; ++i));
do
#    echo "running $2 traceroute for the $i time"
	. ../scripts/traceroute.sh $1 $2"_traceroute.log"

	# wait for $traceroute_wait_in_s seconds before looping again
	sleep $3;
done
