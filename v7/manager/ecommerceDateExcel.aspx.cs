using System;
using System.Web.UI.WebControls;

namespace portal.v7.manager
{
  public partial class ecommerceDateExcel : FormBase
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      if (!IsPostBack)
      {
        populateMonthList1();
        populateYearList1();

        int year = int.Parse(drpCalYear1.SelectedValue);
        int month = int.Parse(drpCalMonth1.SelectedValue);
        Calendar.TodaysDate = new DateTime(year, month, 1);
        Calendar.SelectedDate = Calendar.TodaysDate;

        populateMonthList2();
        populateYearList2();

        year = int.Parse(drpCalYear2.SelectedValue);
        month = int.Parse(drpCalMonth2.SelectedValue);
        Calendar2.TodaysDate = new DateTime(year, month, DateTime.DaysInMonth(year, month));
        Calendar2.SelectedDate = Calendar2.TodaysDate;

        imgExcel.Visible = true;

      }

    }

    protected void populateYearList1()
    {
      for (int intYear = DateTime.Now.Year; intYear >= 2000; intYear--)
      {
        drpCalYear1.Items.Add(intYear.ToString());
      }
      DateTime today = DateTime.Today;
      string lastYear;
      if (today.Month == 1)
      {
        lastYear = DateTime.Today.AddYears(-1).Year.ToString();
      }
      else
      {
        lastYear = DateTime.Today.Year.ToString();
      }
      drpCalYear1.Items.FindByValue(lastYear).Selected = true;
    }

    protected void populateMonthList1()
    {
      var dtf = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat;
      for (int i = 1; i <= 12; i++)
      {
        drpCalMonth1.Items.Add(new ListItem(dtf.GetMonthName(i), i.ToString()));
      }
      DateTime today = DateTime.Today;
      int month = (today.Month == 1) ? 12 : today.Month - 1;
      drpCalMonth1.Items.FindByValue(month.ToString()).Selected = true;
    }

    protected void populateYearList2()
    {
      for (int intYear = DateTime.Now.Year; intYear >= 2000; intYear--)
      {
        drpCalYear2.Items.Add(intYear.ToString());
      }
      DateTime today = DateTime.Today;
      string lastYear;
      if (today.Month == 1)
      {
        lastYear = DateTime.Today.AddYears(-1).Year.ToString();
      }
      else
      {
        lastYear = DateTime.Today.Year.ToString();
      }
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
      DateTime today = DateTime.Today;
      int month = (today.Month == 1) ? 12 : today.Month - 1;
      drpCalMonth2.Items.FindByValue(month.ToString()).Selected = true;
    }

    protected void setCalendar(object Sender, EventArgs e)
    {
      int year = int.Parse(drpCalYear1.SelectedValue);
      int month = int.Parse(drpCalMonth1.SelectedValue);
      Calendar.TodaysDate = new DateTime(year, month, 1);
      Calendar.SelectedDate = Calendar.TodaysDate;
      panError.Visible = false;
    }

    protected void setCalendar2(object Sender, EventArgs e)
    {
      int year = int.Parse(drpCalYear2.SelectedValue);
      int month = int.Parse(drpCalMonth2.SelectedValue);
      Calendar2.TodaysDate = new DateTime(year, month, DateTime.DaysInMonth(year, month));
      Calendar2.SelectedDate = Calendar2.TodaysDate;
      panError.Visible = false;
    }

    protected void imgExcel_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      // ensure dates are kosher (this is also used by ecommerceExcel.cs)
      if (Calendar2.SelectedDate < Calendar.SelectedDate)
      {
        panError.Visible = true;
      }
      else
      {
        Excel ex = new Excel();                                                                                         // instantiate the excelwriter
        ex.DocName = "Ecommerce" + " (" + DateTime.Now.ToString("MMM d yyyy") + ").xlsx";                               // excel file name cannot contain a comman in date
        ex.WsName = "Ecommerce By Date";                                                                                // this is the worksheet name which shows on the first tab at the bottom
        ex.SpName = "[apps].[dbo].[sp7ecommerceExcel]";                                                                 // this is the stored proc that drives this - must be "excelWriter" friendly    

        ex.IntParms[0] = Convert.ToInt32(ddTop.SelectedValue);
        ex.StrParms[0] = Session["cust"].ToString();
        ex.StrParms[1] = null;
        ex.StrParms[2] = null;
        ex.DatParms[0] = Calendar.SelectedDate;
        ex.DatParms[1] = Calendar2.SelectedDate;

        ex.excelWriter();
      }
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }

}