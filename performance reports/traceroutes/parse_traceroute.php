<?php


	//read all .log files in the directory and generate .csv files for each of them
		//should we try to combine them all or set a column based on the name of the file prefix?
		
		//maybe parse each of the "." pieces of the string and add as columns?
		//e.g. pacific-vpn (network), remote (scenario) then it can all be combined in a single file
	
	
	

//	$filename = 'pacific-vpn.remote_traceroute.20241011.log';


	//construct the .csv file:
	
	$csv_content="\"Scenario\",\"Network\",\"Destination\",\"Start Date/Time (UTC)\",\"End Date/Time (UTC)\",\"# of hops\",\"RTT Attempt 1 (ms)\",\"RTT Attempt 2 (ms)\",\"RTT Attempt 3 (ms)\"";

	if ($handle = opendir('.')) 
	{
		
		echo "The current directory has been opened successfully\n";
		
		while (false !== ($filename = readdir($handle))) {

			echo "The current filename is: $filename\n";


			//parse the network and scenario 
			if (preg_match('/([a-zA-Z\-]+)\.([a-zA-Z]+)\_traceroute\.[0-9]+\.log/', $filename, $matches))
			{
				
				echo "The current filename is a traceroute log file\n";
				$v_data = file_get_contents($filename);


				echo "The value of $matches is: ".var_export($matches, true)."\n";
				$network = $matches[1];
				$scenario = $matches[2];
				
				while (strlen($v_data) > 0)
			//	for ($i = 0; $i < 2; $i++)
				{
					if (preg_match('/[0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM) \(UTC\) \- Traceroute has ended/', $v_data, $matches, PREG_OFFSET_CAPTURE))
					{

			//			echo var_export($matches);

						$temp_match = substr($v_data, 0, ($total_offset = strlen($matches[0][0])+$matches[0][1]));
						
						echo "The value of \$temp_match is: ".$temp_match."\n";
						
						
						//extract the values:
						
							//start date/time (UTC)
							//end date/time (UTC)
							//the last three numeric values in ms
							//IP address it was sent to
						
					
			//			preg_match('/([0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM)) \(UTC\) \- Start the traceroute.+traceroute to ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).+[0-9]{1,}.+([0-9]+\.[0-9]+ ms).+([0-9]+\.[0-9]+ ms).+([0-9]+\.[0-9]+ ms).([0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM)) \(UTC\) \- Traceroute has ended/s', $temp_match, $matches);

						preg_match('/([0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM)) \(UTC\) \- Start the traceroute.+traceroute to ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|[a-zA-Z0-9\.]+).+\ +([0-9]{1,})\ +[0-9a-zA-Z\(\. ]+\)\ +([0-9]+\.[0-9]+\ ms|\*)\ +([0-9]+\.[0-9]+\ ms|\*)\ +([0-9]+\.[0-9]+\ ms|\*).([0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM)) \(UTC\) \- Traceroute has ended/s', $temp_match, $matches);

						echo "The value of the matches is: ".var_export($matches, true)."\n";

			//			preg_match('/([0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM)) \(UTC\) \- Start the traceroute.+traceroute to ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).+([0-9]{1,}) +([0-9]+\.[0-9]+ ms).+([0-9]+\.[0-9]+ ms).+([0-9]+\.[0-9]+ ms).+([0-9]{8} [0-9]{2}\:[0-9]{2}\:[0-9]{2} (AM|PM)) \(UTC\) \- Traceroute has ended/s', $temp_match, $matches);
						
			//			echo "The value of the matches is: ".var_export($matches, true)."\n";
							
						$csv_content.="\n\"".$scenario."\",\"".$network."\",\"".$matches[3]."\",\"".$matches[0]."\",\"".$matches[8]."\",\"".$matches[4]."\",\"".str_replace(" ms", "", $matches[5])."\",\"".str_replace(" ms", "", $matches[6])."\",\"".str_replace(" ms", "", $matches[7])."\"";
						
						
						
						
						
						
						$v_data = trim(substr($v_data, $total_offset));

			//			echo "The value of the modified \$v_data is: ".$v_data."\n";
						
						
						

					}		

					echo "The value of strlen(\$v_data) is: ".strlen($v_data)."\n";

				}
				
				//write the csv file:
				file_put_contents("parsed_traceroute_data.csv", $csv_content);


			}

		}
		closedir($handle);
	}


?>