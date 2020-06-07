using System;
using System.Linq;

namespace basePageClass
{
  public class pageTitle : System.Web.UI.Page
  {
    protected override void OnLoadComplete(EventArgs e)
    {
      // This sets/overrides the page's title when a page is setup as (replace WebForm1 with actual page name):
      // public partial class WebForm1 : pageTitle
      // Start by determining the filename for this page
      string fileName = System.IO.Path.GetFileNameWithoutExtension(Request.PhysicalPath);

      fileName = fileName.First().ToString().ToUpper() + fileName.Substring(1);
      fileName = "page" + fileName;

      // Then translate the filename, if not in the translate system then stick to the file name
      try
      {
        fileName = GetGlobalResourceObject("portal", fileName).ToString();
      }
      catch (Exception) { }

      Page.Title = fileName;

      base.OnLoadComplete(e);
    }
  }
}