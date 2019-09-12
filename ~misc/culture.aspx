<%@ Page
  Title="Change Language"
  Language="C#"
  MasterPageFile="~/v7/Site.Master"
  AutoEventWireup="true"
  CodeBehind="culture.aspx.cs"
  Inherits="portal.Culture"
  UICulture="auto"
  Culture="auto" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

  <style>
    .divPage { width: 300px; }

    .tabCulture { margin: 10px auto; border-collapse: collapse; background-color: #0178B9; border: 20px solid #0178B9; }
      .tabCulture td { border: none; padding: 6px; }
      .tabCulture th, .tabCulture th label { border: none; padding: 6px; color: white; text-align: right; font-weight: 500; }
  </style>

</asp:Content>

<asp:Content ID="defaultContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage" runat="server">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/x.png" ID="exit" runat="server" OnClick="exit_Click" />

    <h1><asp:Literal runat="server" Text="<%$  Resources:portal, menuChangeLanguage%>" /></h1>
    <asp:Table ID="tabCulture" CssClass="tabCulture" runat="server" Visible="true">
      <asp:TableRow>
        <asp:TableHeaderCell>
          <asp:RadioButtonList CssClass="tabCultureLang" AutoPostBack="true" ID="radCulture" runat="server" RepeatDirection="Horizontal" TextAlign="Left" BorderStyle="None">
            <asp:ListItem Value="en-US" Text="<%$  Resources:portal, langEnglish%>">English</asp:ListItem>
            <asp:ListItem Value="fr-CA" Text="<%$  Resources:portal, langFrench%>">French</asp:ListItem>
          </asp:RadioButtonList>
        </asp:TableHeaderCell>
      </asp:TableRow>
    </asp:Table>

  </div>

</asp:Content>
