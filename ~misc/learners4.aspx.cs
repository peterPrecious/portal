using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal.v7.facilitator
{
	public partial class learners4 : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}

		protected void CustomerDetailView_DataBound(object sender,	EventArgs e)
		{
			DataRowView rowView = (DataRowView)CustomerDetailView.DataItem;
			if (rowView.Row[0].ToString() == "SpecialID")
			{
				CustomerDetailView.FieldHeaderStyle.BackColor =
					System.Drawing.Color.Red;
			}
		}


	}
}