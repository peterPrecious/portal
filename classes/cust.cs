using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace portal
{
  public class Cust
  {
    #region Fields
    public int
      custNo;
    public string
      custId, custAcctId, custParentId, custTitle, custLang, custAgent, custMaxSponsor,
      custIssueIds, custResetStatus, custIssueIdsTemplate, custIssueIdsMemo,
      custActivateIds, custIdsSize, custFreeHours, custFreeDays,
      custGroups, custPrograms, custCdPrograms,
      custContentOnline, custContentGroup, custContentGroup2, custContentProds, custContentCDs,
      custActive, custDesc, custEmail,
      //    custCluster,
      custCertLogoVubiz, custCertLogoCust, custCertEmailAlert,
      custAssessmentAttempts, custAssessmentScore, custAssessmentCert,
      custLevel, custContentLaunch, custSurvey, custNoCert, custCustomCert,
      //    custTab1, custTab2, custTab3, custTab4, custTab5, custTab6, custTab7, custTab4Type, custTab1Name, custTab2Name, custTab3Name, custTab4Name, custTab5Name, custTab6Name, custTab7Name,
      custAuth, custMyWorldLaunch, custMaxUsers, custPwd, custCritTitles,
      custSeedLogs, custModified, custEcomCurrency, custEcomGroupLicense, custEcomGroupSeat,
      custEcomGroup2Rates, custEcomSplit, custEcomDiscOptions, custEcomDisc, custEcomDiscSplitCust,
      custEcomDiscSplitVubz, custEcomDiscSplitOwnr, custEcomDiscMinUS, custEcomDiscMinCA,
      custEcomDiscMinQty, custEcomDiscLimit, custEcomDiscOriginal, custEcomDiscPrograms,
      custEcomRepurPrograms, custEcomRepurDisc, custEcomRepurPeriod, custEcomCorpRate,
      custEcomCorpDuration, custEcomCorpProgram, custEcomSeller, custEcomOwner, custCorpAlert,
      custResources, custResourcesMaxSponsor, custVuNews, custScheduler, custEcomReports,
      custInfoEditProfile, custInsertLearners, custUpdateLearners, custDeleteLearners, custResetLearners,
      //    custNote1, custNote2, custNote3, custNote4, custNote5,
      custChannelParent, custChannelReportsTo, custChannelGuests,
      custBanner, custUrl, custStartUrl, custReturnUrl, custCompletion,
      custChannelManager,
      custGuid;

    public DateTime custAdded, custExpires;
    public bool custAuto, custEof, custChannelV8, custChannelNop, custEcomG2alert;
    #endregion

    public void init() // initialize cust
    {
      custNo = 0;

      custId = null; custAcctId = null; custParentId = null; custTitle = null; custLang = null; custAgent = null; custMaxSponsor = null;
      custIssueIds = null; custResetStatus = null; custIssueIdsTemplate = null; custIssueIdsMemo = null;
      custActivateIds = null; custIdsSize = null; custFreeHours = null; custFreeDays = null;
      custGroups = null; custPrograms = null; custCdPrograms = null;
      custContentOnline = null; custContentGroup = null; custContentGroup2 = null; custContentProds = null; custContentCDs = null;
      custActive = null; custDesc = null; custEmail = null;
      //custCluster = null;
      custCertLogoVubiz = null; custCertLogoCust = null; custCertEmailAlert = null;
      custAssessmentAttempts = null; custAssessmentScore = null; custAssessmentCert = null;
      custLevel = null; custContentLaunch = null; custSurvey = null; custNoCert = null; custCustomCert = null;
      //      custTab1 = null; custTab2 = null; custTab3 = null; custTab4 = null; custTab5 = null; custTab6 = null; custTab7 = null; custTab4Type = null; custTab1Name = null; custTab2Name = null; custTab3Name = null; custTab4Name = null; custTab5Name = null; custTab6Name = null; custTab7Name = null;
      custAuth = null; custMyWorldLaunch = null; custMaxUsers = null; custPwd = null; custCritTitles = null;
      custSeedLogs = null; custModified = null; custEcomCurrency = null; custEcomGroupLicense = null; custEcomGroupSeat = null;
      custEcomGroup2Rates = null; custEcomSplit = null; custEcomDiscOptions = null; custEcomDisc = null; custEcomDiscSplitCust = null;
      custEcomDiscSplitVubz = null; custEcomDiscSplitOwnr = null; custEcomDiscMinUS = null; custEcomDiscMinCA = null;
      custEcomDiscMinQty = null; custEcomDiscLimit = null; custEcomDiscOriginal = null; custEcomDiscPrograms = null;
      custEcomRepurPrograms = null; custEcomRepurDisc = null; custEcomRepurPeriod = null; custEcomCorpRate = null;
      custEcomCorpDuration = null; custEcomCorpProgram = null; custEcomSeller = null; custEcomOwner = null; custCorpAlert = null;
      custResources = null; custResourcesMaxSponsor = null; custVuNews = null; custScheduler = null; custEcomReports = null;
      custInfoEditProfile = null; custInsertLearners = null; custUpdateLearners = null; custDeleteLearners = null; custResetLearners = null;
      //     custNote1 = null; custNote2 = null; custNote3 = null; custNote4 = null; custNote5 = null;
      custChannelParent = null; custChannelReportsTo = null; custChannelGuests = null;
      custBanner = null; custUrl = null; custStartUrl = null; custReturnUrl = null; custCompletion = null;
      custChannelManager = null;

      custChannelV8 = false; custChannelNop = false; custEcomG2alert = false;
      custGuid = null;

    }

    public void customer(string custId_inp)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6customer";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId_inp));
          SqlDataReader drd = cmd.ExecuteReader();
          custEof = true;
          // populate local variables
          while (drd.Read())
          {
            custEof = false;

            custAcctId = drd["Cust_AcctId"].ToString();
            this.custId = drd["Cust_Id"].ToString();
            custAuto = (bool)drd["Cust_Auto"];
            custParentId = drd["Cust_ParentId"].ToString();
            custChannelManager = drd["Cust_ChannelManager"].ToString();
            custChannelNop = (bool)drd["Cust_ChannelNop"];
            custChannelV8 = (bool)drd["Cust_ChannelV8"];
            custGuid = drd["Cust_Guid"].ToString();

            // if this is a parent without a ChannelManager password, set it to "CCHS_SALES" (for example)
            if (String.IsNullOrEmpty(custParentId.Trim()) && String.IsNullOrEmpty(custChannelManager.Trim()))
            {
              custChannelManager = this.custId.Substring(0, 4) + "_SALES";
            }
            //custNo, custId, custAcctId, custParentId, custTitle, custLang, custAgent, custMaxSponsor, custIssueIds, custResetStatus, custIssueIdsTemplate, custIssueIdsMemo, custActivateIds, custIdsSize, custFreeHours, custFreeDays, custAuto, custGroups, custPrograms, custCdPrograms, custContentOnline, custContentGroup, custContentGroup2, custContentProds, custContentCDs, custActive, custDesc, custAdded, custExpires, custEmail, custCluster, custCertLogoVubiz, custCertLogoCust, custCertEmailAlert, custAssessmentAttempts, custAssessmentScore, custAssessmentCert, custLevel, custContentLaunch, custSurvey, custNoCert, custCustomCert, custTab1, custTab2, custTab3, custTab4, custTab5, custTab6, custTab7, custTab4Type, custTab1Name, custTab2Name, custTab3Name, custTab4Name, custTab5Name, custTab6Name, custTab7Name, custAuth, custMyWorldLaunch, custMaxUsers, custPwd, custCritTitles, custSeedLogs, custModified, custEcomCurrency, custEcomGroupLicense, custEcomGroupSeat, custEcomGroup2Rates, custEcomSplit, custEcomDiscOptions, custEcomDisc, custEcomDiscSplitCust, custEcomDiscSplitVubz, custEcomDiscSplitOwnr, custEcomDiscMinUS, custEcomDiscMinCA, custEcomDiscMinQty, custEcomDiscLimit, custEcomDiscOriginal, custEcomDiscPrograms, custEcomRepurPrograms, custEcomRepurDisc, custEcomRepurPeriod, custEcomCorpRate, custEcomCorpDuration, custEcomCorpProgram, custEcomSeller, custEcomOwner, custEcomG2alert, custCorpAlert, custResources, custResourcesMaxSponsor, custVuNews, custScheduler, custEcomReports, custInfoEditProfile, custInsertLearners, custUpdateLearners, custDeleteLearners, custResetLearners, custNote1, custNote2, custNote3, custNote4, custNote5, custChannelParent, custChannelV8, custChannelReportsTo, custChannelGuests, custBanner, custUrl, custStartUrl, custReturnUrl, custCompletion;
          }
          drd.Close();
        }
      }
    }

    public bool isCustomer(string custId)
    {
      int exists = 0;
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6isCustomer";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          SqlDataReader drd = cmd.ExecuteReader();
          while (drd.Read())
          {
            exists = (int)drd["exists"];
          }
        }
        // con.Close();
      }
      if (exists == 0) return false; else return true;
    }

    public bool isCustomerG2(string custId)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6isCustomerG2";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          SqlDataReader drd = cmd.ExecuteReader();
          if (drd.HasRows)
          {
            drd.Close();
            return true;
          }
          else
          {
            drd.Close();
            return false;
          }
        }
      }
    }

    public string isCustomerParent(string custAcctId)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6isCustomerParent";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custAcctId", custAcctId));
          cmd.Parameters.Add("@isParent", SqlDbType.Char, 1).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          string isParent = cmd.Parameters["@isParent"].Value.ToString();
          return (isParent);
        }
      }
    }

    public bool isEmailAlert(string custId)
    {
      // returns true if the custId's parent has email alerts enabled, else false (also false if the custId is a parent rather than a child)
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7isEmailAlert";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.AddWithValue("@isEmailAlert", DbType.Boolean).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          return (Convert.ToBoolean(cmd.Parameters["@isEmailAlert"].Value));
        }
      }
    }

    public bool getEmailAlert(string acctId)
    {
      // returns true if this account has email alerts enabled, else false [emailAlerts.aspx]
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7emailAlertGet";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@acctId", acctId));
          cmd.Parameters.AddWithValue("@alert", DbType.Boolean).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          return (Convert.ToBoolean(cmd.Parameters["@alert"].Value));
        }
      }
    }

    public void setEmailAlert(string acctId, bool alert)
    {
      // returns true if this account has email alerts enabled, else false [emailAlerts.aspx]
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7emailAlertSet";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@acctId", acctId));
          cmd.Parameters.Add(new SqlParameter("@alert", alert));
          cmd.ExecuteNonQuery();
        }
      }
    }

    public int customerChannelChildren(string custAcctId)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7customerChannelChildren";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custAcctId", custAcctId));
          cmd.Parameters.Add("@noChildren", SqlDbType.Int, 1).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          int noChildren = (int)cmd.Parameters["@noChildren"].Value;
          return (@noChildren);
        }
      }
    }

    public void customerChannelManager(string custAcctId, string curPwd, string newPwd)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7customerChannelManager";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@parentId", custAcctId));
          cmd.Parameters.Add(new SqlParameter("@curPwd", curPwd));
          cmd.Parameters.Add(new SqlParameter("@newPwd", newPwd));
          cmd.ExecuteNonQuery();
        }
      }
    }


    // calls sp6customerClone2 as of Dec 1 2016 to ensure no conflicts
    public string customerClone(string custId, string programs, DateTime? expires)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6customerClone2";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.Add(new SqlParameter("@newCustPrograms", programs));
          cmd.Parameters.Add(new SqlParameter("@newCustExpires", expires));
          SqlDataReader drd = cmd.ExecuteReader();
          string newAcctId = "0000";
          while (drd.Read())
          {
            newAcctId = drd["newCustAcctId"].ToString();
          }
          drd.Close();
          return (newAcctId);
        }
        // con.Close();
      }
    }

    public void customerExpiryDate(string custAcctId, DateTime? custExpires)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6customerExpires";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custAcctId", custAcctId));
          cmd.Parameters.Add(new SqlParameter("@custExpires", custExpires));
          cmd.ExecuteNonQuery();
        }
        //con.Close();
      }
    }

    public void customerProfile(string custId, out string profileId, out string profileReturnUrl, out string profileColor, out string profileLogo)
    // see if this account has a v8 profile (and returnUrl)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7customerProfile";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.Add("@profileId", SqlDbType.VarChar, 50).Direction = ParameterDirection.Output;
          cmd.Parameters.Add("@profileReturnUrl", SqlDbType.VarChar, 2000).Direction = ParameterDirection.Output;
          cmd.Parameters.Add("@profileColor", SqlDbType.VarChar, 2000).Direction = ParameterDirection.Output;
          cmd.Parameters.Add("@profileLogo", SqlDbType.VarChar, 2000).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();

          profileId = cmd.Parameters["@profileId"].Value.ToString();
          profileReturnUrl = cmd.Parameters["@profileReturnUrl"].Value.ToString();
          profileColor = cmd.Parameters["@profileColor"].Value.ToString(); // we no longer use color
          profileLogo = cmd.Parameters["@profileLogo"].Value.ToString();

        }
      }
    }

  }
}