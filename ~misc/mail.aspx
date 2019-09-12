<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="mail.aspx.cs" Inherits="portal.mail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title></title>
</head>

<body>
  <form id="form1" runat="server">
    <div>
      Enter your unique Username or Email Address:
      
      <asp:TextBox ID="txtUniqueId" runat="server">pbulloch@vfnh.com</asp:TextBox>
      <asp:Button ID="btnEmail" runat="server" Text="Button" />
    </div>
  </form>
</body>

</html>
