using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class modules : FormBase
  {
    Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      Session["modsId"] = "";
      se.localize();
      panConfirmShell.Visible = false;
    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      gvModules.DataBind();
    }

    protected void gvModules_SelectedIndexChanged(object sender, EventArgs e)
    {
      // this is fired when we select a Module to edit
      panTop.Visible = false;
      panBot.Visible = true;

      dvModule.ChangeMode(DetailsViewMode.ReadOnly);
      dvModule.DataBind();

      // store the selected Module No
      Session["modsNo"] = gvModules.DataKeys[1].Value;
    }

    protected void listModules_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
      dvModule.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void dvModule_ItemInit(object sender, ImageClickEventArgs e)
    {
      // this initializes all fields when you add a new modlue
      panTop.Visible = false;
      panBot.Visible = true;
      labError.Text = "";

      dvModule.ChangeMode(DetailsViewMode.Insert);
      dvModule.DataBind();
    }

    protected void ddActive_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

    protected void dvModule_Restart(object sender, ImageClickEventArgs e)
    {
      // this restarts the app
      dvModule.ChangeMode(DetailsViewMode.ReadOnly);
      dvModule.DataBind();
      Response.Redirect("Modules.aspx");
    }

    protected void dvModule_DataBound(object sender, EventArgs e)
    {
      if (dvModule.CurrentMode.ToString() == "ReadOnly")  // display 
      {
        panBotHeader.Text = "Module Details";
      }

      if (dvModule.CurrentMode.ToString() == "Edit")
      {
        panBotHeader.Text = "Edit this Module's Details";
      }
    }

    protected void dvModule_ItemInit(object sender, EventArgs e)
    {
      // this initializes all fields when you add a new module

      panTop.Visible = false;
      panBot.Visible = true;
      labError.Text = "";

      dvModule.ChangeMode(DetailsViewMode.Insert);
      dvModule.DataBind();

      ((Label)dvModule.FindControl("modsId")).Text = "";
      ((TextBox)dvModule.FindControl("modsTitle")).Text = "";
      ((TextBox)dvModule.FindControl("modsDescription")).Text = "";
      ((CheckBox)dvModule.FindControl("modsActive")).Checked = true;
      ((TextBox)dvModule.FindControl("modsLength")).Text = "1";

    }

    protected void dvModule_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
      // ensure all mandatory fields were entered
      string missingFields = "";
      if (e.Values["modsId"] == null) missingFields += " Module Id,";
      if (e.Values["modsTitle"] == null) missingFields += " Title,";
      if (e.Values["modsLength"] == null) missingFields += " Length (hours),";

      if (missingFields.Length > 0)
      {
        labError.Text = "You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".";
        e.Cancel = true;
      }
    }

    protected void dvModule_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
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
        Response.Redirect("/portal/v7/administrator/modules.aspx");
      }
    }

    protected void dvModule_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
      string _modsTitle = "", _modsDescription = "", _modsLength = "";

      // ensure all mandatory fields were entered
      TextBox txtModsTitle = (TextBox)dvModule.FindControl("modsTitle"); _modsTitle = txtModsTitle.Text.Trim();
      TextBox txtModsDescription = (TextBox)dvModule.FindControl("modsDescription"); _modsDescription = txtModsDescription.Text.Trim();
      TextBox txtModsLength = (TextBox)dvModule.FindControl("modsLength"); _modsLength = txtModsLength.Text.Trim();

      //HiddenField hidMembLevel = (HiddenField)dvModule.FindControl("hidMembLevel");
      //int seMembLevel = int.Parse(Session["membLevel"].ToString());

      string missingFields = "";
      if (_modsTitle.Length == 0) missingFields += " Title,";
//    if (_modsDescription.Length == 0) missingFields += " Description,";
      if (_modsLength.Length == 0) missingFields += " Length (hours),";
      if (missingFields.Length > 0)
      {
        labError.Text = "<p />You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".</p>";
        labError.Visible = true;
        e.Cancel = true;
      }

    }

    protected void dvModule_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
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
        Response.Redirect("/portal/v7/administrator/Modules.aspx");
      }
    }

    protected void dvModule_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
      Response.Redirect("/portal/v7/administrator/Modules.aspx");
    }

    protected void btnConfirmOk_Click(object sender, EventArgs e)
    {
      Response.Redirect("/portal/v7/facilitator/learners.aspx");
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

  }
}