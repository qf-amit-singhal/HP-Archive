CREATE OR REPLACE Package CCPA.CCPA_Supp_Pkg As
  /*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
    Date: Sep 22, 2020 HB/NS
    Desc: This package used to suppress the consumers that opt-out through the California Consumer 
          Privacy Act.
    Mods:
  |-------------------------------------------------------------------------------------------------|
  | BPC Request     |    Date    |   Author  |           Description                                |
  |-------------------------------------------------------------------------------------------------|
  | 525851/0010     | 09-22-20   |  HB/NS    | Created package for CCPA Suppression.                |
  |-------------------------------------------------------------------------------------------------|
  |-------------------------------------------------------------------------------------------------|
  | Story     		|    Date    |   Author  |           Description                                |
  |-------------------------------------------------------------------------------------------------|
  | B-25226     	| 09-21-21   |  RK/NS    | Regeneron Email Appends CCPA suppression.            |
  |-------------------------------------------------------------------------------------------------|
  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */

  --  Called by different schemas(REGNDR) to suppress the consumers that opt-out through CCPA
  Procedure CCPA_DB_suppression(p_User Varchar2 Default 'ALL');
  
  Procedure Log_CS_Counts;
  
  Procedure Log_suppress_Counts;
  
  V_Suppress_cnt   number :=0;
  V_Unmatch_cnt    number :=0;
  V_Cont_cnt       number :=0; 
  V_Cap_cnt        number :=0;
  V_Contm_cnt      number :=0;
  --[B-25226] Start
  v_eout_cnt       number:=0;
  v_hygiene_res_cnt  number:=0;
  v_sd_cnt         number:=0;
  v_cont_his_cnt   number:=0;
  v_sd_opt_cnt    number:=0;
  v_sd_payer_cnt   number:=0;
  v_sd_raw_cnt     number:=0;
  v_sd_raw_Payer_cnt     number:=0;
  v_vendor_app_cnt       number:=0;
  v_vendor_his_cnt       number:=0;
  v_ea_cnt               number:=0;
  v_hygiene_his_cnt      number:=0;
  v_cnt                  number:=0;
  --[B-25226] End
  
End CCPA_Supp_Pkg;
/
create or replace Package Body           CCPA_Supp_Pkg Is
 
  Procedure CCPA_DB_suppression(P_User Varchar2 Default 'ALL') as 
    
    v_Msg			 Varchar2(4000);
    n_Cont_Id 		 varchar2(4000);
    v_query          varchar2(4000);
    v_sql            varchar2(2000);

    RawR Raw(64) := dsms.dsms_security.encrypt_val('xxx', 'REGMDR');
    RawC Raw(64) := dsms.dsms_security.encrypt_val('xxx', 'CCPA');

    TYPE ref_cursor_type IS REF CURSOR;
    c_cur ref_cursor_type;
    ccpa_type           CCPA_SUPPRESSION.cs_email%type; 

Begin
      v_suppress_cnt:=0;
      v_unmatch_cnt:=0;
      v_cont_cnt:=0;
      v_cap_cnt:=0;
      v_contm_cnt:=0;
	  v_eout_cnt:=0;
      v_hygiene_res_cnt:=0;
      v_sd_cnt:=0;
      v_cont_his_cnt:=0;
      v_sd_opt_cnt:=0;
      v_sd_payer_cnt:=0;
      v_sd_raw_cnt:=0;
      v_sd_raw_Payer_cnt:=0;
      v_vendor_app_cnt:=0;
      v_vendor_his_cnt:=0;
      v_ea_cnt:=0;
	  v_hygiene_his_cnt:=0;
	  v_cnt :=0;

Util_Pkg.Initialize_Program('CCPA_DB_suppression ', 'CCPADBS',P_USER);

If P_User='ALL' Then   
   v_query:='select * From CCPA_SUPPRESSION where CS_SUPPRESS_FLAG is null';
Else
   v_query:='select cs_email From CCPA_SUPPRESSION';
End if;

