<%@ Page
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="emailAlerts.aspx.cs"
  Inherits="portal.v7.manager.emailAlerts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/emailAlerts.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" /><br />
    <h1>
      <asp:Label ID="lab1" runat="server" Text="<%$  Resources:portal, emailAlerts_1%>" /></h1>
    <div class="emailAlerts">
      <asp:Label ID="lab2" runat="server" Text="<%$  Resources:portal, emailAlerts_2%>" />
<%--        This service will email access instructions to any Learner when program(s) have been assigned by the account Facilitator.
        A Learner must have a valid email address in order to qualify for email alerts.<br /><br />
        If this service is enabled then each learner can further be configured to use the service or not; also you can resend email alerts by using Add/Edit Learners.--%>
    </div>

    <h2>
      <asp:Label ID="lab3" runat="server" Text="<%$  Resources:portal, emailAlerts_3%>" />
      <asp:Label Font-Bold="true" ID="labStatus" runat="server" Text="<%$  Resources:portal, emailAlerts_4%>"></asp:Label>
    </h2>
    <br />

    <asp:Button CssClass="button250" ID="butEnable" OnClick="butEnable_Click" runat="server" Text="<%$  Resources:portal, emailAlerts_6%>" />
    <asp:Button CssClass="button250" ID="butDisable" OnClick="butDisable_Click" runat="server" Text="<%$  Resources:portal, emailAlerts_7%>" Visible="false" />

  </div>

</asp:Content>
