create index eo_email_idx on regmdr.EMAIL_OUT(dsms.dsms_security.decrypt_val(EO_EMAIL_ADDRESS,'REGMDR'));

create index add_email_idx on regmdr.EMAIL_HYGIENE_RESULTS_HISTORY(dsms.dsms_security.decrypt_val(EMAIL_ADDRESS,'REGMDR'));

create index radd_email_idx on regmdr.EMAIL_HYGIENE_RESULTS(dsms.dsms_security.decrypt_val(EMAIL_ADDRESS,'REGMDR'));

create index sd_email_idx on regmdr.SOURCE_DATA(dsms.dsms_security.decrypt_val(SD_EMAIL,'REGMDR'));

create index CONTH_EMAIL_idx on regmdr.CONTACT_HISTORY(dsms.dsms_security.decrypt_val(CONTH_EMAIL,'REGMDR'));

create index SDO_EMAIL_ADDRESS_idx on regmdr.SOURCE_DATA_OPT(dsms.dsms_security.decrypt_val(SDO_EMAIL_ADDRESS,'REGMDR'));

create index sdp_email_idx on regmdr.SOURCE_DATA_PAYER(dsms.dsms_security.decrypt_val(SDP_EMAIL,'REGMDR'));

create index sdr_email_idx on regmdr.SOURCE_DATA_RAW(dsms.dsms_security.decrypt_val(SDR_EMAIL,'REGMDR'));

create index sdrp_email_idx on regmdr.SOURCE_DATA_RAW_PAYER(dsms.dsms_security.decrypt_val(SDRP_EMAIL,'REGMDR'));

create index vapd_email_idx on regmdr.VENDOR_APPEND(dsms.dsms_security.decrypt_val(VAPD_APPEND_VALUE,'REGMDR'));

create index vapdh_email_idx on regmdr.VENDOR_APPEND_HISTORY(dsms.dsms_security.decrypt_val(VAPDH_APPEND_VALUE,'REGMDR'));

create index ea_email_idx on regmdr.EMAIL_ACTIVITY(dsms.dsms_security.decrypt_val(EA_EMAIL,'REGMDR'));

