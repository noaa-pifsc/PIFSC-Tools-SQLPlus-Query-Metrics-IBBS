# SQLPlus Query Metrics - IBBS

## Overview
This project was developed to provide an automated method to capture performance metrics for a suite of Oracle queries using a docker container to execute them with SQL\*Plus.  This project provides a method to capture query metrics in a variety of configurations for flexibility and allows a user to define multiple queries and define the SQL\*Plus connection string to determine which Oracle database instance to execute the queries on.  This project is forked from the [SQLPlus Query Metrics project](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics).

## Resources
-   SQLPlus Query Metrics - IBBS Version Control Information:
    -   URL: https://github.com/noaa-pifsc/PIFSC-Tools-SQLPlus-Query-Metrics-IBBS.git
    -   Version: 1.3 (Git tag: ibbs_sqlplus_query_metrics_v1.3)
    -   Forked repository (upstream)
        -   [SQLPlus Query Metrics README](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics/blob/main/README.md)
        -   SQLPlus Query Metrics Version Control Information:
            -   URL: git@github.com:noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics.git
            -   Version: 1.2 (Git tag: sqlplus_query_metrics_v1.2)
-   [Detailed/Summary performance metrics](https://docs.google.com/spreadsheets/d/1iMsI3dJOpzyzH0t-DAYBUajPaK2hxfE4/edit?usp=drive_link&ouid=107579489323446884981&rtpof=true&sd=true)
    -   The local/hybrid projects were configured to run on an hourly basis each weekday for 12 hours (from 7 AM to 7 PM HST)
    -   The [ibbs-query-metrics tab](https://docs.google.com/spreadsheets/d/1iMsI3dJOpzyzH0t-DAYBUajPaK2hxfE4/edit?gid=2040068626#gid=2040068626) contains the detailed information for each query that was executed and the corresponding metrics that were captured
    -   The [Summary tab](https://docs.google.com/spreadsheets/d/1iMsI3dJOpzyzH0t-DAYBUajPaK2hxfE4/edit?gid=1385076456#gid=1385076456) contains the summarized information with comparisons between the different scenarios

## Scenarios
-   There are three different scenarios implemented by the docker project:
    -   Local - this scenario deploys the docker container to a local docker host and connects to a local Oracle database
    -   Remote - this scenario deploys the docker container to a remote docker host and connects to a remote Oracle database
    -   Hybrid - this scenario deploys the docker container to a local docker host and connects to a remote Oracle database

## Setup Procedure
-   ### Database Setup
    -   Create a testing schema that will be used to access and capture database performance metrics for the IBBS database
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
            # execute the preparation script (in this example the remote scenario):
            bash ./PIFSC-Tools-SQLPlus-Query-Metrics-IBBS/deployment_scripts/prepare_docker_project.remote.sh
            ```
        -   press the "Enter" key to dismiss the bash script message 
    -   #### Specify the DB credentials
        -   In the preparation folder update the DB_credentials.sql file to specify the Oracle SQL\*Plus database connection string (e.g. **$base_docker_directory**/sqlplus-query-metrics-ibbs-remote/docker/src/SQL/credentials/DB_credentials.sql for the remote scenario)
        -   The code below is used for the remote scenario:
            ```
            vim $base_docker_directory/sqlplus-query-metrics-ibbs-remote/docker/src/SQL/credentials/DB_credentials.sql
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
            -   For example use the [prepare_docker_project.remote.sh](./deployment_scripts/prepare_docker_project.remote.sh) bash script to prepare the docker container for deployment in the remote scenario
        -   When prompted specify the base directory where the project will be prepared (e.g. /c/docker for Windows), this will set the value of **$base_docker_directory** used within the preparation script
        -   The preparation script will clone the project into a new preparation folder based on the value of **$base_docker_directory** (e.g. **$base_docker_directory**/sqlplus-query-metrics-ibbs-remote preparation folder for the remote scenario) and configure the docker project
        -   This preparation folder will be used to build and execute the docker container
    -   #### Specify the DB credentials
        -   In the preparation folder update the DB_credentials.sql file to specify the Oracle SQL\*Plus database connection string (e.g. **$base_docker_directory**/sqlplus-query-metrics-ibbs-remote/docker/src/SQL/credentials/DB_credentials.sql for the remote scenario)
-   \*Note: more information about the setup procedure for this forked project is available in the [SQLPlus Query Metrics README](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics?tab=readme-ov-file#forked-repository-implementation)

## Building/Running Container
-   In the preparation folder execute the appropriate build and deploy script for the given scenario
    -   ### Linux
        -   On Linux this bash script can be used to automate the execution of the docker container on a timer using cron
            ```
            # execute the build/deploy script (in this example the remote scenario)
            bash $base_docker_directory/sqlplus-query-metrics-ibbs-remote/deployment_scripts/build_deploy_project.sh
            ```
    -   ### Windows
        -   On Windows the batch script can be used to automate the execution of the docker container on a timer using Scheduled Tasks (e.g. **$base_docker_directory**/sqlplus-query-metrics-ibbs-remote/deployment_scripts/build_deploy_project.bat for the remote scenario)

## Docker Application Processing
-   \*Note: more information about the docker application processing for this forked project is available in the [SQLPlus Query Metrics README](https://github.com/noaa-pifsc/PIFSC-Tools-SqlPlus-Query-Metrics?tab=readme-ov-file#docker-application-processing)

## Checking Results
-   Open the docker volume sqlplus-query-metrics-ibbs-logs to view the log files for the different executions of the docker container
-   Open the docker volume sqlplus-query-metrics-ibbs-data to view the exported data files for the different queries
    -   Open the ibbs-query-metrics.csv to view the metrics that were captured for each query execution
    -   Open the .csv files in the query_results folder to view the results of each query

## License
See the [LICENSE.md](./LICENSE.md) for details

## Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
