using System;

namespace portal
{
  public partial class MasterPage : System.Web.UI.MasterPage
  {
    private readonly Sess se = new Sess();
    private readonly Cust cu = new Cust();

    protected void Page_Init() { }

    protected void Page_Load(object sender, EventArgs e)
    {
      // translate the page title which will appear on the browser header
      //string pageTitle = ("page" + MainContent.Page.Title).Replace(" ", "").Replace("(", "").Replace(")", "");
      //try
      //{
      //  pageTitle = (string)GetGlobalResourceObject("portal", pageTitle);
      //}
      //catch (Exception) { }
      //if (pageTitle != "page")
      //{
      //  MainContent.Page.Title = pageTitle;
      //}


      //// put the child page name in footer
      //butPageName.Text = MainContent.Page.Title;
      //headerTitle.Text = MainContent.Page.Title;

      //if cannot localize means session has expired so restart
      bool isOk = se.localize();
      if (!isOk) Response.Redirect("~/v7/default.aspx", true);

      // show/hide footer/header
      if (se.secure)
      {
        panHeader.Visible = true;
        panHeader.Visible = true; //TODO: is this supposed to be for the footer?

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