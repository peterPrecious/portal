using System;
using System.Net.Mail;

namespace portal
{
  public class Mail
  {
    public string sendMessage(string fromAddress, string toAddress, string subject, string body)
    {

      // this is the same as hiveCat.appBuilder.Emailers
      try
      {
        MailAddress emailFrom = new MailAddress(fromAddress);
        MailAddress emailTo = new MailAddress(toAddress);
        MailMessage emailMessage = new MailMessage(emailFrom, emailTo);

        emailMessage.IsBodyHtml = true;
        emailMessage.Subject = subject;
        emailMessage.Body = body.Replace(";;", "<br />");
        emailMessage.BodyEncoding = System.Text.Encoding.UTF8;

        SmtpClient client = new SmtpClient();
        client.Send(emailMessage);

        return "Email was sent successfully.";
      }
      catch (Exception e)
      {
        return e.Message;
      }
    }
  }
}