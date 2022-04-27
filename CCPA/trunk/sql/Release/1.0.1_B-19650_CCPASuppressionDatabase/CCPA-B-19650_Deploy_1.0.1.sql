Spool B-19650-Deploy_log.txt
set echo on
set define off
set sqlblanklines on


Prompt "B-19650_CCPA_Sequences.."
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Release/1.0.1_B-19650_CCPASuppressionDatabase
@B-19650_CCPA_Sequences.sql
show errors

Prompt "B-19650_CCPA_Tables.."
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Release/1.0.1_B-19650_CCPASuppressionDatabase
@B-19650_CCPA_Tables.sql
show errors

Prompt "B-19650_CCPA_Triggers.."
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Release/1.0.1_B-19650_CCPASuppressionDatabase
@B-19650_CCPA_Triggers.sql
show errors

Prompt "Email_Pkg.."
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Packages
@Email_Pkg.sql
show errors

Prompt "Util_Pkg.."
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Packages
@Util_Pkg.sql
show errors

Prompt "CCPA_Supp_Pkg.."
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Packages
@CCPA_Supp_Pkg.sql
show errors

Prompt "Grants-CCPA_B-19650.."
--https://svn.dialog-direct.com/svn/HP-Archive/CCPA/trunk/sql/Release/1.0.1_B-19650_CCPASuppressionDatabase
@Grants-CCPA_B-19650.sql
show errors

spool off



