using System;
using System.Web;

namespace portal.v7.analytics
{
  public partial class customerSalesSummary : FormBase // System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      // WCF Charting requires SSL unless on localhost
      if (!HttpContext.Current.Request.IsSecureConnection && HttpContext.Current.Request.Url.Host != "localhost") imgChart2.Visible = false;
    }

    protected void imgExcel1_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Excel ex = new Excel();
      ex.DocName = ("Customer Sales Summary" + " (" + DateTime.Now.ToString("MMM d, yyyy") + ")").Replace(" ", "_");   // excel file name - doesn't like spaces
      ex.WsName = "12 Month Sales";                                                                                        // this is the worksheet name which shows on the first tab at the bottom
      ex.SpName = "[apps].[dbo].[sp7customerSales]";
      ex.IntParms[0] = Convert.ToInt32(ddTop.Text);
      ex.excelWriter();
    }

    protected void imgExcel2_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Excel ex = new Excel();
      ex.DocName = ("Customer Sales By Year" + " (" + DateTime.Now.ToString("MMM d, yyyy") + ")").Replace(" ", "_");   // excel file name - doesn't like spaces
      ex.WsName = "Annual Sales";                                                                                        // this is the worksheet name which shows on the first tab at the bottom
      ex.SpName = "[apps].[dbo].[sp7customerSalesAnnualExcel]";                                                       // this is the stored proc that drives this - must be "excelWriter" friendly    
      ex.StrParms[0] = gvSales.SelectedValue != null ? gvSales.SelectedValue.ToString() : "CCHS";
      ex.excelWriter();
    }

    protected void imgChart1_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      string url =
        "/portal/v7/kendoUI.aspx" +
        "?title=Ecommerce Sales of the top " + ddTop.Text + " Customers during the past 12 months." +
        "&back=/portal/v7/analytics/customerSalesSummary.aspx" +
        "&sp=sp7customerSalesChart" +
        "&IntParm0=" + ddTop.Text;
      Response.Redirect(url);
    }

    protected void imgChart2_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      string cust = (gvSales.SelectedValue != null ? gvSales.SelectedValue.ToString() : "CCHS");
      string url =
        "/portal/v7/kendoUI.aspx" +
        "?title=Annual Ecommerce sales for : " + cust +
        "&back=/portal/v7/analytics/customerSalesSummary.aspx" +
        "&sp=sp7customerSalesAnnualChart" +
        "&StrParm0=" + cust;
      Response.Redirect(url);
    }



    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }


  }
}
