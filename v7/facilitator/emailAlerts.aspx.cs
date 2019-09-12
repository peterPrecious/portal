using System;

namespace portal.v7.manager
{
  public partial class emailAlerts : System.Web.UI.Page
  {
    Sess se = new Sess();
    Cust cu = new Cust();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();
      if (cu.getEmailAlert(se.custAcctId))
      {
        labStatus.Text = "ENABLED";
        butEnable.Visible = false;
        butDisable.Visible = true;
      }
      else
      {
        labStatus.Text = "DISABLED";
        butEnable.Visible = true;
        butDisable.Visible = false;
      }
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void butEnable_Click(object sender, EventArgs e)
    {
      cu.setEmailAlert(se.custAcctId, true);
      labStatus.Text = "ENABLED";
      Session["custEmailAlert"] = true;
      butEnable.Visible = false;
      butDisable.Visible = true;
    }
    protected void butDisable_Click(object sender, EventArgs e)
    {
      cu.setEmailAlert(se.custAcctId, false);
      labStatus.Text = "DISABLED";
      Session["custEmailAlert"] = false;
      butEnable.Visible = true;
      butDisable.Visible = false;
    }
  }
}