using System;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class programs : FormBase
  {

    string progId = "";

    protected void Page_Load(object sender, EventArgs e)
    {

      if (!Page.IsPostBack)
      {
        progId = Request["programId"];
        txtSearch.Text = progId;
        gvPrograms.DataBind();
      }
    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      gvPrograms.DataBind();
    }

    // this is fired when we select a program to edit
    protected void gvPrograms_SelectedIndexChanged(object sender, EventArgs e)
    {
      panTop.Visible = false;
      panBot.Visible = true;
      dvPrograms.ChangeMode(DetailsViewMode.ReadOnly);
    }

    // this is the icon on the bottom title to return and list programs
    protected void ListLearners_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
      labError.Visible = false;
      labError.Text = "";
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
      dvPrograms.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void Exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }
     
  }
}