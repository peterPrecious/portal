using System;
using System.Globalization;
using System.Threading;

namespace portal.v7
{
  public partial class about : FormBase
  {

    protected override void InitializeCulture()
    {
      Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
      Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }


  }
}