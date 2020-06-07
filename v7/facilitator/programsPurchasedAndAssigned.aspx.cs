using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;


namespace portal.v7.facilitator
{
  public partial class programsPurchasedAndAssigned : FormBase
  {
    private Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();
      if (!IsPostBack)
      {
        populateTitle();
      }
    }

    protected void btnRestart_Click(object sender, EventArgs e)
    {
      Response.Redirect("/portal/v7/facilitator/programsPurchasedAndAssigned.aspx");
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
      gvLearners.Visible = false;
      gvPurchasedAndAssigned.Visible = true;
      btnBack.Visible = false;
    }

    protected void gvPurchasedAndAssigned_PreRender(object sender, EventArgs e)
    {
      btnBack.Visible = false;
    }

    protected void gvLearners_PreRender(object sender, EventArgs e)
    {
      btnBack.Visible = true;
      labInactive.Visible = true;
    }

    protected void gvPurchasedAndAssigned_SelectedIndexChanged(object sender, EventArgs e)
    {
      gvPurchasedAndAssigned.Visible = false;
      gvLearners.Visible = true;
      SqlDataSource2.DataBind();
    }

    protected void gvPurchasedAndAssigned_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.DataRow)
      {
        // create a link for first cell of each row to render Program Title
        string progId, progTitle;
        progId = e.Row.Cells[0].Text;

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
        {
          con.Open();
          using (SqlCommand cmd = new SqlCommand())
          {
            cmd.CommandTimeout = 100;
            cmd.Connection = con;
            cmd.CommandText = "dbo.sp7programTitle";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@progId", progId));
            cmd.Parameters.Add("@progTitle", SqlDbType.VarChar, 256).Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            progTitle = cmd.Parameters["@progTitle"].Value.ToString();
          }
        }
        e.Row.Cells[0].Attributes.Add("onclick", "displayProgDetails('" + progId + "', '" + progTitle + "')");
      }
    }

    protected void gvLearners_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.DataRow)
      {
        // strike through inactive learners
        var membActive = (bool)gvLearners.DataKeys[e.Row.RowIndex].Values[1];
        if (!membActive) e.Row.Cells[1].Style.Value = "text-decoration:line-through;";

        // create a link for first cell of each row to render Program Title
        string progId, progTitle;
        progId = e.Row.Cells[0].Text;

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
        {
          con.Open();
          using (SqlCommand cmd = new SqlCommand())
          {
            cmd.CommandTimeout = 100;
            cmd.Connection = con;
            cmd.CommandText = "dbo.sp7programTitle";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@progId", progId));
            cmd.Parameters.Add("@progTitle", SqlDbType.VarChar, 256).Direction = ParameterDirection.Output;
            cmd.ExecuteNonQuery();
            progTitle = cmd.Parameters["@progTitle"].Value.ToString();
          }
        }
        e.Row.Cells[0].Attributes.Add("onclick", "displayProgDetails('" + progId + "', '" + progTitle + "')");

      }
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
//    labHeader.Text = "Programs Purchased and Assigned for " + se.custId;
      labHeader.Text = GetGlobalResourceObject("portal", "progsPurch_1").ToString() + " " + se.custId;

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
        gvPurchasedAndAssigned.Visible = false;
      }
      else
      {
        gvPurchasedAndAssigned.Visible = true;
      }

    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx", false);
    }

  }
}