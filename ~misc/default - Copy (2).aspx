<%@ Page
  Title="Administration Centre"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  ValidateRequest="false"
  CodeBehind="default.aspx.cs"
  Inherits="portal.Default"
  UICulture="auto"
  Culture="auto" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/tiles.min.css" rel="stylesheet" />
  <link href="/portal/styles/css/default.min.css" rel="stylesheet" />
  <script>
    // this captures the tile click, reloads the page then we act accordingly using Page_Load
    function __doPostBack(tileTargetType, tileTarget) {
      frmMaster.tileTarget.value = tileTarget;
      frmMaster.tileTargetType.value = tileTargetType;
      frmMaster.submit();
    }

    $(function () {
      // set fields to password
      $(".txtMembId, .txtMembPwd").attr("type", "password");
      // essentially toggle by mouseUp and mouseDown
      $(".eyeMembId, .eyeMembPwd")
        .mouseup(function () {
          $(this).prev().attr("type", "password");
        }).mousedown(function () {
          $(this).prev().attr("type", "text");
        });
    });
  </script>

</asp:Content>

<asp:Content ID="defaultContent" ContentPlaceHolderID="MainContent" runat="server">

  <input type="hidden" id="tileTargetType" name="tileTargetType" />
  <input type="hidden" id="tileTarget" name="tileTarget" />

  <asp:Table ID="tabSignIn" CssClass="tabSignIn" runat="server" Visible="false">

    <asp:TableRow>
      <asp:TableCell ColumnSpan="3" HorizontalAlign="Center">
        <h1 style="font-size: 1.2em; color: white;">
          <asp:Literal ID="Literal1" runat="server" Text="<%$  Resources:portal, credentials%>" />
        </h1>
      </asp:TableCell>
    </asp:TableRow>
    <asp:TableRow>
      <asp:TableHeaderCell ColumnSpan="3" HorizontalAlign="Right">
        <asp:RadioButtonList CssClass="tabSignInLang" AutoPostBack="true" ID="radLang" runat="server" RepeatDirection="Horizontal" TextAlign="Right" BorderStyle="None">
          <asp:ListItem Value="en-US" Text="English" Selected="True">English</asp:ListItem>
          <asp:ListItem Value="fr-CA" Text="Français">Français</asp:ListItem>
        </asp:RadioButtonList>
      </asp:TableHeaderCell>
    </asp:TableRow>


    <asp:TableRow ID="rowMembId" CssClass="formRow">
      <asp:TableHeaderCell CssClass="tabSignInLabel" Text="<%$  Resources:portal, membId%>">Username :</asp:TableHeaderCell>
      <asp:TableCell HorizontalAlign="Left">
        <asp:TextBox ID="txtMembId" CssClass="txtMembId" Width="250px" TextMode="SingleLine" Text="" runat="server"></asp:TextBox>
        <asp:Image ID="eyeMembId" CssClass="eyeMembId" ImageUrl="~/styles/icons/eye.png" runat="server" ToolTip="Hide/Show UserName" />
      </asp:TableCell>
      <asp:TableCell>
        <asp:Button CssClass="button100" OnClick="btnMembId_Click" ID="btnMembId" runat="server" Text="<%$  Resources:portal, next%>" />
      </asp:TableCell>
    </asp:TableRow>

    <asp:TableRow ID="rowMembPwd" Visible="false">
      <asp:TableHeaderCell CssClass="tabSignInLabel" Text="<%$  Resources:portal, membPwd%>">Password :</asp:TableHeaderCell>
      <asp:TableCell HorizontalAlign="Left">
        <asp:TextBox ID="txtMembPwd" CssClass="txtMembPwd" Width="250px" TextMode="SingleLine" Text="" runat="server"></asp:TextBox>
        <asp:Image ID="eyeMembPwd" CssClass="eyeMembPwd" ImageUrl="~/styles/icons/eye.png" runat="server" ToolTip="Hide/Show Password" />
      </asp:TableCell>
      <asp:TableCell>
        <asp:Button CssClass="button100" OnClick="btnMembPwd_Click" ID="btnMembPwd" runat="server" Text="Next" />
      </asp:TableCell>
    </asp:TableRow>

    <asp:TableRow ID="rowCustId" Visible="false">
      <asp:TableHeaderCell CssClass="tabSignInLabel" Text="<%$  Resources:portal, custId%>">Customer Id :</asp:TableHeaderCell>
      <asp:TableCell HorizontalAlign="Left">
        <asp:TextBox ID="txtCustId" MaxLength="8" Width="250px" CssClass="input upper" Text="" runat="server"></asp:TextBox>
      </asp:TableCell>
      <asp:TableCell>
        <asp:Button CssClass="button100" OnClick="btnCustId_Click" ID="btnCustId" runat="server" Text="<%$  Resources:portal, next%>" />
      </asp:TableCell>
    </asp:TableRow>

    <asp:TableRow>
      <asp:TableCell ColumnSpan="3"><hr /></asp:TableCell>
    </asp:TableRow>
    <asp:TableRow>
      <asp:TableCell ColumnSpan="3">
        <asp:Button CssClass="button150" ID="butRestart" OnClick="butRestart_Click" runat="server" Text="<%$  Resources:portal, restart%>" />
        <asp:Button CssClass="button150" ID="butBrowser" OnClientClick="window.open('/vubizApps/Default.aspx?lang=en&email=support@vubiz.com&appId=browser.3')" runat="server" Text="<%$  Resources:portal, browserTest%>" />
      </asp:TableCell>
    </asp:TableRow>
    <asp:TableRow>
      <asp:TableCell ColumnSpan="3">
        <asp:Button CssClass="button" ID="btnForgot" OnClick="btnForgot_Click" runat="server" Text="<%$  Resources:portal, forgotCredentials%>" />
      </asp:TableCell>
    </asp:TableRow>
    <asp:TableRow ID="forgotEmail" Visible="false">
      <asp:TableCell ColumnSpan="3">
        <hr />

        <h1 style="font-size: 1.2em; color: white; margin-top: 30px;">
          <asp:Literal ID="Literal2" runat="server" Text="<%$  Resources:portal, forgotCredentials%>" />
        </h1>

        <h2>
          <asp:Literal ID="Literal3" runat="server" Text="<%$  Resources:portal, forgot_1%>" />
        </h2>

        <div style="margin: 30px 0 20px;">
          <asp:TextBox runat="server"
            ID="txtEmail"
            TextMode="Email"
            Height="28px"
            Width="350px">
          </asp:TextBox>&nbsp;

            <asp:Button runat="server"
              CssClass="button"
              ID="btnEmail"
              OnClick="btnEmail_Click"
              Text="<%$  Resources:portal, retrieve%>" />

        </div>
        <asp:Label ID="labEmail" CssClass="labEmail" runat="server"></asp:Label>
      </asp:TableCell>
    </asp:TableRow>
  </asp:Table>
  <div>
    <asp:Label ID="labWelcome" CssClass="labWelcome" runat="server" Text=""></asp:Label><br />
    <asp:Label ID="labManage" CssClass="labManage" runat="server" Text=""></asp:Label><br />
    <asp:Label ID="labContent" CssClass="labContent" runat="server" Text=""></asp:Label>
  </div>
  <div class="divPage" style="margin-top: 00px; background-color: inherit;">

    <asp:ListView runat="server"
      ID="lvTiles"
      Visible="false"
      DataKeyNames="tileNo"
      OnItemDataBound="lvTiles_ItemDataBound"
      DataSourceID="SqlDataSource1">
      <ItemTemplate>
        <li class="tile" onclick="__doPostBack('<%#Eval("tileTargetType")%>', '<%#Eval("tileTarget")%>')" style="background-color: <%#Eval("tileColor")%>">
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

    <asp:Image CssClass="logo" ID="logo" runat="server" />
  </div>

  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="SELECT * FROM apps.dbo.tiles WHERE (tileMembLevel <= @membLevel) AND (@membLevel <> 0) AND (tileGroup = @group) AND (tileActive = 1) ORDER BY tileOrder">
    <SelectParameters>
      <asp:SessionParameter DefaultValue="5" Name="membLevel" SessionField="membLevel" />
      <asp:SessionParameter DefaultValue="home" Name="group" SessionField="tileGroup" />
    </SelectParameters>
  </asp:SqlDataSource>

</asp:Content>
