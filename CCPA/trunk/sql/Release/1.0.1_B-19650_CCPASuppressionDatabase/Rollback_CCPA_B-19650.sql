--Rollback CCPA B-19650

Drop Package Util_pkg;
Drop Package Email_pkg;
Drop  Package CCPA_supp_pkg;

Drop Sequence CONFIG_NAME_SEQ;
Drop Sequence CS_ID_SEQ;
Drop Sequence TZONE_ID_SEQ;

Drop Table APP_CONFIG;
Drop Table CCPA_SUPPRESSION;
Drop Table TIMEZONE;
