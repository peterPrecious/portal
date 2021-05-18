using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal.v7.administrator
{
  public partial class customers : FormBase
  {
    private readonly Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();

      if (!IsPostBack)
      {

      }
    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      gvCustomers.DataSourceID = SqlDataSource1.ID;

      gvCustomers.DataBind();
    }

    protected void butRestart_Click(object sender, EventArgs e)
    { // fired when we clear the search criteria
      Response.Redirect("/portal/v7/administrator/customers.aspx");
    }

    protected void gvCustomers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.DataRow)
      {
        e.Row.Attributes["onclick"] = ClientScript.GetPostBackClientHyperlink(this.gvCustomers, "Select$" + e.Row.RowIndex);
        e.Row.Attributes["style"] = "cursor:pointer";
      }
    }

    protected void gvCustomers_SelectedIndexChanged(object sender, EventArgs e)
    {
      // this is fired when we select a customer to edit
      panTop.Visible = false;
      panBot.Visible = true;

      //panBotTitle.Visible = false;
      panCustPrefix.Visible = false;
      dvCustomer.Visible = true;

      dvCustomer.ChangeMode(DetailsViewMode.ReadOnly);
      dvCustomer.DataBind();

      GridViewRow row = gvCustomers.SelectedRow;
    }

    protected void btnCustPrefix_Click(object sender, EventArgs e)
    {
      labError.Text = "";
      TextBox custPrefix = (TextBox)panCustPrefix.FindControl("txtCustPrefix");
      string txtCustPrefix = custPrefix.Text.ToUpper();
      if (txtCustPrefix.Length != 4)
      {
        labError.Text = "Please enter a 4 character Customer Id prefix, ie '" + se.cust + "'.";
        custPrefix.Text = "";
        return;
      }
      if (!Regex.IsMatch(txtCustPrefix, @"^[A-Z]+$"))
      {
        labError.Text = "Each of the 4 characters must be Alpha (A-Z).";
        custPrefix.Text = "";
        return;
      }

      // this generates the next CustId and inserts an empty record with V8=true 
      // it also creates the NEW Account Internals

      string txtNextCustId = "";
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7nextCustId2";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custPrefix", txtCustPrefix));
          cmd.Parameters.Add("@nextCustId", SqlDbType.VarChar, 8).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          txtNextCustId = (string)cmd.Parameters["@nextCustId"].Value;
        }
      }
      Session["custId"] = txtNextCustId;

      dvCustomer.ChangeMode(DetailsViewMode.Insert);
      dvCustomer.DataBind();

      panCustPrefix.Visible = false;
      dvCustomer.Visible = true;
      panBot.Visible = true;

      labCust.Text = txtNextCustId.Substring(0, 4);
      labCustId.Text = txtNextCustId;
    }

    protected void listCustomers_Click(object sender, EventArgs e)
    {
      panTop.Visible = true;
      panBot.Visible = false;
      labError.Text = "";
    }

    protected void btnInsertCancel_Click(object sender, EventArgs e)
    {
      Response.Redirect("/portal/v7/administrator/customers.aspx");
    }

    protected void btnEditCancel_Click(object sender, EventArgs e)
    {
      dvCustomer.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void dvCustomer_ItemInit(object sender, ImageClickEventArgs e)
    {
      // this initializes all fields when we add a new Customer
      // 
      // ...but we are now doing this after they enter the Cust_Id prefix above
      panTop.Visible = false;
      panBot.Visible = true;
      labError.Text = "";

      dvCustomer.ChangeMode(DetailsViewMode.Insert);
      dvCustomer.DataBind();

      if (dvCustomer.FindControl("custId") != null)
      {
        //custAcctId Row, not needed on insert
        dvCustomer.Rows[0].Visible = false;
      }
    }

    protected void dvCustomer_DataBound(object sender, EventArgs e)
    {
      if (dvCustomer.CurrentMode.ToString() == "ReadOnly")  // display 
      {
        panBotHeader.Text = "Customer Details";
      }

      if (dvCustomer.CurrentMode.ToString() == "Edit")
      {
        panBotHeader.Text = "Edit this Customer Profile";
      }
    }

    protected void dvCustomer_Restart(object sender, ImageClickEventArgs e)
    {
      // this restarts the app
      dvCustomer.ChangeMode(DetailsViewMode.ReadOnly);
      dvCustomer.DataBind();
      Response.Redirect("customers.aspx");
    }

    protected void dvCustomer_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
      Response.Redirect("/portal/v7/administrator/customers.aspx");
    }

    protected void dvCustomer_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
      // ensure all mandatory fields were entered
      string missingFields = "";
      if (e.Values["custId"] == null) missingFields += " Customer Id,";
      if (e.Values["custTitle"] == null) missingFields += " Title,";

      //if (e.Values["custFirstName"] == null) missingFields += " " + GetGlobalResourceObject("portal", "firstName").ToString() + ",";
      //if (e.Values["custLastName"] == null) missingFields += " " + GetGlobalResourceObject("portal", "lastName").ToString() + ",";
      //if (e.Values["custEmail"] == null) missingFields += " " + GetGlobalResourceObject("portal", "email").ToString() + ",";


      if (missingFields.Length > 0)
      {
        //labError.Text = "You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".";
        labError.Text = GetGlobalResourceObject("portal", "customers_8").ToString() + missingFields.TrimEnd(',') + ".";
        e.Cancel = true;
      }

      //DropDownList ctrMembLevel = (DropDownList)dvCustomer.FindControl("membLevel");
      //e.Values["membLevel"] = ctrMembLevel.SelectedValue;


      //// create single string for managerAccess display
      //ListBox ctrMembManagerAccess = (ListBox)dvCustomer.FindControl("membManagerAccess");
      //string membManagerAccess = null;
      //foreach (ListItem item in ctrMembManagerAccess.Items)
      //{
      //  if (item.Selected)
      //  {
      //    membManagerAccess += item.Value + ",";
      //  }
      //}
      //if (membManagerAccess != null) membManagerAccess = membManagerAccess.TrimEnd(',');
      //e.Values["membManagerAccess"] = membManagerAccess;
    }

    protected void dvCustomer_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
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
        Response.Redirect("/portal/v7/administrator/customers.aspx");
      }
    }

    protected void dvCustomer_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {

      string _custTitle = "";
      //, _membFirstName = "", _membLastName = "", _membEmail = "";

      // ensure all mandatory fields were entered
      TextBox txtCustTitle = (TextBox)dvCustomer.FindControl("custTitle"); _custTitle = txtCustTitle.Text.Trim();
      //TextBox txtMembLastName = (TextBox)dvCustomer.FindControl("membLastName"); _membLastName = txtMembLastName.Text.Trim();
      //TextBox txtMembEmail = (TextBox)dvCustomer.FindControl("membEmail"); _membEmail = txtMembEmail.Text.Trim();

      //HiddenField hidMembLevel = (HiddenField)dvCustomer.FindControl("hidMembLevel");
      //int seMembLevel = int.Parse(Session["membLevel"].ToString());

      string missingFields = "";
      if (_custTitle.Length == 0) missingFields += " Title,";
      //if (_membLastName.Length == 0) missingFields += " Last Name,";
      //if (_membEmail.Length == 0) missingFields += " Email,";
      if (missingFields.Length > 0)
      {
        labError.Text = "<p />You are missing mandatory field(s): " + missingFields.TrimEnd(',') + ".</p>";
        labError.Visible = true;
        e.Cancel = true;
      }

      // for some reason I need to force this value into custLang
      DropDownList ctrCustLang = (DropDownList)dvCustomer.FindControl("custLang");
      e.NewValues["custLang"] = ctrCustLang.SelectedValue;


    }

    protected void dvCustomer_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
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
        Response.Redirect("/portal/v7/administrator/customers.aspx");
      }
    }

    protected void dvCustomer_PreRender(object sender, EventArgs e)
    {
      //if (dvCustomer.Rows.Count > 0)
      //{
      //  dvCustomer.Rows[0].Cells[1].Text = Session["custId"].ToString();
      //}
    }

    protected void btnUpdate_Click(object sender, ImageClickEventArgs e)
    {
      string _custId = ((HiddenField)dvCustomer.FindControl("custId")).Value;
      string _custTitle = ((TextBox)dvCustomer.FindControl("custTitle")).Text;
      bool _custActive = ((CheckBox)dvCustomer.FindControl("custActive")).Checked;
      bool _custAuto = ((CheckBox)dvCustomer.FindControl("custAuto")).Checked;
      bool _custChannelNop = ((CheckBox)dvCustomer.FindControl("custChannelNop")).Checked;
      bool _custChannelV8 = ((CheckBox)dvCustomer.FindControl("custChannelV8")).Checked;
      bool _custChannelGuests = ((CheckBox)dvCustomer.FindControl("custChannelGuests")).Checked;
      string _custLang = ((DropDownList)dvCustomer.FindControl("custLang")).SelectedValue;
      string _custProfile = ((TextBox)dvCustomer.FindControl("custProfile")).Text;

      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7nextCustId3";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", _custId));
          cmd.Parameters.Add(new SqlParameter("@custTitle", _custTitle));
          cmd.Parameters.Add(new SqlParameter("@custActive", _custActive));
          cmd.Parameters.Add(new SqlParameter("@custAuto", _custAuto));
          cmd.Parameters.Add(new SqlParameter("@custChannelNop", _custChannelNop));
          cmd.Parameters.Add(new SqlParameter("@custChannelV8", _custChannelV8));
          cmd.Parameters.Add(new SqlParameter("@custChannelGuests", _custChannelGuests));
          cmd.Parameters.Add(new SqlParameter("@custLang", _custLang));
          cmd.Parameters.Add(new SqlParameter("@custProfile", _custProfile));
          cmd.ExecuteNonQuery();
        }
      }

      Response.Redirect("/portal/v7/administrator/customers.aspx");
    }

    protected void btnConfirm_Command(object sender, CommandEventArgs e)
    {
      Session["confirmParms"] = e.CommandArgument;
      btnConfirmOk.Visible = true; // this is set to false below
      string[] parm = Session["confirmParms"].ToString().Split('|');
      int custLearners = 0; // custLearners is a count of learners excluding internals and BIGMGR (password)
      if (parm[0] == "Delete")  // Delete, not Clone, uses an extra parm
      {
        custLearners = Convert.ToInt32(parm[3]);
      }

      if (parm[0] == "Clone")
      {
        labConfirmTitle.Text = "Note !";
        labConfirmMessage.Text = "You are about to Clone Account <b>" + parm[1] + "</b>.<br />Clicking OK will create a new Account whose Customer Id will start with '" + parm[2] + "'";
        btnConfirmCancel.Text = "Cancel";
        btnConfirmOk.Text = "OK";
        panConfirmShell.Visible = true;
      }
      else if (parm[0] == "Delete" && custLearners == 0)
      {
        labConfirmTitle.Text = "Note !";
        labConfirmMessage.Text = "You are about to Delete Account <b>" + parm[1] + "</b>!<br />It is important to remember that clicking OK is an irreversible action.";
        btnConfirmCancel.Text = "Cancel";
        btnConfirmOk.Text = "OK";
        panConfirmShell.Visible = true;
      }
      else if (parm[0] == "Delete" && custLearners > 0)
      {
        labConfirmTitle.Text = "Oops !";
        labConfirmMessage.Text = "You cannot Delete Account <b>" + parm[1] + "</b><br />because it contains " + parm[3] + " active learner(s).";
        btnConfirmCancel.Text = "Cancel";
        btnConfirmOk.Text = "OK";
        btnConfirmOk.Visible = false;
        panConfirmShell.Visible = true;
      }
    }

    protected void btnConfirmOk_Click(object sender, EventArgs e)
    {
      string[] parm = Session["confirmParms"].ToString().Split('|');
      int custLearners = 0;
      if (parm[0] == "Delete")  // Delete, not Clone, uses an extra parm
      {
        custLearners = Convert.ToInt32(parm[3]);
      }

      if (parm[0] == "Clone")
      {
        string cloneCustId = parm[1];
        string cloneCustPrefix = parm[2];

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
        {
          con.Open();
          using (SqlCommand cmd = new SqlCommand())
          {
            cmd.Connection = con;
            cmd.CommandText = "dbo.sp7nextCustId5";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@cloneCustId", cloneCustId));
            cmd.Parameters.Add(new SqlParameter("@cloneCustPrefix", cloneCustPrefix));

            cmd.ExecuteNonQuery();
          }
        }
      }
      else if (parm[0] == "Delete" && custLearners == 0)
      {
        string deleteCustId = parm[1];
        string deleteCustGuid = parm[2];

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
        {
          con.Open();
          using (SqlCommand cmd = new SqlCommand())
          {
            cmd.Connection = con;
            cmd.CommandText = "dbo.sp7customerDelete";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new SqlParameter("@custId", deleteCustId));
            cmd.Parameters.Add(new SqlParameter("@custGuid", deleteCustGuid));

            cmd.ExecuteNonQuery();
          }
        }

      }

      Session["confirmParms"] = "";
      Response.Redirect("/portal/v7/administrator/customers.aspx");

    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void ddActive_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

    protected void txtCustPrefix_PreRender(object sender, EventArgs e)
    {

    }
  }
}