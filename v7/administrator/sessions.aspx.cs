using System;
using System.Collections.Generic;
using System.Globalization;
using System.Threading;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class sessions : FormBase
  {

    protected override void InitializeCulture()
    {
      Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
      Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());
    }

    protected void Page_Load(object sender, EventArgs e)
    {
      // put the session variables as strings into a sorted dictionary
      SortedDictionary<string, string> sortedDictionary = new SortedDictionary<string, string>();
      for (int i = 0; i < Session.Count; i++)
      {
        sortedDictionary.Add(Session.Contents.Keys[i], Session.Contents[i].ToString());
      }

      // now put the sorted values into a table
      foreach (var session in sortedDictionary)
      {
        TableRow tableRow = new TableRow();
        tabSessions.Rows.Add(tableRow);

        TableCell tableCell1 = new TableCell
        {
          Text = session.Key
        };
        tableRow.Cells.Add(tableCell1);

        TableCell tableCell2 = new TableCell
        {
          Text = session.Value
        };
        tableRow.Cells.Add(tableCell2);

        tabSessions.Rows.Add(tableRow);
      }
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }
  }
}