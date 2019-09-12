<%@ Page
  Title="My Profile"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="profile.aspx.cs"
  Inherits="portal.v7.profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/profile.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <div class="body" runat="server">

    <div class="divPage">
      <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />
      <h1>My Profile</h1>

      <asp:DetailsView
        OnDataBound="dvProfile_DataBound"
        ID="dvProfile"
        CssClass="dvProfile"
        runat="server"
        AutoGenerateRows="False"
        DataKeyNames="membInternal"
        DataSourceID="SqlDataSource1">
        <Fields>
          <asp:BoundField DataField="membFirstName" HeaderText="<%$  Resources:portal, firstName%>" />
          <asp:BoundField DataField="membLastName" HeaderText="<%$  Resources:portal, lastName%>" />

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
          <asp:BoundField DataField="membFirstVisit" HeaderText="<%$  Resources:portal, firstVisit%>" DataFormatString="{0:MMM d, yyyy hh:mm}" />
          <asp:BoundField DataField="membLastVisit" HeaderText="<%$  Resources:portal, lastVisit%>" DataFormatString="{0:MMM d, yyyy hh:mm}" />
          <asp:BoundField DataField="membNoVisits" HeaderText="<%$  Resources:portal, noVisits%>" />
        </Fields>
      </asp:DetailsView>
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
      SelectCommand="
        SELECT 
          Memb_FirstName            AS membFirstName, 
          Memb_LastName             AS membLastName,
          UPPER(Memb_Id)            AS membId,
          UPPER(Memb_Pwd)           AS membPwd,
          LOWER(Memb_Email)         AS membEmail, 
          Memb_Level                AS membLevel, 
          Memb_FirstVisit           AS membFirstVisit, 
          Memb_LastVisit            AS membLastVisit, 
          Memb_NoVisits             AS membNoVisits,
          Memb_Internal             AS membInternal
        FROM 
          V5_Vubz.dbo.Memb
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
