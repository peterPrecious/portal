using System;
using System.Globalization;
using System.Threading;

namespace portal
{
  public partial class errors : FormBase
  {

    protected override void InitializeCulture()
    {
      // get system culture
      if (Session["culture"] is null) Session["culture"] = Thread.CurrentThread.CurrentUICulture.Name.ToString();

      UICulture = Session["culture"].ToString();
      Culture = Session["culture"].ToString();
      Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
      Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());
      base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e) { }

  }
}