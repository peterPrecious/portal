<%@ Page
  Title="Ecommerce"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="childAccountsExcel.aspx.cs"
  Inherits="portal.v7.manager.childAccountsExcel" %>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
    <h1>Child Accounts Report (Excel)</h1>
    <h2 style="width: 75%; margin: auto; text-align: left;">
      This produces a spreadsheet of Child Accounts of this Parent Account (<asp:Literal ID="Literal3" runat="server" />) 
      with columns: (Child) Account Id, # Learners and Date Expires. 



      You can Include or Exclude (default) Expired Accounts.  Click on the Excel Icon when ready.
    </h2>
    <br />
    <asp:CheckBox ID="chkExpired" Text="Include Expired Accounts" runat="server" />
    <br /><br />
    <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" runat="server" />
  </div>

</asp:Content>
