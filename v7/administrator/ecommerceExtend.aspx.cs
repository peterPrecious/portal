using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace portal.v7.manager
{
  public partial class ecommerceExtend : System.Web.UI.Page
  {

    protected void Page_Load(object sender, System.EventArgs e) { }

    protected void btnRestart_Click(object sender, System.EventArgs e)
    {
      Response.Redirect("ecommerceExtend.aspx", true);
    }

    protected void btnExtend_Click(object sender, EventArgs e)
    {

      // check input values
      labError.Text = "";
      if (programId.Text.Length != 7) labError.Text += "Requires a valid Program Id<br />";
      if (learnerId.Text.Length < 1) labError.Text += "Requires a valid Learner Id<br />";
      if (noDays.Text.Length < 1)
      {
        labError.Text += "Requires the #Days (plus or minus 365 days). Any negative value essential expires this transaction.<br />";
        return;
      }
      // ensure #days is valid
      int days = 0;
      try
      {
        days = int.Parse(noDays.Text);
        if (days < -365 || days > 365)
        {
          labError.Text += "The #Days must be between -365 and +365. Any negative value essential expires this transaction.<br />";
          return;
        }
      }
      catch (FormatException)
      {
        labError.Text += "#Days must be between -365 and 365.  Typically 30 or -1";
        return;
      }


      // extends ecom transaction using -1 days to expire the transaction or 1-365 to extend it
      string custGuid = Session["custGuid"].ToString();
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7ecomExtend";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custGuid", custGuid));
          cmd.Parameters.Add(new SqlParameter("@learnerId", learnerId.Text));
          cmd.Parameters.Add(new SqlParameter("@programId", programId.Text));
          cmd.Parameters.Add(new SqlParameter("@noDays", noDays.Text));
          SqlDataReader drd = cmd.ExecuteReader();
          while (drd.Read())
          {
            labError.Text = "Successfully reset. Now " + drd["ecomExpires"] + ".";
          }
          drd.Close();
        }
      }
    }

    protected void Exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}