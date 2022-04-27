spool B_25226_rollback.log

set echo on
set define off
set sqlblanklines on

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
  
End CCPA_Supp_Pkg;
/
CREATE OR REPLACE Package Body CCPA.CCPA_Supp_Pkg Is
 
  Procedure CCPA_DB_suppression(P_User Varchar2 Default 'ALL') as 
    
    v_Msg Varchar2(4000);
    n_Cont_Id varchar2(4000);
    v_query   varchar2(4000);
    
    RawR Raw(64) := dsms.dsms_security.encrypt_val('xxx', 'REGMDR');
    RawC Raw(64) := dsms.dsms_security.encrypt_val('xxx', 'CCPA');

    TYPE ref_cursor_type IS REF CURSOR;
    c_cur ref_cursor_type;
    ccpa_type CCPA_SUPPRESSION%rowtype; 

    Begin
      v_suppress_cnt:=0;
      v_unmatch_cnt:=0;
      v_cont_cnt:=0;
      v_cap_cnt:=0;
      v_contm_cnt:=0;
      
      Util_Pkg.Initialize_Program('CCPA_DB_suppression ', 'CCPADBS',P_USER);

      v_Msg := 'Identifing the data which has to be suppressed.';
      
      If P_User='ALL' Then   
           v_query:='select * From CCPA_SUPPRESSION where CS_SUPPRESS_FLAG is null';
      Else
            v_query:='select * From CCPA_SUPPRESSION';
      End if;
      ---suppression section for Regmdr start
      if p_user='REGMDR' or P_User='ALL' then
      v_Msg := 'Loop will run for REGMDR schema. ';
           open c_cur for v_query ;
           loop
           fetch c_cur into ccpa_type;
            Exit when c_cur%notfound;
            Begin
                dbms_output.put_line('in loop '|| ccpa_type.cs_id);
                v_Msg := 'Get contact ids against the CS_ID. ' || ccpa_type.cs_id||' ';
                If ccpa_type.cs_email is not null then   --match 1
                    select listagg(cont_id, ',') WITHIN GROUP (ORDER BY cont_id) into n_Cont_Id
                    from   regmdr.contact
                    where  dsms.dsms_security.decrypt_val(cont_email,'REGMDR') = dsms.dsms_security.decrypt_val(ccpa_type.cs_email,'CCPA');                        
                Elsif ccpa_type.CS_PHONE is not null Then --match 2
                    select listagg(cont_id, ',') WITHIN GROUP (ORDER BY cont_id) into n_Cont_Id
                    from   regmdr.contact_phone
                    where  PHONE_NUMBER = ccpa_type.CS_PHONE;
                Else                                --match 3
                    select listagg(c.cont_id, ',') WITHIN GROUP (ORDER BY c.cont_id) into n_Cont_Id
                    from   regmdr.contact c
                    join regmdr.contact_address ca on c.cont_id=ca.cont_id 
                    where  dsms.dsms_security.decrypt_val(c.CONT_LAST_NAME,'REGMDR')              = dsms.dsms_security.decrypt_val(ccpa_type.CS_LNAME,'CCPA')
                      and  dsms.dsms_security.decrypt_val(nvl(ca.CA_ADDRESS_1,RawR),'REGMDR')     = dsms.dsms_security.decrypt_val(nvl(ccpa_type.CS_ADD1,RawC),'CCPA')
                      and  dsms.dsms_security.decrypt_val(nvl(ca.CA_ADDRESS_2,RawR),'REGMDR')     = dsms.dsms_security.decrypt_val(nvl(ccpa_type.CS_ADD2,RawC),'CCPA')
                      and  dsms.dsms_security.decrypt_val(ca.CA_ZIP,'REGMDR')                     = dsms.dsms_security.decrypt_val(ccpa_type.CS_ZIP,'CCPA');
                 End if;
            Exception
            When Others Then
                 n_Cont_Id:= Null;
            End; 

             v_Msg := 'Contact ids- '||n_cont_id ||' going to be suppressed for CS_ID. ' || ccpa_type.cs_id||' ';
            If n_Cont_Id is not null Then
                v_suppress_cnt:= v_suppress_cnt + 1;
                --contact table
                EXECUTE IMMEDIATE     
                'Update regmdr.contact 
                set cont_active_flag=''N'',
                    cont_inactive_reason=''CCPA Suppression''
                where cont_id in ('||  n_Cont_Id||')';
                  --/*
                v_cont_cnt := v_cont_cnt + SQL%RowCount;
                --contact_acct_preference table
                EXECUTE IMMEDIATE 
                'Update regmdr.contact_acct_preference 
                set  capref_flag =''N''
                where cont_id in ('||  n_Cont_Id||')';
                v_cap_cnt := v_cap_cnt + SQL%RowCount;
                --contact_marketable table
                EXECUTE IMMEDIATE 
                'Delete from regmdr.contact_marketable
                where cont_id in ('||  n_Cont_Id||')';
                v_contm_cnt := v_contm_cnt + SQL%RowCount;
               --*/
            Else  
                v_unmatch_cnt:= v_unmatch_cnt + 1;
            End if;
           
          End Loop;  
      end if;
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
      Util_Pkg.Add_Message('Records Not Matched : ' || Util_Pkg.Html_Indent ||
                           v_unmatch_cnt);
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
      Util_Pkg.Add_Message('Deleted Contact Marketable  : ' || v_contm_cnt);
      Util_Pkg.Add_Message(Util_Pkg.Sep_Bar);
    
  Exception
    When Others Then
      Dbms_Output.Put_Line(SQLERRM);
  End Log_suppress_Counts;
 
End CCPA_Supp_Pkg;
/


show errors

spool off
