<%@ Page
  Title="My Profile"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="profile.aspx.cs"
  Inherits="portal.v7.profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

  <style>
    .dvProfile td:first-child::after { content: " : " }
    .dvProfile td { border: none }
  </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <div class="body" runat="server">

    <div class="divPage">
      <%--<asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />--%>
      <h1>
        <asp:Label runat="server" Text="<%$  Resources:portal, profile_1%>"></asp:Label></h1>
      <h2 style="color: inherit;">
        <asp:Label runat="server" Text="<%$  Resources:portal, profile_2%>"></asp:Label>
      </h2>
      <h3>
        <asp:Label ID="lab2" runat="server" Text="<%$  Resources:portal, profile_3%>" Visible="false"></asp:Label>
      </h3>
      <br />
      <asp:DetailsView
        OnDataBound="dvProfile_DataBound"
        ID="dvProfile"
        CssClass="dvProfile"
        runat="server"
        HorizontalAlign="Center"
        BorderStyle="None"
        CellPadding="5"
        FieldHeaderStyle-Font-Bold="true"
        FieldHeaderStyle-HorizontalAlign="Right"
        RowStyle-HorizontalAlign="Left"
        AutoGenerateRows="False"
        DataKeyNames="membInternal"
        DataSourceID="SqlDataSource1">
        <Fields>
          <asp:BoundField DataField="membFirstName" HeaderText="<%$  Resources:portal, firstName%>" />
          <asp:BoundField DataField="membLastName" HeaderText="<%$  Resources:portal, lastName%>" />
          <asp:BoundField DataField="membCustId" HeaderText="<%$  Resources:portal, custId%>" />

          <asp:TemplateField HeaderText="<%$  Resources:portal, membId%>">
            <ItemTemplate>
              <asp:Label ID="membId" runat="server" Text='<%# Bind("membId") %>'></asp:Label>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:TemplateField HeaderText="<%$  Resources:portal, password%>">
            <ItemTemplate>
              <asp:Label ID="membPwd" runat="server" Text='<%# Bind("membPwd") %>'></asp:Label>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:BoundField DataField="membEmail" HeaderText="<%$  Resources:portal, email%>" />
          <asp:TemplateField HeaderText="<%$  Resources:portal, level%>">
            <ItemTemplate>
              <asp:Label ID="membLevel" runat="server" Text='<%# Bind("membLevel") %>'></asp:Label>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:BoundField DataField="membPrograms" HeaderText="<%$  Resources:portal, programs%>" />
          <asp:BoundField DataField="membFirstVisit" HeaderText="<%$  Resources:portal, firstVisit%>" DataFormatString="{0:MMM d, yyyy hh:mm}" />
          <asp:BoundField DataField="membLastVisit" HeaderText="<%$  Resources:portal, lastVisit%>" DataFormatString="{0:MMM d, yyyy hh:mm}" />
          <asp:BoundField DataField="membNoVisits" HeaderText="<%$  Resources:portal, noVisits%>" />
        </Fields>
      </asp:DetailsView>
      <br />
      <br />
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
      SelectCommand="
        SELECT
            M.Memb_FirstName            AS membFirstName,
            M.Memb_LastName             AS membLastName,
	          C.Cust_Id                   AS membCustId,
            UPPER(M.Memb_Id)            AS membId,
            UPPER(M.Memb_Pwd)           AS membPwd,
            LOWER(M.Memb_Email)         AS membEmail,
            UPPER(M.Memb_Programs)      AS membPrograms,
            M.Memb_Level                AS membLevel,
            M.Memb_FirstVisit           AS membFirstVisit,
            M.Memb_LastVisit            AS membLastVisit,
            M.Memb_NoVisits             AS membNoVisits,
            M.Memb_Internal             AS membInternal
        FROM
            V5_Vubz.dbo.Memb AS M
	          INNER JOIN V5_Vubz.dbo.Cust AS C
		          ON M.Memb_AcctId = C.Cust_AcctId
        WHERE
          Memb_AcctId               = @membAcctId AND
          Memb_Id                   = @membId
      ">
      <SelectParameters>
        <asp:SessionParameter DefaultValue="" Name="membAcctId" SessionField="custAcctId" />
        <asp:SessionParameter DefaultValue="" Name="membId" SessionField="membId" />
      </SelectParameters>
    </asp:SqlDataSource>

  </div>
</asp:Content>