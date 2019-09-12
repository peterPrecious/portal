<%@ Page
  Title="Email Alerts"
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
    <h1>Email Alert Service</h1>

    <div class="emailAlerts">
      This service will email access instructions to any Learner when programs(s) have been assigned by the account Facilitator.
      A Learner must have a valid email address in order to qualify for email alerts.
      <br />
      <br />
      If this service is enabled then each learner can further be configured to use the service or not; also you can resend email alerts by using Add/Edit Learners.
    </div>

    <h2>Service Status is currently
    <asp:Label Font-Bold="true" ID="labStatus" runat="server" Text="DISABLED"></asp:Label></h2>
    <br />


    <asp:Button CssClass="button200" ID="butEnable" OnClick="butEnable_Click" runat="server" Text="ENABLE Email Alerts" />
    <asp:Button CssClass="button200" ID="butDisable" OnClick="butDisable_Click" runat="server" Text="DISABLE Email Alerts" Visible="false" />

  </div>

</asp:Content>
