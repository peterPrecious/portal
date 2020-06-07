<%@ Page
  Title="Profiles"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="profiles.aspx.cs"
  Inherits="portal.v7.administrator.profiles" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/profiles.min.css" rel="stylesheet" />
  <script>
    $(function () { // generates a yellow description in labError of panBottom
      $(".names").on("click", function () { $(".labError").html("Profile Name(s): Each Profile must have one or more names separated by spaces. Every name must be unique amongst all Profiles. IE: 'abcd abcd_en jones'.") })
      $(".autoEnroll").on("click", function () { $(".labError").html("Auto Enroll (Post): Can auto enroll learners via a Form Post") })
      $(".autoEnrollWs").on("click", function () { $(".labError").html("Auto Enroll (WS): Can auto enroll learners via a Web Service") })
      $(".autoSignIn").on("click", function () { $(".labError").html("Auto SignIn: Can sign in (but not enroll) via a Form or Web Post") })
      $(".certPrograms").on("click", function () { $(".labError").html("Certificate Programs (Learners): Expose the Certificate Programs tile which will auto enroll with this CustId into V5") })
      $(".certPrograms_E").on("click", function () { $(".labError").html("Certificate Programs (Employees): Expose the Certificate Programs tile for 'Employees' which will auto enroll with this CustId into V5") })
      $(".contentSource").on("click", function () { $(".labError").html("Content Source: Select the source of the content from: catalogue (default) / ecommerce / assigned / ecom-assigned.") })
      $(".courseTileName").on("click", function () { $(".labError").html("Course Tile Name: This will override the default content tile name which is 'My Learning Themes'. Currently EN only.") })
      $(".custId").on("click", function () { $(".labError").html("Customer Id: The Customer Id is the key for this Profile. This field is mandatory and must be unique amongst all Profiles.") })
      $(".ecommerce").on("click", function () { $(".labError").html("Ecommerce: Show/Hide the Ecommerce subsystem tile.") })
      $(".emailFrom").on("click", function () { $(".labError").html("Email From: Enter email address if other than 'support@vubiz.com'.") })
      $(".guests").on("click", function () { $(".labError").html("Guests (Learners): Show/Hide the Guest subsystem tile.") })
      $(".guests_E").on("click", function () { $(".labError").html("Guests (Employees): If member type = 'E' (ie CFIB employees) then show/hide the Guest subsystem tile.") })
      $(".jit").on("click", function () { $(".labError").html("JIT (Just In Time): Show/Hide the JIT subsystem tile.") })
      $(".lang_en").on("click", function () { $(".labError").html("Available in EN: shows the the app is available in 'EN'") })
      $(".lang_es").on("click", function () { $(".labError").html("Available in ES: shows the the app is available in 'ES'") })
      $(".lang_fr").on("click", function () { $(".labError").html("Available in FR: shows the the app is available in 'FR'") })
      $(".logo").on("click", function () { $(".labError").html("Provide the Logo name, like 'cfib_en.png'") })
      $(".memb_E").on("click", function () { $(".labError").html("Yes is this account support 'employees'. Note: only CFIB uses this feature.") })
      $(".nameCatalogue").on("click", function () { $(".labError").html("Catalogue Name (App): This allows you to create your own name for the Catalogue, within the App (ie My Library).") })
      $(".namePrograms").on("click", function () { $(".labError").html("Programs Name (App): This allows you to create your own name for the Programs, within the App (ie My Courses).") })
      $(".nameReports").on("click", function () { $(".labError").html("Reports Name (App): This allows you to create your own name for the Reports, within the App (ie Reports).") })
      $(".nameCourse").on("click", function () { $(".labError").html("Course Name (Tile): This allows you to create your own name for the Program at the TILE level (ie My Content).") })
      $(".password").on("click", function () { $(".labError").html("Password: Yes is this account uses passwords. Default is False") })
      $(".portal").on("click", function () { $(".labError").html("Portal: This means you want to use the Portal Administration features for reports, etc.  If not checked then it will try to find reports in V8 (like CFIB). Typically you want to turn this ON.") })
      $(".profLang").on("click", function () { $(".labError").html("Default Language: Can be either 'EN', 'FR' or 'ES'.") })
      $(".profNo").on("click", function () { $(".labError").html("Internal No: This is the unique, system generated number. It is only used by Support.") })
      $(".returnUrl").on("click", function () { $(".labError").html("Return Url: Where to go when you sign out. Can leave empty or enter a full url: http://cfib.ca/") })
      $(".showSoloPrograms").on("click", function () { $(".labError").html("Show Solo Programs: If True than show single Programs rather than the default jumping to Module(s)") })
      $(".sso").on("click", function () { $(".labError").html("SSO: can single signon using one of 4 values: 'membNo', 'membId', 'membGuid' or 'custMembGuid' (NOP) ") })
      $(".storeId").on("click", function () { $(".labError").html("Store Id: When profile is from NOP, this shows from which store it was registered. Store Ids are positive integers; zero means this is not used or not from NOP.") })
      $(".videos").on("click", function () { $(".labError").html("Videos: Show/Hide the Video Icon; used in CFIB (default False/Hide).") })
      $(".vukidz").on("click", function () { $(".labError").html("Vukidz: Show/Hide the Vukidz Menu Item (default False/Hide).") })

      // clears the labError
      $(".labError").on("click", function () { $(".labError").html('') })

      $(".btnClone").on("mouseover", function (event) {
        var id = $(this)[0].id;
        var lineNo = id.substring(id.lastIndexOf("_") + 1);
        var nameOld = "#MainContent_gvProfiles_profNameOld_" + lineNo;
        var nameNew = "#MainContent_gvProfiles_profNameNew_" + lineNo;
        var valueOld = $(nameOld).text();
        var valueNew = $(nameNew).val();
        $(".btnClone").prop("title", "Clone '" + valueOld + "' to '" + valueNew + "'.");
      })

    })
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <asp:Panel ID="panConfirmShell" CssClass="panConfirmShell" runat="server" Visible="true">
      <asp:Panel ID="panConfirm" CssClass="panConfirm" runat="server">
        <table style="width: 380px; margin: 0px; margin: auto; border: none;">
          <tr>
            <td>
              <h1>
                <asp:Label ID="labConfirmTitle" CssClass="labConfirmTitle" runat="server"></asp:Label>
              </h1>
            </td>
          </tr>
          <tr>
            <td style="height: 125px; vertical-align: text-top">
              <h2>
                <asp:Label ID="labConfirmMessage" CssClass="labConfirmMessage" runat="server"></asp:Label></h2>
            </td>
          </tr>
          <tr>
            <td>
              <asp:LinkButton CssClass="newButton btnConfirmCancel" ID="btnConfirmCancel" OnClientClick='$(".panConfirm").hide(); return false;' runat="server"></asp:LinkButton>
              &nbsp;&nbsp;
              <asp:LinkButton CssClass="newButton btnConfirmOk" ID="btnConfirmOk" OnClick="btnConfirmOk_Click" runat="server"></asp:LinkButton>
            </td>
          </tr>
        </table>
      </asp:Panel>
    </asp:Panel>

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

      <asp:Panel ID="panTop" CssClass="panTop" runat="server" DefaultButton="butSearch">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline" title="<%$  Resources:portal, title%>">Profiles</span>
          <asp:ImageButton OnClick="dvProfileInit_Click" CssClass="icons add" ImageUrl="~/styles/icons/vubiz/add.png" ToolTip="Add a Profile" runat="server" />
        </h1>

        <div class="thisTitle">
          Profiles are extensions of the Customer Table. They provide specific features for V8/NOP Accounts. 
          They are not used for V5 Accounts. They are listed in Last Date order but the order can be changed by clicking on one of the left four column names.
          For ease of use, the profile can be access by its unique Name or an optional unique Alias.
          An example of a Name/Alias is "CFIB_FR"/"FCEI".
          <br />
          Cloning a Profile creates a new Profile with the same values as the one you are cloning.
          The only exception is the Profile Clone Name which must be unique and entered before your select Clone.
          Once cloned the new Profile will appear at the top of the list where you can edit it like any other Profile.<br />
          <br />

          <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>

          <div style="margin-top: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="<%$  Resources:portal, searchValue%>" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="<%$  Resources:portal, search%>" />
          </div>

        </div>

        <asp:GridView runat="server"
          ID="gvProfiles"
          CssClass="gvProfiles"
          HorizontalAlign="Center"
          AutoGenerateColumns="False"
          AllowSorting="True"
          AllowPaging="True"
          PageSize="20"
          DataKeyNames="profNo, profName"
          OnSelectedIndexChanged="gvProfiles_SelectedIndexChanged"
          HeaderStyle-HorizontalAlign="Left"
          RowStyle-HorizontalAlign="Left"
          DataSourceID="SqlDataSource1">
          <Columns>
            <asp:BoundField DataField="profNo" ReadOnly="True" Visible="false" />
            <asp:TemplateField HeaderText="Profile Name" SortExpression="profName">
              <EditItemTemplate>
                <asp:TextBox ID="profNameOld" CssClass="profNameOld" runat="server" Text='<%# Bind("profName") %>'></asp:TextBox>
              </EditItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profNameOld" CssClass="profNameOld" runat="server" Text='<%# Bind("profName") %>'></asp:Label>
              </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="profCustId" HeaderText="Customer Id" SortExpression="profCustId" />
            <asp:BoundField DataField="profLogo" HeaderText="Logo" SortExpression="profLogo" />
            <asp:BoundField DataField="profLastDate" HeaderText="Last Date" ReadOnly="True" SortExpression="profLastDate" DataFormatString="{0:MMM d yyyy}" />
            <asp:TemplateField HeaderText="Details" ItemStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:ImageButton
                  CssClass="icons info"
                  ID="btnSelect"
                  runat="server"
                  CausesValidation="True"
                  CommandName="Select"
                  ImageUrl="~/styles/icons/vubiz/info.png" />
              </ItemTemplate>
              <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Profile Clone Name" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:TextBox
                  ID="profNameNew"
                  CssClass="profNameNew"
                  MaxLength="24"
                  Text=""
                  runat="server" />
              </ItemTemplate>
              <HeaderStyle HorizontalAlign="Center" />
              <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Clone" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:ImageButton runat="server"
                  ImageUrl="~/styles/icons/vubiz/clone.png"
                  ToolTip="Clone Profile"
                  ID="btnClone"
                  CssClass="icons info btnClone"
                  CausesValidation="True"
                  OnCommand="btnConfirm_Command"
                  CommandArgument='<%# "Clone|" +  Eval("profNo") + "|" + Eval("profName") %>' />
              </ItemTemplate>
              <HeaderStyle HorizontalAlign="Center" />
              <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
          </Columns>
          <HeaderStyle HorizontalAlign="Left" />
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
            Oops. There are no Profiles on file with the Profile Id or Title fragment entered.<br />
          </EmptyDataTemplate>
          <RowStyle HorizontalAlign="Left" />
        </asp:GridView>

      </asp:Panel>

      <asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">

        <h1>
          <asp:Literal runat="server" Text="Add/Edit Profile" />
          <asp:ImageButton
            OnClick="listProfiles_Click"
            CssClass="icons"
            ImageUrl="~/styles/icons/vubiz/back.png"
            ToolTip="Return to Profile Summary"
            runat="server" />
          <br />
        </h1>

        <h2 style="line-height: 1.6em;">Clicking on any field name (at left) will cause a field description to appear below this message.
          <asp:Panel ID="panHideShow" runat="server">
          Click here to
          <asp:LinkButton
            ID="lnkHide"
            CssClass="lnkShowHide"
            OnClick="lnkHide_Click"
            runat="server">hide</asp:LinkButton>
          <asp:LinkButton
            ID="lnkShow"
            CssClass="lnkShowHide"
            OnClick="lnkShow_Click"
            runat="server">show</asp:LinkButton>
          unused fields.
        </asp:Panel>
        </h2>

        <asp:Label ForeColor="Yellow" Font-Bold="true" CssClass="labError" ID="labError" runat="server">&nbsp;</asp:Label>

        <asp:DetailsView
          BorderStyle="None"
          ID="dvProfile"
          runat="server"
          CssClass="dvProfile"
          DataSourceID="SqlDataSource2"
          DataKeyNames="ProfNo"
          OnItemCommand="dvProfile_ItemCommand"
          OnPreRender="dvProfile_PreRender"
          AutoGenerateRows="False">
          <Fields>

            <asp:TemplateField HeaderText="Name">
              <EditItemTemplate>
                <asp:TextBox ID="profName" runat="server" Text='<%# Bind("profName") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profName" runat="server" Text='<%# Bind("profName") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profName" runat="server" Text='<%# Bind("profName") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip name" />
              <ItemStyle CssClass="profName" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Alias">
              <EditItemTemplate>
                <asp:TextBox ID="profAlias" runat="server" Text='<%# Bind("profAlias") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profAlias" runat="server" Text='<%# Bind("profAlias") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profAlias" runat="server" Text='<%# Bind("profAlias") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip alias" />
              <ItemStyle CssClass="profAlias" />
            </asp:TemplateField>


            <asp:TemplateField HeaderText="Auto Enroll (Post)">
              <EditItemTemplate>
                <asp:CheckBox ID="profAutoEnroll" runat="server" Checked='<%# Bind("profAutoEnroll") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profAutoEnroll" runat="server" Checked='<%# Bind("profAutoEnroll") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profAutoEnroll" runat="server" Checked='<%# Bind("profAutoEnroll") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip autoEnroll" />
              <ItemStyle CssClass="profAutoEnroll" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Auto Enroll (WS)">
              <EditItemTemplate>
                <asp:CheckBox ID="profAutoEnrollWs" runat="server" Checked='<%# Bind("profAutoEnrollWs") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profAutoEnrollWs" runat="server" Checked='<%# Bind("profAutoEnrollWs") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profAutoEnrollWs" runat="server" Checked='<%# Bind("profAutoEnrollWs") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip autoEnrollWs" />
              <ItemStyle CssClass="profAutoEnrollWs" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Auto SignIn">
              <EditItemTemplate>
                <asp:CheckBox ID="profAutoSignIn" runat="server" Checked='<%# Bind("profAutoSignIn") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profAutoSignIn" runat="server" Checked='<%# Bind("profAutoSignIn") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profAutoSignIn" runat="server" Checked='<%# Bind("profAutoSignIn") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip autoSignIn" />
              <ItemStyle CssClass="profAutoSignIn" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Certificate Programs (Learners)">
              <EditItemTemplate>
                <asp:TextBox ID="profCertPrograms" runat="server" Text='<%# Bind("profCertPrograms") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profCertPrograms" runat="server" Text='<%# Bind("profCertPrograms") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profCertPrograms" runat="server" Text='<%# Bind("profCertPrograms") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip certPrograms" />
              <ItemStyle CssClass="profCertPrograms" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Certificate Programs (Employees)">
              <EditItemTemplate>
                <asp:TextBox ID="profCertPrograms_E" runat="server" Text='<%# Bind("profCertPrograms_E") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profCertPrograms_E" runat="server" Text='<%# Bind("profCertPrograms_E") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profCertPrograms_E" runat="server" Text='<%# Bind("profCertPrograms_E") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip certPrograms_E" />
              <ItemStyle CssClass="profCertPrograms_E" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Content Source">
              <EditItemTemplate>
                <asp:DropDownList CssClass="profDropDown" AutoPostBack="true" ID="profContentSource" runat="server" SelectedValue='<%# Bind("profContentSource") %>'>
                  <asp:ListItem Text="Catalogue" Value="catalogue" Selected="True" />
                  <asp:ListItem Text="Ecommerce" Value="ecommerce" />
                  <asp:ListItem Text="Assigned" Value="assigned" />
                  <asp:ListItem Text="Ecom Assigned" Value="ecom-assigned" />
                </asp:DropDownList>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:DropDownList CssClass="profDropDown" AutoPostBack="true" ID="profContentSource" runat="server" SelectedValue='<%# Bind("profContentSource") %>'>
                  <asp:ListItem Text="Catalogue" Value="catalogue" Selected="True" />
                  <asp:ListItem Text="Ecommerce" Value="ecommerce" />
                  <asp:ListItem Text="Assigned" Value="assigned" />
                  <asp:ListItem Text="Ecom Assigned" Value="ecom-assigned" />
                </asp:DropDownList>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profContentSource" runat="server" Text='<%# Bind("profContentSource") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip contentSource" />
              <ItemStyle CssClass="profContentSource" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Catalogue Name (App)">
              <EditItemTemplate>
                <asp:TextBox ID="profNameCatalogue" runat="server" Text='<%# Bind("profNameCatalogue") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profNameCatalogue" runat="server" Text='<%# Bind("profNameCatalogue") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profNameCatalogue" runat="server" Text='<%# Bind("profNameCatalogue") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip nameCatalogue" />
              <ItemStyle CssClass="profNameCatalogue" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Programs Name (App)">
              <EditItemTemplate>
                <asp:TextBox ID="profNamePrograms" runat="server" Text='<%# Bind("profNamePrograms") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profNamePrograms" runat="server" Text='<%# Bind("profNamePrograms") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profNamePrograms" runat="server" Text='<%# Bind("profNamePrograms") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip namePrograms" />
              <ItemStyle CssClass="profNamePrograms" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Reports Name (App)">
              <EditItemTemplate>
                <asp:TextBox ID="profNameReports" runat="server" Text='<%# Bind("profNameReports") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profNameReports" runat="server" Text='<%# Bind("profNameReports") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profNameReports" runat="server" Text='<%# Bind("profNameReports") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip nameReports" />
              <ItemStyle CssClass="profNameReports" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Course Name (Tile)">
              <EditItemTemplate>
                <asp:TextBox ID="profCourseTile_en" runat="server" Text='<%# Bind("profCourseTile_en") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profCourseTile_en" runat="server" Text='<%# Bind("profCourseTile_en") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profCourseTile_en" runat="server" Text='<%# Bind("profCourseTile_en") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip nameCourse" />
              <ItemStyle CssClass="profCourseTile_en" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Customer Id">
              <EditItemTemplate>
                <asp:TextBox ID="profCustId" runat="server" Text='<%# Bind("profCustId") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profCustId" runat="server" Text='<%# Bind("profCustId") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profCustId" runat="server" Text='<%# Bind("profCustId") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip custId" />
              <ItemStyle CssClass="profCustId" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Ecommerce">
              <EditItemTemplate>
                <asp:CheckBox ID="profEcommerce" runat="server" Checked='<%# Bind("profEcommerce") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profEcommerce" runat="server" Checked='<%# Bind("profEcommerce") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profEcommerce" runat="server" Checked='<%# Bind("profEcommerce") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip ecommerce" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="EmailFrom">
              <EditItemTemplate>
                <asp:TextBox ID="profEmailFrom" runat="server" Text='<%# Bind("profEmailFrom") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profEmailFrom" runat="server" Text='<%# Bind("profEmailFrom") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profEmailFrom" runat="server" Text='<%# Bind("profEmailFrom") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip emailFrom" />
              <ItemStyle CssClass="profEmailFrom" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Guests (Learners)">
              <EditItemTemplate>
                <asp:CheckBox ID="profGuests" runat="server" Checked='<%# Bind("profGuests") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profGuests" runat="server" Checked='<%# Bind("profGuests") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profGuests" runat="server" Checked='<%# Bind("profGuests") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip guests" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Guests (Employees)">
              <EditItemTemplate>
                <asp:CheckBox ID="profGuests_E" runat="server" Checked='<%# Bind("profGuests_E") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profGuests_E" runat="server" Checked='<%# Bind("profGuests_E") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profGuests_E" runat="server" Checked='<%# Bind("profGuests_E") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip guests_E" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="JIT (Just In Time)">
              <EditItemTemplate>
                <asp:CheckBox ID="profJit" runat="server" Checked='<%# Bind("profJit") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profJit" runat="server" Checked='<%# Bind("profJit") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profJit" runat="server" Checked='<%# Bind("profJit") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip jit" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Default Language">
              <EditItemTemplate>
                <asp:DropDownList CssClass="profDropDown" AutoPostBack="true" ID="profLang" runat="server" SelectedValue='<%# Bind("profLang") %>'>
                  <asp:ListItem Text="EN" Value="EN" Selected="True" />
                  <asp:ListItem Text="ES" Value="ES" />
                  <asp:ListItem Text="FR" Value="FR" />
                </asp:DropDownList>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:DropDownList CssClass="profDropDown" AutoPostBack="true" ID="profLang" runat="server" SelectedValue='<%# Bind("profLang") %>'>
                  <asp:ListItem Text="EN" Value="EN" Selected="True" />
                  <asp:ListItem Text="ES" Value="ES" />
                  <asp:ListItem Text="FR" Value="FR" />
                </asp:DropDownList>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profLang" runat="server" Text='<%# Bind("profLang") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip profLang" />
              <ItemStyle CssClass="profLang" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Available in EN">
              <EditItemTemplate>
                <asp:CheckBox ID="profLang_en" runat="server" Checked='<%# Bind("profLang_en") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profLang_en" runat="server" Checked='<%# Bind("profLang_en") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profLang_en" runat="server" Checked='<%# Bind("profLang_en") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip lang_en" />
              <ItemStyle CssClass="profLang_en" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Available in ES">
              <EditItemTemplate>
                <asp:CheckBox ID="profLang_es" runat="server" Checked='<%# Bind("profLang_es") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profLang_es" runat="server" Checked='<%# Bind("profLang_es") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profLang_es" runat="server" Checked='<%# Bind("profLang_es") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip lang_es" />
              <ItemStyle CssClass="profLang_es" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Available in FR">
              <EditItemTemplate>
                <asp:CheckBox ID="profLang_fr" runat="server" Checked='<%# Bind("profLang_fr") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profLang_fr" runat="server" Checked='<%# Bind("profLang_fr") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profLang_fr" runat="server" Checked='<%# Bind("profLang_fr") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip lang_fr" />
              <ItemStyle CssClass="profLang_fr" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Logo">
              <EditItemTemplate>
                <asp:TextBox ID="profLogo" runat="server" Text='<%# Bind("profLogo") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profLogo" runat="server" Text='<%# Bind("profLogo") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profLogo" runat="server" Text='<%# Bind("profLogo") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip logo" />
              <ItemStyle CssClass="profLogo" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Employees">
              <EditItemTemplate>
                <asp:CheckBox ID="profMemb_E" runat="server" Checked='<%# Bind("profMemb_E") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profMemb_E" runat="server" Checked='<%# Bind("profMemb_E") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profMemb_E" runat="server" Checked='<%# Bind("profMemb_E") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip memb_E" />
              <ItemStyle CssClass="profMemb_E" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Password">
              <EditItemTemplate>
                <asp:CheckBox ID="profPassword" runat="server" Checked='<%# Bind("profPassword") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profPassword" runat="server" Checked='<%# Bind("profPassword") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profPassword" runat="server" Checked='<%# Bind("profPassword") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip password" />
              <ItemStyle CssClass="profPassword" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Use Portal">
              <EditItemTemplate>
                <asp:CheckBox ID="profPortal" runat="server" Checked='<%# Bind("profPortal") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profPortal" runat="server" Checked='<%# Bind("profPortal") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profPortal" runat="server" Checked='<%# Bind("profPortal") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip portal" />
              <ItemStyle CssClass="profPortal" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="ReturnUrl">
              <EditItemTemplate>
                <asp:TextBox ID="profReturnUrl" runat="server" Text='<%# Bind("profReturnUrl") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profReturnUrl" runat="server" Text='<%# Bind("profReturnUrl") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profReturnUrl" runat="server" Text='<%# Bind("profReturnUrl") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip returnUrl" />
              <ItemStyle CssClass="profReturnUrl" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Show Solo Programs">
              <EditItemTemplate>
                <asp:CheckBox ID="profShowSoloPrograms" runat="server" Checked='<%# Bind("profShowSoloPrograms") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profShowSoloPrograms" runat="server" Checked='<%# Bind("profShowSoloPrograms") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profShowSoloPrograms" runat="server" Checked='<%# Bind("profShowSoloPrograms") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip showSoloPrograms" />
              <ItemStyle CssClass="profShowSoloPrograms" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="SSO">
              <EditItemTemplate>
                <asp:TextBox ID="profSso" runat="server" Text='<%# Bind("profSso") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profSso" runat="server" Text='<%# Bind("profSso") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profSso" runat="server" Text='<%# Bind("profSso") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip sso" />
              <ItemStyle CssClass="profSso" />
            </asp:TemplateField>


            <asp:TemplateField HeaderText="Store Id">
              <EditItemTemplate>
                <asp:TextBox ID="profStoreId" CssClass="profStoreId" runat="server" Text='<%# Bind("profStoreId") %>' />
                <asp:RegularExpressionValidator
                  ID="profStoreId_validation" runat="server"
                  ControlToValidate="profStoreId"
                  ForeColor="Yellow"
                  ErrorMessage="<br>Enter a valid numeric Store Id, ie 0-99999."
                  ValidationExpression="^[0-9]*$">
                </asp:RegularExpressionValidator>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profStoreId" CssClass="profStoreId" runat="server" Text='<%# Bind("profStoreId") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profStoreId" CssClass="profStoreId" runat="server" Text='<%# Bind("profStoreId") %>' />
              </ItemTemplate>
              <HeaderStyle CssClass="tip storeId" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Videos">
              <EditItemTemplate>
                <asp:CheckBox ID="profVideos" runat="server" Checked='<%# Bind("profVideos") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profVideos" runat="server" Checked='<%# Bind("profVideos") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profVideos" runat="server" Checked='<%# Bind("profVideos") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip videos" />
              <ItemStyle CssClass="profVideos" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Vukidz">
              <EditItemTemplate>
                <asp:CheckBox ID="profVukidz" runat="server" Checked='<%# Bind("profVukidz") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="profVukidz" runat="server" Checked='<%# Bind("profVukidz") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="profVukidz" runat="server" Checked='<%# Bind("profVukidz") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip vukidz" />
              <ItemStyle CssClass="profVukidz" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="[ Internal No ]" InsertVisible="False">
              <EditItemTemplate>
                <asp:Label ID="profNo" runat="server" Text='<%# Eval("profNo") %>'></asp:Label>
              </EditItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profNo" runat="server" Text='<%# Bind("profNo") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip profNo" />
              <ItemStyle CssClass="profNo" />
            </asp:TemplateField>

            <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icons">

              <EditItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnUpdate" runat="server" CausesValidation="False" CommandName="Update" ToolTip="Update Profile" />
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </EditItemTemplate>

              <InsertItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnInsert" runat="server" CausesValidation="True" CommandName="Insert" ToolTip="Add a Profile" />
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </InsertItemTemplate>

              <ItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/edit.png" ID="btnEdit" runat="server" CausesValidation="True" CommandName="Edit" ToolTip="Edit Profile" />
                <asp:ImageButton runat="server"
                  ImageUrl="~/styles/icons/vubiz/delete.png"
                  ToolTip="Delete Profile"
                  ID="btnDelete"
                  CausesValidation="True"
                  OnCommand="btnConfirm_Command"
                  CommandArgument='<%# "Delete|" +  Eval("profNo") + "|" + Eval("profName") %>' />
              </ItemTemplate>

              <ControlStyle CssClass="icons edit" />

            </asp:TemplateField>

          </Fields>
        </asp:DetailsView>

      </asp:Panel>

    </asp:Panel>

  </div>


  <asp:SqlDataSource
    runat="server"
    ID="SqlDataSource1"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT 
        no              AS profNo,
        custId          AS profCustId,
        logo            AS profLogo,
        lastDate        AS profLastDate,
        name            AS profName
      FROM 
        apps.dbo.profile
      ORDER BY
        lastDate DESC, 
        name
    "></asp:SqlDataSource>

  <asp:SqlDataSource
    ID="SqlDataSource2"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT 
        no                          AS profNo, 
        alias                       AS profAlias,
        autoEnroll                  AS profAutoEnroll, 
        autoEnrollWs                AS profAutoEnrollWs, 
        autoSignIn                  AS profAutoSignIn, 
        certPrograms                AS profCertPrograms, 
        certPrograms_E              AS profCertPrograms_E, 
        contentSource               AS profContentSource, 
        courseTile_en               AS profCourseTile_en, 
        custId                      AS profCustId, 
        ecommerce                   AS profEcommerce, 
        emailFrom                   AS profEmailFrom, 
        guests                      AS profGuests, 
        guests_E                    AS profGuests_E, 
        jit                         AS profJit, 
        lang                        AS profLang, 
        lang_en                     AS profLang_en, 
        lang_es                     AS profLang_es, 
        lang_fr                     AS profLang_fr, 
        lastDate                    AS profLastDate,
        logo                        AS profLogo, 
        memb_E                      AS profMemb_E, 
        name                        AS profName, 
        nameCatalogue               AS profNameCatalogue, 
        namePrograms                AS profNamePrograms, 
        nameReports                 AS profNameReports, 
        password                    AS profPassword, 
        portal                      AS profPortal, 
        returnUrl                   AS profReturnUrl, 
        showSoloPrograms            AS profShowSoloPrograms, 
        sso                         AS profSso, 
        storeId                     AS profStoreId, 
        videos                      AS profVideos, 
        vukidz                      AS profVukidz
      FROM 
        apps.dbo.profile 
      WHERE 
        no = @profNo
    "
    UpdateCommand="
      UPDATE 
        apps.dbo.profile 
      SET 
        alias                       = UPPER(@profAlias),
        autoEnroll                  = @profAutoEnroll, 
        autoEnrollWs                = @profAutoEnrollWs, 
        autoSignIn                  = @profAutoSignIn, 
        certPrograms                = UPPER(@profCertPrograms), 
        certPrograms_E              = UPPER(@profCertPrograms_E), 
        contentSource               = @profContentSource, 
        courseTile_en               = @profCourseTile_en, 
        custId                      = UPPER(@profCustId), 
        ecommerce                   = @profEcommerce, 
        emailFrom                   = @profEmailFrom, 
        guests                      = @profGuests, 
        guests_E                    = @profGuests_E, 
        jit                         = @profJit, 
        lang                        = @profLang, 
        lang_en                     = @profLang_en, 
        lang_es                     = @profLang_es, 
        lang_fr                     = @profLang_fr, 
        lastDate                    = GETDATE(),
        logo                        = @profLogo, 
        memb_E                      = @profMemb_E, 
        name                        = UPPER(@profName), 
        nameCatalogue               = @profNameCatalogue, 
        namePrograms                = @profNamePrograms, 
        nameReports                 = @profNameReports, 
        password                    = @profPassword, 
        portal                      = @profPortal, 
        returnUrl                   = @profReturnUrl, 
        showSoloPrograms            = @profShowSoloPrograms, 
        sso                         = @profSso, 
        storeId                     = @profStoreId, 
        videos                      = @profVideos, 
        vukidz                      = @profVukidz
      WHERE 
        no                          = @profNo
    ">
    <SelectParameters>
      <asp:ControlParameter ControlID="gvProfiles" Name="profNo" PropertyName="SelectedValue" Type="Int32" />
    </SelectParameters>

    <UpdateParameters>
      <asp:Parameter Name="profAlias" />
      <asp:Parameter Name="profAutoEnroll" />
      <asp:Parameter Name="profAutoEnrollWs" />
      <asp:Parameter Name="profAutoSignIn" />
      <asp:Parameter Name="profCertPrograms" />
      <asp:Parameter Name="profCertPrograms_E" />
      <asp:Parameter Name="profContentSource" />
      <asp:Parameter Name="profCourseTile_en" />
      <asp:Parameter Name="profCustId" />
      <asp:Parameter Name="profEcommerce" />
      <asp:Parameter Name="profEmailFrom" />
      <asp:Parameter Name="profGuests" />
      <asp:Parameter Name="profGuests_E" />
      <asp:Parameter Name="profJit" />
      <asp:Parameter Name="profLang" />
      <asp:Parameter Name="profLang_en" />
      <asp:Parameter Name="profLang_es" />
      <asp:Parameter Name="profLang_fr" />
      <asp:Parameter Name="profLogo" />
      <asp:Parameter Name="profMemb_E" />
      <asp:Parameter Name="profName" />
      <asp:Parameter Name="profNameCatalogue" />
      <asp:Parameter Name="profNamePrograms" />
      <asp:Parameter Name="profNameReports" />
      <asp:Parameter Name="profPassword" />
      <asp:Parameter Name="profPortal" />
      <asp:Parameter Name="profReturnUrl" />
      <asp:Parameter Name="profShowSoloPrograms" />
      <asp:Parameter Name="profSso" />
      <asp:Parameter Name="profStoreId" />
      <asp:Parameter Name="profVideos" />
      <asp:Parameter Name="profLastDate" />
      <asp:Parameter Name="profNo" />
    </UpdateParameters>

  </asp:SqlDataSource>

</asp:Content>
