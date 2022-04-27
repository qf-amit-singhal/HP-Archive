spool B_25440_Deploylog_CCPA.txt

set echo on
set define off
set sqlblanklines on


Prompt "CCPA_Supp_Pkg"
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Packages

@CCPA_Supp_Pkg.sql

show errors

spool off
