using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal.v7.facilitator
{
	public partial class learners3 : System.Web.UI.Page
	{
		public int semembLevel = 3;

		protected void Page_Load(object sender, EventArgs e) { }

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


		protected void dvLearner_DataBound(object sender, EventArgs e)
		{
			if (dvLearner.CurrentMode.ToString() == "ReadOnly")  // display 
			{
				// use text to display level
				Label ctrMembLevel = (Label)dvLearner.FindControl("labMembLevel");
				if (ctrMembLevel != null)
				{
					int membLevel = int.Parse(ctrMembLevel.Text.ToString());
					switch (membLevel)
					{
						case 1: ctrMembLevel.Text = "guest"; break;
						case 2: ctrMembLevel.Text = "learner"; break;
						case 3: ctrMembLevel.Text = "facilitator"; break;
						case 4: ctrMembLevel.Text = "manager"; break;
						case 5: ctrMembLevel.Text = "administrator"; break;
					}
				}
			}
		}
     
		//// for membLevel, use label/hiddenfield for facs and dropdowns for mgrs/admns
		//Label ctrMembLevelLab = (Label)dvLearner.FindControl("labMembLevel");
		//  HiddenField ctrMembLevelTxt = (HiddenField)dvLearner.FindControl("txtMembLevel");
		//  DropDownList ctrMembLevelDdl = (DropDownList)dvLearner.FindControl("membLevel");
		//  //CheckBox ctrMembActiveChk = (CheckBox)dvLearner.FindControl("membActive");
		//  //ctrMembActiveChk.Checked = true;

		//  if (dvLearner.CurrentMode.ToString() == "ReadOnly")  // display 
		//  {
		//DataRowView rowView = (DataRowView)dvLearner.DataItem;
		////if (rowView.Row[0].ToString() == "SpecialID")
		////{
		//	dvLearner.FieldHeaderStyle.BackColor = System.Drawing.Color.Red;
		////}
		////DetailsView view = (DetailsView)sender;
		////   DetailsViewRowCollection rows = view.Rows;
		////   DetailsViewRow row = rows[1];
		////   ((TextBox)row.Cells[1].Controls[0]).Text = this.Request.QueryString["membId"];


		////DetailsViewRow row = dvLearner.Rows[1];






		////        int membLevel = int.Parse(dvLearner.DataKey[1].ToString());
		//int membLevel = int.Parse(ctrMembLevelLab.ToString());


		//switch (membLevel)
		//    {
		//      case 1: ctrMembLevelLab.Text = "guest"; break;
		//      case 2: ctrMembLevelLab.Text = "learner"; break;
		//      case 3: ctrMembLevelLab.Text = "facilitator"; break;
		//      case 4: ctrMembLevelLab.Text = "manager"; break;
		//      case 5: ctrMembLevelLab.Text = "administrator"; break;
		//    }
		//  }

		//  else // edit/insert
		//  {
		//    // if fac then use label and hidden field
		//    if (semembLevel == 3)
		//    {

		//      if (ctrMembLevelDdl != null) ctrMembLevelDdl.Visible = false;
		//      if (ctrMembLevelTxt != null) ctrMembLevelTxt.Value = "2";
		//      if (ctrMembLevelLab != null) ctrMembLevelLab.Text = "learner";

		//      if (dvLearner.CurrentMode.ToString() == "Edit")
		//      {
		//        //            int membLevel = int.Parse(dvLearner.DataKey[1].ToString());

		//      }
		//      // if mgr/adm use dropdown
		//    }
		//    else
		//    {
		//      switch (semembLevel)
		//      {
		//        case 4: // if mgr then can assign lrn or fac
		//          ctrMembLevelDdl.Items[0].Enabled = false;
		//          ctrMembLevelDdl.Items[3].Enabled = false;
		//          ctrMembLevelDdl.Items[4].Enabled = false;
		//          break;
		//        case 5: // if adm then can assign lrn, fac or mgr
		//          ctrMembLevelDdl.Items[0].Enabled = false;
		//          ctrMembLevelDdl.Items[4].Enabled = false;
		//          break;
		//      }
		//    }
		//  }


		protected void btnCancel_Click(object sender, EventArgs e)
		{
			//panTop.Visible = true;
			//panBot.Visible = false;
		}

		protected void dvLearner_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
		{
			gvLearners.DataBind();
		}

		protected void dvLearner_ItemInserting(object sender, DetailsViewInsertEventArgs e)
		{
			// ensure all mandatory fields were entered
			if (
					e.Values["membId"] == null ||
					e.Values["membPwd"] == null ||
					e.Values["membFirstName"] == null ||
					e.Values["membLastName"] == null ||
					e.Values["membEmail"] == null
			 )
			{
				labError.Text = "<br />You are missing one or more mandatory fields.";
				labError.Visible = true;
				e.Cancel = true;
			}
		}
		
		protected void dvLearner_PreRender(object sender, EventArgs e)
		{
			if (dvLearner.CurrentMode.ToString() == "Insert")  // display 
			{
        // set membActive to true
        CheckBox checkbox = (CheckBox)dvLearner.FindControl("membActive");
        if (checkbox != null)
        {
          checkbox.Checked = true;
        }
			}
		}


  }
}
