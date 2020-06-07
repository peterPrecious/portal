using System;
using System.Globalization;
using System.Threading;
using System.Web.UI;

namespace portal
{
  public class FormBase : Page
  {

    protected override void InitializeCulture()
    {
      // http://stackoverflow.com/questions/8702296/asp-net-web-page-globalization-localization-in-master-page-c-sharp-3-0

      try
      {
        Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
        Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());
      }
      catch (Exception e)
      {
        System.Diagnostics.Debug.WriteLine("{0} Exception caught.", e);
        Response.Redirect("/portal/index.html");
      }

    }
  }
}