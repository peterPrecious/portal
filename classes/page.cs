using System;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web.UI;

namespace portal
{
  // this is invoked before every page to handle language and the pageTitle
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

    protected override void OnLoadComplete(EventArgs e)
    {
      string path, fileName, title;

      // This sets/overrides the page's title when a page is setup as:
      // public partial class WebForm1 : pageTitle
      // Start by determining the filename for this page

      // this is for a normal page (not an iFrame)
      path = Request.Path;
      fileName = System.IO.Path.GetFileNameWithoutExtension(path);

      if (fileName != null)
      {

        if (fileName == "iFrame") // this is typically an iFrame so look for a title parm in the URL
        {
          title = Request.QueryString["title"];
          if (title != null)
          {
            fileName = title;
            fileName = fileName.Replace(" ", "");
          }
        }

        fileName = fileName.First().ToString().ToUpper() + fileName.Substring(1);  // this will typically already start with a cap it it's a Title
        fileName = "page" + fileName;

        // Then translate the filename, if not in the translate system then stick to the file name
        //try
        //{
        //  fileName = GetGlobalResourceObject("portal", fileName).ToString();
        //}
        //catch (Exception) { }

        Page.Title = fileName;
      }

      base.OnLoadComplete(e);
    }

  }
}