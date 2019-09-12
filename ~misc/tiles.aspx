<%@ Page
  Title="Home"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="tiles.aspx.cs"
  Inherits="portal.v7.tiles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="../styles/css/tiles.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <asp:ListView runat="server"
    ID="lvTiles"
    DataKeyNames="tileNo"
    OnItemDataBound="lvTiles_ItemDataBound"
    DataSourceID="SqlDataSource1">
    <ItemTemplate>
      <li class="tile" onclick="__doPostBack('<%#Eval("tileTargetType")%>', '<%#Eval("tileTarget")%>')" style="background-color: <%#Eval("tileColor")%>">
        <div class="tileIcon">
          <img src="../styles/tiles/<%#Eval("tileIcon")%>" />
        </div>
        <asp:Label CssClass="tileTitle" ID="tileTitle" runat="server" Text=""><%#Eval("tileName")%></asp:Label>
      </li>
    </ItemTemplate>
    <LayoutTemplate>
      <ul id="itemPlaceholderContainer" runat="server" class="tileSet">
        <li runat="server" id="itemPlaceholder" />
      </ul>
    </LayoutTemplate>
  </asp:ListView>

  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="SELECT * FROM apps.dbo.tiles WHERE (tileMembLevel <= @membLevel) AND (@membLevel <> 0) AND (tileGroup = @group)  ORDER BY tileOrder">
    <SelectParameters>
      <asp:SessionParameter DefaultValue="5" Name="membLevel" SessionField="membLevel" />
      <asp:SessionParameter DefaultValue="home" Name="group" SessionField="tileGroup" />
    </SelectParameters>
  </asp:SqlDataSource>

</asp:Content>
