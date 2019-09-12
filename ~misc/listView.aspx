<%@ Page 
  Language="C#" 
  AutoEventWireup="true" 
  CodeBehind="listView.aspx.cs" 
  Inherits="portal.listView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title></title>
  <link href="styles/css/tiles.css" rel="stylesheet" />
  <script>
    function __doPostBack(tileTargetType, tileTarget) {
      theForm.tileTarget.value = tileTarget;
      theForm.tileTargetType.value = tileTargetType;
      theForm.submit();
    }
  </script>
</head>
<body>
  <form id="theForm" runat="server">

    <input type="hidden" id="tileTargetType" name="tileTargetType" />
    <input type="hidden" id="tileTarget" name="tileTarget" />

    <div>
      <asp:ListView runat="server"
        ID="lvTiles"
        OnItemDataBound="lvTiles_ItemDataBound"
        DataKeyNames="tileNo"
        DataSourceID="SqlDataSource1">
        <ItemTemplate>
          <li
            class="tile"
            onclick="__doPostBack('<%#Eval("tileTargetType")%>', '<%#Eval("tileTarget")%>')"
            style="background-color: <%#Eval("tileColor")%>">
            <div class="tileIcon">
              <img src="../styles/tiles/<%#Eval("tileIcon")%>" />
            </div>
            <asp:Label CssClass="tileTitle" ID="tileTitle" runat="server" Text=""><%#Eval("tileName")%></asp:Label></li>
        </ItemTemplate>
        <LayoutTemplate>
          <ul id="itemPlaceholderContainer" runat="server" class="tileSet">
            <li runat="server" id="itemPlaceholder" />
          </ul>
        </LayoutTemplate>
      </asp:ListView>



      <asp:SqlDataSource
        ID="SqlDataSource1"
        runat="server"
        ConnectionString="<%$ ConnectionStrings:apps %>"
        SelectCommand="
            SELECT * FROM [tiles] WHERE tileMembLevel = 3 ORDER BY tileOrder
            "></asp:SqlDataSource>
    </div>
  </form>
</body>
</html>
