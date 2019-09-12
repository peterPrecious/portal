using System;
using System.Web;

namespace portal.v7.manager
{
  public partial class assessments : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e) { }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void imgClose_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      miniEditorShell.Visible = false;
      // refresh grid with updated session values
      gvAssess.DataBind();
    }

    protected void gvAssess_SelectedIndexChanged(object sender, EventArgs e)
    {
      // this launches Bryan's mini editor with the selected session values (will not work on localhost)
      int membNo = Convert.ToInt32(gvAssess.DataKeys[gvAssess.SelectedIndex].Values[0]);
      int modsNo = Convert.ToInt32(gvAssess.DataKeys[gvAssess.SelectedIndex].Values[1]);
      int progNo = Convert.ToInt32(gvAssess.DataKeys[gvAssess.SelectedIndex].Values[2]);
      int sessId = Convert.ToInt32(gvAssess.DataKeys[gvAssess.SelectedIndex].Values[3]);

      // when testing on localhost, we need to force B's app from staging since we don't have that app locallh
      string host = fn.host();
      string url = host == "localhost"
        ? "https://stagingweb.vubiz.com/Gold/vuSCORMAdmin/SessionQuickEdit.aspx?MembNo=" + membNo + "&SessionID=" + sessId + "&memberID=" + membNo + "&moduleID=" + modsNo + "&programID=" + progNo
        : "/Gold/vuSCORMAdmin/SessionQuickEdit.aspx?MembNo=" + membNo + "&SessionID=" + sessId + "&memberID=" + membNo + "&moduleID=" + modsNo + "&programID=" + progNo;
      miniEditor.Attributes["src"] = url;
      miniEditorShell.Visible = true;
    }

    protected Boolean hasAssessments(int numAssessments)
    {
      return numAssessments > 0;
    }


  }
}