--B-19650 Grants CCPA

--From CCPA
grant select , update, insert, delete  on ccpa_suppression to regmdr;
grant select on ccpa_suppression to ccpa_select_role;
grant select , update, insert, delete  on ccpa_suppression to ccpa_dm_role;
grant select , update, insert, delete  on ccpa_suppression to ccpa_di_role;

grant select , update, insert, delete  on app_config to regmdr;
grant select on app_config to ccpa_select_role;
grant select , update, insert, delete  on app_config to ccpa_dm_role;
grant select , update, insert, delete  on app_config to ccpa_di_role;

grant select , update, insert, delete  on timezone to regmdr;
grant select on timezone to ccpa_select_role;
grant select , update, insert, delete  on timezone to ccpa_dm_role;
grant select , update, insert, delete  on timezone to ccpa_di_role;

grant execute  on ccpa_supp_pkg to regmdr;
grant execute  on ccpa_supp_pkg to ccpa_dm_role;
grant execute  on ccpa_supp_pkg to ccpa_di_role;

grant execute  on email_pkg to regmdr;
grant execute  on email_pkg to ccpa_dm_role;
grant execute  on email_pkg to ccpa_di_role;

grant execute  on util_pkg to regmdr;
grant execute  on util_pkg to ccpa_dm_role;
grant execute  on util_pkg to ccpa_di_role;
