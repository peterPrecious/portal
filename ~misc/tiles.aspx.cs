using System;
using System.Globalization;
using System.Threading;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal.v7
{
  public partial class tiles : System.Web.UI.Page
  {
    Sess se = new Sess();

    protected override void InitializeCulture()
    {
      UICulture = Session["culture"].ToString();
      Culture = Session["culture"].ToString();
      Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
      Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());
      base.InitializeCulture();

      // change page title
      Page.Title = Resources.portal.homePageTitle;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize(); // need to show/hide tiles

      if (!IsPostBack) // start tiles at home group
      {
        Session["tileGroup"] = "home";
      }
      else // capture tile click
      {
        string targetType = Request["__EVENTTARGET"]; // sender used for target type (1,2,3)
        string target = Request["__EVENTARGUMENT"]; // parameter used for target
        Session["pageName"] = target;

        // link to same tab (typically local app)
        if (targetType == "1")
        {
          //butPageName.Text = target;
          Response.Redirect(target);
        }

        // link to another tab (typically external app)
        if (targetType == "2") ScriptManager.RegisterStartupScript(Page, Page.GetType(), "popup", "window.open('" + target + "','_blank')", true);

        // link to another menuGroup
        if (targetType == "3")
        {
          Session["tileGroup"] = target;
          lvTiles.DataBind();
        }

      }

    }

    protected void lvTiles_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
      if (e.Item.ItemType == ListViewItemType.DataItem)
      {
        ListViewDataItem item = (ListViewDataItem)e.Item;
        string tileName = (string)DataBinder.Eval(item.DataItem, "tileName");

        // translate if level 3
        Int16 tileMembLevel = (Int16)Convert.ToInt16(DataBinder.Eval(item.DataItem, "tileMembLevel"));
        if (tileMembLevel == 3)
        {
          Label tileLabel = (Label)e.Item.FindControl("tileTitle") as Label;
          tileLabel.Text = GetGlobalResourceObject("portal", "tile_" + tileName.Replace(" ", "").Replace("/", "")).ToString();
        }

        // only show "Assign Content" if isChild
        if (tileName == "Assign Content" && !se.isChild) item.Visible = false;
      }
    }

  }
}
