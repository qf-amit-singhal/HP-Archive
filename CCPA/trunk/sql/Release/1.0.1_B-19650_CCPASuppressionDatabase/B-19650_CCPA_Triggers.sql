--B-19650 TRIGGERS

create or replace TRIGGER APP_CONFIG_BIU
Before Insert Or Update On APP_CONFIG
Referencing Old As Old New As New
For Each Row
Declare
    n_Id    Number;
    v_User  Varchar2(30) := SUBSTR(USER ||' ('|| UPPER(SYS_CONTEXT('USERENV', 'OS_USER')) ||')',1,30);
Begin

    If Inserting Then

        If :NEW.CONFIG_NAME Is Null Then
             select  CONFIG_NAME_SEQ.NextVal Into n_Id From Dual;
            :NEW.CONFIG_NAME := n_Id;
        End If;

        :NEW.CONFIG_CREATE_DATE := SysDate;
        :NEW.CONFIG_CREATE_BY   := v_User;

    End If;

    :NEW.CONFIG_UPDATE_DATE := SysDate;
    :NEW.CONFIG_UPDATE_BY   := v_User;
End;
/

create or replace TRIGGER CCPA_SUPPRESSION_BIU
Before Insert Or Update On CCPA_SUPPRESSION
Referencing Old As Old New As New
For Each Row
Declare
   n_Id    Number;
   v_Key   Varchar2(10) := UPPER(SYS_CONTEXT('USERENV','CURRENT_SCHEMA'));
   v_User  Varchar2(30) := SUBSTR(USER ||' ('|| UPPER(SYS_CONTEXT('USERENV', 'OS_USER')) ||')',1,30);
Begin

  If Inserting Then

        If :NEW.CS_ID Is Null Then
            select  CS_ID_SEQ.NextVal Into n_Id From Dual;
            :NEW.CS_ID := n_Id;
        End If;

        :NEW.CS_CREATE_DATE := SysDate;
        :NEW.CS_CREATE_BY := v_User;
  End If;
--  Upper name and address, lower email
    :NEW.CS_FNAME         := UPPER(TRIM(:NEW.CS_FNAME));
    :NEW.CS_LNAME_RAW     := UPPER(TRIM(:NEW.CS_LNAME_RAW));
    :NEW.CS_ADD1_RAW      := UPPER(TRIM(:NEW.CS_ADD1_RAW));
    :NEW.CS_ADD2_RAW      := UPPER(TRIM(:NEW.CS_ADD2_RAW));
    :NEW.CS_CITY_RAW      := UPPER(TRIM(:NEW.CS_CITY_RAW));
    :NEW.CS_STATE_RAW     := UPPER(TRIM(:NEW.CS_STATE_RAW));
    :NEW.CS_EMAIL_RAW     := LOWER(TRIM(:NEW.CS_EMAIL_RAW));

    If :NEW.CS_LNAME_RAW Is Not Null Then
        :NEW.CS_LNAME := DSMS.DSMS_SECURITY.ENCRYPT_VAL(:NEW.CS_LNAME_RAW, v_Key);
    End If;

    If :NEW.CS_ADD1_RAW Is Not Null Then
        :NEW.CS_ADD1 := DSMS.DSMS_SECURITY.ENCRYPT_VAL(:NEW.CS_ADD1_RAW, v_Key);
    End If;

    If :NEW.CS_ADD2_RAW Is Not Null Then
        :NEW.CS_ADD2 := DSMS.DSMS_SECURITY.ENCRYPT_VAL(:NEW.CS_ADD2_RAW, v_Key);
    End If;

    If :NEW.CS_CITY_RAW Is Not Null Then
        :NEW.CS_CITY := DSMS.DSMS_SECURITY.ENCRYPT_VAL(:NEW.CS_CITY_RAW, v_Key);
    End If;

    If :NEW.CS_STATE_RAW Is Not Null Then
        :NEW.CS_STATE := DSMS.DSMS_SECURITY.ENCRYPT_VAL(:NEW.CS_STATE_RAW, v_Key);
    End If;

    If :NEW.CS_ZIP_RAW Is Not Null Then
        :NEW.CS_ZIP := DSMS.DSMS_SECURITY.ENCRYPT_VAL(:NEW.CS_ZIP_RAW, v_Key);
    End If;

    If :NEW.CS_ZIP4_RAW Is Not Null Then
        :NEW.CS_ZIP4 := DSMS.DSMS_SECURITY.ENCRYPT_VAL(:NEW.CS_ZIP4_RAW, v_Key);
    End If;

    If :NEW.CS_EMAIL_RAW Is Not Null Then
        :NEW.CS_EMAIL := DSMS.DSMS_SECURITY.ENCRYPT_VAL(:NEW.CS_EMAIL_RAW, v_Key);
    End If;

    :NEW.CS_UPDATE_DATE := SysDate;
    :NEW.CS_UPDATE_BY := v_User;  
Exception
    When Others Then
        Raise_Application_Error(-20100,'CCPA Suppression BIU ' || SQLERRM);
End;
/

create or replace TRIGGER TIMEZONE_BIU
Before Insert Or Update On TIMEZONE
Referencing Old As Old New As New
For Each Row
Declare
    n_Id Number;
Begin

   If Inserting Then

      If :NEW.TZONE_ID Is Null Then
          select  TZONE_ID_SEQ.NextVal Into n_Id From Dual;
         :NEW.TZONE_ID := n_Id;
      End If;

     :NEW.TZONE_CREATE_DATE := SysDate;
     :NEW.TZONE_CREATE_BY := User;

   End If;

  :NEW.TZONE_UPDATE_DATE := SysDate;
  :NEW.TZONE_UPDATE_BY := User;
End;
/
