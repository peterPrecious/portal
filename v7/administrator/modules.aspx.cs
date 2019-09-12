using System;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class modules : FormBase
  {
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      gvModules.DataBind();
    }

    // this is fired when we select a learner to edit
    protected void gvModules_SelectedIndexChanged(object sender, EventArgs e)
    {
      panTop.Visible = false;
      panBot.Visible = true;
      dvModule.ChangeMode(DetailsViewMode.ReadOnly);
    }

    // this is the icon on the bottom title to return and list modules
    protected void ListLearners_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
      labError.Visible = false;
      labError.Text = "";
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
      dvModule.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void Exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }
  }
}