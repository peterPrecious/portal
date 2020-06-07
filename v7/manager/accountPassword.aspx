<%@ Page
  Title=""
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="accountPassword.aspx.cs"
  Inherits="portal.v7.manager.accountPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/accountPassword.min.css" rel="stylesheet" />
  <script>
    function hide() {
      $("#<%= txtCurPwd.ClientID %>").attr("type", "password");
      $("#<%= txtNewPwd.ClientID %>").attr("type", "password");
      $("#<%= txtDupPwd.ClientID %>").attr("type", "password");
    }
    function show() {
      $("#<%= txtCurPwd.ClientID %>").attr("type", "text");
      $("#<%= txtNewPwd.ClientID %>").attr("type", "text");
      $("#<%= txtDupPwd.ClientID %>").attr("type", "text");
    }
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">
  if (currentMonth == 0) currentMonth = 12;

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <h1>Change Channel Manager Password</h1>

    <asp:Panel ID="panInactive" runat="server" Visible="false">
      <h2 style="margin-top: 50px;">Oops. You can only change the Manager Password of a Parent Account than has Child Accounts. 
        This account (<asp:Label ID="labCustIdInactive" runat="server"></asp:Label>) does NOT have any Child Accounts.</h2>
    </asp:Panel>

    <asp:Panel ID="panActive" runat="server" Visible="false">

      <h2>The Channel Manager Password allows high level access to all Child Accounts of
          <asp:Label ID="labCustIdActive" CssClass="hilite" runat="server" />.  
          Changing it here will not affect Child Accounts of other Parent Accounts even if they start with the same 4 characters.
      </h2>
      <h3>Note that changing this password will affect
          <asp:Label ID="labChildrenNo" CssClass="hilite" runat="server" />
          Child Account records. 
          It should be done infrequently and off peak hours. 
          New passwords should be as secure as possible, must be at least 8 characters long, 
          and must begin with
          <asp:Label ID="labNewPassword1" CssClass="hilite" runat="server" />.
          An example might be
          <asp:Label ID="labNewPassword2" CssClass="hilite" runat="server" />. 
          Available characters are A-Z 0-9 !*-_ (case insensitive).
      </h3>

      <asp:Panel ID="panError" CssClass="panError" Visible="false" runat="server">
        <asp:Literal ID="litError" runat="server"></asp:Literal>
      </asp:Panel>

      <asp:Table CssClass="tabMgrPwd" runat="server">

        <asp:TableRow>
          <asp:TableCell>Passwords ?</asp:TableCell>
          <asp:TableCell>
         <input type="radio" onclick="show()" name="passwords" checked>Show
         <input type="radio" onclick="hide()" name="passwords">Hide<br>
          </asp:TableCell>
        </asp:TableRow>

        <asp:TableRow>
          <asp:TableCell>Current Manager Password :</asp:TableCell><asp:TableCell>
            <asp:TextBox ID="txtCurPwd" runat="server" CssClass="upper"></asp:TextBox><span title="Clear this field." class="clear">Ω</span>
          </asp:TableCell>
        </asp:TableRow>

        <asp:TableRow>
          <asp:TableCell>New Manager Password :</asp:TableCell><asp:TableCell>
            <asp:TextBox ID="txtNewPwd" runat="server" CssClass="upper"></asp:TextBox><span title="Clear this field." class="clear">Ω</span>
          </asp:TableCell>
        </asp:TableRow>

        <asp:TableRow>
          <asp:TableCell>New Password (Repeat) :</asp:TableCell><asp:TableCell>
            <asp:TextBox ID="txtDupPwd" runat="server" CssClass="upper"></asp:TextBox><span title="Clear this field." class="clear">Ω</span>
          </asp:TableCell>
        </asp:TableRow>

        <asp:TableRow>
          <asp:TableCell ColumnSpan="2">
            <div style="margin-left: auto; margin-right: auto; text-align: center;">
              <asp:Button CssClass="button200" ID="butChange" OnClick="butChange_Click" runat="server" Text="Change Passwords" />
            </div>
          </asp:TableCell>
        </asp:TableRow>

        <asp:TableRow>
          <asp:TableCell ColumnSpan="2">
        Changing passwords can take a minute or two. 
          </asp:TableCell>
        </asp:TableRow>

      </asp:Table>

    </asp:Panel>

    <asp:Panel ID="panSuccess" runat="server" Visible="false">
      <div class="title">
        <img class="exit" src="/portal/styles/icons/x-white.png" />
        <h2 style="margin-top: 50px; text-align: center;">Congratulations!<br />
          <br />
          All Child Accounts have been changed. </h2>
      </div>
    </asp:Panel>
  </div>

</asp:Content>
