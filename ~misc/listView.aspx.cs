using System;
using System.Web.UI.WebControls;

namespace portal
{
  public partial class listView : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      if (IsPostBack) // capture tile click
      {
        //string targetType = Request["__EVENTTARGET"]; // sender used for target type (1,2,3)
        //string target = Request["__EVENTARGUMENT"]; // parameter used for target

        string targetType = Request["tileTargetType"]; // sender used for target type (1,2,3)
        string target = Request["tileTarget"]; // parameter used for target
      }
    }
    protected void lvTiles_ItemDataBound(object sender, ListViewItemEventArgs e)
    {


    }
  }
}