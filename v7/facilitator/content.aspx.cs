using System;
using System.Drawing;
using System.Web.UI.WebControls;

namespace portal.v7.facilitator
{
  public partial class content : FormBase
  {
    private Memb me = new Memb();

    // for some reason the next two variable needs to be at this level
    private int membNo;
    private string membPrograms;

    protected void Page_Load(object sender, EventArgs e) { }

    protected void butAssign_Click(object sender, EventArgs e)
    {
      bool ok = true;
      int usersCnt = 0, progsCnt = 0, assignedCnt = 0;

      // count the number of users that will be assigned content
      if (ok)
      {
        foreach (GridViewRow row in gvUsers.Rows)
        {
          CheckBox chkbox = (CheckBox)row.FindControl("chkRow");
          if (chkbox.Checked == true)
          {
            usersCnt++;
          }
        }
        if (usersCnt == 0)
        {
          labAlert.Text = "You must select one or more learners.";
          panAlert.Visible = true;
          panWarning.Visible = false;
          ok = false;
        }
      }

      // count the number of progs that will be assigned 
      if (ok)
      {
        foreach (GridViewRow row in gvProgs.Rows)
        {
          CheckBox chkbox = (CheckBox)row.FindControl("chkRow");
          if (chkbox.Checked == true)
          {
            progsCnt++;
          }
        }
        if (progsCnt == 0)
        {
          labAlert.Text = "You must select one or more programs.";
          panAlert.Visible = true;
          ok = false;
        }
      }

      // go through the prog grid and ensure each selected users haven't already had it assigned
      string progId, userId; string[] progIds;

      if (ok)
      {
        foreach (GridViewRow progRow in gvProgs.Rows)
        {
          if (ok)
          {
            CheckBox progChkbox = (CheckBox)progRow.FindControl("chkRow");
            if (progChkbox.Checked == true)
            {
              // find row selected and extract the progId and number available
              progId = progRow.Cells[1].Text;
              if (int.Parse(progRow.Cells[5].Text) < usersCnt)
              {
                ok = false;
                labAlert.Text = "Cannot assign " + usersCnt.ToString() + " seats of Program " + progId + " when there is only " + progRow.Cells[5].Text + " available.";
                panAlert.Visible = true;
              }

              // now go through the user grid and see if any selected user has this progId already assigned
              foreach (GridViewRow userRow in gvUsers.Rows)
              {
                if (ok)
                {
                  CheckBox userChkbox = (CheckBox)userRow.FindControl("chkRow");
                  if (userChkbox.Checked == true)
                  {
                    userId = userRow.Cells[2].Text;
                    progIds = userRow.Cells[4].Text.Split(' ');
                    foreach (string prog in progIds)
                    {
                      if (prog == progId)
                      {
                        ok = false;
                        labAlert.Text = "Program " + progId + " has already been assigned to " + userId;
                        panAlert.Visible = true;
                      }
                    }

                    progIds = userRow.Cells[5].Text.Split(' ');
                    foreach (string prog in progIds)
                    {
                      if (prog == progId)
                      {
                        ok = false;
                        labAlert.Text = "Program " + progId + " has already been assigned to " + userId;
                        panAlert.Visible = true;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      // redo looping and now put the programs selected into the selected users "Programs After" column
      if (ok)
      {
        foreach (GridViewRow progRow in gvProgs.Rows)
        {
          CheckBox progChkbox = (CheckBox)progRow.FindControl("chkRow");
          if (progChkbox.Checked == true)
          {
            // find row selected and extract the progId
            progId = progRow.Cells[1].Text;


            assignedCnt = 0;
            // now go through the user grid and add to any selected users
            foreach (GridViewRow userRow in gvUsers.Rows)
            {
              CheckBox userChkbox = (CheckBox)userRow.FindControl("chkRow");
              if (userChkbox.Checked == true)
              {
                //                if (userRow.Cells[6].Text.Length < 7)
                if (userRow.Cells[5].Text.Length < 7)
                {
                  //                  userRow.Cells[6].Text = progId;
                  userRow.Cells[5].Text = progId;
                }
                else
                {
                  //                  userRow.Cells[6].Text = (userRow.Cells[6].Text + " " + progId);
                  userRow.Cells[5].Text = (userRow.Cells[5].Text + " " + progId);
                }
                assignedCnt++;
              }
            }

            // show how many of program were assigned
            progRow.Cells[6].Text = assignedCnt.ToString();
            progRow.Cells[7].Text = (int.Parse(progRow.Cells[5].Text) - assignedCnt).ToString();

          }
        }
      }

      if (ok)
      {
        string _progs = (progsCnt == 1) ? " program to " : " programs to ";
        string _users = (usersCnt == 1) ? " learner" : " learners";
        labAlert.Text = "You are about to assign " + progsCnt.ToString() + _progs + usersCnt.ToString() + _users + ". <br />You can now either Restart or Commit.";
        panAlert.Visible = true;
        panWarning.Visible = true;
        showHideCheckBoxes(false);
        butAssign.Visible = false;
        butCommit.Visible = true;
      }

    }

    protected void butCommit_Click(object sender, EventArgs e)
    {
      foreach (GridViewRow gvRow in gvUsers.Rows)
      {
        if (gvRow.Cells[5].Text.Length >= 7)
        {
          gvRow.Cells[4].Text = gvRow.Cells[4].Text + " " + gvRow.Cells[5].Text;
          gvRow.Cells[5].Text = "";

          // update the member programs
          membNo = int.Parse(gvUsers.DataKeys[gvRow.RowIndex].Value.ToString());
          membPrograms = gvRow.Cells[4].Text;
//          me.memberPrograms2(membNo, membPrograms);
          me.memberPrograms(membNo, membPrograms);

          // refresh grids
          gvProgs.DataBind();
          gvUsers.DataBind();

        }
      }
      butAssign.Visible = true;
      butCommit.Visible = false;

      Response.Redirect("~/v7/facilitator/content.aspx");
    }

    protected void butNext_Click(object sender, EventArgs e)
    {
      panAlert.Visible = false;
    }

    protected void gvProgs_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      if (e.Row.RowType == DataControlRowType.DataRow)
      {
        // first get the progId in row being bound
        string progId = e.Row.Cells[1].Text;

        // now go through and count all the programs assigned in the gvUser table
        int noProgs = 0;
        foreach (GridViewRow gvRow in gvUsers.Rows)
        {
          if (gvRow.Cells[4].Text.IndexOf(progId) > -1)
          {
            noProgs++;
          }
        }

        // put the number into Assigned 
        e.Row.Cells[4].Text = noProgs.ToString();

        // compute the number Available
        e.Row.Cells[5].Text = (int.Parse(e.Row.Cells[3].Text) - noProgs).ToString();
      }
    }

    protected void gvProgs_DataBound(object sender, EventArgs e)
    {
      showHideElements();
    }

    protected void showHideElements()
    {
      CheckBox checkbox = new CheckBox();

      foreach (GridViewRow gvRow in gvProgs.Rows)
      {
        // uncheck check box (we've assigned stuff)
        checkbox = (CheckBox)gvRow.FindControl("chkRow");
        checkbox.Checked = false;

        // hide if no programs to assign
        if (gvRow.Cells[5].Text == "0")  // || gvRow.Cells[7].Text == "0")
        {
          checkbox.Visible = false;
        }
      }
    }

    protected void showHideCheckBoxes(bool visible)
    {
      CheckBox checkbox = new CheckBox();

      GridViewRow gvHeader = gvUsers.HeaderRow;
      checkbox = (CheckBox)gvHeader.FindControl("chkAllUsers");
      checkbox.Visible = visible;
      foreach (GridViewRow gvRow in gvUsers.Rows)
      {
        checkbox = (CheckBox)gvRow.FindControl("chkRow");
        checkbox.Visible = visible;
      }

      gvHeader = gvProgs.HeaderRow;
      checkbox = (CheckBox)gvHeader.FindControl("chkAllProgs");
      checkbox.Visible = visible;
      foreach (GridViewRow gvRow in gvProgs.Rows)
      {
        checkbox = (CheckBox)gvRow.FindControl("chkRow");
        checkbox.Visible = visible;
      }
    }

    protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      CheckBox checkbox = new CheckBox();

      // get rid of the default &nbsp; when empty
      if (e.Row.RowType.ToString() == "DataRow")
      {
        e.Row.Cells[4].Text = e.Row.Cells[4].Text.Replace("&nbsp;", "");
        e.Row.Cells[5].Text = e.Row.Cells[5].Text.Replace("&nbsp;", "");

        // if this row is false
        if (e.Row.Cells[5].Text == "False")
        {
          e.Row.Cells[0].Enabled = false; // disable the checkbox
          e.Row.Cells[1].Style.Add("text-decoration", "line-through");
          e.Row.Cells[2].Style.Add("text-decoration", "line-through");
          e.Row.Cells[3].Style.Add("text-decoration", "line-through");
          e.Row.Cells[4].Style.Add("text-decoration", "line-through");
          e.Row.Cells[5].Style.Add("text-decoration", "line-through");
          e.Row.Cells[6].ForeColor = Color.Yellow; // highlight the False values
        }

      }
    }

    protected void exit_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
      Response.Redirect("/portal/v7/default.aspx");
    }

    protected void butRestart_Click(object sender, EventArgs e)
    {
      Response.Redirect("/portal/v7/facilitator/content.aspx");
    }
  }
}
