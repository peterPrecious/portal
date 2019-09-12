using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal
{
  public partial class pooh : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      Cust cu = new Cust();
      Memb me = new Memb();
      Sess se = new Sess();
      Apps ap = new Apps();

      bool pooh = cu.isEmailAlert("CCHS1068");


    }
  }
}