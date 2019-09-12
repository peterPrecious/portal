using System;
using System.Text.RegularExpressions;

namespace portal.v7.manager
{
  public partial class accountPassword : System.Web.UI.Page
  {
    Cust cu = new Cust();
    Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();
      if (!IsPostBack)
      {
        txtCurPwd.Text = txtNewPwd.Text = txtDupPwd.Text = "";

        int channelChildren = cu.customerChannelChildren(se.custAcctId);
        if (channelChildren > 0)
        {
          panActive.Visible = true;
          labCustIdActive.Text = se.custId;
          labChildrenNo.Text = channelChildren.ToString();
          labNewPassword1.Text = se.custId.Substring(0, 4) + "_";
          labNewPassword2.Text = se.custId.Substring(0, 4) + "_ADMIN" + DateTime.Now.Year.ToString() + "!";
        }
        else
        {
          panInactive.Visible = true;
          labCustIdInactive.Text = se.custId;
        }

      }
    }

    protected void butChange_Click(object sender, EventArgs e)
    {
      litError.Text = "";
      panError.Visible = false;

      string curPwd = txtCurPwd.Text.ToUpper();
      string newPwd = txtNewPwd.Text.ToUpper();
      string dupPwd = txtDupPwd.Text.ToUpper();

      var validChars = new Regex(@"^[A-Z0-9!*-_]+$");

      if (curPwd.Length < 8 || newPwd.Length < 8 || dupPwd.Length < 8)
      {
        litError.Text = "Passwords must be at least 8 characters long!";
      }
      else if (curPwd.Length > 50 || newPwd.Length > 50 || dupPwd.Length > 50)
      {
        litError.Text = "Passwords cannot excede 50 characters in length!";
      }
      else if (curPwd != se.custChannelManager)
      {
        litError.Text = "Your current manager password is not valid!";
      }
      else if (newPwd.Substring(0, 5) != se.custId.Substring(0, 4) + "_")
      {
        litError.Text = "Your new password must start with '" + se.custId.Substring(0, 4) + "_'";
      }
      else if (newPwd != dupPwd)
      {
        litError.Text = "Your new passwords are NOT the same!";
      }
      else if (curPwd == newPwd)
      {
        litError.Text = "Your new password is the same as the Current Password!";
      }
      else if (!validChars.IsMatch(newPwd))
      {
        litError.Text = "Your new password must only contain characters: A-Z 0-9 !*-_";
      }

      if (litError.Text.Length > 0)
      {
        panError.Visible = true;
      }
      else
      {
        // modify the customer channel passwords
        cu.customerChannelManager(se.custAcctId, curPwd, newPwd);

        // reload the customer record to get latest session variables (same as in default.aspx)
        cu.customer(se.custId);

        // store key customer values
        Session["custId"] = cu.custId;
        Session["custAcctId"] = cu.custAcctId;
        Session["custChannelManager"] = cu.custChannelManager;
        se.localize();

        panActive.Visible = false;
        panSuccess.Visible = true;

      }

    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}