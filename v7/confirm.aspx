<%@ Page
  Title="Confirm Test"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="confirm.aspx.cs"
  Inherits="portal.v7.administrator.Confirm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

  <style>
    .panConfirm {
      color: white;
      top: 100px;
      width: 400px;
      height: 200px;
      margin: 100px auto;
      border: none;
      padding: 30px;
      background-color: #0178B9;
      text-align: center;
      box-shadow: 0px 0px 30px grey;
    }

      .panConfirm td {
        border: none;
      }

    .newButton {
      color: white;
      border: none;
      border: 1px solid white;
      background-color: none;
      font-weight: bold;
      font-size: 1.0em;
      padding: 5px 20px;
      margin: 3px;
    }

      .newButton:hover {
        color: #0178B9;
        background-color: white;
        border-right: 2px solid black;
        border-bottom: 2px solid black;
        text-decoration: none;
      }
  </style>
  <script>
    function confirmCancel() {
      $(".panConfirm").hide();
    }
  </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <asp:Panel ID="panConfirm" CssClass="panConfirm" runat="server" Visible="true">
    <table style="width: 380px; margin: 0px; margin: auto; border: none;">
      <tr>
        <td>
          <h1>
            <asp:Label ID="labConfirmTitle" runat="server"></asp:Label>
          </h1>
        </td>
      </tr>
      <tr>
        <td style="height: 125px; vertical-align: text-top">
          <h2>
            <asp:Label ID="labConfirmMessage" runat="server"></asp:Label></h2>
        </td>
      </tr>
      <tr>
        <td>
          <asp:LinkButton CssClass="newButton" ID="btnConfirmCancel" OnClientClick="confirmCancel(); return false;" Text="" runat="server"></asp:LinkButton>
          &nbsp;&nbsp;
          <asp:LinkButton CssClass="newButton" ID="btnConfirmConfirm" runat="server"></asp:LinkButton>
        </td>
      </tr>
    </table>
  </asp:Panel>

  <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
</asp:Content>
