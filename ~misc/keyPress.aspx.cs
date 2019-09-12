using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal
{
  public partial class keyPress : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
      Label1.Text = hiddenField.Value;
      hiddenField.Value = "";
    }
  }
}