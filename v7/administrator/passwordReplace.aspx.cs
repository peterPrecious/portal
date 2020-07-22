using System;

namespace portal.v7.facilitator
{
  public partial class passwordReplace : System.Web.UI.Page
  {
    Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();
    }


    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}