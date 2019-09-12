<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="privatey.aspx.cs" Inherits="portal.v7.privatey" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title></title>
  <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js"></script>

  <style>
    .txtBox1, .txtBox2  { vertical-align: top; height: 20px; }
    .icon1,.icon2 { vertical-align: bottom; opacity: 0.7; cursor:pointer;}
  </style>

  <script>
    $(function () {
      $(".icon1").on("click", function () {
        var ele = $(".txtBox1")[0];
        if (ele.type === 'text') {
          ele.type = 'password';
        }
        else {
          ele.type = 'text';
        }
      });
      $(".icon2").on("click", function () {
        var ele = $(".txtBox2")[0];
        if (ele.type === 'text') {
          ele.type = 'password';
        }
        else {
          ele.type = 'text';
        }
      });
    });


  </script>
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <table>
        <tr>
          <td>
            <asp:TextBox TextMode="SingleLine" CssClass="txtBox1" ID="TextBox1" runat="server" Text="biteme"></asp:TextBox>
          </td>
          <td>
            <asp:Image CssClass="icon1" ID="Image1" ImageUrl="~/styles/icons/eye.png" runat="server" />
          </td>
        </tr>

        <tr>
          <td>
            <asp:TextBox TextMode="SingleLine" CssClass="txtBox2" ID="TextBox2" runat="server" Text="biteme"></asp:TextBox>
          </td>
          <td>
            <asp:Image CssClass="icon2" ID="Image2" ImageUrl="~/styles/icons/eye.png" runat="server" />
          </td>
        </tr>
      </table>


    </div>
  </form>
</body>
</html>
