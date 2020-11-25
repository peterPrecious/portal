using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.Services;

namespace portal.services
{
  [WebService(Namespace = "http://vubiz.com/")]
  [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
  [System.ComponentModel.ToolboxItem(false)]
  // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
  // [System.Web.Script.Services.ScriptService]
  public class accountManagement : System.Web.Services.WebService
  {




    #region Description
    [WebMethod(Description = "<br>" +
      "Changes a User Id ('Password' in V5) using parameters:<ol>" +
      "<li>membAcctId - Account Id in the form 1234</li>" +
      "<li>membOldId - Existing User Id</li>" +
      "<li>membNewId - New User Id</li>" +
      "</ol><br>Returns one of:<br> {" +
      "<br>'statusNumber':'200','statusDescription':'Password Successfully Updated.'" +
      "<br>'statusNumber':'430','statusDescription':'The New and Old User Ids are the same.'" +
      "<br>'statusNumber':'431','statusDescription':'The Account Id is not valid.'" +
      "<br>'statusNumber':'432','statusDescription':'The New User Id already exists.'" +
      "<br>'statusNumber':'433','statusDescription':'The Old User Id  does NOT exist.'" +
      "<br>'statusNumber':'434','statusDescription':'The Old User Id must be an Active Learner or Facilitator.'" +
      "<br>'statusNumber':'435','statusDescription':'The New User Id is not valid.'" +
      "<br>'statusNumber':'436','statusDescription':'The Old User Id is not valid.'" +
      "<br>}")]
    #endregion
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

        case "430": statusDescription = "The New and Old User Ids are the same."; break;
        case "431": statusDescription = "The Account Id is not valid."; break;
        case "432": statusDescription = "The New User Id already exists."; break;
        case "433": statusDescription = "The Old User Id does NOT exist."; break;
        case "434": statusDescription = "The Old User Id must be an Active Learner or Facilitator."; break;
        case "435": statusDescription = "The New User Id is not valid."; break;
        case "436": statusDescription = "The Old User Id is not valid."; break;
      }

      Dictionary<string, string> values = new Dictionary<string, string>
      {
        { "statusNumber", statusNumber },
        { "statusDescription", statusDescription }
      };

      //  return ("biteme");

      return convertDicToJSON((Dictionary<string, string>)values, false);
    }



    #region Description
    [WebMethod(Description = "<br>" +
      "Returns key profile and history data for a Learner using parameters:<ol>" +
      "<li>custId - Customer Id in the form ABCD1234</li>" +
      "<li>membId - Unique User Id</li>" +
      "</ol><br>Returns one JSON string for member data and another for the program data:<br><br> {" +
      "<br>'member': {'isParent':'True', 'membId':'UNIQUEME', 'firstName':'Joseph', 'lastName':'Blow', 'email':'jblow@email.com', 'guid':'c14ac0a1-2d6a-404c-8af4-3a82b3a50941', 'firstVisit':'3/24/2014 12:00:00 AM', 'lastVisit':'8/20/2018 2:39:00 PM', 'noVisits':'461'}, " +
      "<br>'programs': [{'progId':'P1687EN','progNo':'2814','progTitle':'WHMIS for Workers 2015','progStatus':'not started'},{'progId':'P1324EN','progNo':'693','progTitle':'WHMIS for Workers 2016','progStatus':'not started'}]" +
      "<br>}")]
    #endregion
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

          // added const "V" to return the proper values if there are not result2 (programs) - previously just returned "[" for some reason.  Friday Nov 13, 2020
          const string V = "[]";

          if (drd.HasRows)
          {
            result1 = convertSqlToJSON(drd, false);
            drd.NextResult();
            result2 = convertSqlToJSON(drd, true);
            if (!drd.HasRows)
            {
              result2 = V;
            }
            result = "{\"member\": " + result1 + ", \"programs\": " + result2 + "}";
          }

          con.Close();
          return (result);
        }
      }
    }



    //[WebMethod]
    //public string ecomSignIn(string ecomId, string ecomPwd)
    //{
    //  using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
    //  {
    //    con.Open();
    //    using (SqlCommand cmd = new SqlCommand())
    //    {
    //      cmd.CommandTimeout = 100;
    //      cmd.Connection = con;
    //      cmd.CommandText = "dbo.sp7ecomSignIn";
    //      cmd.CommandType = CommandType.StoredProcedure;
    //      cmd.Parameters.Add(new SqlParameter("@ecomId", ecomId));
    //      cmd.Parameters.Add(new SqlParameter("@ecomPwd", ecomPwd));

    //      SqlDataReader drd = cmd.ExecuteReader();
    //      string result = null;
    //      if (drd.HasRows) result = convertSqlToJSON(drd, false);
    //      con.Close();
    //      return (result);
    //    }
    //  }
    //}



    //[WebMethod(Description = "")]
    //public string ecomAccountGet(string ecomGuid)
    //{
    //  using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
    //  {
    //    con.Open();
    //    using (SqlCommand cmd = new SqlCommand())
    //    {
    //      cmd.CommandTimeout = 100;
    //      cmd.Connection = con;
    //      cmd.CommandText = "dbo.sp7ecomAccountGet";
    //      cmd.CommandType = CommandType.StoredProcedure;
    //      cmd.Parameters.Add(new SqlParameter("@ecomGuid", ecomGuid));

    //      SqlDataReader drd = cmd.ExecuteReader();
    //      string result = null;
    //      if (drd.HasRows) result = convertSqlToJSON(drd, false);
    //      con.Close();
    //      return (result);
    //    }
    //  }
    //}



    #region Description
    [WebMethod(Description = "<br>" +
      "Checks the V5 Member DataBase using parameters:<ol>" +
      "<li>custId - Customer Id in the form ABCD1234</li>" +
      "<li>membId - User Id</li>" +
      "</ol><br>Returns 'isMember':'1' if learner is active, else 'ismember':'0")]
    #endregion
    public string isV5Member(string custId, string membId)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp8IsV5member";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.Add(new SqlParameter("@membId", membId));

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