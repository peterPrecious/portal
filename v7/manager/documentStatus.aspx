<%@ Page Title="" Language="C#" AutoEventWireup="true"
  MasterPageFile="~/v7/site.master"
  CodeBehind="documentStatus.aspx.cs"
  Inherits="portal.v7.manager.documentStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .documents, a { color: white; }
      a:hover { color: yellow; }
    li { padding-top: 10px; }
  </style>
  <link href="../../styles/css/styles.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <h1 style="margin-bottom: 25px;">
      <span onclick="fadeIn()" class="hoverUnderline" title="Click to show discription.">Custom Documents Status</span>
    </h1>

    <div class="thisTitle">
      This allows your to view the current documents that would appear in this Account.
      <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
    </div>

    <ul style="width: 200px; margin: auto; text-align: left; padding: 30px;">
      <li>
        <asp:LinkButton CssClass="documents" ID="doc1" OnClick="doc_Click" runat="server">harassment.pdf</asp:LinkButton></li>
      <li>
        <asp:LinkButton CssClass="documents" ID="doc2" OnClick="doc_Click" runat="server">conflict.pdf</asp:LinkButton></li>
      <li>
        <asp:LinkButton CssClass="documents" ID="doc3" OnClick="doc_Click" runat="server">reaffirmation.pdf</asp:LinkButton></li>
      <li>
        <asp:LinkButton CssClass="documents" ID="doc4" OnClick="doc_Click" runat="server">ethicsemployees.pdf</asp:LinkButton></li>
    </ul>

    <%--    <div style="width: 200px; margin:auto; text-align: left; padding:30px;">
      <asp:LinkButton CssClass="documents" ID="doc1" OnClick="doc_Click" runat="server">harassment.pdf</asp:LinkButton> <br /><br />
      <asp:LinkButton CssClass="documents" ID="doc2" OnClick="doc_Click" runat="server">conflict.pdf</asp:LinkButton>  <br /><br />
      <asp:LinkButton CssClass="documents" ID="doc3" OnClick="doc_Click" runat="server">reaffirmation.pdf</asp:LinkButton> <br /><br />
      <asp:LinkButton CssClass="documents" ID="doc4" OnClick="doc_Click" runat="server">ethicsemployees.pdf</asp:LinkButton> <br />
    </div>--%>
  </div>
</asp:Content>
