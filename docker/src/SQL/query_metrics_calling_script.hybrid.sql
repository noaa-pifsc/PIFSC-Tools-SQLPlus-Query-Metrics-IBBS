/************************************************************************************
 Filename   : query_metrics_calling_script.sql
 Purpose    : Automated script for generating an OCI metrics data set export for the development database instance
************************************************************************************/
SET FEEDBACK ON
SET TRIMSPOOL ON
SET VERIFY OFF
SET SQLBLANKLINES ON
SET AUTOCOMMIT OFF
SET EXITCOMMIT OFF
SET ECHO OFF

WHENEVER SQLERROR EXIT 1
WHENEVER OSERROR  EXIT 1


SET DEFINE ON



-- Provide credentials in the form: USER@TNS/PASSWORD when using a TNS Name
-- Provide credentials in the form: USER/PASSWORD@HOSTNAME/SID when specifying hostname and SID values
--DEFINE apps_credentials=&1
SET ECHO OFF
@@credentials/DB_credentials.sql
CONNECT &apps_credentials
--SET ECHO ON

--load the runtime configuration:
@@./sqlplus_config/runtime_config.sql

SET TERMOUT OFF

--retrieve the current date and date/time
COLUMN CURRENT_DATE_TIME new_value V_CURRENT_DATE_TIME
COLUMN CURRENT_DATE new_value V_CURRENT_DATE

SELECT to_char(SYSDATE, 'YYYYMMDD') AS CURRENT_DATE from dual;


DEFINE V_LOG_FILE_NAME = query_metrics_log_&V_CURRENT_DATE..log;

--define the local variables to indicate the scenario the SQL*Plus script is being run
DEFINE V_APP_LOCATION_NAME = 'Local';
DEFINE V_DB_LOCATION_NAME = 'Remote';

PROMPT export OCI metrics data
@@query_metrics_export.sql

--SET ECHO OFF;

DISCONNECT;

EXIT;
