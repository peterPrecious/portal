using System;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class aliases : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      panBot.Visible = false;
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
      // clear out any values from previous insert
      TextBox _t1 = (TextBox)dvAlias.FindControl("alias"); _t1.Text = "";
      TextBox _t2 = (TextBox)dvAlias.FindControl("profile"); _t2.Text = "";
      CheckBox _c1 = (CheckBox)dvAlias.FindControl("guest"); if (_c1.Checked == true) { _c1.Checked = false; }

      panTop.Visible = false;
      panBot.Visible = true;
    }

    protected void btnList_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
    }

    protected void btnInsert_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}