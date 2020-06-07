using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace portal
{
  // these are static methods thus do not need to be instantiated in client
  public static class fn
  {
    #region General Functions

    public static bool IsNumeric(this string str)
    {
      try
      {
        Double.Parse(str.ToString());
        return true;
      }
      catch
      {
      }
      return false;
    }

    public static string scheme() // ie http, https, etc
    {
      return HttpContext.Current.Request.Url.Scheme.ToString();
    }
    public static string host() // ie www.mywebsite.com
    {
      return HttpContext.Current.Request.Url.Host.ToString();
    }

    public static string right(string original, int numberCharacters)
    {
      return original.Substring(original.Length - numberCharacters);
    }

    public static string left(string original, int numberCharacters)
    {
      return original.Length > numberCharacters ? original.Substring(0, numberCharacters) : original;
    }

    public static string leftPlus(string original, int numberCharacters)
    {
      return original.Length > numberCharacters ? original.Substring(0, numberCharacters) + "..." : original;
    }

    public static string nullToString(object value)
    {
      return value == null ? "" : value.ToString();
    }

    public static int length(object value)
    {
      string temp = nullToString(value);
      return temp.Length;
    }

    public static string fDefault(string value, string ifNoValue) // if null or empty return ifNoValue
    {
      value = value ?? "";
      return value == "" ? ifNoValue : value;
    }

    public static string fstrDefault(string value, string ifNoValue) // if null or empty return ifNoValue
    {
      return String.IsNullOrEmpty(value) ? ifNoValue : value;
    }

    public static int fintDefault(int value, int ifNoValue) // if zero return ifNoValue
    {
      return value == 0 ? ifNoValue : value;
    }

    public static string reQuote(string value) //  replace single and smart quotes with two single quotes so we don't screw up SQL (used to be called reQuote)
    {
      value = value ?? ""; // if null set to ""
//    value = value.Replace("“", "'").Replace("”", "'").Replace("‘", "'").Replace("’", "'").Replace("\"", "'").Replace("''", "'").Replace("'", "''");
      value = value.Replace("“", "'").Replace("”", "'").Replace("‘", "'").Replace("’", "'").Replace("\"", "'").Replace("''", "'"); // removed last replace Feb 2020 as double quotes where appearing the memb table
      return value;
    }

    public static string fFormatSqlDate(string value)
    {
      return value;
    }

    public static string coll(string value) // this separates the collection by pipes - ie programs
    {
      return value.Replace(", ", ",").Replace(",", "|");
    }

    public static string conc(string field, string value) // if original field value is empty then return value else add value separated by pipes
    {
      return (field == null) ? value : field + "|" + value;
    }

    public static bool missing(string coll)
    {
      string[] aColl = coll.Split('|');
      for (int i = 0; i < aColl.Length; i++)
      {
        if (aColl[i].Length == 0) return true;
      }
      return false;
    }

    public static DateTime dateDefault(DateTime dateIn, DateTime dateOut)
    {
      DateTime okDate;
      bool ok = DateTime.TryParse(dateIn.ToString(), out okDate);
      return (ok ? dateIn : dateOut);
    }
    #endregion

    #region Error Table

    // this is copied to documentation/ecomErrors.docx
    public static string err(int errNo, string parm1 = "", string parm2 = "", string parm3 = "")
    {
      string msg;
      switch (errNo)
      {
        case 200: msg = "200 Password Successfully Updated."; break; // this is only used for "P" transactions

        case 430: msg = "430 The New and Old Passwords are the same."; break;
        case 431: msg = "431 The Account Id is not valid."; break;
        case 432: msg = "432 The New Password already exists."; break;
        case 433: msg = "433 The Old Password does NOT exist."; break;
        case 434: msg = "434 The Old Password must be an Active Learner or Facilitator."; break;
        case 435: msg = "435 The New Password is not valid."; break;
        case 436: msg = "436 The Old Password is not valid."; break;
        case 486: msg = "486 Can only add a Learner if Account is auto-enroll."; break;

        case 443: msg = "443 Missing Action parameter, requires V (validate), C (commit) or P (new password)."; break;
        case 444: msg = "444 The service did not receive any form POST values to process."; break;
        case 467: msg = "467 No Programs have been selected."; break;

        case 450: msg = "450 Missing " + parm1 + "."; break;
        case 451: msg = "451 Invalid " + parm1 + "."; break;
        case 452: msg = "452 CustomerId " + parm1 + " is not a Parent account."; break;
        case 453: msg = "453 OrderId '" + parm1 + "' has already been posted (Account Id: " + parm2 + ", Password: " + parm3 + ")."; break;

        case 469: msg = "469 Service was accessed with an incorrect Transaction Type."; break;

        case 470: msg = "470 You are trying to Add On to a Group site that does not exist."; break;
        case 445: msg = "445 You are trying to Add On to a Parent site rather than a Group site."; break;

        case 446: msg = "446 You are trying to Add On to a Group site that has not been purchased."; break;
        case 471: msg = "471 You are trying to Add On to a Group site with a password that does not exist."; break;
        case 472: msg = "472 You are trying to Add On to a Group site with a password that is not assigned to a facilitator."; break;
        case 474: msg = "474 Line item is not extended properly."; break;
        case 475: msg = "475 Line item is not totalled properly."; break;

        case 473: msg = "473 Line item " + parm1 + " contained a invalid Program Id (" + parm2 + ")."; break;
        case 466: msg = "466 Line item " + parm1 + " contained a Program Id (" + parm2 + ") that is not in the current catalogue."; break;
        case 477: msg = "477 Line item " + parm1 + " must have a quantity of 1."; break;
        case 461: msg = "461 Line item " + parm1 + " cannot have a negative price (you can negate the quantity)."; break;
        case 478: msg = "478 Line item " + parm1 + " is not extended properly."; break;
        case 479: msg = "479 Line item " + parm1 + " is not totalled properly."; break;
        case 480: msg = "480 Line item " + parm1 + " in line item " + parm2 + " is not in the catalogue."; break;

        case 481: msg = "481 Quantities are not totalled properly."; break;
        case 482: msg = "482 GST is not totalled properly."; break;
        case 483: msg = "483 PST is not totalled properly."; break;
        case 484: msg = "484 HST is not totalled properly."; break;
        case 485: msg = "485 Extensions are not totalled properly."; break;

        case 490: msg = "490 Application Error ..." + parm1 + parm2; break;
        case 497: msg = "497 Unable to Generate Group Account (full) - Contact Systems."; break;
        case 498: msg = "498 Unable to Generate Group Account (" + parm1 + " used) - Contact Systems."; break;
        case 499: msg = "499 Group Services are temporarily suspended."; break;

        default: msg = "400 Unrecognized Error Number"; break;
      }
      return msg;

    }

    #endregion

    #region Logging

    public static long logXml(string xmldata) // log to Bryan's vuGold DB because other apps use this log
    {
      xmldata = xmldata.Replace("UTF-8", "UTF-16");
      xmldata = xmldata.Replace("utf-8", "UTF-16");

      long logNo;

      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "vuGold.dbo.spEcomTranInsert";
          cmd.CommandType = CommandType.StoredProcedure;

          SqlParameter parmXML = new SqlParameter();
          parmXML.DbType = System.Data.DbType.Xml;
          parmXML.Value = xmldata;
          parmXML.ParameterName = "@Tran";
          cmd.Parameters.Add(parmXML);

          SqlParameter parmID = new SqlParameter();
          parmID.Direction = System.Data.ParameterDirection.Output;
          parmID.ParameterName = "@TranID";
          parmID.DbType = System.Data.DbType.Int32;
          cmd.Parameters.Add(parmID);

          cmd.ExecuteNonQuery();

          logNo = Convert.ToInt64(parmID.Value);
        }
      }

      return logNo;

    }

    public static void logForm(long logNo, string formPost) // log to DB whatever form data was received (typically easier to read)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp5ecomForm";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@logNo", logNo));
          cmd.Parameters.Add(new SqlParameter("@dataIn", formPost));
          cmd.ExecuteNonQuery();
        }
      }
    }

    public static void logStep(bool bStep, long logNo, string logStep, string logMisc = null)
    {
      // log the logic step to DB
      if (bStep)
      {
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
        {
          con.Open();
          using (SqlCommand cmd = new SqlCommand())
          {
            cmd.CommandTimeout = 100;
            cmd.Connection = con;
            cmd.CommandText = "dbo.sp5ecomSteps";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@logNo", logNo));
            cmd.Parameters.Add(new SqlParameter("@logStep", logStep));
            cmd.ExecuteNonQuery();
          }
        }
      }
    }

    public static void logPost(long logNo, string dataIn, string status, Ecom ec) // log overall behaviour of transaction
    {
      string ecomAcctId = (ec.ecomMedia == "Online") ? null : left(ec.ecomCustId, 4) + ec.ecomNewAcctId;
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp5ecomLogs";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@logNo", logNo));
          cmd.Parameters.Add(new SqlParameter("@dataIn", dataIn));
          cmd.Parameters.Add(new SqlParameter("@status", status));
          cmd.Parameters.Add(new SqlParameter("@custId", ec.ecomCustId));
          cmd.Parameters.Add(new SqlParameter("@accountId", ecomAcctId));
          cmd.Parameters.Add(new SqlParameter("@id", ec.ecomId));
          cmd.Parameters.Add(new SqlParameter("@expires", ec.ecomExpires));

          // added Nov 14, 2017 to retrieve what the stored proc was already returning - needed for Alex to send from NOP to V8
          cmd.Parameters.Add("@guid", SqlDbType.VarChar, 36).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          ec.ecomGuid = cmd.Parameters["@guid"].Value.ToString();

        }
      }
    }


    // this function has been disabled as it grew out of control
    public static void logTxt(string fileName, string value) // log transaction into to txt whatever form data was received in case SQL is wonky, use random file name
    {
      //fileName = @"C:\Temp\peterEcommerce\" + fileName + ".txt";
      //using (System.IO.StreamWriter file = new System.IO.StreamWriter(fileName, true))
      //{
      //  file.WriteLine(value);
      //}
    }

    #endregion
  }
}