using System;
using System.Threading;
using System.Globalization;
using System.Web.UI;

namespace portal
{
  public partial class Culture : FormBase
  {

    protected override void InitializeCulture()
    {
      // did we change language by radio button?
      string culture = Request.Form["ctl00$MainContent$radCulture"];
      if (culture != null)
      {
        Session["culture"] = culture;
      }
      else if (Session["culture"] is null)
      {
        Session["culture"] = Thread.CurrentThread.CurrentUICulture.Name.ToString();
      }

      UICulture = Session["culture"].ToString();
      Culture = Session["culture"].ToString();
      Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
      Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());
      base.InitializeCulture();

      // store date format for EN or FR
      Session["dateFormat"] = (Session["culture"].ToString().Substring(0, 2) == "en") ? "MMM d, yyyy" : "d MMM yyyy";

      // change page title
      Page.Title = Resources.portal.menuChangeLanguage;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
      Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
      Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());

      if (!IsPostBack)
      {
        // set default language before change
        if (Session["culture"].ToString() == "en-US")
        {
          radCulture.Items.FindByValue("en-US").Selected = true;
          radCulture.Items.FindByValue("fr-CA").Selected = false;
        }
        else if (Session["culture"].ToString() == "fr-CA")
        {
          radCulture.Items.FindByValue("en-US").Selected = false;
          radCulture.Items.FindByValue("fr-CA").Selected = true;
        }
      }
    }


    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }
  }
}