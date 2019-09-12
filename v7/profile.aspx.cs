using System;
using System.Web.UI.WebControls;

namespace portal.v7
{
  public partial class profile : FormBase
  {
    private Sess se = new Sess();

    protected void dvProfile_DataBound(object sender, EventArgs e)
    {
      se.localize();

      // only display the Password if this account uses them (based on profile)
      if (se.usesPassword == false)
      {
        dvProfile.Rows[3].Visible = false;
      }


      Label membLevel = (Label)dvProfile.FindControl("membLevel");
      switch (membLevel.Text)
      {
        case "1": membLevel.Text = "Guest"; break;
        case "2": membLevel.Text = "Learner"; break;
        case "3": membLevel.Text = "Facilitator"; break;
        case "4": membLevel.Text = "Manager"; break;
        case "5": membLevel.Text = "Administrator"; break;
      }

      if ((bool)dvProfile.DataKey[0]) // hide username and password for internals
      {
        Label membId = (Label)dvProfile.FindControl("membId");
        membId.Text = "*************";
        Label membPwd = (Label)dvProfile.FindControl("membPwd");
        membPwd.Text = "*************";
      }

    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }


  }
}