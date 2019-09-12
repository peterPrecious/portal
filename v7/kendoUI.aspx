<%@ Page Title="" Language="C#" MasterPageFile="~/v7/site.master" AutoEventWireup="true" CodeBehind="kendoUI.aspx.cs" Inherits="portal.v7.kendoUI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

  <link rel="stylesheet" href="//kendo.cdn.telerik.com/2017.2.621/styles/kendo.common-material.min.css" />
  <link rel="stylesheet" href="//kendo.cdn.telerik.com/2017.2.621/styles/kendo.material.min.css" />
  <link rel="stylesheet" href="//kendo.cdn.telerik.com/2017.2.621/styles/kendo.material.mobile.min.css" />
  <script src="//code.jquery.com/jquery-1.12.3.min.js"></script>
  <script src="//kendo.cdn.telerik.com/2017.2.621/js/kendo.all.min.js"></script>

  <link href="/portal/styles/css/kendoUI.min.css" rel="stylesheet" />
  <script src="/portal/scripts/kendoUI.min.js"></script>
  <script src="/portal/scripts/$urls.min.js"></script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage" style="width: 85%; min-width: 800px;">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

    <table class="tabContain">
      <tr>
        <td>
          <h3>Chart is being generated...</h3>

        </td>
      </tr>
      <tr>
        <td id="chart" style="padding: 30px 0;"></td>
      </tr>
      <tr>
        <td>
          <h4>Place the mouse over the bar to see actual value.</h4>
        </td>
      </tr>
    </table>
  </div>

</asp:Content>
