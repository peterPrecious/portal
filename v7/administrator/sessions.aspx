<%@ Page
  Title="Sessions"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="sessions.aspx.cs"
  Inherits="portal.v7.administrator.sessions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/sessions.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
    <h1 style="color: inherit;">Session Variables</h1>
    <h2 style="color: inherit;">These values are maintained during the session.</h2>
    <asp:Table CssClass="tabSessions" ID="tabSessions" runat="server">
      <asp:TableHeaderRow>
        <asp:TableHeaderCell>Key&nbsp;</asp:TableHeaderCell>
        <asp:TableHeaderCell>Value</asp:TableHeaderCell>
      </asp:TableHeaderRow>
    </asp:Table>
  </div>

</asp:Content>
