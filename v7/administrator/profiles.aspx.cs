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
      Session["custId"] = "";

      lnkHide.Visible = true;
      lnkShow.Visible = false;

      string start = Request.QueryString["start"];
      if (fn.fDefault(start, "") == "dvProfile")
      {
        panTop.Visible = false;
        panBot.Visible = true;
        SqlDataSource2.SelectParameters["profNo"].DefaultValue = Session["profNo"].ToString();
        dvProfile.ChangeMode(DetailsViewMode.ReadOnly);
      }

      panConfirmShell.Visible = false;
    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      gvProfiles.DataBind();
    }

    protected void dvProfileInit_Click(object sender, EventArgs e)
    {

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
          btnConfirmCancel.Text = "OK";
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
            cmd.CommandText = "dbo.[sp7profileClone]";
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
      hideRow("l", i--, "profCourseTile_en");
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

      lnkShow.Visible = true;
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
      hideRows(sender, e);
      lnkHide.Visible = false;
      lnkShow.Visible = true;
    }

    protected void lnkShow_Click(object sender, EventArgs e)
    {
      Response.Redirect("profiles.aspx?start=dvProfile&profNo=" + Session["profNo"].ToString());
    }

    protected void dvProfile_ItemCreated(object sender, EventArgs e)
    {
      Session["profNo"] = gvProfiles.DataKeys[1].Value;

      panTop.Visible = false;
      panBot.Visible = true;
      dvProfile.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void dvProfile_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
      //if (e.CommandName == "ReadOnly")
      //{
      //  panHideShow.ForeColor = System.Drawing.Color.White;
      //}
      //else
      //{
      //  panHideShow.ForeColor = System.Drawing.Color.Yellow;
      //}
    }

    protected void dvProfile_PreRender(object sender, EventArgs e)
    {
      if (dvProfile.CurrentMode.ToString() == "ReadOnly")
      {
        //        panHideShow.ForeColor = System.Drawing.Color.White;
        panHideShow.Visible = true; ;
      }
      else
      {
        //      panHideShow.ForeColor = System.Drawing.Color.Yellow;
        panHideShow.Visible = false;
      }
    }
  }
}