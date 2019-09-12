<%@ Page
  Language="C#"
  AutoEventWireup="true"
  CodeBehind="errors.aspx.cs"
  Inherits="portal.errors" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title></title>
  <link href="/portal/styles/css/errors.min.css" rel="stylesheet" />
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <table>
        <tr>
          <td class="td1">Oops!</td>
        </tr>
        <tr>
          <td class="td2">
            <asp:Literal runat="server" Text="<%$  Resources:portal, errorHouston%>" />
          </td>
        </tr>
        <tr>
          <td class="td3">
            <img src="../styles/sadFace.gif" />
          </td>
        </tr>
        <tr>
          <td class="td4">
            <asp:Literal runat="server" Text="<%$  Resources:portal, errorPage%>" />
          </td>
        </tr>

        <%--    
        <tr>
          <td class="td4"><asp:Literal ID="ErrorText" runat="server"></asp:Literal></td>
        </tr>
        <tr>
          <td class="td5"><asp:Literal ID="ErrorDetails" runat="server"></asp:Literal></td>
        </tr>--%>
      </table>
    </div>
  </form>
</body>
</html>
