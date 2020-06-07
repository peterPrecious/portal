<%@ Page
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="learnersExcel.aspx.cs"
  Inherits="portal.v7.facilitator.learnersExcel" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">

</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
    <h1><asp:Literal runat="server" Text="<%$  Resources:portal, learners_12%>" /></h1>
    <h2 style="margin-bottom: 50px;">
      <asp:Literal runat="server" Text="<%$  Resources:portal, learners_13%>" /> <%--There are --%>
      <asp:Label ID="labCount" runat="server" />
      <asp:Literal runat="server" Text="<%$  Resources:portal, learners_14%>" /> <%--learners available for Export.--%>    
    </h2>
    <asp:Button ID="butBegin" CssClass="newButton" OnClick="butBegin_Click" runat="server" Text="<%$  Resources:portal, begin%>" />
    <br /><br />
  </div>

</asp:Content>
