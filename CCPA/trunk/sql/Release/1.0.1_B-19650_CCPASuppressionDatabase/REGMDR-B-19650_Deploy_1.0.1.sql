Spool B-19650-REG_Deploy_log.txt
set echo on
set define off
set sqlblanklines on

Prompt "Grants_REGMDR-B-19650.."
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Release/1.0.1_B-19650_CCPASuppressionDatabase
@Grants_REGMDR-B-19650.sql
show errors

spool off



