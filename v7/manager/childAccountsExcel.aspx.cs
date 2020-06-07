using System;

namespace portal.v7.manager
{
  public partial class childAccountsExcel : FormBase
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      Literal3.Text = Session["custId"].ToString();
    }

    protected void imgExcel_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Excel ex = new Excel                                                                                                   // instantiate the excelwriter
      {
        DocName = ("Child Accounts Report" + " (" + DateTime.Now.ToString("MMM d yyyy") + ")").Replace(" ", "_"),            // excel file name - doesn't like spaces
        WsName = "Child Accounts Report",                                                                                    // this is the worksheet name which shows on the first tab at the bottom
        SpName = "[apps].[dbo].[spXchildAccounts]"                                                                           // this is the stored proc that drives this - must be "excelWriter" friendly    
      };

      ex.StrParms[0] = Session["custAcctId"].ToString();
      ex.IntParms[0] = chkExpired.Checked ? 1 : 0;

      ex.excelWriter();
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }

}