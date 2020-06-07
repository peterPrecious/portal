<%@ Page
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="iFrame.aspx.cs"
  Inherits="portal.v7.iFrame" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/iFrame.min.css" rel="stylesheet" />
  <script src="/portal/scripts/$urls.min.js"></script>
  <script>

    // this picks up the title to put on the browser 
    //var title = $.getUrlVar("title");
    //if (title.length > 0) document.title = decodeURI(title);

    /* resize on load */
    $(function () {
      goldAppsResize();
    });

    /* resize on resize */
    $(window).on("resize", function () {
      var resizeTimer;
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(goldAppsResize, 500);
    });

    function goldAppsResize() {
      $(".goldApps").height($(window).height() - 100);
    }

  </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" runat="server" OnClick="exit_Click" />

  <iframe class="goldApps" id="goldApps" runat="server"></iframe>

</asp:Content>
