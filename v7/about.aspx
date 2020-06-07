<%@ Page
  Title="About"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="about.aspx.cs"
  Inherits="portal.v7.about" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/about.min.css" rel="stylesheet" />
  <script>
    $(function () {

      $("#Introduction").show();

      $(".cat").on("click", function () {
        $(".cat").css("color", "white");
        var cat = $(this)[0].className.substring(4, 99);
        this.style.color = "yellow";
        $(".ans").hide();
        $("#" + cat).show();
      })
    })
  </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" runat="server" OnClick="exit_Click" />

    <h1><asp:Localize runat="server" Text="<%$  Resources:portal, about_0%>" /></h1>
    <h2><asp:Localize runat="server" Text="<%$  Resources:portal, about_01%>" /></h2>

    <table class="faq">
      <tr>
        <td class="left">
          <div class="cat Introduction">
            <asp:Localize runat="server" Text="<%$  Resources:portal, introduction%>" />
          </div>
          <div class="cat Access">
            <asp:Localize runat="server" Text="<%$  Resources:portal, access%>" />
          </div>
          <div class="cat Language">
            <asp:Localize runat="server" Text="<%$  Resources:portal, language%>" />
          </div>
          <div class="cat Levels">
            <asp:Localize runat="server" Text="<%$  Resources:portal, levels%>" />
          </div>
          <div class="cat Reports">
            <asp:Localize runat="server" Text="<%$  Resources:portal, reports%>" />
          </div>
          <div class="cat Setup">
            <asp:Localize runat="server" Text="<%$  Resources:portal, setup%>" />
          </div>
        </td>
        <td class="right">
          <div class="ans" id="Introduction">
            <asp:Localize runat="server" Text="<%$  Resources:portal, about_1%>" />
            <%--          This Administrative service is designed for Facilitators and Managers. Depending on your setup, this is where you can manage your learners and the content they will review. This provides a series of reports to monitor learner activities.--%>
          </div>
          <div class="ans" id="Access">
            <asp:Localize runat="server" Text="<%$  Resources:portal, about_2%>" />
            <%--          You need to be a Facilitator or Manager to access this service. Use the Customer Id (Account) plus your Unique Id (Password), select your language then Sign In. When you are done, please remember to Sign Out when you are done to secure your data plus conserve resources.--%>
          </div>
          <div class="ans" id="Language">
            <asp:Localize runat="server" Text="<%$  Resources:portal, about_3%>" />
            <%--          Services are provided for Facilitators in both English and French. If you use a Microsoft Browser (IE or Edge) and have your Language Preference set to French, the service will pick that up. Otherwise it will default to Enlish unless you specify otherwise.  Manager services are only provided in Englsh.--%>
          </div>
          <div class="ans" id="Levels">
            <asp:Localize runat="server" Text="<%$  Resources:portal, about_4%>" />
            <%--          Facilitators do the heavy lifting for each account. They typically manage the learners and their performance. While Facilitators may have access to the content, they are not considered learners. Each Account is also setup with a Manager who can assign Facilitator status plus do a few other site routines.--%>
          </div>
          <div class="ans" id="Reports">
            <asp:Localize runat="server" Text="<%$  Resources:portal, about_5%>" />
            <%--          Reports come in a variety of flavours. Little online "reports" like this one that you are reading, is an "info" report and will have a blue background. Key online reports where you manage information will have a white background.  CSS and Excel reports will be generated.--%>
          </div>
          <div class="ans" id="Setup">
            <asp:Localize runat="server" Text="<%$  Resources:portal, about_6%>" />
            <%--          Account features and reports appear on the menu items at the top left. Operational features for your benefit appear on the top right. Note that this service will NOT run on small screens like a phone since large online forms etc. are a key part of the deliverables. --%>
          </div>
        </td>
      </tr>
      <tr>
        <th colspan="2" style="padding: 12px;"></th>
      </tr>
    </table>
  </div>

</asp:Content>
