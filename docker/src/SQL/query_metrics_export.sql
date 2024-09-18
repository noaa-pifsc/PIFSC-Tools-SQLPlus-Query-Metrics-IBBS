--SET ECHO ON;
SET SERVEROUTPUT ON;

--define the columns for the current date and date/time in UTC
COLUMN CURRENT_DATE_UTC new_value V_CURRENT_DATE_UTC
COLUMN CURRENT_DATE_TIME_UTC new_value V_CURRENT_DATE_TIME_UTC

--retrieve the current date and date/time
SELECT to_char(CAST(CURRENT_TIMESTAMP AT TIME ZONE 'UTC' as date), 'YYYYMMDD') AS CURRENT_DATE_UTC, to_char(CAST(CURRENT_TIMESTAMP AT TIME ZONE 'UTC' as date), 'YYYYMMDD HH:MI:SS AM') AS CURRENT_DATE_TIME_UTC from dual;

DEFINE V_LOG_FILE_NAME = query_metrics_log_&V_CURRENT_DATE_UTC..log;


SET ECHO OFF;

SET DEFINE ON;
--add a logging message:

SET TERMOUT ON;

--log the information for the current query
SPOOL ../logs/&V_LOG_FILE_NAME append;
PROMPT &V_CURRENT_DATE_TIME_UTC. - Connected as &_USER
PROMPT &V_CURRENT_DATE_TIME_UTC. - **Note: All dates/times shown are in UTC unless specified otherwise
PROMPT &V_CURRENT_DATE_TIME_UTC. - Running the SQLPlus Tests using the Database "&V_DB_NAME." from the application location "&V_APP_LOCATION_NAME." and DB location "&V_DB_LOCATION_NAME."
PROMPT &V_CURRENT_DATE_TIME_UTC. - Retrieve the query metrics data for the query &1.
SPOOL OFF;



SET TERMOUT OFF;


--retrieve the current timestamp
SELECT to_char(CAST(CURRENT_TIMESTAMP AT TIME ZONE 'UTC' as date), 'YYYYMMDD HH:MI:SS AM') AS CURRENT_DATE_TIME_UTC from dual;
SET TERMOUT ON;

SPOOL ../logs/&V_LOG_FILE_NAME append;
PROMPT &V_CURRENT_DATE_TIME_UTC. - Generate the metrics queries from the specified query
SPOOL OFF;

SET TERMOUT OFF;

--create temporary files based on the substitution variable value:

--create the script to execute the specified query from the second parameter
SPOOL ./temp_export_query.sql;

	PROMPT &2.;;

SPOOL OFF;


--create the script to retrieve the total number of records returned by the specified query from the second parameter
SPOOL ./temp_count_query.sql;

	PROMPT SELECT COUNT(*) AS NUM_ROWS FROM (&2.);;

SPOOL OFF;


--create the script to explain the specified query from the second parameter
SPOOL ./temp_explain_query.sql;

	PROMPT EXPLAIN PLAN FOR &2.;;

SPOOL OFF;

SET ECHO OFF;



--retrieve the current timestamp
COLUMN NUM_ROWS new_value V_NUM_ROWS
COLUMN START_TIMESTAMP new_value V_START_TIMESTAMP
COLUMN START_DATE_TIME_UTC new_value V_START_DATE_TIME_UTC
COLUMN START_DATE_TIME_HST new_value V_START_DATE_TIME_HST


--retrieve the current timestamp
SELECT to_char(CAST(CURRENT_TIMESTAMP AT TIME ZONE 'UTC' as date), 'YYYYMMDD HH:MI:SS AM') AS CURRENT_DATE_TIME_UTC from dual;
SET TERMOUT ON;

--log that the count(*) query is being executed
SPOOL ../logs/&V_LOG_FILE_NAME append;
PROMPT &V_CURRENT_DATE_TIME_UTC. - retrieve the number of rows returned by the specified query
SPOOL OFF;

SET TERMOUT OFF;

--execute the COUNT(*) query to retrieve the number of rows from the query
START ./temp_count_query.sql;

--retrieve the current timestamp
SELECT to_char(CAST(CURRENT_TIMESTAMP AT TIME ZONE 'UTC' as date), 'YYYYMMDD HH:MI:SS AM') AS CURRENT_DATE_TIME_UTC from dual;
SET TERMOUT ON;

