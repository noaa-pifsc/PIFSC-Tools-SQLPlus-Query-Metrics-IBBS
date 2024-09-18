# Demonstration Outline

## Overview
This document defines a demonstration outline for the SQLPlus Query Tests project.  

## Outline
-   Show the [README](https://picgitlab.nmfs.local/centralized-data-tools/sqlplus-query-metrics/-/tree/main?ref_type=heads)
-   Walk through the [setup process](https://picgitlab.nmfs.local/centralized-data-tools/sqlplus-query-metrics/-/tree/main?ref_type=heads#setup-procedure)
    -   The setup is easy to do, clone the project, update the credentials file for the target DB instance/schema, define the queries in separate .sql files in the designated directory
-   Show how to build and run the container
-   Check the results
    -   Explore the volume using Docker Desktop
    -   Download the log from the log volume to view the information that is logged
    -   Download an example of the exported data (spooled using SQL*Plus)
    -   Download the query-metrics.csv file from the data volume and show the information is logged each time, response time is measured in thousands of a second.
