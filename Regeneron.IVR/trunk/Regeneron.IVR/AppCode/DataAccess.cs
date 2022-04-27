using System;
using System.Collections.Generic;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using Dapper.Data;
using System.Linq;

namespace Regeneron.IVR
{
    public class DataAccess
    {
        public static DapperDb dprDb = new DapperDb(App.ConnectionString);

        
        public static void Save(Controllers.RequestViewModel vm)
        {
            var p = new OracleDynamicParameters();
            p.Add("p_TITLE", vm.Title, dbType: OracleDbType.Varchar2);
            p.Add("p_FIRST_NAME", vm.FirstName, dbType: OracleDbType.Varchar2);
            p.Add("p_LAST_NAME", vm.LastName, dbType: OracleDbType.Varchar2);
            p.Add("p_EMAIL", vm.Email, dbType: OracleDbType.Varchar2);
            p.Add("p_ADDRESS_1", vm.Address1, dbType: OracleDbType.Varchar2);
            p.Add("p_ADDRESS_2", vm.Address2, dbType: OracleDbType.Varchar2);
            p.Add("p_CITY", vm.City, dbType: OracleDbType.Varchar2);
            p.Add("p_STATE", vm.State, dbType: OracleDbType.Varchar2);
            p.Add("p_ZIP", vm.Zip, dbType: OracleDbType.Varchar2);
            p.Add("p_QUANTITY", vm.Quantity, dbType: OracleDbType.Varchar2);
            p.Add("p_EMAIL_OPT_FLAG", vm.SendViaEmail ? "Y" : "N", dbType: OracleDbType.Varchar2);
            p.Add("p_MAIL_OPT_FLAG", vm.SendViaMail ? "Y" : "N", dbType: OracleDbType.Varchar2);

            dprDb.Execute("regmdr.Web_DI_Pkg.Save_Contact", p, CommandType.StoredProcedure);
        }

        public class DapperDb : DbContext
        {

            public DapperDb(string conn)
                : base(new ConFactory(conn))
            {
            }

            protected class ConFactory : System.Data.Common.IDbConnectionFactory
            {
                private readonly string connStr;

                public ConFactory(string conn)
                {
                    connStr = conn;
                }

                IDbConnection System.Data.Common.IDbConnectionFactory.Create()
                {
                    return new OracleConnection(connStr);
                }

                IDbConnection System.Data.Common.IDbConnectionFactory.CreateAndOpen()
                {
                    OracleConnection conn = new OracleConnection(connStr);
                    conn.Open();
                    return conn;
                }
            }
        }
    }
}