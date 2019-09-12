<%@ Page
  Title="Ecommerce"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="crossAccountProgramActivityExcel.aspx.cs"
  Inherits="portal.v7.manager.crossAccountProgramActivityExcel" %>


<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/crossAccountProgramActivityExcel.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage" style="width: 500px">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
    <h1>Cross Account Program Activity (Excel)</h1>
    <p class="c2">This generates Program Activity Analysis for all Active Accounts in the Customer Group <span><% =Session["cust"].ToString()%></span>.</p>
    <h3>Note: this app is only available from this Parent Account (<% =Session["custId"].ToString()%>). It cannot be accessed from Child Accounts.</h3>
    <table class="tabContain">
      <tr>
        <th>Program Id :</th>
        <td>
          <asp:TextBox ID="txtProgramId" MaxLength="7" CssClass="upper" runat="server"></asp:TextBox></td>
        <td>
          <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" runat="server" /></td>
      </tr>
      <tr>
        <td colspan="3" style="vertical-align: middle; font-size: larger; color: white;">
          <asp:Panel ID="panError" runat="server" Visible="false">The Program Id must be 7 characters long!</asp:Panel>
        </td>
      </tr>
    </table>

  </div>

</asp:Content>
