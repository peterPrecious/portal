using System;

namespace portal.v7.facilitator
{
  public partial class passwordFinder : System.Web.UI.Page
  {

    protected void Page_Load(object sender, EventArgs e)
    {
    }


    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}