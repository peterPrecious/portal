using System;
using System.Web.UI;

namespace portal.v7
{
  public partial class signout : Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      Session.Clear();
      Session["secure"] = false;
      Response.Redirect("~/index.html", true);
    }
  }
}