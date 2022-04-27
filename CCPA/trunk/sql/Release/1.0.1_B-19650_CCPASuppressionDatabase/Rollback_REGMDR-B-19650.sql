--FROM REGMDR
REVOKE select, insert, update, delete on CONTACT_ACCT_PREFERENCE  From CCPA;
REVOKE select, insert, update, delete on CONTACT  From CCPA;
REVOKE select, insert, update, delete on CONTACT_MARKETABLE  From CCPA;
REVOKE select, insert, update, delete on CONTACT_Address  From CCPA;
REVOKE select, insert, update, delete on contact_phone From CCPA;
REVOKE execute on dsms.dsms_security From CCPA;

---regmdr index
DROP index cont_email_fidx;
DROP index cont_last_name_idx;
