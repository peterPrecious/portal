using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace portal
{
  public class Prog
  {
    #region Fields
    public string vProg_Id, vProg_No, vProg_Mods, vProg_Scos, vProg_Title1, vProg_Title2, vProg_Promo, vProg_US_Memo, vProg_CA_Memo, vProg_Length, vProg_Duration_Memo, vProg_Desc, vProg_GrouId, vProg_Memo, vProg_Bookmark, vProg_CompletedButton, vProg_Test, vProg_LogTestResults, vProg_ResetStatus, vProg_Exam, vProg_Retired, vProg_Assessment, vProg_AssessmentAttempts, vProg_AssessmentCert, vProg_AssessmentIds, vProg_AssessmentScore, vProg_Owner, vProg_EcomSplitOwner1, vProg_EcomSplitOwner2, vProg_EcomGroupLicense, vProg_EcomGroupSeat, vProg_TaxExempt, vProg_Cert, vProg_CertTimeSpent, vProg_CertTestScore, vProg_CertTestAttempts, vProg_CustomCert, vProg_Discounts;
    public string vProg_Title; //  not on db / this is the title that is either the general title (Title1) or the Variation assiged to a particular set of customer ids
    public string vProg_US, vProg_CA, vProg_MaxHours, vProg_Duration;  //  note these values are retrieved from vCust_Programs string, not the prog table
    public bool vProg_Eof, vProg_Ok;
    #endregion

    public bool isProgram(string progId)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6isProgram";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@progId", progId));
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
  }
}