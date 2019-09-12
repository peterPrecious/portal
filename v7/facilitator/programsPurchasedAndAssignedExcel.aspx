<%@ Page
  Title="Programs Assigned (Excel)"
  Language="C#"
  AutoEventWireup="true"
  MasterPageFile="~/v7/site.master"
  EnableEventValidation="true"
  CodeBehind="programsPurchasedAndAssignedExcel.aspx.cs"
  Inherits="portal.v7.facilitator.programsPurchasedAndAssignedExcel" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/programsPurchasedAndAssigned.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">
  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

    <h1>
      <span onclick="fadeIn()" class="hoverUnderline" title="Click to hide/show discription.">
        <asp:Label ID="labHeader" runat="server" />
      </span>
    </h1>

    <div class="thisTitle">
      <asp:Panel runat="server">
        Press the Begin button to generate the Excel which shows all the Learners that have been assigned the Program(s) selected below.
        <asp:Literal ID="litNone" runat="server" Visible="false">Because this Account does not contain any Purchased Programs, the Excel cannot be generated.</asp:Literal>
      </asp:Panel>
    </div>

    <asp:Table runat="server" CellPadding="20" BorderStyle="None" HorizontalAlign="Center">
      <asp:TableRow BorderStyle="None">
        <asp:TableCell BorderStyle="None">
          <asp:DropDownList ID="ddProgs" runat="server"
            AutoPostBack="true"
            OnSelectedIndexChanged="ddProgs_SelectedIndexChanged"
            Style="border: none; height: 33px; background-color: #0178B9; color: white; border: 1px solid white;">
            <asp:ListItem>All Programs</asp:ListItem>
          </asp:DropDownList>
        </asp:TableCell>
        <asp:TableCell BorderStyle="None">
          <asp:LinkButton ID="btnBegin" CssClass="newButton" OnClick="btnBegin_Click" Text="Begin" runat="server"></asp:LinkButton>
        </asp:TableCell>
      </asp:TableRow>
    </asp:Table>











  </div>
</asp:Content>
