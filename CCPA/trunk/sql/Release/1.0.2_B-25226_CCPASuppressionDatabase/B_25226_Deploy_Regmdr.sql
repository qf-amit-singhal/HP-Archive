spool B_25440_Deploylog_regmdr.txt

set echo on
set define off
set sqlblanklines on

Prompt "B_25226_Grant_CCPA"
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Release/1.0.2_B-25226_CCPASuppressionDatabase

@B_25226_Grant_CCPA.sql

show errors

Prompt "B_25226_INDEX_REG"
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Release/1.0.2_B-25226_CCPASuppressionDatabase

@B_25226_INDEX_REG.sql

show errors

spool off
