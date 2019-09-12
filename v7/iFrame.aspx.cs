using System;

namespace portal.v7
{
  public partial class iFrame : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      // this is passed from tiles clicked in default.aspx for Bryan's gold Apps
      string url = Request["url"];
      goldApps.Attributes["src"] = url;
    }


    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}