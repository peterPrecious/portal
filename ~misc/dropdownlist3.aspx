﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dropdownlist2.aspx.cs" Inherits="portal.dropdownlist2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title></title>
</head>
<body>
  <form id="form1" runat="server">
    <div>

      <asp:DetailsView
        ID="DetailsView1"
        AutoGenerateRows="false"
        DataKeyNames="AccountCode"
        DataSourceID="MyDataSource"
        AutoGenerateInsertButton="true"
        AutoGenerateEditButton="true"
        AutoGenerateDeleteButton="true"
        AllowPaging="true"
        runat="server">
        <Fields>
          <asp:BoundField DataField="AccountCode" HeaderText="junk1" />

          <asp:TemplateField HeaderText="AcountDD">
            <ItemTemplate>
              <%#Eval("AccountLevel")%>
            </ItemTemplate>

            <InsertItemTemplate>
              <asp:DropDownList ID="GroupList"
                SelectedValue='<%# Bind("AccountDD") %>'
                runat="server">
                <asp:ListItem Value="1"> Guest </asp:ListItem>
                <asp:ListItem Value="2"> Learner </asp:ListItem>
                <asp:ListItem Value="3"> Facilitator </asp:ListItem>
                <asp:ListItem Value="4"> Manager </asp:ListItem>
                <asp:ListItem Value="5"> Administrator </asp:ListItem>
              </asp:DropDownList>
            </InsertItemTemplate>

            <EditItemTemplate>
              <asp:DropDownList ID="GroupList"
                SelectedValue='<%# Bind("AccountDD") %>'
                runat="server">
                <asp:ListItem Value="1"> Guest </asp:ListItem>
                <asp:ListItem Value="2"> Learner </asp:ListItem>
                <asp:ListItem Value="3"> Facilitator </asp:ListItem>
                <asp:ListItem Value="4"> Manager </asp:ListItem>
                <asp:ListItem Value="5"> Administrator </asp:ListItem>
              </asp:DropDownList>
            </EditItemTemplate>

          </asp:TemplateField>

          <asp:BoundField DataField="AccountCat" HeaderText="junk2" />
        </Fields>
      </asp:DetailsView>

<%--            dbo.membLevelDropDown(AccountDD) AS AccountLevel--%>

      <asp:SqlDataSource
        ID="MyDataSource"
        ConnectionString="<%$ ConnectionStrings:apps %>"
        runat="server"
        SelectCommand="
          SELECT 
            AccountCode,
            AccountDD,
            AccountCat,
            CASE AccountDD
              WHEN '1' THEN 'Guest'
              WHEN '2' THEN 'Learner'
              WHEN '3' THEN 'Facilitator'
              WHEN '4' THEN 'Manager'
              WHEN '5' THEN 'Administrator'
            END AS AccountLevel
          FROM 
            AccountsTable"
        UpdateCommand="
          UPDATE 
            AccountsTable 
          SET 
            AccountDD=@AccountDD, 
            AccountCat=@AccountCat
          WHERE 
            AccountCode=@AccountCode"
        InsertCommand="
          INSERT 
            AccountsTable  
            (
              AccountCode, 
              AccountDD,              
              AccountCat
            ) 
          VALUES
          (
            @AccountCode,
            @AccountDD,
            @AccountCat
          )" />





    </div>
  </form>
</body>
</html>
