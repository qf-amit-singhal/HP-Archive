--B-19650_Tables

--APP_CONFIG
CREATE TABLE "CCPA"."APP_CONFIG" 
   ("CONFIG_NAME" 				VARCHAR2(200) NOT NULL ENABLE, 
	"CONFIG_VALUE" 				VARCHAR2(1000), 
	"CONFIG_DESCR" 				VARCHAR2(1000), 
	"CONFIG_CREATE_DATE" 		DATE, 
	"CONFIG_CREATE_BY" 			VARCHAR2(50), 
	"CONFIG_UPDATE_DATE" 		DATE, 
	"CONFIG_UPDATE_BY" 			VARCHAR2(50), 
	 CONSTRAINT "APP_CONFIG_PK" PRIMARY KEY ("CONFIG_NAME") 
	);
	
--CCPA_SUPPRESSION	
CREATE TABLE "CCPA"."CCPA_SUPPRESSION" 
   ("CS_ID" 					NUMBER, 
	"CS_FNAME" 					VARCHAR2(50), 
	"CS_LNAME" 					RAW(256), 
	"CS_ADD1" 					RAW(256), 
	"CS_ADD2" 					RAW(256), 
	"CS_CITY" 					RAW(128), 
	"CS_STATE" 					RAW(32), 
	"CS_ZIP" 					RAW(32), 
	"CS_ZIP4" 					RAW(32), 
	"CS_EMAIL" 					RAW(256), 
	"CS_PHONE" 					VARCHAR2(20), 
	"CS_REC_DATE" 				DATE, 
	"CS_SOURCE" 				VARCHAR2(50), 
	"CS_LOAD_DATE" 				DATE, 
	"CS_REQ_TYPE" 				VARCHAR2(20), 
	"CS_CREATE_DATE" 			DATE, 
	"CS_CREATE_BY" 				VARCHAR2(30), 
	"CS_UPDATE_DATE" 			DATE, 
	"CS_UPDATE_BY" 				VARCHAR2(30), 
	"CS_SUPPRESS_FLAG" 			CHAR(1), 
	"CS_LNAME_RAW" 				VARCHAR2(50), 
	"CS_ADD1_RAW" 				VARCHAR2(100), 
	"CS_ADD2_RAW" 				VARCHAR2(100), 
	"CS_CITY_RAW" 				VARCHAR2(50), 
	"CS_STATE_RAW" 				VARCHAR2(20), 
	"CS_ZIP_RAW" 				VARCHAR2(12), 
	"CS_ZIP4_RAW" 				VARCHAR2(12), 
	"CS_EMAIL_RAW" 				VARCHAR2(100), 
	 CONSTRAINT "CCPA_SUPPRESSION_PK" PRIMARY KEY ("CS_ID") 
	);
	
--TIMEZONE	
CREATE TABLE "CCPA"."TIMEZONE" 
   ("TZONE_ID" 					NUMBER, 
	"TZONE_CODE" 				VARCHAR2(4) NOT NULL ENABLE, 
	"TZONE_NAME" 				VARCHAR2(255) NOT NULL ENABLE, 
	"TZONE_UTC_OFFSET" 			NUMBER NOT NULL ENABLE, 
	"TZONE_CREATE_DATE" 		DATE, 
	"TZONE_CREATE_BY" 			VARCHAR2(30), 
	"TZONE_UPDATE_DATE" 		DATE, 
	"TZONE_UPDATE_BY" 			VARCHAR2(30), 
	 CONSTRAINT "TIMEZONE_PK" 	PRIMARY KEY ("TZONE_ID") 
	);
	
insert into CCPA.APP_CONFIG (config_name,config_value,config_descr) 
values('IT_EMAIL','hunny.batra@qualfon.com,niranjan.singh@qualfon.com,jay.patel@qualfon.com,Susan.Hofmeister@qualfon.com, Ajay.tiwari@qualfon.com',
'Accounts that will receive emails during development.');

insert into CCPA.APP_CONFIG (config_name,config_value,config_descr) 
values('REG_EMAIL','REGMDRMDR@qualfon.com',
'EmailId for Regeneron CCPA suppression records.');

Commit;

	 