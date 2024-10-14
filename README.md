# SQL\*Plus Query Metrics - IBBS

## Overview
This SQL\*Plus Query Metrics (SQM) International Billfish Biosampling System (IBBS) project was developed to provide an automated method to capture performance metrics for a suite of Oracle queries using a docker container to execute them with SQL\*Plus for the IBBS database.  This project provides a method to capture query metrics in a variety of configurations for flexibility and allows a user to define multiple queries and define the SQL\*Plus connection string to determine which Oracle database instance to execute the queries on.  This project is forked from the [SQM project](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics).

## Resources
-   SQM IBBS Version Control Information:
    -   URL: https://github.com/noaa-pifsc/PIFSC-Tools-SQLPlus-Query-Metrics-IBBS.git
    -   Version: 1.4 (Git tag: ibbs_sqlplus_query_metrics_v1.4)
    -   Forked repository (upstream)
        -   [SQM README](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics/blob/main/README.md)
        -   SQM Version Control Information:
            -   URL: git@github.com:noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics.git
            -   Version: 1.2 (Git tag: sqlplus_query_metrics_v1.2)
-   [Detailed/Summary performance metrics](https://docs.google.com/spreadsheets/d/1iMsI3dJOpzyzH0t-DAYBUajPaK2hxfE4/edit?usp=drive_link&ouid=107579489323446884981&rtpof=true&sd=true)
    -   During the testing window the local/hybrid projects were configured to run on an hourly basis each weekday for 12 hours (from 7 AM to 7 PM HST)
    -   The [ibbs-query-metrics tab](https://docs.google.com/spreadsheets/d/1iMsI3dJOpzyzH0t-DAYBUajPaK2hxfE4/edit?gid=2040068626#gid=2040068626) contains the detailed information for each query that was executed and the corresponding metrics that were captured
    -   The [Summary tab](https://docs.google.com/spreadsheets/d/1iMsI3dJOpzyzH0t-DAYBUajPaK2hxfE4/edit?gid=1385076456#gid=1385076456) contains the summarized information with comparisons between the different scenarios

## Scenarios
-   There are multiple scenarios implemented by the docker project:
    -   Local - this scenario deploys the docker container to a local docker host and connects to a local Oracle database in the following network configurations:
        -   PIFSC Ethernet
        -   Pacific VPN
    -   Remote - this scenario deploys the docker container to a remote docker host and connects to a remote Oracle database in the following network configurations:
        -   FishSTOC network
    -   Hybrid - this scenario deploys the docker container to a local docker host and connects to a remote Oracle database in the following network configurations:
        -   PIFSC Ethernet
        -   Pacific VPN
        -   East Coast VPN
        -   West Coast VPN
-   Each scenario has its own set of files used to specify the configuration during the [preparation process](#prepare-the-docker-container)
    -   Configuration files:
        -   Bash script configuration (e.g. [project_scenario_config.pifsc-ethernet.local.sh](./docker/src/scripts/sh_script_config/project_scenario_config.pifsc-ethernet.local.sh) for the PIFSC Ethernet network/local database scenario)
        -   SQLPlus configuration (e.g. [scenario_config.pacific-vpn.hybrid.sql](./docker/src/SQL/sqlplus_config/scenario_config.pacific-vpn.hybrid.sql) for the Pacific VPN network/hybrid scenario)
    -   deployment script (e.g. [prepare_docker_project.fishstoc.remote.sh](./deployment_scripts/prepare_docker_project.fishstoc.remote.sh) for the FishSTOC network/remote database scenario)
        -   The deployment script prepares the working directory for the docker container and renames the corresponding configuration files to make them active

## Setup Procedure
-   ### Database Setup
    -   Create a testing schema on the S&T FishSTOC test database instance that will be used to access and capture database performance metrics for the IBBS database
    -   Grant the new testing schema the IBBS_READ_ROLE;
    ```
    -- replace [TEST_SCHEMA_NAME] with the actual name of the testing schema:
    GRANT [TEST_SCHEMA_NAME] IBBS_READ_ROLE;
    ```
-   ### Linux
    -   #### Clone the repository
        ```
        # clone the repository into a working directory that will be used to prepare the container for execution:
        git clone https://github.com/noaa-pifsc/PIFSC-Tools-SQLPlus-Query-Metrics-IBBS.git
        ```
    -   #### Prepare the docker container
        -   Set the \$base_docker_directory bash/environment variables to define the base directory location where the docker application will be built and executed
            ```
            # define the $base_docker_directory variable (e.g. /home/webd/docker) to make it easy to execute the preparation and deployment bash scripts:
            base_docker_directory="[PATH TO PREPARATION FOLDER]"

            # define the value of $base_docker_directory as an environment variable
            export base_docker_directory
            ```
        -   Execute the preparation bash script:
            ```
            # execute the preparation script (in this example the FishSTOC network/remote database scenario):
            bash ./PIFSC-Tools-SQLPlus-Query-Metrics-IBBS/deployment_scripts/prepare_docker_project.fishstoc.remote.sh
            ```
        -   press the "Enter" key to dismiss the bash script message
    -   #### Specify the DB credentials
        -   In the preparation folder update the DB_credentials.sql file to specify the Oracle SQL\*Plus database connection string (e.g. **$base_docker_directory**/sqlplus-query-metrics-ibbs-fishstoc-remote/docker/src/SQL/credentials/DB_credentials.sql for the FishSTOC network/remote database scenario)
        -   The code below is used for the remote scenario:
            ```
            vim $base_docker_directory/sqlplus-query-metrics-ibbs-fishstoc-remote/docker/src/SQL/credentials/DB_credentials.sql
            ```
-   ### Windows
    -   #### Clone the repository
        ```
        # clone the repository into a working directory that will be used to prepare the container for execution:
        git clone https://github.com/noaa-pifsc/PIFSC-Tools-SQLPlus-Query-Metrics-IBBS.git
        ```
        -   \*Note: The links in this documentation will work if you are viewing this README from the working directory
    -   #### Prepare the docker container
        -   Execute the appropriate docker preparation script stored in the [deployment_scripts](./deployment_scripts) folder to prepare the docker container for deployment in a new preparation folder
            -   For example use the [prepare_docker_project.fishstoc.remote.sh](./deployment_scripts/prepare_docker_project.fishstoc.remote.sh) bash script to prepare the docker container for deployment in the FishSTOC network/remote database scenario
        -   When prompted specify the base directory where the project will be prepared (e.g. /c/docker for Windows), this will set the value of **$base_docker_directory** used within the preparation script
        -   The preparation script will clone the project into a new preparation folder based on the value of **$base_docker_directory** (e.g. **$base_docker_directory**/sqlplus-query-metrics-ibbs-fishstoc-remote preparation folder for the FishSTOC network/remote database scenario) and configure the docker project
        -   This preparation folder will be used to build and execute the docker container
    -   #### Specify the DB credentials
        -   In the preparation folder update the DB_credentials.sql file to specify the Oracle SQL\*Plus database connection string (e.g. **$base_docker_directory**/sqlplus-query-metrics-ibbs-fishstoc-remote/docker/src/SQL/credentials/DB_credentials.sql for the FishSTOC network/remote database scenario)
-   \*Note: more information about the setup procedure for this forked project is available in the [SQM README](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics?tab=readme-ov-file#forked-repository-implementation)

## Building/Running Container
-   In the preparation folder execute the appropriate build and deploy script for the given scenario
    -   ### Linux
        -   On Linux this bash script can be used to automate the execution of the docker container on a timer using cron
            ```
            # execute the build/deploy script (in this example the FishSTOC network/remote database scenario)
            bash $base_docker_directory/sqlplus-query-metrics-ibbs-fishstoc-remote/deployment_scripts/build_deploy_project.sh
            ```
    -   ### Windows
        -   On Windows the batch script can be used to automate the execution of the docker container on a timer using Scheduled Tasks (e.g. **$base_docker_directory**/sqlplus-query-metrics-ibbs-fishstoc-remote/deployment_scripts/build_deploy_project.bat for the FishSTOC network/remote database scenario)

## Docker Application Processing
-   \*Note: more information about the docker application processing for this forked project is available in the [SQM README](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics?tab=readme-ov-file#docker-application-processing)

## Checking Results
-   Open the docker volume sqlplus-query-metrics-ibbs-logs to view the log files for the different executions of the docker container
    -   The log files will have the following names: query_metrics_log_YYYYMMDD.log with the date in the UTC timezone (e.g. query_metrics_log_20241007.log for a script that began running on 10/7/2024 in the UTC timezone)
    -   There are one or more separate traceroute logs depending on the scenario
        -   For example when the Pacific VPN network/hybrid scenario the pacific-vpn.local_traceroute.log and pacific-vpn.remote_traceroute.log files will contain the results of the corresponding traceroute scripts
        -   For more information about the tracelog feature see the [SQM documentation](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics?tab=readme-ov-file#docker-application-processing)
    -   Summarize the traceroute data:
        -   Copy the traceroute files for each scenario from the docker volume (e.g. pacific-vpn.remote_traceroute.log for the Pacific VPN network and Remote scenario) into the [traceroutes](./performance%20reports/traceroutes) folder
        -   Execute the [parse_traceroute.php](./performance%20reports/traceroutes/parse_traceroute.php) script to generate a .csv file (parsed_traceroute_data.csv) that contains the information from each traceroute command.
            -   The [parse_traceroute.bat](./performance%20reports/traceroutes/parse_traceroute.bat) script can be executed on a Windows machine to execute the PHP script
        -   Open the parsed_traceroute_data.csv and [combined_traceroute_summary.xlsx](./performance%20reports/traceroutes/combined_traceroute_summary.xlsx) excel file, copy the data from parsed_traceroute_data.csv into the "traceroute data" worksheet and view the summary information in the "Summary" worksheet.
-   Open the docker volume sqlplus-query-metrics-ibbs-data to view the exported data files for the different queries
    -   Open the ibbs-query-metrics.csv to view the metrics that were captured for each query execution
        -   Summarize the performance metrics:
            -   Open the parsed_traceroute_data.csv and [ibbs-query-metrics-combined.xlsx](./performance%20reports/ibbs-query-metrics-combined.xlsx) excel file, copy the data from ibbs-query-metrics.csv into the "ibbs-query-metrics" worksheet and view the summary information in the "Summary" worksheet.
    -   Open the .csv files in the query_results folder to view the results of each query

## Standard Metrics/Information Logging
-   The following metrics and information is captured for each web action in a .csv file:
    -   DB Name - The name of the database (IBBS)
    -   DB Location - is the location of the database (local or remote)
    -   App Location - is the location of the SQM IBBS docker container (local or remote)
    -   Network - is the network configuration for the docker container (e.g. PIFSC Ethernet, FishSTOC, Pacific VPN, etc.)
    -   Date/Time (UTC) - The Date/Time the given SQL query test was started in the UTC time zone in MM/DD/YYYY HH:MI:SS AM/PM format
    -   Date/Time (HST) - The Date/Time the given SQL query test was started in the Hawaii Standard time zone in MM/DD/YYYY HH:MI:SS AM/PM format
    -   Cost - The cost of the given SQL query as calculated on the corresponding database instance
    -   \# Rows - The total number of rows returned by the given SQL query
    -   SQL - The SQL query that is executed on the given database instance
    -   Response Time (s) - The total number of seconds elapsed between when the SQL query is sent to the given database instance and when the result set is finished downloading
    -   Result Set Size (bytes) - the total size, in bytes, for the result set downloaded from the given database instance

## License
See the [LICENSE.md](./LICENSE.md) for details

## Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
