<%@ Page
  Title=""
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="passwordReplace.aspx.cs"
  Inherits="portal.v7.facilitator.passwordReplace" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/passwordFinder.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />
    <br />

    <asp:Panel ID="panTop" CssClass="panTop" runat="server" DefaultButton="butSearch">

      <h1>
        <span onclick="fadeIn()" class="hoverUnderline">
          <asp:Literal runat="server" Text="Learner Password Replace" />
        </span>
      </h1>

      <div class="thisTitle">
        <asp:Literal runat="server" />
        Enter the Learner's Username. Must be in this account  ie ABCD1234 and "SMI1234").
        <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
        <div style="margin: 30px; text-align: center;">
          <asp:TextBox ID="txtMembId" Text="" CssClass="alignCenter" runat="server" />
          <asp:Button ID="butSearch" CssClass="button" runat="server" Text="Search" />
        </div>
      </div>

      <asp:GridView runat="server"
        ID="gvPasswords"
        CssClass="gvPasswords"
        HorizontalAlign="Center"
        HeaderStyle-HorizontalAlign="Left"
        AutoGenerateColumns="False"
        RowStyle-HorizontalAlign="Left"
        AllowSorting="True"
        AllowPaging="True"
        PageSize="20"
        CellPadding="5"
        DataSourceID="SqlDataSource1">

        <Columns>
          <asp:BoundField DataField="membId" HeaderText="Username" SortExpression="membId" />
          <asp:BoundField DataField="membFirstName" HeaderText="First Name" SortExpression="membFirstName" />
          <asp:BoundField DataField="membLastName" HeaderText="Last Name" SortExpression="membLastName" />
          <asp:BoundField DataField="membPwd" HeaderText="Password" />
        </Columns>


        <PagerSettings
          FirstPageImageUrl="~/styles/icons/grids/frst.png"
          LastPageImageUrl="~/styles/icons/grids/last.png"
          NextPageImageUrl="~/styles/icons/grids/next.png"
          PreviousPageImageUrl="~/styles/icons/grids/prev.png"
          Position="Bottom"
          Mode="NextPreviousFirstLast" />
        <PagerStyle CssClass="commands" HorizontalAlign="Center" />


        <EmptyDataRowStyle CssClass="empty" />
        <EmptyDataTemplate>
          Oops. There are no Learners on file with the Username, First Name or Last Name fragment entered.<br />
        </EmptyDataTemplate>


      </asp:GridView>

    </asp:Panel>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
      ConnectionString="<%$ ConnectionStrings:V5_Vubz %>"
      SelectCommand="
        SELECT TOP 100 
          [Memb_Id]                 AS membId, 
          [Memb_FirstName]          AS membFirstName, 
          [Memb_LastName]           AS membLastName, 
          [Memb_Pwd]                AS membPwd
        FROM
          V5_Vubz.dbo.Memb
        WHERE 
          (
          Memb_AcctId = @membAcctId AND 
          Memb_Internal = 0 AND
          Memb_Level &lt; @membLevel AND
          Memb_Id NOT LIKE '%_ADMIN' AND
          Memb_Id NOT LIKE '%_SALES'
          )
          AND
    	    (
          LEN(@search) = 0 OR 
          @search IS NULL OR 
          @search = '*' OR 
          Memb_Id LIKE '%' + @search + '%' OR 
          Memb_FirstName LIKE '%' + @search + '%' OR 
          Memb_Lastname LIKE '%' + @search + '%' 
		      )

        ORDER BY 
          Memb_Id     
      ">

      <SelectParameters>
        <asp:SessionParameter Name="membLevel" SessionField="membLevel" />
        <asp:SessionParameter Name="membAcctId" DefaultValue="" SessionField="custAcctId" />
        <asp:ControlParameter Name="search" ControlID="txtSearch" DefaultValue="*" PropertyName="Text" />
      </SelectParameters>



    </asp:SqlDataSource>

  </div>

</asp:Content>
