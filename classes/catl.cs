using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace portal
{
  public class Catl
  {
    #region Fields
    public int catlNo, catlParentNo, catlOrder;
    public string catlCustId, catlTitle, catlPromo, catlPrograms, catlTileColor, catlTileIcon, catlJITNo;
    public bool catlActive;

    public bool catlEof;
    #endregion

    //  Get Catl No for a specific program
    public int catalogueNo(string custId, string progId)
    {
      catlNo = 0;

      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6catalogueNo";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.Add(new SqlParameter("@progId", progId));
          SqlDataReader drd = cmd.ExecuteReader();
          while (drd.Read())
          {
            catlNo = Convert.ToInt32(drd["catlNo"]);
          }
          drd.Close();
        }
      }
      return (catlNo);
    }


    public void catalogueReCreate(string newCustId)  // delete and recreate the Group2 catalogue
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6catalogueRecreate";
          cmd.Parameters.Clear();
          cmd.Parameters.Add(new SqlParameter("@newCustId", newCustId));
          cmd.ExecuteNonQuery();
        }
      }

    }

    public string stripString(string programString)
    {
      // strip programId from program string
      string[] temp = programString.Split(' ');
      for (int i = 0; i < temp.Length; i++) temp[i] = fn.left(temp[i], 7);
      return string.Join(" ", temp);
    }

    public bool exists(string program, string[] programs)
    {
      if (programs == null) return false;
      // if the new Program is on the Old list then we don't need to add again
      foreach (string programId in programs) if (programId == program) return true;
      return false;
    }

    public int catalogueProgramExpires(string custId, string progId) //  Get Catl expiry for specific program - specified in days in the Catl_Programs string
    {
      string catlPrograms = "";
      int expireDays = 90; // use this if no hit

      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6catalogueProgram";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.Add(new SqlParameter("@progId", progId));
          SqlDataReader drd = cmd.ExecuteReader();
          while (drd.Read())
          {
            catlPrograms = drd["Catl_Programs"].ToString();
          }
          drd.Close();
        }
        //con.Close();
      }


      // extract the program from the string then from that extract the expire days
      string[] progs = catlPrograms.Split(' ');
      foreach (string progString in progs)
      {
        string[] bits = progString.Split('~');
        if (bits[0] == progId) // this is the programId
        {
          return (Convert.ToInt32(bits[4])); // this is the number of days
        }
      }
      return (expireDays);
    }
  }

}