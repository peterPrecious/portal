using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace portal.services
{
  public class vuAcct : vuAcctI
  {

    public string phpTest(string name)
    {
      return "hi " + name;
    }

    public string changePassword(string membAcctId, string membOldId, string membNewId)
    {

      string statusNumber = null, statusDescription = null;

      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6memberChangeId";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@membAcctId", membAcctId));
          cmd.Parameters.Add(new SqlParameter("@membNewId", membNewId));
          cmd.Parameters.Add(new SqlParameter("@membOldId", membOldId));

          SqlParameter returnValue = new SqlParameter("@Return_Value", DbType.Int32)
          {
            Direction = ParameterDirection.ReturnValue
          };
          cmd.Parameters.Add(returnValue);
          cmd.ExecuteNonQuery();
          statusNumber = cmd.Parameters["@Return_Value"].Value.ToString();

          con.Close();
        }
      }
      switch (statusNumber)
      {
        case "200": statusDescription = "Password Successfully Updated."; break;

        case "430": statusDescription = "The New and Old Passwords are the same."; break;
        case "431": statusDescription = "The Account Id is not valid."; break;
        case "432": statusDescription = "The New Password already exists."; break;
        case "433": statusDescription = "The Old Password does NOT exist."; break;
        case "434": statusDescription = "The Old Password must be an Active Learner or Facilitator."; break;
        case "435": statusDescription = "The New Password is not valid."; break;
        case "436": statusDescription = "The Old Password is not valid."; break;
      }

      Dictionary<string, string> values = new Dictionary<string, string>
      {
        { "statusNumber", statusNumber },
        { "statusDescription", statusDescription }
      };

      //  return ("biteme");

      return convertDicToJSON((Dictionary<string, string>)values, false);
    }

    public string memberStatus(string custId, string membId)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6memberStatus";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.Add(new SqlParameter("@membId", membId));

          SqlDataReader drd = cmd.ExecuteReader();
          string result = null, result1 = null, result2 = null;
          if (drd.HasRows)
          {
            result1 = convertSqlToJSON(drd, false);
            drd.NextResult();
            result2 = convertSqlToJSON(drd, true);

            result = "{\"member\": " + result1 + ", \"programs\": " + result2 + "}";
          }

          con.Close();
          return (result);
        }
      }
    }

    public string ecomSignIn(string ecomId, string ecomPwd)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7ecomSignIn";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@ecomId", ecomId));
          cmd.Parameters.Add(new SqlParameter("@ecomPwd", ecomPwd));

          SqlDataReader drd = cmd.ExecuteReader();
          string result = null;
          if (drd.HasRows) result = convertSqlToJSON(drd, false);
          con.Close();
          return (result);
        }
      }
    }

    public string ecomAccountGet(string ecomGuid)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7ecomAccountGet";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@ecomGuid", ecomGuid));

          SqlDataReader drd = cmd.ExecuteReader();
          string result = null;
          if (drd.HasRows) result = convertSqlToJSON(drd, false);
          con.Close();
          return (result);
        }
      }
    }


    private string convertSqlToJSON(SqlDataReader reader, bool isArray)
    {
      // this is a general routine used in v8client.asmx.cs and v8clientserver.asmx.cs to render properly formatted JSON
      // the isArray, when true will add [] around the objects, else it will not

      if (reader == null || reader.FieldCount == 0)
      {
        return "null";
      }
      int rowCount = 0;
      StringBuilder sb = new StringBuilder();
      if (isArray) { sb.Append("["); };
      while (reader.Read())
      {
        sb.Append("{");
        for (int i = 0; i < reader.FieldCount; i++)
        {
          sb.Append("\"" + reader.GetName(i) + "\":");
          sb.Append("\"" + reader[i] + "\"");
          sb.Append(i == reader.FieldCount - 1 ? "" : ",");
        }
        sb.Append("},");
        rowCount++;
      }
      if (rowCount > 0)
      {
        int index = sb.ToString().LastIndexOf(",");
        sb.Remove(index, 1);
        if (isArray) { sb.Append("]"); };
      }

      //return Encoding.UTF8.GetString(Encoding.UTF8.GetBytes(sb.ToString()));     
      return sb.ToString();
    }

    private string convertDicToJSON(Dictionary<string, string> values, bool isArray)
    {
      // this takes a dictionary array or name/pairs and returns JSON
      // it does NOT handle arrays

      StringBuilder sb = new StringBuilder();
      sb.Append("{");

      int valCount = 0;
      foreach (KeyValuePair<string, string> kvp in values)
      {
        valCount++;
        if (valCount > 1) sb.Append(",");
        sb.Append("\"" + kvp.Key + "\":\"" + kvp.Value + "\"");
      }

      // if there are no pairs then return null
      if (valCount == 0)
      {
        return "null";
      }
      // else close the JSON string and return
      else
      {
        sb.Append("}");
        return sb.ToString();
      }


    }
  }
}
