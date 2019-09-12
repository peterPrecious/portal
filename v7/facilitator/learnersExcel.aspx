<%@ Page
  Title="Learners"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="learnersExcel.aspx.cs"
  Inherits="portal.v7.facilitator.learnersExcel" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage" style="width: 400px">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
    <h1>Export Learners to Excel</h1>
    <h2 style="margin-bottom: 50px;">There are <asp:Label ID="labCount" runat="server" Text="Label"></asp:Label> Learners available for Export.    </h2>

    <asp:Button ID="butBegin" CssClass="button" OnClick="butBegin_Click" runat="server" Text="Begin" />

  </div>
</asp:Content>
