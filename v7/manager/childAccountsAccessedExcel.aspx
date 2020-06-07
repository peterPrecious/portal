<%@ Page
  Title="Ecommerce"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="childAccountsAccessedExcel.aspx.cs"
  Inherits="portal.v7.manager.childAccountsAccessedExcel" %>


<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">

  <style>
    .tbDates { margin: 25px auto; background-color: #0178B9; border: none; }
      .tbDates .nextPrev { display: none; }
      .tbDates * { border: none; }
    .drp { border: 1px solid white; margin: 0 3px; background-color: #8DC640; }
  </style>

</asp:Content>


<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

    <h1>Child Accounts Accessed Report (Excel)</h1>
    <h2 style="width: 75%; margin: auto; text-align: left;">
      This produces a spreadsheet of Child Accounts of this Parent Account (<asp:Literal ID="Literal3" runat="server" />) 
      with columns: (Child) Account Id and the # Accessed, ie a count of how many learners have accessed the account 
      after the date specified below.   
      You can Include Expired Accounts. Click on the Excel Icon when ready.
    </h2>

    <asp:Table ID="tbDates" CssClass="tbDates" runat="server">
      <asp:TableRow>
        <asp:TableCell>
          <asp:DropDownList ID="drpCalMonth" runat="Server" OnSelectedIndexChanged="setCalendar" CssClass="drp" AutoPostBack="true"></asp:DropDownList>
          <asp:DropDownList ID="drpCalYear" runat="Server" OnSelectedIndexChanged="setCalendar" CssClass="drp" AutoPostBack="true"></asp:DropDownList>
        </asp:TableCell>
      </asp:TableRow>
      <asp:TableRow>
        <asp:TableCell>
          <asp:Calendar
            ID="Calendar"
            CssClass="Calendar"
            NextPrevStyle-CssClass="nextPrev"
            OtherMonthDayStyle-ForeColor="#8DC640"
            TitleStyle-BackColor="#8DC640"
            DayHeaderStyle-Font-Bold="false"
            TitleStyle-ForeColor="black"
            DayStyle-ForeColor="white"
            DayHeaderStyle-ForeColor="White"
            runat="server"></asp:Calendar>
        </asp:TableCell>
      </asp:TableRow>
    </asp:Table>

    <asp:CheckBox ID="chkExpired" Text="Include Expired Accounts" runat="server" />
    <br /><br />
    <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" runat="server" />
  </div>

</asp:Content>
