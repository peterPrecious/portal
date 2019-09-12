using System;

namespace portal
{
  public partial class forgot : System.Web.UI.Page
  {

    private Mail ma = new Mail();
    private Memb me = new Memb();

    protected void Page_Load(object sender, EventArgs e) { }

    protected void btnEmail_Click(object sender, EventArgs e)
    {
      string emailFrom = "support@vubiz.com";
      string emailTo = txtEmail.Text;
      string subject = "Your credentials";


      if (emailTo.Length == 0)
      {
        labEmail.Text = "Please enter a valid Email Address.";
        return;
      }

      // get credentials if email address is unique (ie count = 1)
      me.memberByEmail(emailTo, out int count, out string custId, out string membId, out string membPwd);

      if (count == 1)
      {
        string body = "Email: " + emailTo +
                      "<br />Customer Id: " + custId +
                      "<br />Username: " + membId +
                      "<br />Password: " + membPwd;
        labEmail.Text = ma.sendMessage(emailFrom, emailTo, subject, body);
      }
      else if (count == 0)
      {
        labEmail.Text = "That Email is not on file.";
      }
      else if (count > 1)
      {
        labEmail.Text = "That Email is NOT Unique, ie more than one learner has that email address.";
      }

    }
  }
}