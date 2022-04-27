using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace Regeneron.IVR
{
    public class App
    { 

        public static string ConnectionString { get { return WebConfigurationManager.ConnectionStrings["Main"].ConnectionString; } }
        public static string EmailSvcUrl { get { return WebConfigurationManager.AppSettings["email_svc_url"]; } }
        public static string EmailSvcUser { get { return WebConfigurationManager.AppSettings["email_svc_user"]; } }
        public static string EmailSvcPassword { get { return WebConfigurationManager.AppSettings["email_svc_password"]; } }

        public static string EmailName { get { return WebConfigurationManager.AppSettings["email_name"]; } }
        public static string EmailId { get { return WebConfigurationManager.AppSettings["email_id"]; } }
        public static string EmailSendFromUserId { get { return WebConfigurationManager.AppSettings["email_send_from_user_id"]; } }
    }
}