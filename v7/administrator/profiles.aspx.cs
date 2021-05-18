using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class profiles : FormBase
  {

    protected void Page_Load(object sender, EventArgs e)
    {
      //Session["custId"] = "";

      //string start = Request.QueryString["start"];
      //if (fn.fDefault(start, "") == "dvProfile")
      //{
      //  panTop.Visible = false;
      //  panBot.Visible = true;
      //  SqlDataSource2.SelectParameters["profNo"].DefaultValue = Session["profNo"].ToString();
      //  dvProfile.ChangeMode(DetailsViewMode.ReadOnly);
      //}

      //panConfirmShell.Visible = false;
    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      gvProfiles.DataBind();
    }

    protected void gvProfiles_SelectedIndexChanged(object sender, EventArgs e)
    {
      // this is fired when we select a Profile to edit
      panTop.Visible = false;
      panBot.Visible = true;
      dvProfile.ChangeMode(DetailsViewMode.ReadOnly);

      // store the selected Profile No
      Session["profNo"] = gvProfiles.DataKeys[1].Value;

    }

    protected void listProfiles_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
      dvProfile.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void btnConfirm_Command(object sender, CommandEventArgs e)
    {
      btnConfirmOk.Visible = true; // this is set to false below
      Session["confirmParms"] = e.CommandArgument;
      string[] parm = Session["confirmParms"].ToString().Split('|');

      if (parm[0] == "Clone")
      {
        int row = ((sender as ImageButton).NamingContainer as GridViewRow).RowIndex;
        string profNameNew = ((TextBox)gvProfiles.Rows[row].FindControl("profNameNew")).Text.ToUpper();

        if (profNameNew == "")
        {
          labConfirmTitle.Text = "Oops !";
          labConfirmMessage.Text = "In order to Clone '" + parm[2] + "',<br />you must enter a new Profile Clone Name.";
          btnConfirmOk.Visible = false;
          btnConfirmCancel.Text = "OK Cancel";
          panConfirmShell.Visible = true;
        }
        else
        {
          Session["confirmParms"] += "|" + profNameNew;
          parm = Session["confirmParms"].ToString().Split('|');

          labConfirmTitle.Text = "Note !";
          labConfirmMessage.Text = "You are about to Clone profile '" + parm[2] + "'.<br />Clicking OK will create a new Profile called '" + parm[3] + "'";
          btnConfirmOk.Visible = true;
          btnConfirmCancel.Text = "Cancel";
          btnConfirmOk.Text = "OK";
          panConfirmShell.Visible = true;
        }
      }

      else if (parm[0] == "Delete")
      {
        labConfirmTitle.Text = "Note !";
        labConfirmMessage.Text = "You are about to Delete profile '" + parm[2] + "'.<br />This is an irreversable action.";
        btnConfirmOk.Visible = true;
        btnConfirmCancel.Text = "Cancel";
        btnConfirmOk.Text = "OK";
        panConfirmShell.Visible = true;
      }

    }

    protected void btnConfirmOk_Click(object sender, EventArgs e)
    {
      string[] parm = Session["confirmParms"].ToString().Split('|');

      if (parm[0] == "Clone")
      {
        string profileNameOld = parm[2];
        string profileNameNew = parm[3];

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
        {
          con.Open();
          using (SqlCommand cmd = new SqlCommand())
          {
            cmd.Connection = con;
            cmd.CommandText = "dbo.sp7profileClone";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@profileNameOld", profileNameOld));
            cmd.Parameters.Add(new SqlParameter("@profileNameNew", profileNameNew));

            cmd.ExecuteNonQuery();
          }
        }
      }
      else if (parm[0] == "Delete")
      {
        string profileNo = parm[1];

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
        {
          con.Open();
          using (SqlCommand cmd = new SqlCommand())
          {
            cmd.Connection = con;
            cmd.CommandText = "dbo.sp7profileDelete";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@profileNo", profileNo));

            cmd.ExecuteNonQuery();
          }
        }

      }

      Session["confirmParms"] = "";
      Response.Redirect("/portal/v7/administrator/Profiles.aspx");

    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void hideRows(object sender, EventArgs e)
    {
      int i = 31; // use this for row number (if you add an element, increase this value by 1)

      // Important: hide rows from bottom of the table upwards so the integrity of the row numbers remains
      Label label = (Label)dvProfile.FindControl("profNo");
      dvProfile.Rows[31].Visible = false;

      // "c" is for CheckBox and "l" is for Label
      // these must be listed in the reverse order that they appear (except for Internal No - above)
      hideRow("c", i--, "profVukidz");
      hideRow("c", i--, "profVideos");
      hideRow("l", i--, "profStoreId");
      hideRow("l", i--, "profSso");
      hideRow("c", i--, "profShowSoloPrograms");
      hideRow("l", i--, "profReturnUrl");
      hideRow("c", i--, "profPortal");
      hideRow("c", i--, "profPassword");
      hideRow("c", i--, "profMemb_E");
      hideRow("l", i--, "profLogo");
      hideRow("c", i--, "profLang_fr");
      hideRow("c", i--, "profLang_es");
      hideRow("c", i--, "profLang_en");
      hideRow("l", i--, "profLang");
      hideRow("c", i--, "profJit");
      hideRow("c", i--, "profGuests_E");
      hideRow("c", i--, "profGuests");
      hideRow("l", i--, "profEmailFrom");
      hideRow("c", i--, "profEcommerce");
      hideRow("l", i--, "profCustId");
      hideRow("l", i--, "profCourseTileName_en");
      hideRow("l", i--, "profNameReports");
      hideRow("l", i--, "profNamePrograms");
      hideRow("l", i--, "profNameCatalogue");
      hideRow("l", i--, "profContentSource");
      hideRow("l", i--, "profCertPrograms_E");
      hideRow("l", i--, "profCertPrograms");
      hideRow("c", i--, "profAutoSignIn");
      hideRow("c", i--, "profAutoEnrollWs");
      hideRow("c", i--, "profAutoEnroll");
      hideRow("l", i--, "profAlias");

      //lnkShow.Visible = true;
    }

    protected void hideRow(string type, int rowNo, string control)
    {
      // dvProfile.Rows[rowNo].BackColor = System.Drawing.Color.Black; // for debugger;
      if (type == "c")
      {
        CheckBox checkBox = (CheckBox)dvProfile.FindControl(control);
        if (!checkBox.Checked) dvProfile.Rows[rowNo].Visible = false;
      }
      else if (type == "l")
      {
        Label label = (Label)dvProfile.FindControl(control);
        if (label.Text == "") dvProfile.Rows[rowNo].Visible = false;
      }
    }

    protected void lnkHide_Click(object sender, EventArgs e)
    {
      //hideRows(sender, e);
      //lnkHide.Visible = false;
      //lnkShow.Visible = true;
    }

    protected void lnkShow_Click(object sender, EventArgs e)
    {
      Response.Redirect("profiles.aspx?start=dvProfile&profNo=" + Session["profNo"].ToString());
    }




    protected void dvProfile_ItemInit(object sender, EventArgs e)
    {
      // this initializes all fields when you add a new profile

      panTop.Visible = false;
      panBot.Visible = true;
      labError.Text = "";

      dvProfile.ChangeMode(DetailsViewMode.Insert);
      dvProfile.DataBind();

      ((TextBox)dvProfile.FindControl("profName")).Text = "";
      ((TextBox)dvProfile.FindControl("profAlias")).Text = "";

      ((CheckBox)dvProfile.FindControl("profAutoEnroll")).Checked = true;
      ((CheckBox)dvProfile.FindControl("profAutoEnrollWs")).Checked = true;
      ((CheckBox)dvProfile.FindControl("profAutoSignIn")).Checked = true;

      ((TextBox)dvProfile.FindControl("profCertPrograms")).Text = "";
      ((TextBox)dvProfile.FindControl("profCertPrograms_E")).Text = "";

      DropDownList profContentSource = (DropDownList)dvProfile.FindControl("profContentSource");
      profContentSource.Items.FindByValue("ecommerce").Enabled = true;
      profContentSource.Items.FindByValue("assigned").Enabled = false;
      profContentSource.Items.FindByValue("ecom-assigned").Enabled = false;

      ((TextBox)dvProfile.FindControl("profNameCatalogue")).Text = "";
      ((TextBox)dvProfile.FindControl("profNamePrograms")).Text = "";
      ((TextBox)dvProfile.FindControl("profNameReports")).Text = "";
      ((TextBox)dvProfile.FindControl("profNameCourses")).Text = "";
      ((TextBox)dvProfile.FindControl("profCourseTileName_en")).Text = "";
      ((TextBox)dvProfile.FindControl("profCustId")).Text = "";

      ((CheckBox)dvProfile.FindControl("profEcommerce")).Checked = true;
      ((TextBox)dvProfile.FindControl("profEmailFrom")).Text = "";
      ((CheckBox)dvProfile.FindControl("profGuests")).Checked = true;
      ((CheckBox)dvProfile.FindControl("profGuests_E")).Checked = true;
      ((CheckBox)dvProfile.FindControl("profJit")).Checked = true;

      DropDownList profLang = (DropDownList)dvProfile.FindControl("profLang");
      profLang.Items.FindByValue("EN").Enabled = true;
      profLang.Items.FindByValue("ES").Enabled = false;
      profLang.Items.FindByValue("FR").Enabled = false;

      ((CheckBox)dvProfile.FindControl("profLang_en")).Checked = true;
      ((CheckBox)dvProfile.FindControl("profLang_es")).Checked = false;
      ((CheckBox)dvProfile.FindControl("profLang_fr")).Checked = false;

      ((TextBox)dvProfile.FindControl("profLogo")).Text = "";
      ((CheckBox)dvProfile.FindControl("profMemb_E")).Checked = false;
      ((CheckBox)dvProfile.FindControl("profPassword")).Checked = false;
      ((CheckBox)dvProfile.FindControl("profPortal")).Checked = false;
      ((TextBox)dvProfile.FindControl("profReturnUrl")).Text = "";
      ((CheckBox)dvProfile.FindControl("profShowSoloPrograms")).Checked = false;
      ((TextBox)dvProfile.FindControl("profSso")).Text = "";
      ((TextBox)dvProfile.FindControl("profStoreId")).Text = "";
      ((CheckBox)dvProfile.FindControl("profVideos")).Checked = false;
      ((CheckBox)dvProfile.FindControl("profVukidz")).Checked = false;

      ((Label)dvProfile.FindControl("profNo")).Text = "";
    }

    protected void dvProfile_DataBound(object sender, EventArgs e)
    {
      if (dvProfile.CurrentMode.ToString() == "ReadOnly")  // display 
      {
        panBotHeader.Text = "Profile Details";
      }

      if (dvProfile.CurrentMode.ToString() == "Edit")
      {
        panBotHeader.Text = "Edit this Profile's Details";
      }
    }

    protected void dvProfile_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
      // ensure all mandatory fields were entered
      string missingFields = "";
      if (e.Values["profName"] == null) missingFields += " Profile Name,";
      if (e.Values["profCustId"] == null) missingFields += " Customer Id,";
      //if (e.Values["membLastName"] == null) missingFields += " " + GetGlobalResourceObject("portal", "lastName").ToString() + ",";
      //if (e.Values["membEmail"] == null) missingFields += " " + GetGlobalResourceObject("portal", "email").ToString() + ",";

      if (missingFields.Length > 0)
      {
        //labError.Text = "You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".";
        labError.Text = "You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".";
        e.Cancel = true;
      }

    }

    protected void dvProfile_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
    {
      if (e.Exception != null)
      {
        string sqlNumber = ((System.Data.SqlClient.SqlException)e.Exception).Number.ToString();
        if (sqlNumber == "2627")
        {
          labError.Text = "<p>" + GetGlobalResourceObject("portal", "sqlDuplicate").ToString() + "</p>";
        }
        else
        {
          labError.Text = "<p>" + GetGlobalResourceObject("portal", "sql").ToString() + "<br />[SQL error: " + sqlNumber + " - " + e.Exception.Message.ToString() + "]  Contact Support Services." + "</p>";
        }
        e.ExceptionHandled = true;
        e.KeepInInsertMode = true;
      }
      else
      {
        Response.Redirect("/portal/v7/administrator/profiles.aspx");
      }
    }

    protected void dvProfile_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
      //string _membPwd = "", _membFirstName = "", _membLastName = "", _membEmail = "";

      //// ensure all mandatory fields were entered
      //if (usesPassword)
      //{
      //  TextBox txtMembPwd = (TextBox)dvProfile.FindControl("membPwd"); _membPwd = txtMembPwd.Text.Trim();
      //}

      //TextBox txtMembFirstName = (TextBox)dvProfile.FindControl("membFirstName"); _membFirstName = txtMembFirstName.Text.Trim();
      //TextBox txtMembLastName = (TextBox)dvProfile.FindControl("membLastName"); _membLastName = txtMembLastName.Text.Trim();
      //TextBox txtMembEmail = (TextBox)dvProfile.FindControl("membEmail"); _membEmail = txtMembEmail.Text.Trim();

      //HiddenField hidMembLevel = (HiddenField)dvProfile.FindControl("hidMembLevel");
      //int seMembLevel = int.Parse(Session["membLevel"].ToString());

      //string missingFields = "";
      //if (usesPassword)
      //{
      //  if (_membPwd.Length == 0) missingFields += " Password,";
      //}
      //if (_membFirstName.Length == 0) missingFields += " First Name,";
      //if (_membLastName.Length == 0) missingFields += " Last Name,";
      //if (_membEmail.Length == 0) missingFields += " Email,";
      //if (missingFields.Length > 0)
      //{
      //  labError.Text = "<p />You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".</p>";
      //  labError.Visible = true;
      //  e.Cancel = true;
      //}

      //// for some reason I need to force this value into membLevel
      //DropDownList ctrMembLevel = (DropDownList)dvProfile.FindControl("membLevel");
      //e.NewValues["membLevel"] = ctrMembLevel.SelectedValue;

      //// create single string for managerAccess display
      //ListBox ctrMembManagerAccess = (ListBox)dvProfile.FindControl("membManagerAccess");
      //string membManagerAccess = null;
      //foreach (ListItem item in ctrMembManagerAccess.Items)
      //{
      //  if (item.Selected)
      //  {
      //    membManagerAccess += item.Value + ",";
      //  }
      //}

      //if (membManagerAccess != null) membManagerAccess = membManagerAccess.TrimEnd(',');
      //e.NewValues["membManagerAccess"] = membManagerAccess;

      //// both the session memb (ie me) and the user memb (being analyzed) must be managers
      //if ((hidMembLevel.Value == "4" || hidMembLevel.Value == "5") && seMembLevel > 3)
      //{
      //  managerAccessShow(usesPassword);
      //}
      //else
      //{
      //  managerAccessHide(usesPassword);
      //}
    }

    protected void dvProfile_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
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
        Response.Redirect("/portal/v7/administrator/profiles.aspx");
      }
    }

    protected void dvProfile_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
      Response.Redirect("/portal/v7/administrator/profiles.aspx");
    }

  }

}