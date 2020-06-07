using System;
using System.Web.UI.WebControls;

namespace portal.v7.manager
{
  public partial class childAccountsAccessedExcel : FormBase
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      Literal3.Text = Session["custId"].ToString();

      if (!IsPostBack)
      {
        populateMonthList();
        populateYearList();

        int year = int.Parse(drpCalYear.SelectedValue);
        int month = int.Parse(drpCalMonth.SelectedValue);
        Calendar.TodaysDate = new DateTime(year, month, 1);
        Calendar.SelectedDate = Calendar.TodaysDate;
      }
    }

    protected void populateYearList()
    {
      for (int intYear = DateTime.Now.Year; intYear >= 2000; intYear--)
      {
        drpCalYear.Items.Add(intYear.ToString());
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
      drpCalYear.Items.FindByValue(lastYear).Selected = true;
    }


    protected void populateMonthList()
    {
      var dtf = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat;
      for (int i = 1; i <= 12; i++)
      {
        drpCalMonth.Items.Add(new ListItem(dtf.GetMonthName(i), i.ToString()));
      }
      DateTime today = DateTime.Today;
      int month = (today.Month == 1) ? 12 : today.Month - 1;
      drpCalMonth.Items.FindByValue(month.ToString()).Selected = true;
    }


    protected void setCalendar(object Sender, EventArgs e)
    {
      int year = int.Parse(drpCalYear.SelectedValue);
      int month = int.Parse(drpCalMonth.SelectedValue);
      Calendar.TodaysDate = new DateTime(year, month, 1);
      Calendar.SelectedDate = Calendar.TodaysDate;
    }


    protected void imgExcel_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Excel ex = new Excel                                                                                                   // instantiate the excelwriter
      {
        DocName = ("Child Accounts Accessed Report" + " (" + DateTime.Now.ToString("MMM d yyyy") + ")").Replace(" ", "_"),            // excel file name - doesn't like spaces
        WsName = "Child Accounts Accessed Report",                                                                                    // this is the worksheet name which shows on the first tab at the bottom
        SpName = "[apps].[dbo].[spXchildAccountsAccessed]"                                                                           // this is the stored proc that drives this - must be "excelWriter" friendly    
      };

      ex.StrParms[0] = Session["custAcctId"].ToString();
      ex.IntParms[0] = chkExpired.Checked ? 1 : 0;
      ex.DatParms[0] = Calendar.SelectedDate;

      ex.excelWriter();
    }


    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}