--log that the explain plan query is being executed
SPOOL ../logs/&V_LOG_FILE_NAME append;
PROMPT &V_CURRENT_DATE_TIME_UTC. - retrieve the explain plan from the query
SPOOL OFF;

SET TERMOUT OFF;


--clear the plan_table table
DELETE FROM PLAN_TABLE;


--generate the explain plan for the query:
START ./temp_explain_query.sql


--retrieve the current timestamp
COLUMN QUERY_COST new_value V_QUERY_COST
SELECT TRIM(COST) AS QUERY_COST FROM
(SELECT cost from plan_table ORDER BY ID ASC) WHERE ROWNUM = 1;

--export the result set in .csv format:
SET FEEDBACK OFF;
set markup csv on;
SET TERMOUT OFF;
SET NEWPAGE 0;
SET PAGESIZE 0;
SET ECHO OFF;
SET longchunksize 2000;
SET LONG 2000;


--retrieve the current timestamp
SELECT to_char(CAST(CURRENT_TIMESTAMP AT TIME ZONE 'UTC' as date), 'YYYYMMDD HH:MI:SS AM') AS CURRENT_DATE_TIME_UTC from dual;
SET TERMOUT ON;

--log that the SELECT query is being executed and the results are being saved
SPOOL ../logs/&V_LOG_FILE_NAME append;
PROMPT &V_CURRENT_DATE_TIME_UTC. - execute the query and download the results
SPOOL OFF;

SET TERMOUT OFF;

--capture the timestamp before the query is sent
SELECT to_char(CURRENT_TIMESTAMP, 'YYYYMMDD HH:MI:SS.FF3 AM') AS START_TIMESTAMP, 

--capture the start date/time in the UTC time zone
to_char(CAST(CURRENT_TIMESTAMP AT TIME ZONE 'UTC' as date), 'MM/DD/YYYY HH:MI:SS AM') AS START_DATE_TIME_UTC, 

--capture the start date/time in the Pacific/Honolulu time zone
to_char(CAST (CURRENT_TIMESTAMP AT TIME ZONE 'Pacific/Honolulu' AS DATE), 'MM/DD/YYYY HH:MI:SS AM') AS START_DATE_TIME_HST from dual;

--execute the export query
spool ../data_exports/&1..csv
START ./temp_export_query.sql
spool off;


--retrieve the current timestamp
COLUMN END_TIMESTAMP new_value V_END_TIMESTAMP
SELECT to_char(CURRENT_TIMESTAMP, 'YYYYMMDD HH:MI:SS.FF3 AM') AS END_TIMESTAMP, to_char(CAST(CURRENT_TIMESTAMP AT TIME ZONE 'UTC' as date), 'YYYYMMDD HH:MI:SS AM') AS CURRENT_DATE_TIME_UTC from dual;


--calculate the total time between when the query was sent and the response was received
COLUMN ELAPSED_TIME_SEC new_value V_ELAPSED_TIME_SEC
select TO_NUMBER(extract(minute from diff)) * 60 + TO_NUMBER(TRIM(extract(second from diff))) AS ELAPSED_TIME_SEC FROM (SELECT to_timestamp('&&V_END_TIMESTAMP', 'YYYYMMDD HH:MI:SS.FF3 AM') - to_timestamp('&&V_START_TIMESTAMP', 'YYYYMMDD HH:MI:SS.FF3 AM') diff from dual);

SET TERMOUT ON;

--add a logging message for the total time the data export took:
SPOOL ../logs/&V_LOG_FILE_NAME append;
PROMPT &V_CURRENT_DATE_TIME_UTC. - metrics data export has completed, the entire process took &V_ELAPSED_TIME_SEC. seconds
SPOOL OFF;




--add an entry in the .csv file with associated metrics for the query that was just executed
SPOOL ../data_exports/&V_CSV_OUTPUT_FILE_NAME. append;
PROMPT "&V_DB_NAME.","&V_DB_LOCATION_NAME","&V_APP_LOCATION_NAME","&1.","&V_START_DATE_TIME_UTC.","&V_START_DATE_TIME_HST.","&V_QUERY_COST.","&V_NUM_ROWS.","&2.","&V_ELAPSED_TIME_SEC.","[FILE_SIZE]";
SPOOL OFF;

--log that the entire script has finished executing
SPOOL ../logs/&V_LOG_FILE_NAME. append;
PROMPT &V_CURRENT_DATE_TIME_UTC. - Finished capturing metrics for the query: &1.
SPOOL OFF;


