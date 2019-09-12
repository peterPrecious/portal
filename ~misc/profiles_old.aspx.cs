using System;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class profiles : FormBase //  System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {

      // configure header background color (from Profile color)
     // gvProfiles.HeaderStyle.BackColor = System.Drawing.ColorTranslator.FromHtml(Session["color"].ToString());

      //tdProfileData.Visible = false;
      //panProfileDesc.Visible = false; // hide the parameter description panel
    }

    protected void gvProfileList_SelectedIndexChanged(object sender, EventArgs e)
    {
      //tdProfileList.Visible = false;
    //  tdProfileData.Visible = true;
    }
    protected void gvProfileData_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      //gvProfiles.DataBind();
    }

    protected void lnkPopupDesc_Command(object sender, CommandEventArgs e)
    {
      //string popup = e.CommandArgument.ToString();
      //if (popup == "") popup = "Sorry|This parameter has not yet been defined";
      //string[] popups = popup.Split('|');
      //labProfileDesc.Text = "<h1>" + popups[0] + "</h3>" + popups[1];
      //panProfileDesc.Visible = true;
    }

    protected void butBack_Click(object sender, EventArgs e)
    {
      //tdProfileList.Visible = true;
   //   tdProfileData.Visible = false;
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}