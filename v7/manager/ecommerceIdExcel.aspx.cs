using System;
using System.Web.UI.WebControls;

namespace portal.v7.manager
{
	public partial class ecommerceIdExcel : FormBase
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
			if (txtOrderId.Text.Length == 0 && txtLineId.Text.Length == 0)
			{
				panError.Visible = true;
			}
			else
			{
				Excel ex = new Excel(); // instantiate the excelwriter

				ex.DocName = ("Ecommerce" + " (" + DateTime.Now.ToString("MMM d, yyyy") + ")").Replace(" ", "_") + ".xlsx" ;			// excel file name - doesn't like spaces
				ex.WsName = "Ecommerce By Id";																																										// this is the worksheet name which shows on the first tab at the bottom
				ex.SpName = "[apps].[dbo].[sp7ecommerceExcel]";																																		// this is the stored proc that drives this - must be "excelWriter" friendly    

				ex.IntParms[0] = Convert.ToInt32(ddTop.SelectedValue);
				ex.StrParms[0] = Session["cust"].ToString();
				ex.StrParms[1] = txtOrderId.Text;
				ex.StrParms[2] = txtLineId.Text;
				ex.DatParms[0] = null;
				ex.DatParms[1] = null;

				ex.excelWriter();
			}
		}

		protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			Response.Redirect("/portal/v7/default.aspx");
		}

	}

}