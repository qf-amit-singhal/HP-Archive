CREATE OR REPLACE Package CCPA.Util_Pkg AuthId Definer Is
 /*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
    Date: Sep 22, 2020 HB/NS
    Desc: Misc procedures and functions used throughout the system.
    Mods:
  |-------------------------------------------------------------------------------------------------|
  | BPC Request     |    Date    |   Author  |           Description                                |
  |-------------------------------------------------------------------------------------------------|
  | 525851/0010     | 09-22-20   |  HB/NS    | Created package for Misc procedures and functions.	|
  |-------------------------------------------------------------------------------------------------|
  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */

    Function Get_App_Config_Value(p_Config_Name app_config.config_name%Type) Return Varchar2;
    
    Function File_Exists(p_File_Name Varchar2,
                         p_Dir       Varchar2 Default 'DATA')
    Return Char;

    Function Get_Log_File_Name(p_Prog Varchar2 Default Null) Return Varchar2;

    Function Add_Breaks(p_Lines Number, p_Max_Lines Number Default 15) Return Varchar2;
    
    Function Get_Elapsed_Minutes Return Number;
    
    Procedure Write_To_File(p_Text        Varchar2,
                            p_File_Name   Varchar2 Default Null,
                            p_Directory   Varchar2 Default 'OUT',
                            p_Put_Line    Boolean  Default True,
                            p_Tag_Date    Boolean  Default True,
                            p_Initialize  Boolean  Default False);

  
    Procedure Initialize_Program(p_Prog_Name Varchar2, p_Prog_Code Varchar2, p_user varchar2 Default null);

 --  Used to log and create email messages
    Procedure Add_Message(p_Msg         Varchar2,
                          p_Log_Msg     Varchar2 Default 'Y',
                          p_Email_Msg   Varchar2 Default 'Y');


--  Sends an email in a standard format. Detects the schema to determine who to send to.
--  Each schema has an email list associated with it.
    Procedure Send_Email(p_Subject      Varchar2 Default Null,
                         p_Msg          Clob     Default Null,
                         p_Error        Varchar2 Default 'N',
                         p_Addr_To      Varchar2 Default Null,
                         p_Addr_From    Varchar2 Default Null,
                         p_Cc           Varchar2 Default Null,
                         p_Mime_Type    Varchar2 Default 'H',
                         p_File_Name    Varchar2 Default Null,
                         p_Directory    Varchar2 Default Null);

    App_Code        Varchar2(12) := Upper(sys_context('userenv','current_schema'));
    OS_User         Varchar2(50) := Lower(sys_context('userenv', 'os_user'));
    DB_Name         Varchar2(10) := Lower(sys_context('userenv', 'db_name'));
    Server_Host     Varchar2(10) := Lower(sys_context('userenv', 'server_host'));

    Out_Dir         Varchar2(20) := Upper(sys_context('userenv','current_schema')) || '_OUT_DIR';
    Data_Dir        Varchar2(20) := Upper(sys_context('userenv','current_schema')) || '_DATA_DIR';
    Log_File        Varchar2(50);       --  This is the name of the program log file

    Session_Start   Date := Sysdate;

    Html_Msg        Clob;               --  Entire email message
    Html_End        Varchar2(4000);     --  Preformatted footer
    Html_Space      Varchar2(05) := Chr(38)||'nbsp';    --  Leading spaces are not allowed.

--  Use this to create indent effect; otherwise, use: <blockquote></blockquote>
    Html_Indent     Varchar2(25) := Html_Space || Html_Space || Html_Space;

--  Use to create a border line.
    Html_Line       Varchar2(100) := '<div style=''border-top:solid #B5C4DF 1.0pt;padding:3.0pt 0in 0in 0in''>';

    Sep_Bar         Constant Varchar2(50) := '____________________________________';

    NR_Email        Constant Varchar2(40)  := 'donotreply@dialog-direct.com';
    IT_CM_Email     Constant Varchar2(40)  := 'ITCampaignMgmt@Dialog-Direct.com';
    PSCP_Email      Constant Varchar2(40)  := 'PSC-Production@dialog-direct.com';
    ST_Email        Constant Varchar2(40)  := 'SustainedTeam-DL@dialog-direct.com';

    CM_Email            Varchar2(100);
    DI_Email            Varchar2(100);
    DM_Email            Varchar2(100);
    PM_Email            Varchar2(100);
    IT_Email            Varchar2(500);

    Prog_Name           Varchar2(99);

    Row_Count           Number := 0;        

