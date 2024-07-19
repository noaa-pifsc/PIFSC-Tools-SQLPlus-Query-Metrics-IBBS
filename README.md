# SQLPlus Query Metrics - IBBS

## Overview
This project was developed to provide an automated method to capture performance metrics for a suite of Oracle queries using a docker container to execute them with SQL\*Plus.  This project provides a method to capture query metrics in a variety of configurations for flexibility and allows a user to define multiple queries and define the SQL\*Plus connection string to determine which Oracle database instance to execute the queries on.  This project is forked from the [SQLPlus Query Metrics project](https://picgitlab.nmfs.local/centralized-data-tools/sqlplus-query-metrics).

## Resources
-   SQLPlus Query Metrics - IBBS Version Control Information:
    -   URL: git@picgitlab.nmfs.local:query-metrics/sqlplus-query-metrics-ibbs.git
    -   Version: 1.2 (Git tag: ibbs_sqlplus_query_metrics_v1.2)
    -   Forked repository (upstream)
        -   [SQLPlus Query Metrics README](https://picgitlab.nmfs.local/centralized-data-tools/sqlplus-query-metrics/-/blob/main/README.md?ref_type=heads)
        -   SQLPlus Query Metrics Version Control Information:
            -   URL: git@picgitlab.nmfs.local:centralized-data-tools/sqlplus-query-metrics.git
            -   Version: 1.2 (Git tag: sqlplus_query_metrics_v1.2)

## Scenarios
-   There are three different scenarios implemented by the docker project:
    -   Local - this scenario deploys the docker container to a local docker host and connects to a local Oracle database
    -   Remote - this scenario deploys the docker container to a remote docker host and connects to a remote Oracle database
    -   Hybrid - this scenario deploys the docker container to a local docker host and connects to a remote Oracle database

## Setup Procedure
-   Execute the appropriate docker preparation script stored in the [deployment_scripts](./deployment_scripts) folder to prepare the docker container for deployment in a new working directory
    -   For example use the [prepare_docker_project.local.sh](./deployment_scripts/prepare_docker_project.local.sh) bash script to prepare the Local docker container for deployment in the c:/docker/sqlplus-query-metrics-ibbs-local folder
-   Update the DB_credentials.sql file in the appropriate new working directory to specify the Oracle SQL*Plus database connection string (e.g. c:/docker/sqlplus-query-metrics-ibbs-local/docker/src/SQL/credentials/DB_credentials.sql) for the local scenario
-   \*Note: more information about the setup procedure for this forked project is available in the [SQLPlus Query Metrics README](https://picgitlab.nmfs.local/centralized-data-tools/sqlplus-query-metrics/-/blob/main/README.md?ref_type=heads#forked-repository-implementation)

## Building/Running Container
-   Execute the appropriate build and deploy script for the given scenario (e.g. [build_deploy_project.remote.sh](./deployment_scripts/build_deploy_project.remote.sh) for the remote scenario)

## Docker Application Processing
-   \*Note: more information about the docker application processing for this forked project is available in the [SQLPlus Query Metrics README](https://picgitlab.nmfs.local/centralized-data-tools/sqlplus-query-metrics/-/blob/main/README.md?ref_type=heads#docker-application-processing)

## Checking Results
-   Open the docker volume sqlplus-query-metrics-ibbs-logs to view the log files for the different executions of the docker container
-   Open the docker volume sqlplus-query-metrics-ibbs-data to view the exported data files for the different queries
    -   Open the ibbs-query-metrics.csv to view the metrics that were captured for each query execution
