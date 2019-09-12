using System;
using System.Text;
using System.Web.UI.WebControls;

namespace portal.v7.manager
{
  public partial class documentStatus : System.Web.UI.Page
  {
    Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();
    }

    protected void doc_Click(object sender, EventArgs e)
    {
      string document = ((LinkButton)sender).Text;
      documentUrl(document, "", se.lang, se.cust, se.custAcctId, "", "");
    }


    protected void documentUrl(string document, string modsId, string lang, string cust, string custAcctId, string progId, string memo)
    {
      string parms = ""
        + "&vFileName=" + document.ToLower()
        + "&vModsId=" + modsId.ToUpper()
        + "&vLang=" + lang.ToUpper()
        + "&vCust=" + cust.ToUpper()
        + "&vAcctId=" + custAcctId.ToUpper()
        + "&vProgId=" + progId.ToUpper()
        + "&vMemo=" + memo;

      byte[] bytes = Encoding.Default.GetBytes(parms);
      parms = Encoding.UTF8.GetString(bytes);

      byte[] byte2 = System.Text.Encoding.UTF8.GetBytes(parms);
      parms = System.Convert.ToBase64String(byte2);
      string url ="/DocService/Document.aspx?vParms=" + parms;
//      Response.Redirect(url, true);


      Response.Write("<script>");
      Response.Write("window.open('" + url + "','_new')");
      Response.Write("</script>");



    }




    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}