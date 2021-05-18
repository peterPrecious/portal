using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class programs : FormBase
  {
    Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      Session["progId"] = "";
      se.localize();
      panConfirmShell.Visible = false;
    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      gvPrograms.DataBind();
    }

    // this is fired when we select a program to edit
    protected void gvPrograms_SelectedIndexChanged(object sender, EventArgs e)
    {
      // this is fired when we select a Module to edit
      panTop.Visible = false;
      panBot.Visible = true;

      dvProgram.ChangeMode(DetailsViewMode.ReadOnly);
      dvProgram.DataBind();

      // store the selected Program No
      Session["progNo"] = gvPrograms.DataKeys[1].Value;
    }

    // this is the icon on the bottom title to return and list programs
    protected void listPrograms_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
//      labError.Text = "";
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
      dvProgram.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void dvProgram_DataBound(object sender, EventArgs e)
    {
      if (dvProgram.CurrentMode.ToString() == "ReadOnly")  // display 
      {
        panBotHeader.Text = "Program Details";
      }

      if (dvProgram.CurrentMode.ToString() == "Edit")
      {
        panBotHeader.Text = "Edit this Program's Details";
      }
    }

    protected void dvProgram_ItemInit(object sender, ImageClickEventArgs e)
    {
      // this initializes all fields when you add a new modlue
      panTop.Visible = false;
      panBot.Visible = true;
      labError.Text = "";

      dvProgram.ChangeMode(DetailsViewMode.Insert);
      dvProgram.DataBind();
    }


    protected void dvProgram_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
      // ensure all mandatory fields were entered
      string missingFields = "";
      if (e.Values["progId"] == null) missingFields += " Program Id,";
      if (e.Values["progTitle"] == null) missingFields += " Title,";

      if (missingFields.Length > 0)
      {
        labError.Text = "You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".";
        e.Cancel = true;
      }
    }

    protected void dvProgram_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
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

    protected void dvProgram_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
      string _progTitle = "", _progDesc = "";

      // ensure all mandatory fields were entered
      TextBox txtProgTitle = (TextBox)dvProgram.FindControl("progTitle"); _progTitle = txtProgTitle.Text.Trim();
      TextBox txtProgDesc = (TextBox)dvProgram.FindControl("progDesc"); _progDesc = txtProgDesc.Text.Trim();

      //HiddenField hidMembLevel = (HiddenField)dvProgram.FindControl("hidMembLevel");
      //int seMembLevel = int.Parse(Session["membLevel"].ToString());

      string missingFields = "";
      if (_progTitle.Length == 0) missingFields += " Title,";
      if (_progDesc.Length == 0) missingFields += " Description,";
      if (missingFields.Length > 0)
      {
        labError.Text = "<p />You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".</p>";
        labError.Visible = true;
        e.Cancel = true;
      }

    }

    protected void dvProgram_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
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
        Response.Redirect("/portal/v7/administrator/Programs.aspx");
      }
    }

    protected void dvProgram_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
      Response.Redirect("/portal/v7/administrator/Programs.aspx");
    }




    protected void btnConfirmOk_Click(object sender, EventArgs e)
    {
      Response.Redirect("/portal/v7/administrator/programs.aspx");
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }
     
  }
}