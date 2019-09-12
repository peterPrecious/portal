using System;
using System.Drawing;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class profiles : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void gvProfile_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
      // this is for debugging - it serves no purpose (not even hooked up)
      GridViewRow row = (GridViewRow)gvProfile.Rows[e.RowIndex];
      TextBox txtValue = (TextBox)row.Cells[3].Controls[1];

      string id = gvProfile.DataKeys[e.RowIndex].Values["id"].ToString();
      string profile = gvProfile.DataKeys[e.RowIndex].Values["profile"].ToString();
      string name = gvProfile.DataKeys[e.RowIndex].Values["name"].ToString();
      string value = txtValue.Text;

    }

    protected void gvProfiles_SelectedIndexChanged(object sender, EventArgs e)
    {
      // unhighlight profiles
      foreach (GridViewRow row in gvProfiles.Rows)
      {
        row.Font.Bold = false;
        row.BackColor = Color.Transparent;
        row.ForeColor = Color.White;
      }
      GridViewRow selectedRow = gvProfiles.Rows[gvProfiles.SelectedIndex];

      // highlight selected profile  
      selectedRow.Font.Bold = true;
      selectedRow.BackColor = Color.White;
      selectedRow.ForeColor = Color.Black;

      // if showAll set session (easier to handle) - use in SqlDataSource2
      CheckBox checkbox = (CheckBox)selectedRow.FindControl("showAll");
      if (checkbox.Checked)
      {
        Session["showAll"] = "Y";
      }
      else
      {
        Session["showAll"] = "N";
      }

    }

    protected void gvProfile_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

  }
}