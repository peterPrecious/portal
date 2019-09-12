using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.Text;


namespace portal.services
{
  [ServiceContract(Namespace = "")]
  [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
  public class kendoUI
  {
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString);

    [OperationContract]
    public string sp7customerActivityChart()
    {
      con.Open();
      SqlCommand cmd = new SqlCommand
      {
        Connection = con,
        CommandText = "[apps].[dbo].[sp7customerActivityChart]",
        CommandType = CommandType.StoredProcedure
      };
      SqlDataReader drd = cmd.ExecuteReader();
      string result = "null";
      if (drd.HasRows)
      {
        result = convertToJSON(drd, true);
      }
      con.Close();
      return (result);
    }

    [OperationContract]
    public string sp7customerSalesDetailsChart(int IntParm0, string DatParm0, string DatParm1) // get customer sales
    {
      con.Open();
      SqlCommand cmd = new SqlCommand
      {
        Connection = con,
        CommandText = "[apps].[dbo].[sp7customerSalesDetailsChart]",
        CommandType = CommandType.StoredProcedure
      };

      cmd.Parameters.Add(new SqlParameter("@IntParm0", IntParm0));
      cmd.Parameters.Add(new SqlParameter("@DatParm0", DatParm0));
      cmd.Parameters.Add(new SqlParameter("@DatParm1", DatParm1));

      SqlDataReader drd = cmd.ExecuteReader();
      string result = "null";
      if (drd.HasRows)
      {
        result = convertToJSON(drd, true);
      }
      con.Close();
      return (result);
    }

    [OperationContract]
    public string sp7customerSalesChart(int IntParm0)
    {
      con.Open();
      SqlCommand cmd = new SqlCommand
      {
        Connection = con,
        CommandText = "[apps].[dbo].[sp7customerSalesChart]",
        CommandType = CommandType.StoredProcedure
      };

      cmd.Parameters.Add(new SqlParameter("@IntParm0", IntParm0));

      SqlDataReader drd = cmd.ExecuteReader();
      string result = "null";
      if (drd.HasRows)
      {
        result = convertToJSON(drd, true);
      }
      con.Close();
      return (result);
    }

    [OperationContract]
    public string sp7customerSalesAnnualChart(string StrParm0)
    {
      con.Open();
      SqlCommand cmd = new SqlCommand
      {
        Connection = con,
        CommandText = "[apps].[dbo].[sp7customerSalesAnnualChart]",
        CommandType = CommandType.StoredProcedure
      };

      cmd.Parameters.Add(new SqlParameter("@StrParm0", StrParm0));

      SqlDataReader drd = cmd.ExecuteReader();
      string result = "null";
      if (drd.HasRows)
      {
        result = convertToJSON(drd, true);
      }
      con.Close();
      return (result);
    }

    [OperationContract]
    public string sp7moduleUsageChart()
    {
      con.Open();
      SqlCommand cmd = new SqlCommand
      {
        Connection = con,
        CommandText = "[apps].[dbo].[sp7moduleUsageChart]",
        CommandType = CommandType.StoredProcedure
      };
      SqlDataReader drd = cmd.ExecuteReader();
      string result = "null";
      if (drd.HasRows)
      {
        result = convertToJSON(drd, true);
      }
      con.Close();
      return (result);
    }


    private string convertToJSON(SqlDataReader reader, bool isArray)
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
  }
}
