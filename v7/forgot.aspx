<%@ Page
  Title="Forgot Credentials?"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="forgot.aspx.cs"
  Inherits="portal.forgot" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

</asp:Content>

<asp:Content ID="forgotContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <h1>Forgot Credentials?</h1>

    <h2>Enter your unique email address where we will send your credentials.</h2>

    <div style="margin: 50px 0 20px;">
      <asp:TextBox runat="server"
        ID="txtEmail"
        TextMode="Email"
        Height="28px"
        Width="350px">
      </asp:TextBox>

      <asp:Button runat="server"
        CssClass="button"
        ID="btnEmail"
        OnClick="btnEmail_Click"
        Text="Retrieve" />

    </div>

    <asp:Label ID="labEmail" runat="server"></asp:Label>

  </div>

</asp:Content>
