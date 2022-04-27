spool Ford_B-28168_Eloqua_Email_Activity_Automation_deploy_log.txt
set echo on
set define off
set sqlblanklines on

Prompt "CreateTableScripts_EloquaEmailActivityStage..."
--https://svn.dialog-direct.com/svn/HP-Archive/DialogCampaign\EloquaEmailActivity\CreateTableScripts_EloquaEmailActivityStage.sql
@CreateTableScripts_EloquaEmailActivityStage.sql

Prompt "CreateTableScripts_EloquaEmailActivity_Analytics_Ford..."
--https://svn.dialog-direct.com/svn/HP-Archive/DialogCampaign\EloquaEmailActivity\FORD\CreateTableScripts_EloquaEmailActivity_Analytics_Ford.sql
@CreateTableScripts_EloquaEmailActivity_Analytics_Ford.sql

show errors

spool off
