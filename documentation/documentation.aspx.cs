using System;

namespace portal.v7
{
  public partial class documentation : FormBase
  {
    private Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      //se.localize();
      //Page.Title = (se.lang == "en") ? "english" : "french";


    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}