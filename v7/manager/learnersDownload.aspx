<%@ Page
  Language="C#"
  MasterPageFile="~/v7/site.master"
  Title="Download Active Learners"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="learnersDownload.aspx.cs"
  Inherits="portal.v7.facilitator.learnersDownload" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
    <h1>Download (Export) All Active Learners to Excel</h1>
    <h2>There are <asp:Label ID="labCount" runat="server" Text="Label"></asp:Label> Learners available for Download.</h2>
    <h2 style="margin-bottom: 50px;">Once you have generated the Excel file (by clicking Begin button below), you can close this app.</h2>
    <asp:Button ID="butBegin" CssClass="newButton" OnClick="butBegin_Click" runat="server" Text="Begin" />
  </div>

</asp:Content>
