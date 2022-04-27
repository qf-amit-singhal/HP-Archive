CREATE OR REPLACE Package CCPA.Email_Pkg AuthId Current_User As
 /*  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *
    Date: Sep 22, 2020 HB/NS
    Desc: Uses the Utl_Smtp package to send emails in ascii and non-ascii char sets.
        Sends emails with text or binary attachments.
    Mods:
  |-------------------------------------------------------------------------------------------------|
  | BPC Request     |    Date    |   Author  |           Description                                |
  |-------------------------------------------------------------------------------------------------|
  | 525851/0010     | 09-22-20   |  HB/NS    | Created package for send emails.                		|
  |-------------------------------------------------------------------------------------------------|
  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
--  A simple email API for sending email in plain text in a single call.
--  The recipients is a list of email addresses are separated by either a "," or a ";"
    Procedure Send(p_From       In Varchar2,
                   p_To         In Varchar2,
                   p_Subject    In Varchar2,
                   p_Message    In Clob,
                   p_Cc         In Varchar2 Default Null,
                   p_Bcc        In Varchar2 Default Null,
                   p_File_Name  In Varchar2 Default Null,
                   p_Directory  In Varchar2 Default Null,
                   p_Mime_Type  In Varchar2 Default 'H',
                   p_Priority   Pls_Integer Default Null);

    Procedure Attach_Oracle_File(p_Conn       In Out NoCopy Utl_Smtp.Connection,
                                 p_Directory  In Varchar2,
                                 p_File_Name  In Varchar2,
                                 p_Mime_Type  In Varchar2);

--  Send a single text attachment.
    Procedure Attach_Text(p_Conn        In Out NoCopy Utl_Smtp.Connection,
                          p_Data        In Varchar2,
                          p_File_Name   In Varchar2 Default Null,
                          p_Mime_Type   In Varchar2,
                          p_Inline      In Boolean  Default True,
                          p_Last        In Boolean  Default True);

--  Send a binary attachment. The attachment will be encoded in Base-64 encoding format.
    Procedure Attach_Base64(p_Conn       In Out NoCopy Utl_Smtp.Connection,
                            p_Data       In Raw,
                            p_File_Name  In Varchar2 Default Null,
                            p_Mime_Type  In Varchar2 Default 'application/octet');

    Function Get_Address(p_Addr_List In Out Varchar2) Return Varchar2;

--  Validate an email address
    Function IsValid(p_Email_Address in varchar2) Return Boolean;

--  Creates the beginning of an HTML message and defines the table and body styles
    Function Create_HTML_Email(p_Text Varchar2 Default Null,
                               p_Font Varchar2 Default 'Tahoma') Return Varchar2;

    Function Create_HTML_Footer(p_Text Varchar2) Return Varchar2;

End Email_Pkg;
/
CREATE OR REPLACE Package Body CCPA.Email_Pkg Is

--  Customize the SMTP host, port And your domain name below.
    c_Smtp_Host       Constant Varchar2(256) := 'mx.budco.com';
    c_Smtp_Port       Constant Pls_Integer   := 25;
    c_Smtp_Domain     Constant Varchar2(256) := 'mx.budco.com';

--  Boundary is a unique string that demarcates boundaries of parts in a multi-part email.
--  The string should not appear inside the body of any part of the email.
    c_Boundary        Constant Varchar2(256) := 'E490B4868F18D186C8297BD5';
    c_Beg_Boundary    Constant Varchar2(256) := '--' || c_Boundary || Utl_Tcp.CrLf;
    c_End_Boundary    Constant Varchar2(256) := '--' || c_Boundary || '--' || Utl_Tcp.CrLf;

    c_Max_Base64_Line_Width Constant Pls_Integer   := 76 / 4 * 3;

--  Variables for Content-Type:
    c_Content_Type_Plain    Constant Varchar2(30) := 'text/plain; charset="us-ascii"';
    c_Content_Type_Html     Constant Varchar2(30) := 'text/html; charset="us-ascii"';
    c_Content_Type_Mixed    Constant Varchar2(15) := 'multipart/mixed';
    c_Content_Type_Rich     Constant Varchar2(15) := 'text/enriched';
    c_Content_Type_Alter    Constant Varchar2(25) := 'multipart/alternative';

    Procedure Smtp_Write_Data(p_Conn In Out NoCopy Utl_Smtp.Connection, p_Message Varchar2) Is
    Begin
        Utl_Smtp.Write_Data(p_Conn, p_Message);
    Exception
        When Others Then
            Dbms_Output.Put_line(SQLERRM);
            Raise_Application_Error(-20200, 'SMTP Write Data Error: ' || SQLERRM);
    End Smtp_Write_Data;


    Procedure Send(p_From       In Varchar2,
                   p_To         In Varchar2,
                   p_Subject    In Varchar2,
                   p_Message    In Clob,
                   p_Cc         In Varchar2 Default Null,
                   p_Bcc        In Varchar2 Default Null,
                   p_File_Name  In Varchar2 Default Null,
                   p_Directory  In Varchar2 Default Null,
                   p_Mime_Type  In Varchar2 Default 'H',
                   p_Priority   Pls_Integer Default Null) Is

        v_To        Varchar2(32767) := p_To;
        v_Cc        Varchar2(32767) := p_Cc;
        v_From      Varchar2(32767) := p_From;

    --  Customize the signature that will appear in the email's MIME header.
        v_Mailer    Varchar2(25) := 'Mailer by Oracle Utl_Smtp';

        v_Type      Varchar2(99);

        s_Conn      Utl_Smtp.Connection;

    Begin

    --  Open SMTP connection
        s_Conn := Utl_Smtp.Open_Connection(c_Smtp_Host, c_Smtp_Port);
        Utl_Smtp.Helo(s_Conn, c_Smtp_Domain);

    --  Start an email and specify sender's address
        Utl_Smtp.Mail(s_Conn, Get_Address(v_From));

    --  Specify email To: recipients.
        While (v_To Is Not Null) Loop
            Utl_Smtp.Rcpt(s_Conn, Get_Address(v_To));
        End Loop;

    --  Specify email Cc: recipients.
        While (v_Cc Is Not Null) Loop
            Utl_Smtp.Rcpt(s_Conn, Get_Address(v_Cc));
        End Loop;

    --  Start body of email
        Utl_Smtp.Open_Data(s_Conn);

        Smtp_Write_Data(s_Conn, 'From: ' || p_From  || Utl_Tcp.CrLf);
        Smtp_Write_Data(s_Conn, 'To: '   || p_To    || Utl_Tcp.CrLf);

        If p_Cc Is Not Null Then
            Smtp_Write_Data(s_Conn, 'Cc: '  || p_Cc  || Utl_Tcp.CrLf);
        End If;

        If p_Bcc Is Not Null Then
            Smtp_Write_Data(s_Conn, 'Bcc: ' || p_Bcc || Utl_Tcp.CrLf);
        End If;

        Smtp_Write_Data(s_Conn, 'Subject: ' || p_Subject   || Utl_Tcp.CrLf);

    --  Identify the content type
        Case
            When p_File_Name Is Not Null And p_Directory Is Not Null Then
            --  This appears to be a standard content type if an attachement is included
                v_Type := c_Content_Type_Mixed || '; boundary="' || c_Boundary || '"';
            When Upper(p_Mime_Type) = 'A' Then  v_Type := c_Content_Type_Alter;
            When Upper(p_Mime_Type) = 'H' Then  v_Type := c_Content_Type_Html;
            When Upper(p_Mime_Type) = 'M' Then  v_Type := c_Content_Type_Mixed;
            When Upper(p_Mime_Type) = 'P' Then  v_Type := c_Content_Type_Plain;
            When Upper(p_Mime_Type) = 'R' Then  v_Type := c_Content_Type_Rich;
            Else                                v_Type := c_Content_Type_Plain;
        End Case;

        Smtp_Write_Data(s_Conn, 'Content-Type: ' || v_Type || Utl_Tcp.CrLf);

        Smtp_Write_Data(s_Conn, 'X-Mailer: '    || v_Mailer    || Utl_Tcp.CrLf);

    --  Set priority: 1=High, 2, 3=Normal, 4, 5=Low
        If p_Priority Is Not Null Then
            Smtp_Write_Data(s_Conn, 'X-Priority:' || p_Priority || Utl_Tcp.CrLf);
            Case
                When p_Priority = 1 Then
                    Smtp_Write_Data(s_Conn, 'X-MSMail-Priority: High'   || Utl_Tcp.CrLf);
                When p_Priority = 5 Then
                    Smtp_Write_Data(s_Conn, 'X-MSMail-Priority: Low'    || Utl_Tcp.CrLf);
                Else
                    Smtp_Write_Data(s_Conn, 'X-MSMail-Priority: Normal' || Utl_Tcp.CrLf);
            End Case;
        End If;

    --  Send an empty line to denotes end of MIME headers and beginning of message body.
        Smtp_Write_Data(s_Conn, Utl_Tcp.CrLf);

        If Upper(p_Mime_Type) = 'M' Then
            Smtp_Write_Data(s_Conn, 'This is a multi-part message in MIME format.' || Utl_Tcp.CrLf);
        End If;

    --  Attach a file if both params are passed
        If p_File_Name Is Not Null And p_Directory Is Not Null Then

            Attach_Text(p_Conn      => s_Conn,
                        p_Data      => DBMS_Lob.Substr(p_Message,32765,1),
                        p_Mime_Type => c_Content_Type_Html,  
                        p_Last      => False);

            Attach_Oracle_File(p_Conn      => s_Conn,
                               p_Directory => p_Directory,
                               p_File_Name => p_File_Name,
                               p_Mime_Type => c_Content_Type_Mixed);
        Else
        --  Write the message
            If Length(p_Message) > 32765 Then
            --  Utl_Smtp.Write_Data has a varchar2 datatype which is limited to 32,767 chars.
                Smtp_Write_Data(s_Conn, DBMS_Lob.Substr(p_Message,32765,1));
                Smtp_Write_Data(s_Conn, DBMS_Lob.Substr(p_Message,32765,32766));
            Else
                Smtp_Write_Data(s_Conn, p_Message);
            End If;
        End If;


    --  End the email session.
        Utl_Smtp.Close_Data(s_Conn);

    --  Close the smtp connection.
        Utl_Smtp.Quit(s_Conn);

    Exception
        When Utl_Smtp.Invalid_Operation Then
            Dbms_Output.Put_line('Send: Invalid Operation.');
            Dbms_Output.Put_line(SQLERRM);
            Utl_Smtp.Quit(s_Conn);
        When Utl_Smtp.Transient_Error Then
            Dbms_Output.Put_line('Send: Temporary transient error.');
            Dbms_Output.Put_line(SQLERRM);
            Utl_Smtp.Quit(s_Conn);
        When Utl_Smtp.Permanent_Error Then
            Dbms_Output.Put_line('Send: Permanent server error.');
            Dbms_Output.Put_line(SQLERRM);
            Utl_Smtp.Quit(s_Conn);
        When Others Then
            Dbms_Output.Put_line(SQLERRM);
            Utl_Smtp.Quit(s_Conn);
    End Send;


    Procedure Begin_Attachment(p_Conn         In Out NoCopy Utl_Smtp.Connection,
                               p_Mime_Type    In Varchar2,
                               p_File_Name    In Varchar2,
                               p_Inline       In Boolean  Default True,
                               p_Transfer_Enc In Varchar2 Default Null) Is
    /*  Send an attachment with no size limit. First, begin the attachment with Begin_Attachment().
        Then, call Utl_Smtp.Write_Data() repeatedly to send the attachment piece-by-piece. If the
        attachment is text-based, but in non-ASCII or multi-byte character set, use
        Utl_Raw.Cast_To_Raw(p_Message) instead. To send binary attachment, the binary content
        should first be encoded in Base-64 encoding format using the demo package for 8i, or the
        native one in 9i.   */

        v_Data_Value    Varchar2(500);

    Begin

        Smtp_Write_Data(p_Conn, c_Beg_Boundary);

        Smtp_Write_Data(p_Conn, 'Content-Type: ' || p_Mime_Type || Utl_Tcp.CrLf);

        If  p_File_Name Is Not Null  Then   --  Determine the content disposition
            If  p_Inline  Then
                v_Data_Value := v_Data_Value || 'inline; filename="'||p_File_Name||'"';
            Else
                v_Data_Value := v_Data_Value || 'attachment; filename="'||p_File_Name||'"';
            End If;
            v_Data_Value := 'Content-Disposition: ' || v_Data_Value;
            Smtp_Write_Data(p_Conn, v_Data_Value || Utl_Tcp.CrLf);
        End If;

        If  p_Transfer_Enc Is Not Null  Then
            Smtp_Write_Data(p_Conn, 'Content-Transfer-Encoding: ' || p_Transfer_Enc || Utl_Tcp.CrLf);
        End If;

        Smtp_Write_Data(p_Conn, Utl_Tcp.CrLf);

    Exception
        When Others Then
            Dbms_Output.Put_line(SQLERRM);
    End Begin_Attachment;


    Procedure Attach_Oracle_File(p_Conn       In Out NoCopy Utl_Smtp.Connection,
                                 p_Directory  In Varchar2,
                                 p_File_Name  In Varchar2,
                                 p_Mime_Type  In Varchar2) Is

        v_File          Utl_File.File_Type;
        v_Line          Varchar2(4000);

    Begin

        Begin_Attachment(p_Conn      => p_Conn,
                         p_Mime_Type => p_Mime_Type,
                         p_Inline    => False,
                         p_File_Name => p_File_Name);

        v_File := Utl_File.FOpen(p_Directory, p_File_Name, 'R');

        Loop
            Begin
                Utl_File.Get_Line(v_File, v_Line);
                Utl_Smtp.Write_Data(p_Conn, v_Line||Chr(10));
            Exception
              When No_Data_Found Then Exit;
              When Others Then
                Dbms_Output.Put_Line('Attach Ora File - Smtp Write Block: ' || SQLERRM);
            End;
        End Loop;

    --  End the attachment
        Smtp_Write_Data(p_Conn, Utl_Tcp.CrLf);
        Smtp_Write_Data(p_Conn, c_End_Boundary);

        Utl_File.FClose(v_File);

    Exception
        When Others Then
            Dbms_Output.Put_Line('Attach Oracle File: ' || SQLERRM);
            Utl_File.FClose(v_File);
    End Attach_Oracle_File;


    Procedure Attach_Text(p_Conn        In Out NoCopy Utl_Smtp.Connection,
                          p_Data        In Varchar2,
                          p_File_Name   In Varchar2 Default Null,
                          p_Mime_Type   In Varchar2,
                          p_Inline      In Boolean  Default True,
                          p_Last        In Boolean  Default True) Is
    Begin

        Begin_Attachment(p_Conn      => p_Conn,
                         p_File_Name => p_File_Name,
                         p_Mime_Type => p_Mime_Type,
                         p_Inline    => p_Inline);

        Smtp_Write_Data(p_Conn, p_Data);

    --  End the attachment
        Smtp_Write_Data(p_Conn, Utl_Tcp.CrLf);

        If p_Last Then
            Smtp_Write_Data(p_Conn, c_End_Boundary);
        End If;

    Exception
        When Others Then
            Dbms_Output.Put_Line('Attach Text: ' || SQLERRM);
    End Attach_Text;


    Procedure Attach_Base64(p_Conn       In Out NoCopy Utl_Smtp.Connection,
                            p_Data       In Raw,
                            p_File_Name  In Varchar2 Default Null,
                            p_Mime_Type  In Varchar2 Default 'application/octet') Is

        v_Chunk_Data   Varchar2(57);    --  equals value of c_Max_Base64_Line_Width

        i_Chunk_Size   Pls_Integer := 1;
        i_Data_Length  Pls_Integer := Utl_Raw.Length(p_Data);

    Begin

        Begin_Attachment(p_Conn         => p_Conn,
                         p_Mime_Type    => p_Mime_Type,
                         p_Inline       => False,
                         p_File_Name    => p_File_Name,
                         p_Transfer_Enc => 'base64');

    --  Split the Base64-encoded attachment into multiple lines
        While i_Chunk_Size < i_Data_Length Loop

            If i_Chunk_Size + c_Max_Base64_Line_Width < i_Data_Length Then
               v_Chunk_Data := Utl_Raw.SubStr(p_Data, i_Chunk_Size, c_Max_Base64_Line_Width);
            Else
               v_Chunk_Data := Utl_Raw.SubStr(p_Data, i_Chunk_Size);
            End If;

            Utl_Smtp.Write_Raw_Data(p_Conn, Utl_Encode.Base64_Encode(v_Chunk_Data));
            Utl_Smtp.Write_Data(p_Conn, Utl_Tcp.CrLf);

            i_Chunk_Size := i_Chunk_Size + c_Max_Base64_Line_Width;
        End Loop;

    --  End the attachment
        Utl_Smtp.Write_Data(p_Conn, Utl_Tcp.CrLf);
        Utl_Smtp.Write_Data(p_Conn, c_End_Boundary);

    Exception
        When Others Then
            Dbms_Output.Put_Line('Attach Base64: ' || SQLERRM);
    End Attach_Base64;


    Function Get_Address(p_Addr_List In Out Varchar2) Return Varchar2 Is
    /*  Return the first email address from a list of email addresses that may be
        separated by either a "," or a ";".  The format may be in any of these:
        someone@some-domain,  "Someone at some domain" <someone@some-domain>
        Someone at some domain <someone@some-domain>                              */

        v_Address   Varchar2(256);
        i_Count     Pls_Integer;

        Function Lookup_Unquoted_Char(p_String In Varchar2,
                                      p_Chars  In Varchar2)  Return Pls_Integer As

            v_Char          Varchar2(5);
            i_Cntr          Pls_Integer;
            i_Len           Pls_Integer;
            b_Inside_Quote  Boolean;

        Begin

            i_Cntr := 1;
            i_Len := Length(p_String);
            b_Inside_Quote := False;

            While (i_Cntr <= i_Len) Loop
                v_Char := SubStr(p_String, i_Cntr, 1);

                If b_Inside_Quote Then
                    If v_Char = '"' Then
                        b_Inside_Quote := False;
                    Elsif v_Char = '\' Then
                        i_Cntr := i_Cntr + 1;     -- Skip the quote character
                    End If;
                    GoTo NEXT_CHAR;
                End If;

                If v_Char = '"' Then
                    b_Inside_Quote := True;
                    GoTo NEXT_CHAR;
                End If;

                If InStr(p_Chars, v_Char) >= 1 Then
                    Return i_Cntr;
                End If;

                <<NEXT_CHAR>>

                i_Cntr := i_Cntr + 1;
            End Loop;

            Return 0;

        End Lookup_Unquoted_Char;

    Begin

        p_Addr_List := LTrim(p_Addr_List);

        i_Count := Lookup_Unquoted_Char(p_Addr_List, ',;');

        If  i_Count >= 1 Then
            v_Address   := SubStr(p_Addr_List, 1, i_Count - 1);
            p_Addr_List := SubStr(p_Addr_List, i_Count + 1);
        Else
            v_Address := p_Addr_List;
            p_Addr_List := '';
        End If;

        i_Count := Lookup_Unquoted_Char(v_Address, '<');

        If  i_Count >= 1  Then
            v_Address := SubStr(v_Address, i_Count + 1);
            i_Count := InStr(v_Address, '>');
            If  i_Count >= 1  Then
                v_Address := SubStr(v_Address, 1, i_Count - 1);
            End If;
        End If;

        Return v_Address;

    End Get_Address;


    Function IsValid(p_Email_Address in varchar2) Return Boolean Is

       RegExp_Str Varchar2(1000) := '^[a-z0-9!#$%&''*+/=?^_`{|}~-]+(\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+([A-Z]{2}|arpa|biz|com|info|intww|name|net|org|pro|aero|asia|cat|coop|edu|gov|jobs|mil|mobi|museum|pro|tel|travel|post)$';

    Begin

        If RegExp_Like(p_Email_Address, RegExp_Str, 'i') then
            Return True;
        Else
            Return False;
        End If;

    Exception
        When Others Then
            Return False;
    End IsValid;


    Function Create_HTML_Email(p_Text Varchar2 Default Null,
                               p_Font Varchar2 Default 'Tahoma') Return Varchar2 Is

        v_Email  Clob;

    Begin

    --  Some email clients need additional space, so use width: 98% to accomodate.
        v_Email := '<html><head></head>' || Chr(10) ||
                   '<body style="font-family:' || p_Font ||'; font-size:10pt" >' || Chr(10) ||
                   '<style>'|| Chr(10) ||
                   '#datatable {' || Chr(10) ||
                   '  font-family: ' || p_Font ||', Calibri;' || Chr(10) ||
                   '  width: 100%;' || Chr(10) ||
                   '  border-collapse: collapse;}' || Chr(10) ||
                   '#datatable td, #datatable th {' || Chr(10) ||
                   '  font-size: 10pt;' || Chr(10) ||
                   '  border: 1px solid black;}' || Chr(10) ||
               /*  '  text-align: left;}' || Chr(10) ||   */
                   '</style>' || Chr(10) ||
                   p_Text;

        Return v_Email;

    End Create_HTML_Email;


    Function Create_HTML_Footer(p_Text Varchar2) Return Varchar2 Is

        v_Footer  Varchar2(500);

    Begin

        v_Footer := '<br><br><hr><font face="Calibri" size="2">' ||
                    '<i>' || p_Text || '</i></font><br>';
               /*   'About This Email<br>'
                    'This is an automated email. If you have any questions please Contact Krissy Varney.<br>'
                    'If you no longer wish to receive these particular messages via e-mail you may unsubscribe at any time, but good luck with that :)<br>'
                    'This message, including any attachments, is confidential and/or proprietary to Dialog Direct¿ and should be read or retained only by the intended recipient. If you have received it in error, please notify the sender immediately and delete the original message.<br>'
                    '2014 Dialog Direct'

<div style="font-family:Arial,Tahoma,Helvetica,sans-serif; font-size:12px; padding:10px" >
    <font color=#3399FF><b>DIALOG</b></font><font color=#000099><b>DIRECT </b></font>
    <font color=#000000> 2014 <i>TMP730 New Tempo Task Summary run by efabian on BUDX from bpdb-nb3</i></font>
</div>
                */

        Return v_Footer;

    End Create_HTML_Footer;

End Email_Pkg;
/
