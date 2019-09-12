using System;

namespace portal.v7.manager
{
  public partial class crossAccountProgramActivityExcel : FormBase
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				imgExcel.Visible = true;
			}
		}

		protected void imgExcel_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			// ensure dates are kosher
			if (txtProgramId.Text.Length != 7)
			{
				panError.Visible = true;
			}
			else
			{
				Excel ex = new Excel(); // instantiate the excelwriter (ensure there are NO commas in the file name [chrome])
				ex.DocName = ("Program Activity" + " (" + DateTime.Now.ToString("MMM d yyyy") + ")").Replace(" ", "_").Replace(",", "_");			// excel file name - doesn't like spaces
				ex.WsName = "Cross Account Program Activity for Account Group " + Session["cust"].ToString();                                 // this is the worksheet name which shows on the first tab at the bottom
        ex.SpName = "[apps].[dbo].[spXcrossAccountProgramActivity]";																									                // this is the stored proc that drives this - must be "excelWriter" friendly    
				ex.StrParms[0] = Session["cust"].ToString();
				ex.StrParms[1] = txtProgramId.Text;
				ex.excelWriter();
			}
		}

		protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			Response.Redirect("/portal/v7/default.aspx");
		}
	}
}