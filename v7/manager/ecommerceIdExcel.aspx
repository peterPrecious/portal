<%@ Page
  Title="Ecommerce"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="ecommerceIdExcel.aspx.cs"
  Inherits="portal.v7.manager.ecommerceIdExcel" %>


<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/ecommerceIdExcel.min.css" rel="stylesheet" />
  <script>
    $(function () {
      $("#MainContent_txtOrderId").on("focus", function () { $("#MainContent_panError").hide(); })
      $("#MainContent_txtLineId").on("focus", function () { $("#MainContent_panError").hide(); })
    });
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">


  <div class="divPage" style="width: 500px">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
    <h1>Ecommerce Transactions by Id (Excel)</h1>
    <h2>Enter an Order Id and/or a Line ID then click the Excel Icon to retrieve up to&nbsp;
    <asp:DropDownList ID="ddTop" Style="border: 1px solid white; background-color: #0178B9; color: white;" runat="server">
      <asp:ListItem Selected="True">100</asp:ListItem>
      <asp:ListItem>1000</asp:ListItem>
      <asp:ListItem>10000</asp:ListItem>
    </asp:DropDownList>
      transactions.
    </h2>

    <table class="tabContain" style="margin: auto;">
      <tr>
        <td class="tdParent">
          <table class="tbDates">
            <tr>
              <th class="tdParent">Order Id:</th>
              <td class="tdParent">
                <asp:TextBox ID="txtOrderId" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
              <th class="tdParent">Line Id:</th>
              <td class="tdParent">
                <asp:TextBox ID="txtLineId" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
              <td colspan="2">
                <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" runat="server" />
              </td>
            </tr>
            <tr>
              <td colspan="2" style="vertical-align: middle; font-size: larger; color: white;">
                <asp:Panel ID="panError" runat="server" Visible="false">Enter at least one value!</asp:Panel>
              </td>
            </tr>

          </table>
        </td>

      </tr>

    </table>
  </div>

</asp:Content>
