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
    $(function () { $("#MainContent_txtOrderId").on("focus", function () { $("#MainContent_panError").hide(); }) });
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">


  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
    <h1>Ecommerce Transactions by Order Id (Excel)</h1>
    <h2>Enter a valid Order Id then click the Excel Icon to retrieve up to&nbsp;
    <asp:DropDownList ID="ddTop" Style="border: 1px solid white; background-color: #0178B9; color: white;" runat="server">
      <asp:ListItem Selected="True">10</asp:ListItem>
      <asp:ListItem>100</asp:ListItem>
      <asp:ListItem>1000</asp:ListItem>
    </asp:DropDownList>
      transactions.<br />If the Order Id is not on file, then the Excel report will have no data.
    </h2>
    <h3><asp:Label CssClass="statusLabel" ID="StatusLabel" runat="server"></asp:Label></h3>

    <table>
      <tr>
        <td>Order Id:</td>
        <td>
          <asp:TextBox ID="txtOrderId" Width="200px" runat="server"></asp:TextBox></td>
        <td>
          <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" xCssClass="excel" runat="server" /></td>
      </tr>
    </table>
  </div>

</asp:Content>
