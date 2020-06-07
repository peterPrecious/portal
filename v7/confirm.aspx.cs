using System;

namespace portal.v7.administrator
{
  public partial class Confirm : FormBase
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      labConfirmTitle.Text = "Warning !";
      labConfirmMessage.Text = "Once upon a time when the pigs were swine the monkeys chewed tobacco.";
      btnConfirmCancel.Text = "Cancel";
      btnConfirmConfirm.Text = "OK";
      panConfirm.Visible = true;
    }
  }
}