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
    Sess se = new Sess();

    protected void Page_Load(object sender, EventArgs e)
    {
      Session["custId"] = "";
      se.localize();
      labError_1.Text = "";
      panConfirmShell.Visible = false;
    }

    protected void butSearch_Click(object sender, EventArgs e)
    {
      gvCustomers.DataBind();
    }

    protected void gvCustomers_SelectedIndexChanged(object sender, EventArgs e)
    {
      // this is fired when we select a customer to edit
      panTop.Visible = false;
      panBot.Visible = true;
      panBot_1.Visible = false;
      panBot_2.Visible = true;
      dvCustomer.ChangeMode(DetailsViewMode.ReadOnly);
    }

    protected void btnCustPrefix_Click(object sender, EventArgs e)
    {
      labError_1.Text = "";
      TextBox custPrefix = (TextBox)panCustPrefix.FindControl("txtCustPrefix");
      string txtCustPrefix = custPrefix.Text.ToUpper();
      if (txtCustPrefix.Length != 4)
      {
        labError_1.Text = "Please enter a 4 character Customer Id prefix, ie 'ABCD'.";
        custPrefix.Text = "";
        return;
      }
      if (!Regex.IsMatch(txtCustPrefix, @"^[A-Z]+$"))
      {
        labError_1.Text = "Each of the 4 characters must be Alpha (A-Z).";
        custPrefix.Text = "";
        return;
      }
      // this SP generates the next CustId and inserts an empty record with V8=true 
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

      panBot_1.Visible = false; // hide the creation of the cust_id
      panBot_2.Visible = true;  // show the record details (now in edit mode)

      dvCustomer.ChangeMode(DetailsViewMode.Insert);
      dvCustomer.DataBind();
    }

    protected void listCustomers_Click(object sender, EventArgs e)
    {
      // this is the icon on the bottom title to return and list modules
      gvCustomers.DataBind();
      panTop.Visible = true;
      panBot.Visible = false;
      labError_1.Text = "";
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
      // this normally initializes all fields when we add a new Customer but 
      // we are now doing this after they enter the Cust_Id prefix above
      panTop.Visible = false;
      panBot.Visible = true;
      panBot_1.Visible = true;
      panBot_2.Visible = false;

      labCust.Text = se.cust;
      labCustId.Text = se.cust;
    }

    protected void dvCustomer_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
    {
      Response.Redirect("/portal/v7/administrator/customers.aspx");
    }

    protected void dvCustomer_PreRender(object sender, EventArgs e)
    {
      if (dvCustomer.Rows.Count > 0)
      {
        dvCustomer.Rows[0].Cells[1].Text = Session["custId"].ToString();
      }
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
      int custLearners = 0; // custLearners is a count of learners excluding internals and big sales
      if (parm[0] == "Delete")  // Delete, not Clone, uses an extra parm
      {
        custLearners = Convert.ToInt32(parm[3]);
      }

      if (parm[0] == "Clone")
      {
        labConfirmTitle.Text = "Note !";
        labConfirmMessage.Text = "You are about to Clone Account '" + parm[1] + "'.<br />Clicking OK will create a new Account whose Customer Id will start with '" + parm[2] + "'";
        btnConfirmCancel.Text = "Cancel";
        btnConfirmOk.Text = "OK";
        panConfirmShell.Visible = true;
      }
      else if (parm[0] == "Delete" && custLearners == 0)
      {
        labConfirmTitle.Text = "Note !";
        labConfirmMessage.Text = "You are about to Delete Account '" + parm[1] + "'!<br />It is important to remember that clicking OK is an irreversible action.";
        btnConfirmCancel.Text = "Cancel";
        btnConfirmOk.Text = "OK";
        panConfirmShell.Visible = true;
      }
      else if (parm[0] == "Delete" && custLearners > 0)
      {
        labConfirmTitle.Text = "Oops !";
        labConfirmMessage.Text = "You cannot Delete Account '" + parm[1] + "'<br />because it contains " + parm[3] + " active learner(s).";
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


  }
}