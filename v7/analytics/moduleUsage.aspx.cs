using System;
using System.Web;

namespace portal.v7.analytics
{
  public partial class moduleUsage : FormBase
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      // WCF Charting requires SSL unless on localhost
      if (!HttpContext.Current.Request.IsSecureConnection && HttpContext.Current.Request.Url.Host != "localhost") imgChart.Visible = false;

      //labDate.Text = DateTime.Now.ToString("MMM d, yyyy");
    }

    protected void imgExcel_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Excel ex = new Excel(); // instantiate the excelwriter

      ex.DocName = ("Module Usage" + " (" + DateTime.Now.ToString("MMM d, yyyy") + ")").Replace(" ", "_");  // excel file name - doesn't like spaces
      ex.WsName = "Usage";                                                                                  // this is the worksheet name which shows on the first tab at the bottom
      ex.SpName = "[apps].[dbo].[sp7moduleUsage]";                                                          // this is the stored proc that drives this - must be "excelWriter" friendly    

      ex.excelWriter();
    }

    protected void imgChart_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      string url =
        "/portal/v7/kendoUI.aspx" +
        "?title=List of top 20 modules accessed during the past twelve months." +
        "&back=/portal/v7/analytics/moduleUsage.aspx" +
        "&sp=sp7moduleUsageChart";
      Response.Redirect(url);
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}
