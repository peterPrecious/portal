using System;
using System.Web.UI;

namespace portal
{
  public partial class MasterPage : System.Web.UI.MasterPage
  {
    private readonly Sess se = new Sess();
    private readonly Cust cu = new Cust();

    protected void Page_Init() { }

    protected void Page_Load(object sender, EventArgs e)
    {
      //if cannot localize means session has expired so restart
      bool isOk = se.localize();
      if (!isOk) Response.Redirect("~/v7/default.aspx", true);

      // show/hide footer/header
      if (se.secure)
      {
        if (Request.QueryString["header"] != null && Request.QueryString["header"].Equals("false"))
        {
          //do nothing
        }
        else
        {
          panHeader.Visible = true;
        }
        
        //panFooter.Visible = true; //TODO: wire up after revamp

        // create sessions link for debugging
        if (fn.host() == "localhost" || se.membLevel == 5)
        {
          butPageName.NavigateUrl = "~/v7/administrator/sessions.aspx";
        }

        // get logo from profile
        string imageUrl = null;
        if (Session["logo"] != null)
        {
          imageUrl = "/vubizApps/styles/logos/" + Session["logo"].ToString();
        }

        // build nav menu
        Memb me = new Memb();
        var navMenu = me.buildNavMenu(se.membLevel, se.membFirstName, se.membLastName, imageUrl);
        panHeader.Controls.Clear();
        panHeader.Controls.Add(new LiteralControl(navMenu));

      }
    }

    protected void butHome_Click(object sender, EventArgs e)
    {
      Session["tileGroup"] = "home";
      Response.Redirect("~/v7/default.aspx", true);
    }

  }
}