using System;
using System.Web;
using System.Web.UI.WebControls;

namespace portal.v7
{

  public partial class customerSalesDetails : FormBase
  {

    protected void Page_Load(object sender, EventArgs e)
    {

      if (!IsPostBack)
      {
        populateMonthList1();
        populateYearList1();

        int year = int.Parse(drpCalYear1.SelectedValue);
        int month = int.Parse(drpCalMonth1.SelectedValue);
        Calendar1.TodaysDate = new DateTime(year, month, 1);

        populateMonthList2();
        populateYearList2();

        year = int.Parse(drpCalYear2.SelectedValue);
        month = int.Parse(drpCalMonth2.SelectedValue);
        Calendar2.TodaysDate = new DateTime(year, month, 1);
      }

      // WCF Charting requires SSL unless on localhost
      if (!HttpContext.Current.Request.IsSecureConnection && HttpContext.Current.Request.Url.Host != "localhost") imgChart.Visible = false;

    }

    protected void populateYearList1()
    {
      //Year list can be changed by changing the lower and upper limits of the For statement    
      for (int intYear = DateTime.Now.Year; intYear >= 2000; intYear--)
      {
        drpCalYear1.Items.Add(intYear.ToString());
      }
      // start with the previous year
      string lastYear = DateTime.Today.AddYears(-1).Year.ToString();
      drpCalYear1.Items.FindByValue(lastYear).Selected = true;
    }

    protected void populateMonthList1()
    {
      //Add each month to the list
      var dtf = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat;
      for (int i = 1; i <= 12; i++)
      {
        drpCalMonth1.Items.Add(new ListItem(dtf.GetMonthName(i), i.ToString()));
      }
      // start with January 
      drpCalMonth1.Items.FindByValue("1").Selected = true;
    }

    protected void populateYearList2()
    {
      //Year list can be changed by changing the lower and upper limits of the For statement    
      for (int intYear = DateTime.Now.Year; intYear >= 2000; intYear--)
      {
        drpCalYear2.Items.Add(intYear.ToString());
      }
      // start with the previous year
      string lastYear = DateTime.Today.AddYears(-1).Year.ToString();
      drpCalYear2.Items.FindByValue(lastYear).Selected = true;

    }

    protected void populateMonthList2()
    {
      //Add each month to the list
      var dtf = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat;
      for (int i = 1; i <= 12; i++)
      {
        drpCalMonth2.Items.Add(new ListItem(dtf.GetMonthName(i), i.ToString()));
      }
      // start with January 
      drpCalMonth2.Items.FindByValue("12").Selected = true;
    }

    protected void setCalendar1(object Sender, EventArgs e)
    {
      int year = int.Parse(drpCalYear1.SelectedValue);
      int month = int.Parse(drpCalMonth1.SelectedValue);
      Calendar1.TodaysDate = new DateTime(year, month, 1);
    }

    protected void setCalendar2(object Sender, EventArgs e)
    {
      int year = int.Parse(drpCalYear2.SelectedValue);
      int month = int.Parse(drpCalMonth2.SelectedValue);
      Calendar2.TodaysDate = new DateTime(year, month, 1);
    }

    protected void gvSalesTotal_DataBound(object sender, EventArgs e)
    {
      // this show the chart and excel images when there's some selected date values
      if (Calendar1.SelectedDate.Year > 2000 && Calendar2.SelectedDate.Year > 2000)
      {
        imgChart.Visible = true;
        imgExcel.Visible = true;
      }
    }

    protected void imgExcel_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Excel ex = new Excel(); // instantiate the excelwriter

      ex.DocName = ("Customer Sales Details" + " (" + DateTime.Now.ToString("MMM d, yyyy") + ")").Replace(" ", "_");   // excel file name - doesn't like spaces
      ex.WsName = "Sales";                                                                                             // this is the worksheet name which shows on the first tab at the bottom
      ex.SpName = "[apps].[dbo].[sp7customerSalesDetailsExcel]";                                                       // this is the stored proc that drives this - must be "excelWriter" friendly    

      ex.IntParms[0] = Convert.ToInt32(ddTop.Text);
      ex.DatParms[0] = Calendar1.SelectedDate;
      ex.DatParms[1] = Calendar2.SelectedDate;

      ex.excelWriter();
    }

    protected void imgChart_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      string url =
        "/portal/v7/kendoUI.aspx" +
        "?title=Ecommerce sales of the top " + ddTop.Text + " accounts between " + Calendar1.SelectedDate.ToString("MMM dd, yyyy") + " and " + Calendar2.SelectedDate.ToString("MMM dd, yyyy") + "." +
        "&back=/portal/v7/analytics/customerSalesDetails.aspx" +
        "&sp=sp7customerSalesDetailsChart" +
        "&IntParm0=" + ddTop.Text +
        "&DatParm0=" + Calendar1.SelectedDate +
        "&DatParm1=" + Calendar2.SelectedDate;
      Response.Redirect(url);
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}