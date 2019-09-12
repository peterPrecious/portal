using System;
using System.Web.UI.WebControls;

namespace portal.v7.manager
{
  public partial class documentUpload : FormBase
  {
    Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();

      if (!IsPostBack)
      {
        vAccounts.Items[0].Text = "Just this Account: <strong>" + se.custId + "</strong>";
        vAccounts.Items[0].Value = se.custId;

        vAccounts.Items[1].Text = "All Accounts starting with <strong>" + se.cust + "</strong>";
        vAccounts.Items[1].Value = se.cust;

        if (se.membLevel == 5) vAccounts.Items.Add(new ListItem("All Accounts", ""));
      }

    }


    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void butNext_Click(object sender, EventArgs e)
    {
      string documentName = Request.Form[3];
      string customerId = Request.Form[4];
      string language = Request.Form[5];
      string nextUrl = "/portal/v7/manager/DocumentUpload.aspx";

      string url = "/docservice/default.aspx" +
        "?vDocument=" + documentName +
        "&vCustID=" + customerId +
        "&vLang=" + language +
        "&vNext=" + nextUrl;
      Response.Redirect(url, false);
    }

  }
}