End Util_Pkg;
/
CREATE OR REPLACE Package Body CCPA.Util_Pkg Is
 
   Function Get_Log_File_Name(p_Prog Varchar2 Default Null) Return Varchar2 Is

        v_Log_Name  Varchar2(40) := To_Char(SysDate,'yymmddhhmi') ||
                                    SubStr(DB_Name,4,1) || '.log';
    Begin

        Log_File := Nvl(p_Prog,Lower(App_Code)) ||'_'|| v_Log_Name;

        Return Log_File;

    Exception
        When Others Then
            Log_File := Lower(App_Code) ||'_'|| v_Log_Name;
            Return v_Log_Name;
    End Get_Log_File_Name;

        Function Get_App_Config_Value(p_Config_Name app_config.config_name%Type) Return Varchar2 Is

        v_Config_Value  app_config.config_value%Type;

    Begin

        select  config_value
        into    v_Config_Value
        from    app_config
        where   config_name = p_Config_Name;

        Return  v_Config_Value;

    Exception
        When Others Then
            Return Null;
    End Get_App_Config_Value;

    Function Get_Elapsed_Minutes Return Number Is
    Begin
        Return Round(To_Number(SysDate - Session_Start)*1440);
    End;

    Function Add_Breaks(p_Lines Number, p_Max_Lines Number Default 15)
    Return   Varchar2 Is

        n_Lines     Number := p_Lines;
        v_Return    Varchar2(99) := '<br>';

    Begin

        While n_Lines < p_Max_Lines Loop
            n_Lines := n_Lines + 1;
            v_Return := v_Return || '<br>';
        End Loop;

        Return v_Return;

    End;    

    Function File_Exists(p_File_Name Varchar2,
                         p_Dir       Varchar2 Default 'DATA')
    Return Char Is

         bExists        Boolean;
         nFile_Len      Number;
         nBlock_Size    Number;
         v_Folder       Varchar2(25);

    Begin

    --  Sys_context returns the app code to build data directory variable
        If InStr(Upper(p_Dir),'OUT') > 0 Then
            v_Folder := Out_Dir;
        Else
            v_Folder := Data_Dir;
        End If;

    --  Fills variables
        Utl_File.FGetAttr(v_Folder, p_File_Name, bExists, nFile_Len, nBlock_Size);

        If bExists Then
            Return 'Y';
        Else
            Return 'N';
        End If;

    Exception
        When Others Then
            Raise_Application_Error(-20901, 'File Exists ' || v_Folder ||' '|| SQLERRM);
            Return 'N';
    End File_Exists;

    Procedure Add_Message(p_Msg         Varchar2,
                          p_Log_Msg     Varchar2 Default 'Y',
                          p_Email_Msg   Varchar2 Default 'Y') Is

                                  --  Replace blanks and carriage returns
        v_Message   Varchar2(2000) := Replace(Replace(p_Msg, Html_Space, ' '),'<br>',Chr(10));

    Begin

        If p_Email_Msg = 'Y' Then
            Html_Msg := Html_Msg || p_Msg || '<br>';
        End If;

        v_Message := Replace(Replace(v_Message,'<strong>',''),'</strong>','');

        Dbms_Output.Put_Line(v_Message);

        If p_Log_Msg = 'Y' Then
            Write_To_File(p_Text => v_Message, p_File_Name => Log_File, p_Put_Line => False);
        End If;

    Exception
        When Others Then
            Null;
    End Add_Message;

    Procedure Write_To_File(p_Text        Varchar2,
                            p_File_Name   Varchar2 Default Null,
                            p_Directory   Varchar2 Default 'OUT',
                            p_Put_Line    Boolean  Default True,
                            p_Tag_Date    Boolean  Default True,
                            p_Initialize  Boolean  Default False) Is

        v_Folder        Varchar2(40);
        v_File          Varchar2(60);
        v_Text          Varchar2(32500) := p_Text;

        Output_File     Utl_File.File_Type;

    Begin

        If p_Tag_Date Then
            v_Text := SubStr(To_Char(SysDate,'yyyy.mm.dd:hh.mi') ||' | '|| p_Text, 1, 32000);
        End If;

        If p_Put_Line Then
            Dbms_Output.Put_Line(v_Text);
        End If;

        If InStr(Upper(p_Directory),'OUT') > 0 Then
            v_Folder := Out_Dir;
        Else
            v_Folder := Data_Dir;
        End If;

        If p_File_Name Is Not Null Then
            v_File := p_File_Name;
        Else
            v_File := Get_Log_File_Name;
        End If;

        If p_Initialize Then
            If File_Exists(v_File, v_Folder) = 'Y' Then
                Utl_File.FRemove (v_Folder, v_File);
            End If;
        End If;

        Output_File := Utl_File.FOpen(v_Folder, v_File, 'A', 32767);

        Utl_File.Put_Line(Output_File, v_Text);

        Utl_File.FClose(Output_File);

    Exception
        When Others Then
            dbms_output.put_line('Write to file: '||sqlerrm);
            If Utl_File.Is_Open(Output_File) Then
                Utl_File.FClose(Output_File);
            End If;
    End Write_To_File;

    Procedure Initialize_Program(p_Prog_Name Varchar2, p_Prog_Code Varchar2, p_user varchar2 Default null) Is

        CS_Rec_Count    number;

        v_Msg           Varchar2(99) := 'Init 1 ';

    Begin

    --  Capture the date and time this program started
        Session_Start := SysDate;

        Prog_Name := p_Prog_Name;
        Log_File := Get_Log_File_Name(p_Prog_Code);

        Row_Count        := 0;
      
        IT_Email := Get_App_Config_Value('IT_EMAIL');

   --  Create html message and define style.
        Html_Msg := Email_Pkg.Create_HTML_Email;

    --  Need this info for the email report.
        If p_user = 'ALL' Then
            v_Msg := 'Init Source Log ';

            select  count(*)
            into    CS_Rec_Count
            from    CCPA_SUPPRESSION cs
            where CS_SUPPRESS_FLAG is null;
        Elsif p_user is not null then
            v_Msg := 'Init Source Log ';

            select  count(*)
            into    CS_Rec_Count
            from    CCPA_SUPPRESSION;
        Else
            CS_Rec_Count := 0;
        End If;

        Add_Message('Here are the results of the <strong>' || p_Prog_Name ||'</strong> procedure.<br>');
        Add_Message(Sep_Bar);
        Add_Message('Run Date : '       || Html_Indent || To_Char(SysDate,'MM/DD/YYYY HH:MI:SS AM'));

        If p_user is not null Then
            Add_Message('Total Records : '  || Html_Indent || CS_Rec_Count);
        End If;

        Add_Message(Sep_Bar);

    Exception
        When Others Then
            Raise_Application_Error(-20008, v_Msg || SQLERRM);
    End Initialize_Program;
    
    Procedure Send_Email(p_Subject      Varchar2 Default Null,
                         p_Msg          Clob     Default Null,
                         p_Error        Varchar2 Default 'N',
                         p_Addr_To      Varchar2 Default Null,
                         p_Addr_From    Varchar2 Default Null,
                         p_Cc           Varchar2 Default Null,
                         p_Mime_Type    Varchar2 Default 'H',
                         p_File_Name    Varchar2 Default Null,
                         p_Directory    Varchar2 Default Null) Is

        v_From      Varchar2(100) := NR_Email;
        v_To        Varchar2(200) := IT_Email;
        v_Cc        Varchar2(200) := p_Cc;
        v_Subject   Varchar2(100) ;

    Begin

        v_Subject := App_Code||' '||Nvl(p_Subject, Prog_Name);

        If  p_Error = 'Y' Then                      --  Make the email to/from IT
            v_To := IT_Email;
            v_Subject := 'ERROR => ' ||v_Subject;   --  Add error indicator to subject
        End If;

        If Upper(DB_Name) = 'APPX' Then
            v_To := IT_Email;

            If p_Addr_To Is Not Null Then           --  Override settings above.
                v_To := p_Addr_To;
            End If;

            If p_Addr_From Is Not Null Then         --  Override settings above.
                v_From := p_Addr_From;
            End If;

        End If;

        Add_Message('Program End : ' || Html_Indent ||
                    To_Char(SysDate,'MM/DD/YYYY HH:MI:SS AM') ||' ('||
                    Get_Elapsed_Minutes ||' mins.)');
        Add_Message(Sep_Bar);

        Html_End := '<hr>' || '<font face="Calibri" size="2">' ||
                    '<i>'  || Prog_Name || ' run by ' || Util_Pkg.Os_User ||
                    ' on ' || DB_Name   || ' from ' ||
                    Util_Pkg.Server_Host || '</i></font>' ||Chr(10)||'</body></html>';

    --  Finalize the email message
        Html_Msg :=  Html_Msg || nvl(p_Msg,'<br>No additional information to report.') ||
                     Add_Breaks(10) || Html_End;

        Email_Pkg.Send(p_From      => v_From,
                       p_To        => v_To,
                       p_Cc        => v_Cc,
                       p_Subject   => v_Subject ||' ('|| Lower(DB_Name) ||')',
                       p_Message   => Html_Msg,
                       p_Mime_Type => p_Mime_Type,
                       p_File_Name => p_File_Name,
                       p_Directory => p_Directory);

    Exception
        When Others Then
            If InStr(SQLERRM, 'Service not available', 1) > 0 Then
                Write_To_File('Email Unavailable - Service Error', Log_File);
                Write_To_File(SQLERRM, Log_File);
            Else
                Write_To_File('Send Email To:   ' || v_To, Log_File);
                Write_To_File('Send Email From: ' || v_From, Log_File);
                Write_To_File('Send Email Err:  ' || SQLERRM, Log_File);
            End If;
    End Send_Email;
End Util_Pkg;
/
