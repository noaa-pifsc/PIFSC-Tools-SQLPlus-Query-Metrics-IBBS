<?php

	//construct the .csv file header:
	$csv_content="\"Scenario\",\"Network\",\"Destination\",\"Start Date/Time (UTC)\",\"End Date/Time (UTC)\",\"# of hops\",\"RTT Attempt 1 (ms)\",\"RTT Attempt 2 (ms)\",\"RTT Attempt 3 (ms)\"";

	//open the current directory 
	if ($handle = opendir('.')) 
	{
		
//		echo "The current directory has been opened successfully\n";
		//read the directory and loop through the files 
		while (false !== ($filename = readdir($handle))) {
			//check the current file

			//check to see if the current file in the directory is a traceroute log file
			if (preg_match('/([a-zA-Z\-]+)\.([a-zA-Z]+)\_traceroute\.[0-9]+\.log/', $filename, $matches))
			{
				//the current file is a traceroute log file
				echo "the current file ($filename) in the directory is a traceroute log file\n";

				//load the traceroute log file's content
				$v_data = file_get_contents($filename);

				//parse the network and scenario from the traceroute log file name
				$network = $matches[1];
				$scenario = $matches[2];

				//loop through the traceroute log file until the whole file is parsed
				while (strlen($v_data) > 0)
				{
					//process the traceroute log file
					
					//find the end of the next traceroute command
					if (preg_match('/[0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM) \(UTC\) \- Traceroute has ended/', $v_data, $matches, PREG_OFFSET_CAPTURE))
					{
						//process the current traceroute command

						//extract the current traceroute command 
						$temp_match = substr($v_data, 0, ($total_offset = strlen($matches[0][0])+$matches[0][1]));

						//parse the current traceroute command to extract the statistics
						preg_match('/([0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM)) \(UTC\) \- Start the traceroute.+traceroute to ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|[a-zA-Z0-9\.]+).+\ +([0-9]{1,})\ +[0-9a-zA-Z\(\. ]+\)\ +([0-9]+\.[0-9]+\ ms|\*)\ +([0-9]+\.[0-9]+\ ms|\*)\ +([0-9]+\.[0-9]+\ ms|\*).([0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM)) \(UTC\) \- Traceroute has ended/s', $temp_match, $matches);

						//generate a csv file row with the current traceroute command statistics
						$csv_content.="\n\"".$scenario."\",\"".$network."\",\"".$matches[3]."\",\"".$matches[1]."\",\"".$matches[8]."\",\"".$matches[4]."\",\"".str_replace(" ms", "", $matches[5])."\",\"".str_replace(" ms", "", $matches[6])."\",\"".str_replace(" ms", "", $matches[7])."\"";
						
						//remove the current traceroute command from the $v_data variable so the next command can be processed
						$v_data = trim(substr($v_data, $total_offset));
					}
				}
				
				echo "the current traceroute log file ($filename) has been processed\n";
			}
		}

		echo "write the .csv file to the file system\n";

		//write the csv file:
		file_put_contents("parsed_traceroute_data.csv", $csv_content);

		//close the directory handle
		closedir($handle);
	}


?>