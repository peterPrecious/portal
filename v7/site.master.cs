using System;

namespace portal
{
  public partial class MasterPage : System.Web.UI.MasterPage
  {
    private Sess se = new portal.Sess();
    private Cust cu = new portal.Cust();


    protected void Page_Init()
    {
  
    }

    protected void Page_Load(object sender, EventArgs e)
    {
      // put the child page name in footer
      butPageName.Text = MainContent.Page.Title;
      headerTitle.Text = MainContent.Page.Title;

      //if cannot localize means session has expired so restart
      bool isOk = se.localize();
      if (!isOk) Response.Redirect("~/v7/default.aspx", true);

      // show/hide footer/header
      if (se.secure)
      {
        panHeader.Visible = true;
        panHeader.Visible = true;

        // create sessions link for debugging
        if (fn.host() == "localhost" || se.membLevel == 5)
        {
          butPageName.NavigateUrl = "~/v7/administrator/sessions.aspx";
        }
      }
    }

    protected void butHome_Click(object sender, EventArgs e)
    {
      Session["tileGroup"] = "home";
      Response.Redirect("~/v7/default.aspx", true);
    }

  }
}