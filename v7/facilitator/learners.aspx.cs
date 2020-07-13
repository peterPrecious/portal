using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal.v7.facilitator
{
  public partial class learners : FormBase

  {
    private readonly Sess se = new Sess();
    private readonly Apps ap = new Apps();

    protected void Page_Load(object sender, EventArgs e)
    {
      if (!IsPostBack)
      {
        se.localize();
        labError.Text = "";

        //SH - 07/06/20 - Display 'Include Child Accounts' flag for memb_level 4 or greater
        int membLevel = int.Parse(Session["membLevel"].ToString());
        if (membLevel >= 4)
        {
          chkIncludeChildAccounts.Visible = true;
        }

        // count number of learners to configure the title (store in session variable)
        int userCount = int.Parse(Session["userCount"].ToString());
        if (userCount == 0)
        {
          setNoLearnersText();
        }

        // this is called by javascript to edit the userName
        if (Request.Form["__EVENTTARGET"] == "ctl00$MainContent$dvLearner$membId")
        {
          membIdValidate();
        }
      }
    }

    protected override void Render(HtmlTextWriter writer)
    {
      // Register controls for event validation
      foreach (GridViewRow r in gvLearners.Rows)
      {
        if (r.RowType == DataControlRowType.DataRow)
        {
          Page.ClientScript.RegisterForEventValidation(gvLearners.UniqueID, "Select$" + r.RowIndex);
        }
      }

      base.Render(writer);
    }

    protected void setNoLearnersText()
    {
      DataView dv = null;

      if (chkIncludeChildAccounts.Checked)
      {
        dv = (DataView)SqlDataSource3.Select(DataSourceSelectArguments.Empty);
      }
      else
      {
        dv = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
      }

      Session["userCount"] = dv.Count;

      if (dv.Count == 0)
      {
        noLearners.Visible = false;
      }
      else if (dv.Count == 1)
      {
        noLearners.Text = Session["userCount"] + " " + GetGlobalResourceObject("portal", "noLearners_1").ToString();
      }
      else if (dv.Count == 200)
      {
        noLearners.Text = Session["userCount"] + " " + GetGlobalResourceObject("portal", "noLearners_200").ToString();
      }
      else
      {
        noLearners.Text = Session["userCount"] + " " + GetGlobalResourceObject("portal", "noLearners_2").ToString();
      }
    }

    // fired when we capture the search criteria
    protected void butSearch_Click(object sender, EventArgs e)
    {
      if (chkIncludeChildAccounts.Checked)
      {
        gvLearners.DataSourceID = SqlDataSource3.ID;
      }
      else
      {
        gvLearners.DataSourceID = SqlDataSource1.ID;
      }

      gvLearners.DataBind();
      setNoLearnersText();
    }

    // fired when we clear the search criteria
    protected void butClear_Click(object sender, EventArgs e)
    {
      txtSearch.Text = "";
      chkIncludeChildAccounts.Checked = false;
      gvLearners.DataSourceID = SqlDataSource1.ID;
      gvLearners.DataBind();
      setNoLearnersText();
    }

    protected void gvLearners_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.DataRow)
      {
        e.Row.Attributes["onclick"] = ClientScript.GetPostBackClientHyperlink(this.gvLearners, "Select$" + e.Row.RowIndex);
        e.Row.Attributes["style"] = "cursor:pointer";
      }
    }

    // this is fired when we select a learner to edit
    protected void gvLearners_SelectedIndexChanged(object sender, EventArgs e)
    {
      panIncludeChildAccounts_Message.Visible = false;
      panTop.Visible = false;
      panBot.Visible = true;
      dvLearner.ChangeMode(DetailsViewMode.ReadOnly);
      dvLearner.DataBind();

      GridViewRow row = gvLearners.SelectedRow;
      if(!string.IsNullOrWhiteSpace(row.Cells[5].Text))
      {
        int isChild = Convert.ToInt32(row.Cells[5].Text);

        if (isChild > 0)
        {
          ImageButton btnEdit = (ImageButton)dvLearner.FindControl("btnEdit");
          ImageButton btnDelete = (ImageButton)dvLearner.FindControl("btnDelete");

          if (btnEdit != null)
          {
            btnEdit.Enabled = false;
          }

          if (btnDelete != null)
          {
            btnDelete.Enabled = false;
          }

          panIncludeChildAccounts_Message.Visible = true;
        }
      }
    }

    // this is the icon at the top title to add a learner
    protected void AddLearner_Click(object sender, EventArgs e)
    {
      panTop.Visible = false;
      panBot.Visible = true;
    }

    // this is the icon on the bottom title to return and list learners
    protected void ListLearners_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
      labError.Text = "";
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
      dvLearner.ChangeMode(DetailsViewMode.ReadOnly);
    }

    // this initializes all fields when you add a new learner
    protected void dvLearner_ItemInit(object sender, ImageClickEventArgs e)
    {
      panTop.Visible = false;
      panBot.Visible = true;
      labError.Text = "";

      dvLearner.ChangeMode(DetailsViewMode.Insert);
      dvLearner.DataBind();

      if (dvLearner.FindControl("membId") != null)
      {
        ((TextBox)dvLearner.FindControl("membId")).Text = "";
        if (se.usesPassword) //se.usesPassword set on SignIn, typically a Profile entry
        {
          ((TextBox)dvLearner.FindControl("membPwd")).Text = "";
        }
        else
        {
          DetailsViewRow row = dvLearner.Rows[1];
          row.Visible = false;
        }

        ((TextBox)dvLearner.FindControl("membFirstName")).Text = "";
        ((TextBox)dvLearner.FindControl("membLastName")).Text = "";
        ((TextBox)dvLearner.FindControl("membEmail")).Text = "";
        ((TextBox)dvLearner.FindControl("membOrganization")).Text = "";
        ((TextBox)dvLearner.FindControl("membMemo")).Text = "";

        DropDownList ctrMembLevel = (DropDownList)dvLearner.FindControl("membLevel");
        ctrMembLevel.Items.FindByValue("1").Enabled = false;
        ctrMembLevel.Items.FindByValue("2").Enabled = true;
        ctrMembLevel.Items.FindByValue("5").Enabled = false;
        // disable levels unless beneath your membLevel
        int seMembLevel = int.Parse(Session["membLevel"].ToString());
        if (seMembLevel == 3)
        {
          ctrMembLevel.Items.FindByValue("3").Enabled = false;
          ctrMembLevel.Items.FindByValue("4").Enabled = false;
        }
        if (seMembLevel == 4)
        {
          ctrMembLevel.Items.FindByValue("3").Enabled = true;
          ctrMembLevel.Items.FindByValue("4").Enabled = false;
        }
        if (seMembLevel == 5)
        {
          ctrMembLevel.Items.FindByValue("3").Enabled = true;
          ctrMembLevel.Items.FindByValue("4").Enabled = true;
        }
        Label labMembLevel = (Label)dvLearner.FindControl("labMembLevel");
        labMembLevel.Text = ""; // only used for read

        HiddenField hidMembLevel = (HiddenField)dvLearner.FindControl("hidMembLevel");
        hidMembLevel.Value = "2";

        managerAccessHide(se.usesPassword); // Hide until membLevel set to 4 or 5
        ((CheckBox)dvLearner.FindControl("membActive")).Checked = true;
        ((CheckBox)dvLearner.FindControl("membEmailAlert")).Checked = true;
      }
    }

    protected void dvLearner_DataBound(object sender, EventArgs e)
    {
      if (dvLearner.CurrentMode.ToString() == "ReadOnly")  // display 
      {
        if (!se.usesPassword)  // hide Pwd if not needed  
        {
          Label labMembPwd = (Label)dvLearner.FindControl("membPwd");
          if (labMembPwd != null)
          {
            DetailsViewRow row = dvLearner.Rows[1];
            row.Visible = false;
          }
        }

        // this is the level of the person running this app
        int seMembLevel = int.Parse(Session["membLevel"].ToString());

        // this is the level of the learner being analyzed
        Label ctrMembLevel = (Label)dvLearner.FindControl("membLevel");
        // just offer levels below your own


        // these are the Manager Access values    
        Label ctrMembManagerAccess = (Label)dvLearner.FindControl("membManagerAccess");

        // both the session memb (ie me) and the user memb (being analyzed) must be managers
        if ((ctrMembLevel.Text == "Manager" || ctrMembLevel.Text == "Administrator") && seMembLevel > 3)
        {
          // use text to display managerAccess
          if (ctrMembManagerAccess != null)
          {
            string managerAccess = ctrMembManagerAccess.Text.ToString();
            if (managerAccess == "" || managerAccess == "0")
            {
              ctrMembManagerAccess.Text = "No Special Access";
            }
            else
            {
              ctrMembManagerAccess.Text = "Special Access: ";
              if (managerAccess.IndexOf("1") > -1) { ctrMembManagerAccess.Text += "<br />&nbsp;&nbsp;&nbsp;Program Table"; }
              if (managerAccess.IndexOf("2") > -1) { ctrMembManagerAccess.Text += "<br />&nbsp;&nbsp;&nbsp;Module Table"; }
              if (managerAccess.IndexOf("3") > -1) { ctrMembManagerAccess.Text += "<br />&nbsp;&nbsp;&nbsp;Extend Ecommerce"; }
            }
          }
          managerAccessShow(se.usesPassword);
        }
        else
        {
          managerAccessHide(se.usesPassword);
        }


      }

      if (dvLearner.CurrentMode.ToString() == "Edit")
      {
        if (!se.usesPassword)  // hide Pwd if not needed  
        {
          TextBox txtMembPwd = (TextBox)dvLearner.FindControl("membPwd");
          if (txtMembPwd != null)
          {
            DetailsViewRow row = dvLearner.Rows[1];
            row.Visible = false;
          }
        }

        // this is the level of the person running this app
        int seMembLevel = int.Parse(Session["membLevel"].ToString());

        // this is the level of the learner being analyzed
        HiddenField hidMembLevel = (HiddenField)dvLearner.FindControl("hidMembLevel");

        // added (forgotten) Sep 25, 2019
        DropDownList ctrMembLevel = (DropDownList)dvLearner.FindControl("membLevel");
        ctrMembLevel.Items.FindByValue("1").Enabled = false;
        ctrMembLevel.Items.FindByValue("2").Enabled = true;
        ctrMembLevel.Items.FindByValue("5").Enabled = false;
        // disable levels unless beneath your membLevel
        if (seMembLevel == 3)
        {
          ctrMembLevel.Items.FindByValue("3").Enabled = false;
          ctrMembLevel.Items.FindByValue("4").Enabled = false;
        }
        if (seMembLevel == 4)
        {
          ctrMembLevel.Items.FindByValue("3").Enabled = true;
          ctrMembLevel.Items.FindByValue("4").Enabled = false;
        }
        if (seMembLevel == 5)
        {
          ctrMembLevel.Items.FindByValue("3").Enabled = true;
          ctrMembLevel.Items.FindByValue("4").Enabled = true;
        }


        // set the Manager Access values since can be multiple values, ie 1,2    
        ListBox lstMembManagerAccess = (ListBox)dvLearner.FindControl("membManagerAccess");
        HiddenField hidMembManagerAccess = (HiddenField)dvLearner.FindControl("hidMembManagerAccess");

        // both the session memb (ie me) and the user memb (being analyzed) must be managers
        if ((hidMembLevel.Value == "4" || hidMembLevel.Value == "5") && seMembLevel > 3)
        {
          // use text to display managerAccess
          if (lstMembManagerAccess != null)
          {
            string managerAccess = hidMembManagerAccess.Value;

            if (managerAccess == "") lstMembManagerAccess.Items[0].Selected = true;
            if (managerAccess.IndexOf("0") > -1) lstMembManagerAccess.Items[0].Selected = true;
            if (managerAccess.IndexOf("1") > -1) lstMembManagerAccess.Items[1].Selected = true;
            if (managerAccess.IndexOf("2") > -1) lstMembManagerAccess.Items[2].Selected = true;
            if (managerAccess.IndexOf("3") > -1) lstMembManagerAccess.Items[3].Selected = true;
          }
          managerAccessShow(se.usesPassword);
        }
        else
        {
          managerAccessHide(se.usesPassword);
        }
      }
    }

    protected void dvLearner_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
      // ensure all mandatory fields were entered
      string missingFields = "";
      if (e.Values["membId"] == null) missingFields += " " + GetGlobalResourceObject("portal", "membId").ToString() + ",";
      if (e.Values["membPwd"] == null && se.usesPassword) missingFields += " " + GetGlobalResourceObject("portal", "password").ToString() + ",";
      if (e.Values["membFirstName"] == null) missingFields += " " + GetGlobalResourceObject("portal", "firstName").ToString() + ",";
      if (e.Values["membLastName"] == null) missingFields += " " + GetGlobalResourceObject("portal", "lastName").ToString() + ",";
      if (e.Values["membEmail"] == null) missingFields += " " + GetGlobalResourceObject("portal", "email").ToString() + ",";
      if (missingFields.Length > 0)
      {
        //labError.Text = "You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".";
        labError.Text = GetGlobalResourceObject("portal", "learners_8").ToString() + missingFields.TrimEnd(',') + ".";
        e.Cancel = true;
      }

      DropDownList ctrMembLevel = (DropDownList)dvLearner.FindControl("membLevel");
      e.Values["membLevel"] = ctrMembLevel.SelectedValue;


      // create single string for managerAccess display
      ListBox ctrMembManagerAccess = (ListBox)dvLearner.FindControl("membManagerAccess");
      string membManagerAccess = null;
      foreach (ListItem item in ctrMembManagerAccess.Items)
      {
        if (item.Selected)
        {
          membManagerAccess += item.Value + ",";
        }
      }
      if (membManagerAccess != null) membManagerAccess = membManagerAccess.TrimEnd(',');
      e.Values["membManagerAccess"] = membManagerAccess;
    }

    protected void dvLearner_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
      if (e.Exception != null)
      {
        string sqlNumber = ((System.Data.SqlClient.SqlException)e.Exception).Number.ToString();
        if (sqlNumber == "2627")
        {
          labError.Text = "<p />" + GetGlobalResourceObject("portal", "sqlDuplicate").ToString();
        }
        else
        {
          labError.Text = "<p />" + GetGlobalResourceObject("portal", "sql").ToString() + "<br />[SQL error: " + sqlNumber + " - " + e.Exception.Message.ToString() + "]  Contact Support Services.";
        }
        e.ExceptionHandled = true;
        e.KeepInInsertMode = true;
      }
      else
      {
        Response.Redirect("/portal/v7/facilitator/learners.aspx");
      }
    }

    protected void dvLearner_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
      string _membPwd = "", _membFirstName = "", _membLastName = "", _membEmail = "";

      // ensure all mandatory fields were entered
      if (se.usesPassword)
      {
        TextBox txtMembPwd = (TextBox)dvLearner.FindControl("membPwd"); _membPwd = txtMembPwd.Text.Trim();
      }
      TextBox txtMembFirstName = (TextBox)dvLearner.FindControl("membFirstName"); _membFirstName = txtMembFirstName.Text.Trim();
      TextBox txtMembLastName = (TextBox)dvLearner.FindControl("membLastName"); _membLastName = txtMembLastName.Text.Trim();
      TextBox txtMembEmail = (TextBox)dvLearner.FindControl("membEmail"); _membEmail = txtMembEmail.Text.Trim();

      string missingFields = "";
      if (se.usesPassword)
      {
        if (_membPwd.Length == 0) missingFields += " Password,";
      }
      if (_membFirstName.Length == 0) missingFields += " First Name,";
      if (_membLastName.Length == 0) missingFields += " Last Name,";
      if (_membEmail.Length == 0) missingFields += " Email,";
      if (missingFields.Length > 0)
      {
        labError.Text = "<p />You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".";
        labError.Visible = true;
        e.Cancel = true;
      }

      // for some reason I need to force this value into membLevel
      DropDownList ctrMembLevel = (DropDownList)dvLearner.FindControl("membLevel");
      e.NewValues["membLevel"] = ctrMembLevel.SelectedValue;

      // create single string for managerAccess display
      ListBox ctrMembManagerAccess = (ListBox)dvLearner.FindControl("membManagerAccess");
      string membManagerAccess = null;
      foreach (ListItem item in ctrMembManagerAccess.Items)
      {
        if (item.Selected)
        {
          membManagerAccess += item.Value + ",";
        }
      }
      if (membManagerAccess != null) membManagerAccess = membManagerAccess.TrimEnd(',');
      e.NewValues["membManagerAccess"] = membManagerAccess;
    }

    protected void dvLearner_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
      if (e.Exception != null)
      {
        string sqlNumber = ((System.Data.SqlClient.SqlException)e.Exception).Number.ToString();
        labError.Text = "<p />" + GetGlobalResourceObject("portal", "sql").ToString() + "<br />[SQL error: " + sqlNumber + " - " + e.Exception.Message.ToString() + "]  Contact Support Services.";

        labError.Visible = true;
        e.ExceptionHandled = true;
      }
      else
      {
        Response.Redirect("/portal/v7/facilitator/learners.aspx");
      }
    }

    protected void dvLearner_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
      Response.Redirect("/portal/v7/facilitator/learners.aspx");
    }

    protected void membIdValidate()
    {
      TextBox txtMembId = (TextBox)dvLearner.FindControl("membId");
      Label labMembId = (Label)dvLearner.FindControl("labNotUnique");
      string membId = txtMembId.Text;

      int count;
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7isIdUnique2";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@membId", membId));
          cmd.Parameters.Add("@count", SqlDbType.Int).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          count = (int)cmd.Parameters["@count"].Value;
        }
      }

      labMembId.Visible = false;
      if (count > 0) // count 0 means there are no existing learners on file with that membId
      {
        string sqlNumber = "2627"; // use value for this;
        labError.Text = "<p />" + GetGlobalResourceObject("portal", "sql_" + sqlNumber).ToString();
        labError.Visible = true;
        labMembId.Visible = true;
      }
    }

    protected void butResendEmailAlerts_Click(object sender, ImageClickEventArgs e)
    {
      int membNo = (int)dvLearner.DataKey[0];
      ap.resetLearnerProgramAssignment(membNo);
      ((Label)dvLearner.FindControl("labResendEmailAlerts")).Visible = true;
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }


    protected void managerAccessHide(bool usesPassword)  // use javascript to hide/show the Manager Access Row (easier)
    {
      //    "$(function () { managerAccess('hide', false); });",
      //    "$(function () { managerAccess('show', " + usesPassword + "); });",
      string script = "$(function () { managerAccess('hide', '" + usesPassword + "'); });";
      ScriptManager.RegisterClientScriptBlock(
        this,
        GetType(),
        "scriptHidden",
        script,
        true
      );
    }

    protected void managerAccessShow(bool usesPassword)
    {
      string script = "$(function () { managerAccess('show', '" + usesPassword + "'); });";
      ScriptManager.RegisterClientScriptBlock(
        this,
        GetType(),
        "scriptVisible",
        script,
        true
      );
    }

    protected void dvLearner_PageIndexChanging(object sender, DetailsViewPageEventArgs e)
    {

    }
  }
}