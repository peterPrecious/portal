using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace portal
{
  public class Apps
  {
    public SqlDataReader lang() // Get Apps lang values (used to test excel)
    {
      SqlDataReader drd = null;
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "apps.dbo.sp7lang";
          cmd.CommandType = CommandType.StoredProcedure;
          drd = cmd.ExecuteReader();
          return (drd);
        }
      }
    }

    public string token(int minutes) // see if this account has a v8 profile
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp8tokenSet2";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@minutes", minutes));
          cmd.Parameters.Add("@guid", SqlDbType.VarChar, 38).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          string token = cmd.Parameters["@guid"].Value.ToString();
          return (token);
        }
      }
    }

    public string password(bool isNop, string ecomId) // If NOP then get the password from the apps/ecomRegister table
    {
      if (!isNop)
      {
        return (null);
      }
      else
      { // get password from apps.ecomRegister (assumes account isNop)
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
        {
          con.Open();
          using (SqlCommand cmd = new SqlCommand())
          {
            cmd.Connection = con;
            cmd.CommandText = "dbo.sp7ecomPassword";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@ecomId", ecomId));
            cmd.Parameters.Add("@ecomPwd", SqlDbType.VarChar, 64).Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            string password = cmd.Parameters["@ecomPwd"].Value.ToString();
            return (password);
          }
        }
      }
    }

    public void saveNopReturnUrl(string membGuid, string returnUrl, string childId) // If NOP store the returnURL so we can get back with the childId for future editting
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7saveNopReturnUrl";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@membGuid", membGuid));
          cmd.Parameters.Add(new SqlParameter("@returnUrl", returnUrl));
          cmd.Parameters.Add(new SqlParameter("@childId", childId));
          cmd.ExecuteNonQuery();
        }
      }
    }

    public void saveNopReturnUrlAdmin(string ecomId, string storeId, string returnUrl) // If NOP ADMIN store the returnURL so we can get back with the childId for future editting
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7saveNopReturnUrlAdmin";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@ecomId", ecomId));
          cmd.Parameters.Add(new SqlParameter("@storeId", storeId));
          cmd.Parameters.Add(new SqlParameter("@returnUrl", returnUrl));
          cmd.ExecuteNonQuery();
        }
      }
    }


    public void getNopReturnUrl(string ecomId, out string nopReturnUrl) // used in for the Store tile
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7nopReturnUrl";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@ecomId", ecomId));
          cmd.Parameters.Add("@nopReturnUrl", SqlDbType.VarChar, 2000).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();

          nopReturnUrl = cmd.Parameters["@nopReturnUrl"].Value.ToString();
        }
      }
    }

    public void resetLearnerProgramAssignment(int membNo) // called by learners.aspx to resend initial email alerts
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7resetLearnerProgramAssignment";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@membNo", membNo));
          cmd.ExecuteNonQuery();
        }
      }
    }


  }
}