---suppression section for Regmdr start
If p_user='REGMDR' or P_User='ALL' then
   v_Msg := 'Loop will run for REGMDR schema. ';

   Open c_cur for v_query ;
     loop
     fetch c_cur into ccpa_type;
     Exit when c_cur%notfound;

		select count(*) into v_cnt from regmdr.VENDOR_APPEND
		where dsms.dsms_security.decrypt_val(VAPD_APPEND_VALUE,'REGMDR')=dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');

			If v_cnt >= 1 Then

			v_suppress_cnt:= v_suppress_cnt + 1;
               --contact table
				Update regmdr.contact 
                set CONT_EMAIL=null,    --[B-25226]
                    CONT_EMAIL_DOMAIN=null   --[B-25226]
                where dsms.dsms_security.decrypt_val(cont_email,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_cont_cnt := v_cont_cnt + SQL%RowCount;

			   --EMAIL_OUT
			    Update regmdr.EMAIL_OUT
                set  EO_EMAIL_ADDRESS =NULL
                where dsms.dsms_security.decrypt_val(EO_EMAIL_ADDRESS,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_eout_cnt := v_eout_cnt + SQL%RowCount;

				--regmdr.EMAIL_HYGIENE_RESULTS_HISTORY 
				Update regmdr.EMAIL_HYGIENE_RESULTS_HISTORY
                set  EMAIL_ADDRESS =NULL
                where dsms.dsms_security.decrypt_val(EMAIL_ADDRESS,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_hygiene_his_cnt := v_hygiene_his_cnt + SQL%RowCount;

				--regmdr.EMAIL_HYGIENE_RESULTS 
			    Update regmdr.EMAIL_HYGIENE_RESULTS
                set  EMAIL_ADDRESS=NULL
                where dsms.dsms_security.decrypt_val(EMAIL_ADDRESS,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_hygiene_res_cnt := v_hygiene_res_cnt + SQL%RowCount;

				--regmdr.SOURCE_DATA 
				Update regmdr.SOURCE_DATA
                set  SD_EMAIL =NULL
                where dsms.dsms_security.decrypt_val(SD_EMAIL,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_sd_cnt := v_sd_cnt + SQL%RowCount;

				--regmdr.CONTACT_HISTORY 
			    Update regmdr.CONTACT_HISTORY
                set  CONTH_EMAIL =NULL
                where dsms.dsms_security.decrypt_val(CONTH_EMAIL,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_cont_his_cnt := v_cont_his_cnt + SQL%RowCount;

				--regmdr.SOURCE_DATA_OPT 
			    Update regmdr.SOURCE_DATA_OPT
                set  SDO_EMAIL_ADDRESS =NULL
                where dsms.dsms_security.decrypt_val(SDO_EMAIL_ADDRESS,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_sd_opt_cnt := v_sd_opt_cnt + SQL%RowCount;

				--regmdr.SOURCE_DATA_PAYER 
			    Update regmdr.SOURCE_DATA_PAYER
                set  SDP_EMAIL =NULL
                where dsms.dsms_security.decrypt_val(SDP_EMAIL,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_sd_payer_cnt := v_sd_payer_cnt + SQL%RowCount;

				--regmdr.SOURCE_DATA_RAW 
			    Update regmdr.SOURCE_DATA_RAW
                set  SDR_EMAIL =NULL
                where dsms.dsms_security.decrypt_val(SDR_EMAIL,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_sd_raw_cnt := v_sd_raw_cnt + SQL%RowCount;

				--regmdr.SOURCE_DATA_RAW_PAYER 
			    Update regmdr.SOURCE_DATA_RAW_PAYER
                set  SDRP_EMAIL =NULL
                where dsms.dsms_security.decrypt_val(SDRP_EMAIL,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_sd_raw_Payer_cnt := v_sd_raw_Payer_cnt + SQL%RowCount;

				--regmdr.VENDOR_APPEND 
			    Update regmdr.VENDOR_APPEND
                set  VAPD_APPEND_VALUE =dsms.dsms_security.encrypt_val('EMAIL_PURGED','REGMDR'),
                     SC_CODE='CCPA_SUPPRESS'
                where dsms.dsms_security.decrypt_val(VAPD_APPEND_VALUE,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_vendor_app_cnt := v_vendor_app_cnt + SQL%RowCount;

				--regmdr.VENDOR_APPEND_HISTORY 
			    Update regmdr.VENDOR_APPEND_HISTORY
                set  VAPDH_APPEND_VALUE =dsms.dsms_security.encrypt_val('EMAIL_PURGED','REGMDR'),
                     SC_CODE='CCPA_SUPPRESS'
                where dsms.dsms_security.decrypt_val(VAPDH_APPEND_VALUE,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_vendor_his_cnt := v_vendor_his_cnt + SQL%RowCount;

				--regmdr.EMAIL_ACTIVITY 
			    Update regmdr.EMAIL_ACTIVITY
                set  EA_EMAIL =NULL
                where dsms.dsms_security.decrypt_val(EA_EMAIL,'REGMDR')  = dsms.dsms_security.decrypt_val(ccpa_type,'CCPA');
                v_ea_cnt := v_ea_cnt + SQL%RowCount;

			End If;     
	End Loop;  
End if;

v_Msg := 'Update all new records that are suppressed. ' ;

      If P_user = 'ALL' Then
        Update CCPA_SUPPRESSION
        set CS_SUPPRESS_FLAG='Y'
        where CS_SUPPRESS_FLAG is null ;
      End If;
      commit;

      Log_CS_Counts;
      Log_suppress_Counts;

      Util_Pkg.Send_Email;
    ---suppression section for Regmdr end
    Exception
    When Others then
        Util_Pkg.Add_Message(v_Msg || SQLERRM);
        Util_Pkg.Send_Email(p_Error => 'Y');
        Rollback;           
End CCPA_DB_suppression;

  Procedure Log_CS_Counts Is

    v_table_name Varchar2(999) := 'CCPA Suppression';

  Begin

      Util_Pkg.Add_Message('<strong>' || v_table_name || '</strong>');

      Util_Pkg.Add_Message('Suppressed Records : ' || Util_Pkg.Html_Indent ||
                           v_suppress_cnt);
     /* Util_Pkg.Add_Message('Records Not Matched : ' || Util_Pkg.Html_Indent ||
                           v_unmatch_cnt);*/
      Util_Pkg.Add_Message(Util_Pkg.Sep_Bar);

  Exception
    When Others Then
      Dbms_Output.Put_Line(SQLERRM);
  End Log_CS_Counts; 

  Procedure Log_suppress_Counts Is

  Begin

      Util_Pkg.Add_Message('<strong>' || 'Regeneron- Suppress Results' || '</strong>');

      Util_Pkg.Add_Message('Contact  : ' || v_cont_cnt);
      Util_Pkg.Add_Message('Contact Acct Pref  : ' || v_cap_cnt);
	  --[B-25226] Start
	  Util_Pkg.Add_Message('EMAIL OUT  : ' || v_eout_cnt);
	  Util_Pkg.Add_Message('EMAIL HYGIENE RESULTS HISTORY  : ' || v_hygiene_his_cnt);
	  Util_Pkg.Add_Message('EMAIL HYGIENE RESULTS  : ' || v_hygiene_res_cnt);
	  Util_Pkg.Add_Message('SOURCE DATA  : ' || v_sd_cnt);
	  Util_Pkg.Add_Message('CONTACT HISTORY  : ' || v_cont_his_cnt);
	  Util_Pkg.Add_Message('SOURCE DATA OPT  : ' || v_sd_opt_cnt);
	  Util_Pkg.Add_Message('SOURCE DATA PAYER  : ' || v_sd_payer_cnt);
	  Util_Pkg.Add_Message('SOURCE DATA RAW  : ' || v_sd_raw_cnt);
	  Util_Pkg.Add_Message('SOURCE DATA RAW PAYER  : ' || v_sd_raw_Payer_cnt);
	  Util_Pkg.Add_Message('VENDOR APPEND  : ' || v_vendor_app_cnt);
	  Util_Pkg.Add_Message('VENDOR APPEND HISTORY  : ' || v_vendor_his_cnt);
	  Util_Pkg.Add_Message('EMAIL ACTIVITY  : ' || v_ea_cnt);
      Util_Pkg.Add_Message('Deleted Contact Marketable  : ' || v_contm_cnt);
	  --[B-25226] End
      Util_Pkg.Add_Message(Util_Pkg.Sep_Bar);

  Exception
    When Others Then
      Dbms_Output.Put_Line(SQLERRM);
  End Log_suppress_Counts;

End CCPA_Supp_Pkg;
/
