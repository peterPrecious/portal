<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="keyPress.aspx.cs" Inherits="portal.keyPress" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title></title>
  <script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
  <script>
    $(function () {
      $("#<%=membId.ClientID%>").on("keydown", function (evt) {
        if (evt.which == 8 || evt.which == 46) return false;  // ignore backspace or del
        var val = this.value;
        var hidden = $("#<%=hiddenField.ClientID%>").val(); // the hidden field must be called this
        evt = evt || window.event;
        // Ensure we only handle printable keys, excluding enter and space
        var charCode = typeof evt.which == "number" ? evt.which : evt.keyCode;
        if (charCode && charCode >= 32) {
          var keyChar = String.fromCharCode(charCode).toLowerCase(); // added toLowerCase since keydown is always upper
          var mappedChar = "*";
          var start, end;
          if (typeof this.selectionStart == "number" && typeof this.selectionEnd == "number") {
            start = this.selectionStart;
            end = this.selectionEnd;
            this.value = val.slice(0, start) + mappedChar + val.slice(end); // this is what's input
            hidden = hidden.slice(0, start) + keyChar + hidden.slice(end);  // this is saved
            // Move the caret/cursor
            this.selectionStart = this.selectionEnd = start + 1;
            hidden.selectionStart = hidden.selectionEnd = start + 1;
            $("#hiddenField").val(hidden);
          }
          return false;
        }
      });
    });
  </script>
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <asp:TextBox ID="membId" TextMode="Password" runat="server"></asp:TextBox>
      <asp:Button runat="server" Text="Button" OnClick="Unnamed_Click" />
      <asp:HiddenField ID="hiddenField" runat="server" Value="" />
      <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
    </div>
  </form>


</body>
</html>

