#!/bin/bash

# first argument is destination
# second argument is log file output

# add the newline character in case the previous command did not complete
echo "" >> ../logs/$2

# log the time that the traceroute started executing
echo $(date "+%Y%m%d %I:%M:%S %p")" - Start the traceroute">> ../logs/$2

# log the command used for the traceroute
echo "the command is traceroute -T -p 22 $1" >> ../logs/$2

# send the traceroute command and save it to the log file
traceroute -T -p 22 "$1" >> ../logs/$2

# log the time that the traceroute finished executing
echo $(date "+%Y%m%d %I:%M:%S %p")" - Traceroute has ended">> ../logs/$2

