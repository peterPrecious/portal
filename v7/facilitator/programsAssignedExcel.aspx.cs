using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;


namespace portal.v7.facilitator
{
  public partial class programsPurchasedAndAssignedExcel : FormBase
  {
    private Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();
      if (!IsPostBack)
      {
        populateTitle();
        PopulateDropDown();
      }
      Session["progId"] = ddProgs.SelectedValue;
    }

    public void purchaseCounts(out int membCount, out int purchasedCount, out int assignedCount)
    {
      // return true/false if custAcctid has made purchases
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7programsPurchasedCount";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@accountId", se.custAcctId));
          cmd.Parameters.Add("@membCount", SqlDbType.Int).Direction = ParameterDirection.Output;
          cmd.Parameters.Add("@purchasedCount", SqlDbType.Int).Direction = ParameterDirection.Output;
          cmd.Parameters.Add("@assignedCount", SqlDbType.Int).Direction = ParameterDirection.Output;

          cmd.ExecuteNonQuery();
          membCount = (int)cmd.Parameters["@membCount"].Value;
          purchasedCount = (int)cmd.Parameters["@purchasedCount"].Value;
          assignedCount = (int)cmd.Parameters["@assignedCount"].Value;
        }
      }
    }

    protected void populateTitle()
    {
      labHeader.Text = GetGlobalResourceObject("portal", "progAssigned_1").ToString() + " " + se.custId;
      labSubHeader.Text = GetGlobalResourceObject("portal", "progAssigned_2").ToString();
      btnBegin.Text = GetGlobalResourceObject("portal", "begin").ToString();

      if (Session["membCount"] == null)
      {
        purchaseCounts(out int membCount, out int purchasedCount, out int assignedCount);
        Session["membCount"] = membCount;
        Session["purchasedCount"] = purchasedCount;
        Session["assignedCount"] = assignedCount;
      }
      if ((int)Session["membCount"] == 0 || (int)Session["purchasedCount"] == 0)
      {
        litNone.Visible = true;
      }
      else
      {
        //litMembCount.Text = Session["membCount"].ToString();
        //litProgCount.Text = Session["purchasedCount"].ToString();
      }
    }

    protected void PopulateDropDown()
    {
      string dropDown = se.lang == "en" ? "All Programs" : "Tous les programmes";

      ddProgs.Items.Clear();
//    ddProgs.Items.Add(new ListItem("All Programs", "*******"));
      ddProgs.Items.Add(new ListItem(dropDown, "*******"));
      string progId;
      string url = @"
        SELECT DISTINCT 
          pr.Prog_Id 
        FROM 
          V5_Vubz.dbo.Memb AS me INNER JOIN 
          V5_Base.dbo.Prog AS pr ON CHARINDEX(pr.Prog_Id, me.Memb_Programs) > 0 
        WHERE 
          Memb_AcctId = '####' AND 
          LEN(me.Memb_Programs) > 0 AND 
          me.Memb_Internal = 0 
        ORDER BY 
          pr.Prog_Id";
      url = url.Replace("####", se.custAcctId); // hard to twig string above directly
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        // not sure why there are squiggly lines below - seems to work fine.
        SqlCommand command = new SqlCommand(url, con);
        using (SqlDataReader reader = command.ExecuteReader())
        {
          while (reader.Read())
          {
            progId = reader[0].ToString();
            ddProgs.Items.Add(new ListItem(progId, progId));
          }
        }
      }
      Session["progId"] = "*******";
    }

    protected void btnBegin_Click(object sender, EventArgs e)
    {
      Excel ex = new Excel(); // instantiate the excelwriter

      ex.DocName = "Programs Assigned" + " - " + DateTime.Now.ToString("MMM d yyyy");
      ex.WsName = "Programs Assigned";                                                                           // this is the worksheet name which shows on the first tab at the bottom
      ex.SpName = "[apps].[dbo].[sp7programsPurchasedAndAssignedExcel]";                                                    // this is the stored proc that drives this - must be "excelWriter" friendly    

      ex.StrParms[0] = Session["custAcctId"].ToString();
      ex.StrParms[1] = Session["progId"].ToString();

      ex.excelWriter();
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void ddProgs_SelectedIndexChanged(object sender, EventArgs e)
    {
      Session["progId"] = ddProgs.SelectedValue;
    }
  }
}