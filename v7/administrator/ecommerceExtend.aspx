<%@ Page
  Title="Ecommerce Extend"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="ecommerceExtend.aspx.cs"
  Inherits="portal.v7.manager.ecommerceExtend" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .checks { color: yellow; padding: 0; margin: 0; }
    .input { height: 10px; }
    .tbSelect, .tbSelect th, .tbSelect td { border: none; }
    .programId, .noDays { text-align: center; }
    .tbSelect { margin-bottom: 40px; }
    .labError { text-align: center; color: yellow; font-weight: bold; }
    .cellError { padding: 20px; }
  </style>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="Exit_Click" />
    <br />

    <h1>Extend Access to Ecommerce Transactions (coming)</h1>

    <p class="c2">
      Enter the <b>User Id</b> <span class="yellow">of the Ecommerce Purchaser</span>, the <b>Program Id</b> and <b># Days</b> to extend the Transaction <b>from today</b>.
      Typically you might want to extend expiry by 30 or 60 days, or you can enter a negative number of days, ie -1 days.
      Note: any negative number of Days will set the Expires Date to that number of days before today; which effectively means the transaction has expired.
    </p>

    <asp:Table CssClass="tbSelect" runat="server" HorizontalAlign="Center" CellPadding="5">
      <asp:TableHeaderRow>
        <asp:TableHeaderCell HorizontalAlign="Left">User Id</asp:TableHeaderCell>
        <asp:TableHeaderCell>Program Id</asp:TableHeaderCell>
        <asp:TableHeaderCell># Days</asp:TableHeaderCell>
        <asp:TableHeaderCell>Action</asp:TableHeaderCell>
      </asp:TableHeaderRow>
      <asp:TableRow>
        <asp:TableCell>
          <asp:TextBox Height="18" CssClass="learnerId" ID="learnerId" placeholder="learnerId" Width="500" Text="483FBD77A79B016B59266CF2ED0CD14949AE145F" runat="server"></asp:TextBox>
        </asp:TableCell>
        <asp:TableCell>
          <asp:TextBox Height="18" CssClass="programId" ID="programId" placeholder="Program Id" Width="70" Text="P1932EN" runat="server" MaxLength="7"></asp:TextBox>
        </asp:TableCell>
        <asp:TableCell>
          <asp:TextBox Height="18" CssClass="noDays" ID="noDays" placeholder="# Days" Width="50" Text="-1" runat="server"></asp:TextBox>
        </asp:TableCell>
        <asp:TableCell>
          <asp:Button ID="btnExtend" runat="server" Text="Extend" OnClick="btnExtend_Click" />
          <asp:Button ID="btnRestart" runat="server" Text="Restart" OnClick="btnRestart_Click" />
        </asp:TableCell>
      </asp:TableRow>
      <asp:TableFooterRow BorderStyle="None">
        <asp:TableCell CssClass="cellError" ColumnSpan="4">
          <asp:Label ID="labError" CssClass="labError" runat="server" Text=""></asp:Label>
        </asp:TableCell>
      </asp:TableFooterRow>
    </asp:Table>

  </div>

</asp:Content>
