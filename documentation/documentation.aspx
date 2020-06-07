<%@ Page
  Title="Documentation"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="documentation.aspx.cs"
  Inherits="portal.v7.documentation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/styles.min.css" rel="stylesheet" />
  <link href="/portal/styles/css/documentation.min.css" rel="stylesheet" />
</asp:Content>

<%-- Note: update this documentation/documentation.aspx AS WELL AS documentation/index.html --%>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />
    <h1>Vubiz Documentation</h1>
    <ol>
      <li><a href="channelMaster.docx">Changing Channel Master Password</a></li>
      <li><a href="ecomDocs.docx">Ecommerce Services</a></li>
      <li><a href="ecomErrors.docx">Ecommerce Errors</a></li>
      <li><a href="vuEcomSsoDocs.docx">Ecommerce Single SignOn Services</a></li>
      <li><a href="ssoDocs.docx">Single SignOn Services</a></li>
      <li><a href="accountManagement.docx">Account Management Services</a></li>
      <li><a href="ecomExtend.docx">Extend Ecommerce Transaction</a></li>
    </ol>
  </div>

</asp:Content>
