using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace portal
{
  public class Prof
  {
    // profile db fields
    public int profileId = 0;
    public string profileProfile, profileParameter, profileValue;

    // parameter db fields
    public int parameterId = 0;
    public string parameterName, parameterDesc;

    public void parameterDescByName(string parameterName, out string parameterDesc)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7parameterDescByName";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@parameterName", parameterName));
          cmd.Parameters.Add("@parameterDesc", SqlDbType.VarChar, 2000).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          parameterDesc = cmd.Parameters["@parameterDesc"].Value.ToString();
        }
      }
    }

    public void profileValueByParameter(string profile, string parameter, out string value)
    { // not sure this is used
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7profileValueByParameter";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@profile", profile));
          cmd.Parameters.Add(new SqlParameter("@parameter", parameter));
          cmd.Parameters.Add("@value", SqlDbType.VarChar, 2000).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          value = cmd.Parameters["@value"].Value.ToString();
        }
      }
    }

  }
}