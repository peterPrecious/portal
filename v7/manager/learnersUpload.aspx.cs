using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace portal.v7.manager
{
  public partial class learnersUpload : FormBase
  {
    private readonly Sess se = new Sess();
    private readonly Prog pr = new Prog();
    private readonly Memb me = new Memb();

    protected void Page_Load(object sender, EventArgs e)
    {
      se.localize();
      StatusLabel.Text = "";

      if (!IsPostBack)
      {
        Session["fileName"] = "";
        Session["fullPath"] = "";
        Session["fileText"] = "";
      }

      string fileName = se.custId + "_LEARNERS.txt";
      labCustId1.Text = fileName;
      labCustId2.Text = fileName;
      labCustId3.Text = fileName;

      // disable option to DELETE ALL unless big admin
      if (se.membLevel != 5) { radAction.Items.Remove(radAction.Items.FindByValue("99")); }

    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void butConfirm_Click(object sender, EventArgs e)
    {
      StatusLabel.Text = "";
      if (FileUploadControl.HasFile)
      {
        try
        {
          Session["fileName"] = Path.GetFileName(FileUploadControl.FileName);

          if (Session["fileName"].ToString().ToUpper() != se.custId + "_LEARNERS.TXT")
          {
            StatusLabel.Text = "'" + Session["fileName"].ToString() + "' is not the correct file to upload - it must be: '" + se.custId + "_LEARNERS.txt'";
            butUpload.Visible = false;
            return;
          }


          FileUploadControl.SaveAs(Server.MapPath("~/repository/") + Session["fileName"]);
          Session["fullPath"] = Server.MapPath("~/repository/") + Session["fileName"];
        }
        catch (Exception ex)
        {
          StatusLabel.Text = "The specified file could not be uploaded: " + ex.Message;
        }
      }
      else
      {
        StatusLabel.Text = "You did not choose a Learner file to Upload!";
      }

      if (StatusLabel.Text == "")
      {
        butConfirm.Visible = false;
        butUpload.Visible = true;

        BulletedList1.Items.FindByValue("1").Text = "Upload learner text file '" + FileUploadControl.FileName + "'";
        BulletedList1.Items.FindByValue("2").Text = radAction.SelectedItem.ToString();
        BulletedList1.Items.FindByValue("3").Text = radProgs.SelectedItem.ToString();

        panStatus.Visible = true;

        tabUploadLearners.Visible = false;
      }
    }

    protected void butRestart_Click(object sender, EventArgs e)
    {
      Response.Redirect("learnersUpload.aspx");
    }

    protected void butUpload_Click(object sender, EventArgs e)
    {
      char tab = '\t';
      char emp = '\0';
      string validId = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@$%^*()_+-{}[];,.:";
      string record, header;
      int rowCnt = 0;
      int colCnt = -1;

      // check records for integrity
      Session["fileText"] = File.ReadAllText(Session["fullPath"].ToString());
      string[] lines = File.ReadAllLines(Session["fullPath"].ToString());
      foreach (string line in lines)
      {
        record = line.Trim();

        // ignore empty records (easy to pass in from excel)
        if (record.Replace(tab, emp).Length > 0)
        {
          rowCnt++;
          // check for valid header on first record
          if (rowCnt == 1)
          {
            header = record.Replace(tab, emp).Replace(" ", "").ToUpper(); // strip out tabs on header
            if (header != "Learner Id	Password	First Name	Last Name	Email Address	Programs	Memo".Replace(tab, emp).Replace(" ", "").ToUpper())
            {
              StatusLabel.Text = "[Row: " + rowCnt + "] The uploaded file did not contain a valid Header"; return;
            }
          }
          // check remaining rows
          else
          {
            colCnt = -1;

            // sometimes there are insufficient tabs/fields at end - pad and assume fields are empty
            record = record + tab + tab + tab + tab + tab + tab + tab;
            record = record.Replace("\"", ""); // remove any double quotes
            string[] fields = record.Split(tab); // split record into fields (we only really want 6 fields: 0-5) 
            string field;

            colCnt++;  // field 0: Learner Id, must exist and use valid characters
            field = fields[colCnt].Trim();
            if (field.Length == 0) { StatusLabel.Text = "[Row: " + rowCnt + ", Col: " + colCnt + "] Missing Learner Id"; return; }
            foreach (char c in field)
            {
              if (validId.IndexOf(c.ToString()) == -1)
              {
                StatusLabel.Text = "[Row: " + rowCnt + ", Col: " + colCnt + "] Invalid Learner Id:" + field + ". Use only A-Z, 0-9 and !@$%^*()_+-{}[];,.:"; return;
              }
            }

            colCnt++;  // field 1: Password

            colCnt++;  // field 2: First Name
            field = fields[colCnt].Trim();
            if (field.Length == 0) { StatusLabel.Text = "[Row: " + rowCnt + ", Col: " + colCnt + "] Missing First Name"; return; }

            colCnt++;  // field 3: Last Name
            field = fields[colCnt].Trim();
            if (field.Length == 0) { StatusLabel.Text = "[Row: " + rowCnt + ", Col: " + colCnt + "] Missing Last Name"; return; }

            colCnt++;  // field 4: Email Address

            colCnt++;  // field 5: Programs, if present ensure they are valid
            field = fields[colCnt].Trim().ToUpper();
            if (field.Length > 0)
            {
              string[] progs = field.Split(' '); // split the programs "field" into progs array
              foreach (string prog in progs)
              {
                if (prog.Length != 7)
                {
                  StatusLabel.Text = "[Row: " + rowCnt + ", Col: " + colCnt + "] Invalid Program ID: " + prog; return;
                }
                else
                {
                  if (!pr.isProgram(prog))
                  {
                    StatusLabel.Text = "[Row: " + rowCnt + ", Col: " + colCnt + "] No Such Program ID: " + prog; return;
                  }
                }
              }
            }

            colCnt++;  // field 6: Memo

          }
        }
      }

      tabUploadLearners.Visible = false;
      butUpload.Visible = false;
      butRestart.Visible = false;
      StatusLabel.Text = "Congratulations.  Upload completed successfully.";
      panStatus.Visible = false;


      // prep the member table before uploading learners, "action" is as follows:
      //    -1: do not modify memb table
      //    0: inactive all learners (caution, only use if submitting all active learners)
      //    10/30: inactive all except those added in the last 10 or 30 days 
      //    99: DELETE ALL LEARNERS (rarely needed - only use when setting up a new account)
      int _action = -1;
      bool parseOK = int.TryParse(radAction.SelectedValue.ToString(), out _action);
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp7memberUpdatePrep";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@acctId", se.custAcctId));
          cmd.Parameters.Add(new SqlParameter("@action", _action));
          cmd.ExecuteNonQuery();
        }
      }

      // now upload learners (similiar code to above but simpler sincer there are no errors
      rowCnt = 0;
      foreach (string line in lines)
      {
        rowCnt++; // use to ignore header

        record = line.Trim();
        if (record.Replace(tab, emp).Length > 0 && rowCnt > 2)          // ignore empty records (easy to pass in from excel plus header)
        {
          colCnt = -1;

          record = record + tab + tab + tab + tab + tab + tab + tab;    // ensure sufficient tabs/fields at end
          record = record.Replace("\"", "");                            // remove any double quotes
          string[] fields = record.Split(tab);                          // split record into fields (we only really want 6 fields: 0-5) 

          me.init();                                                    // start with a clean/empty me.
          colCnt++; me.membId = fields[colCnt].Trim().ToUpper();        // field 0: Learner Id
          colCnt++; me.membPwd = fields[colCnt].Trim().ToUpper();       // field 1: Password
          colCnt++; me.membFirstName = fields[colCnt].Trim();           // field 2: First Name
          colCnt++; me.membLastName = fields[colCnt].Trim();            // field 3: Last Name
          colCnt++; me.membEmail = fields[colCnt].Trim();               // field 4: Email
          colCnt++; me.membPrograms = fields[colCnt].Trim().ToUpper();  // field 5: Programs
          colCnt++; me.membMemo = fields[colCnt].Trim();                // field 6: Memo
          me.memberUpdate(se.custAcctId, se.membNo);                    // upload memb, one learner at a time

        }
      }

    }

  }

}