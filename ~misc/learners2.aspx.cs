using System;
using System.Web.UI.WebControls;

namespace portal.v7.facilitator
{
	public partial class learners2 : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{

		}



		protected void dvLearner_ItemInit(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			// clear out any values from previous insert
			dvLearner.ChangeMode(DetailsViewMode.Insert);
			if (dvLearner.FindControl("membId") != null)
			{
				((TextBox)dvLearner.FindControl("membId")).Text = "";
				((TextBox)dvLearner.FindControl("membPwd")).Text = "";
				((TextBox)dvLearner.FindControl("membFirstName")).Text = "";
				((TextBox)dvLearner.FindControl("membLastName")).Text = "";
				((TextBox)dvLearner.FindControl("membEmail")).Text = "";
				((TextBox)dvLearner.FindControl("membOrganization")).Text = "";
				((TextBox)dvLearner.FindControl("membMemo")).Text = "";

				((DropDownList)dvLearner.FindControl("membLevel")).SelectedIndex = 1;
				((CheckBox)dvLearner.FindControl("membActive")).Checked = true;
				((CheckBox)dvLearner.FindControl("membEmailAlert")).Checked = true;
			}
		}

		protected void dvLearner_PageIndexChanging(object sender, DetailsViewPageEventArgs e)
		{

		}


		protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
		{
			Response.Redirect("/portal/v7/default.aspx");
		}


	}
}