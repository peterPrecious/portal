<%@ Page Title="" Language="C#" AutoEventWireup="true"
  MasterPageFile="~/v7/site.master"
  CodeBehind="documentUpload.aspx.cs"
  Inherits="portal.v7.manager.documentUpload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .tabDocumentUpload { width: 800px; margin: auto; }
      .tabDocumentUpload tr td { width: 45%; padding: 0px; }
        .tabDocumentUpload tr td:first-child { text-align: right; vertical-align: top; padding-right: 10px; }
        .tabDocumentUpload tr td:last-child { text-align: left; }
      .tabDocumentUpload .tabRow { padding-top: 20px; }
      .tabDocumentUpload .custId { padding-left: 7px; }
      .tabDocumentUpload .txtCustId { text-align: center; }
    .button { margin: 20px 0 30px 30px; }
    table, tr, td { border: none; }
  </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <h1 style="margin-bottom: 25px;">
      <span onclick="fadeIn()" class="hoverUnderline" title="Click to show discription.">Upload Custom Document</span>
    </h1>

    <ul class="thisTitle">
      <li>This allows you to upload a document that is customized to your Organization&#39;s standards. They appear when VuBuild Authors use <strong>smartlinks</strong>.</li>
      <li>If you offer this document in multiple languages, please develop ONE document per language, ie do not make any one document multi-lingual. </li>
      <li>Note that the file name you use to upload<strong><em> can be any name</em></strong> - it will be converted to the name you select below.</li>
      <li>You can update this document in the future by simply re-uploading a revised version, which will override whatever was previously uploaded.</li>
      <li>Select the Document Name, Account info and the Language then click "Next" to Upload.</li>
      <li>You will then be directed to a little page where you can upload your document.</li>
      <li>First "Browse..." to find the document on your system, then click "Upload".</li>
      <li>It will just take a second then you will immediately be returned back here <strong><em>signifying that the upload was successful.</em></strong></li>
      <li style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></li>
    </ul>

    <asp:Table CssClass="tabDocumentUpload" ID="tabDocumentUpload" runat="server">

      <asp:TableRow>
        <asp:TableCell CssClass="tabRow">Document File Name :</asp:TableCell>
        <asp:TableCell CssClass="tabRow">
          <asp:RadioButtonList CssClass="vDocument" ID="vDocument" runat="server">
            <asp:ListItem Selected="True">harassment.pdf</asp:ListItem>
            <asp:ListItem>conflict.pdf</asp:ListItem>
            <asp:ListItem>reaffirmation.pdf</asp:ListItem>
            <asp:ListItem>ethicsemployees.pdf</asp:ListItem>
          </asp:RadioButtonList>
        </asp:TableCell>
      </asp:TableRow>

      <asp:TableRow>
        <asp:TableCell CssClass="tabRow">For Account(s) :</asp:TableCell>

        <asp:TableCell CssClass="tabRow">
          <asp:RadioButtonList CssClass="vAccounts" ID="vAccounts" runat="server">
            <asp:ListItem Selected="True" />
            <asp:ListItem />
          </asp:RadioButtonList>
        </asp:TableCell>

      </asp:TableRow>

      <asp:TableRow>
        <asp:TableCell CssClass="tabRow">Language :</asp:TableCell>
        <asp:TableCell CssClass="tabRow">
          <asp:RadioButtonList CssClass="vLang" ID="vLang" runat="server">
            <asp:ListItem Selected="True">EN</asp:ListItem>
            <asp:ListItem>FR</asp:ListItem>
            <asp:ListItem>ES</asp:ListItem>
          </asp:RadioButtonList>
        </asp:TableCell>
      </asp:TableRow>
    </asp:Table>

    <asp:Button ID="butNext" OnClick="butNext_Click" CssClass="button" runat="server" Text="Next" />


  </div>
</asp:Content>
