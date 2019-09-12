using System;
using System.Web;
using System.Web.UI.WebControls;

namespace portal.v7.facilitator
{
  public partial class programActivityDetailsExcel : FormBase
  {
    Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      if (!IsPostBack)
      {
        populateMonthList1();
        populateYearList1();

        int year = int.Parse(drpCalYear1.SelectedValue);
        int month = int.Parse(drpCalMonth1.SelectedValue);
        Calendar1.TodaysDate = new DateTime(year, month, 1);
        Calendar1.SelectedDate = Calendar1.TodaysDate;

        populateMonthList2();
        populateYearList2();

        year = int.Parse(drpCalYear2.SelectedValue);
        month = int.Parse(drpCalMonth2.SelectedValue);
        int day = DateTime.DaysInMonth(year, month);


        Calendar2.TodaysDate = new DateTime(year, month, day);
        Calendar2.SelectedDate = Calendar2.TodaysDate;
      }
    }

    protected void populateYearList1()
    {
      //Year list can be changed by changing the lower and upper limits of the For statement    
      for (int intYear = DateTime.Now.Year; intYear >= 2000; intYear--)
      {
        drpCalYear1.Items.Add(intYear.ToString());
      }
      // start with current year unless Jan use previous year
      string lastYear;
      if (DateTime.Now.Month == 1)
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
      //Add each month to the list
      var dtf = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat;
      for (int i = 1; i <= 12; i++)
      {
        drpCalMonth1.Items.Add(new ListItem(dtf.GetMonthName(i), i.ToString()));
      }
      // start with previous month 
      int currentMonth = DateTime.Now.Month - 1;
      if (currentMonth == 0) { currentMonth = 12; }
      drpCalMonth1.Items.FindByValue(currentMonth.ToString()).Selected = true;
    }

    protected void populateYearList2()
    {
      //Year list can be changed by changing the lower and upper limits of the For statement    
      for (int intYear = DateTime.Now.Year; intYear >= 2000; intYear--)
      {
        drpCalYear2.Items.Add(intYear.ToString());
      }
      // start with current year unless Jan use previous year
      string lastYear;
      if (DateTime.Now.Month == 1)
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
      // start with previous month 
      int currentMonth = DateTime.Now.Month - 1;
      if (currentMonth == 0) { currentMonth = 12; }

      drpCalMonth2.Items.FindByValue(currentMonth.ToString()).Selected = true;
    }

    protected void setCalendar1(object Sender, EventArgs e)
    {
      int year = int.Parse(drpCalYear1.SelectedValue);
      int month = int.Parse(drpCalMonth1.SelectedValue);
      Calendar1.TodaysDate = new DateTime(year, month, 1);
      Calendar1.SelectedDate = Calendar1.TodaysDate;
    }

    protected void setCalendar2(object Sender, EventArgs e)
    {
      int year = int.Parse(drpCalYear2.SelectedValue);
      int month = int.Parse(drpCalMonth2.SelectedValue);
      Calendar2.TodaysDate = new DateTime(year, month, 1);
    }

    protected void imgExcel_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Excel ex = new Excel(); // instantiate the excelwriter

      se.localize();

      ex.DocName = "Program Activity Details" + " - " + DateTime.Now.ToString("MMM d yyyy");  // excel file name - doesn't like spaces
      ex.WsName = "Details";                                                                  // this is the worksheet name which shows on the first tab at the bottom
      ex.SpName = "[apps].[dbo].[sp7programActivityDetailsExcel]";                            // this is the stored proc that drives this - must be "excelWriter" friendly    

      ex.StrParms[0] = se.custId;
      ex.StrParms[1] = txtMembId.Text;
      ex.DatParms[0] = Calendar1.SelectedDate;
      ex.DatParms[1] = Calendar2.SelectedDate;

      ex.excelWriter();
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}