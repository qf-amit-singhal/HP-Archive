--B-19650 Grants REGMDR

--FROM REGMDR
Grant select, insert, update, delete on CONTACT_ACCT_PREFERENCE  to CCPA;
Grant select, insert, update, delete on CONTACT  to CCPA;
Grant select, insert, update, delete on CONTACT_MARKETABLE  to CCPA;
Grant select, insert, update, delete on CONTACT_Address  to CCPA;
Grant select, insert, update, delete on contact_phone to CCPA;
Grant execute on dsms.dsms_security to CCPA;

---regmdr index
create index cont_email_fidx on contact(dsms.dsms_security.decrypt_val(CONT_EMAIL,'REGMDR'));
create index cont_last_name_idx on contact(dsms.dsms_security.decrypt_val(CONT_LAST_NAME,'REGMDR'));
