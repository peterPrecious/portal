<%@ Page
  AutoEventWireup="true"
  CodeBehind="profiles.aspx.cs"
  EnableEventValidation="false"
  Inherits="portal.v7.administrator.profiles"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  Title="Profiles" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/profiles.min.css" rel="stylesheet" />
  <script>

    function setLabError(desc) {
      if ($(".labError").html() == "" || $(".labError").html() != desc) {
        $(".labError").html(desc);
      } else {
        $(".labError").html("");
      }
    }

    $(function () { // generates a yellow description in labError - listed below in order rendered online

      $(".name").on("click", function () { $(".labError").html("Name: Each Profile must have one or more names separated by spaces.<br />Every name must be unique amongst all Profiles. IE: 'abcd abcd_en jones'.") })
      $(".alias").on("click", function () { $(".labError").html("Alias: This is another way to access a Profile - often a name-friendly value") })
      $(".autoEnroll").on("click", function () { $(".labError").html("Auto Enroll (Post): Can auto enroll learners via a Form Post") })
      $(".autoEnrollWs").on("click", function () { $(".labError").html("Auto Enroll (WS): Can auto enroll learners via a Web Service") })
      $(".autoSignIn").on("click", function () { $(".labError").html("Auto SignIn: Can sign in (but not enroll) via a Form or Web Post") })
      $(".certPrograms").on("click", function () { $(".labError").html("Certificate Programs (Learners): Expose the Certificate Programs tile which will auto enroll with this CustId into V5") })
      $(".certPrograms_E").on("click", function () { $(".labError").html("Certificate Programs (Employees): Expose the Certificate Programs tile for 'Employees' which will auto enroll with this CustId into V5") })
      $(".contentSource").on("click", function () { $(".labError").html("Content Source: Select the source of the content, ie one of: catalogue (default) / ecommerce / assigned / ecom-assigned.") })
      $(".nameCatalogue").on("click", function () { $(".labError").html("Catalogue Name (App): This allows you to create your own name for the Catalogue, within the App (ie My Library).") })
      $(".namePrograms").on("click", function () { $(".labError").html("Programs Name (App): This allows you to create your own name for the Programs, within the App (ie My Courses).") })
      $(".nameReports").on("click", function () { $(".labError").html("Reports Name (App): This allows you to create your own name for the Reports, within the App (ie Reports).") })
      $(".nameCourses").on("click", function () { $(".labError").html("Courses Name (Tile): This allows you to create your own name for the Program Tile (ie My Content).") })
      $(".courseTileName_en").on("click", function () { $(".labError").html("Course Tile Name: This will override the default content tile name which is 'My Learning Themes'. Currently EN only.") })
      $(".custId").on("click", function () { $(".labError").html("Customer Id: The Customer Id is the key for this Profile. This field is mandatory and must be unique amongst all Profiles.") })
      $(".ecommerce").on("click", function () { $(".labError").html("Ecommerce: Show/Hide the Ecommerce subsystem tile.") })
      $(".emailFrom").on("click", function () { $(".labError").html("Email From: Enter email address if other than 'support@vubiz.com'.") })
      $(".guests").on("click", function () { $(".labError").html("Guests (Learners): Show/Hide the Guest subsystem tile.") })
      $(".guests_E").on("click", function () { $(".labError").html("Guests (Employees): If member type = 'E' (ie CFIB employees) then show/hide the Guest subsystem tile.") })
      $(".jit").on("click", function () { $(".labError").html("JIT (Just In Time): Show/Hide the JIT subsystem tile.") })
      $(".lang_en").on("click", function () { $(".labError").html("Available in EN: shows the app is available in 'EN'") })
      $(".lang_es").on("click", function () { $(".labError").html("Available in ES: shows the app is available in 'ES'") })
      $(".lang_fr").on("click", function () { $(".labError").html("Available in FR: shows the app is available in 'FR'") })
      $(".logo").on("click", function () { $(".labError").html("Provide the Logo name, like 'cfib_en.png'. Must have been previously uploaded.") })
      $(".memb_E").on("click", function () { $(".labError").html("Yes if this account supports 'employees'. Note: currently only CFIB uses this feature.") })
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
      $(".labError").on("click", function () { setLabError("") })

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

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png"
      ID="exit" runat="server" OnClick="exit_Click" />

    <asp:Panel ID="panConfirmShell" CssClass="panConfirmShell" runat="server" Visible="false">
      <asp:Panel ID="panConfirm" CssClass="panConfirm" runat="server">
        <h1>
          <asp:Label ID="labConfirmTitle" runat="server"></asp:Label></h1>
        <h2>
          <asp:Label ID="labConfirmMessage" runat="server"></asp:Label><br /><br />
          <asp:LinkButton CssClass="newButton" ID="btnConfirmCancel" OnClientClick='$(".panConfirm").hide(); return false;' runat="server"></asp:LinkButton>&nbsp;&nbsp;
          <asp:LinkButton CssClass="newButton" ID="btnConfirmOk" OnClick="btnConfirmOk_Click" runat="server"></asp:LinkButton>
        </h2>
      </asp:Panel>
    </asp:Panel>

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

      <asp:Panel ID="panTop" CssClass="panTop" runat="server">
        <br /><br />

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Literal runat="server" Text="Profiles" />
          </span>

          <asp:ImageButton runat="server"
            ImageUrl="~/styles/icons/portal/add.png"
            OnClick="dvProfile_ItemInit"
            ToolTip="Add a Profile"
            Width="25" />
        </h1>

        <div class="thisTitle">
          Profiles are extensions of the Customer Table that provide specific features for V8/NOP Service.  
          They are NOT used for V5 Accounts. They are listed in Last Date order but the order can be changed by 
          clicking on one of the left four column names. 
          For ease of use, the profile can be access by its unique Name or an optional unique Alias. 
          An example of a Name/Alias is &quot;CFIB_FR&quot;/&quot;FCEI&quot;.
          <br /><br />
          Cloning a Profile creates a new Profile with the same values as the one you are cloning.
          The only exception is the Profile Clone Name which must be unique and entered before your select Clone.
          Once cloned the new Profile will appear at the top of the list where you can edit it like any other Profile.
          <br /><br />
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" />

          <div style="margin-top: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="<%$  Resources:portal, searchValue%>" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="<%$  Resources:portal, search%>" />
          </div>

        </div>

        <asp:GridView runat="server"
          AllowPaging="True"
          AllowSorting="True"
          AutoGenerateColumns="False"
          CssClass="gvProfiles"
          DataKeyNames="profNo"
          DataSourceID="SqlDataSource1"
          HeaderStyle-BackColor="#0178B9"
          HeaderStyle-ForeColor="White"
          HorizontalAlign="Center"
          ID="gvProfiles"
          OnSelectedIndexChanged="gvProfiles_SelectedIndexChanged"
          PageSize="20"
          Width="800px">
          <Columns>
            <asp:BoundField DataField="profNo" ReadOnly="True" Visible="false" />
            <asp:TemplateField HeaderText="Profile Name" SortExpression="profName">
              <EditItemTemplate>
                <asp:TextBox ID="profNameOld" CssClass="profNameOld" runat="server" Text='<%# Bind("profName") %>'></asp:TextBox>
              </EditItemTemplate>
              <ItemTemplate>
                <asp:Label ID="Label1" CssClass="profNameOld" runat="server" Text='<%# Bind("profName") %>'></asp:Label>
              </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="profCustId" HeaderText="Customer Id" SortExpression="profCustId" />
            <asp:BoundField DataField="profLogo" HeaderText="Logo" SortExpression="profLogo" />
            <asp:BoundField DataField="profLastDate" HeaderText="Last Date" ReadOnly="True" SortExpression="profLastDate" DataFormatString="{0:MMM d yyyy}" />
            <asp:TemplateField HeaderText="Details" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:ImageButton runat="server"
                  CausesValidation="True"
                  CommandName="Select"
                  CssClass="icons2"
                  ID="btnSelect"
                  ImageUrl="~/styles/icons/portal/details.png"
                  Text="Details"
                  ToolTip="Display details of this Profile" />
              </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Profile Clone Name" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:TextBox runat="server"
                  CausesValidation="False"
                  ID="profNameNew"
                  CssClass="profNameNew"
                  MaxLength="24"
                  Text="" />
              </ItemTemplate>
              <HeaderStyle HorizontalAlign="Center" />
              <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Clone" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:ImageButton runat="server"
                  CausesValidation="False"
                  CssClass="icons2"
                  ID="btnClone"
                  ImageUrl="~/styles/icons/portal/clone.png"
                  OnCommand="btnConfirm_Command"
                  CommandArgument='<%# "Clone|" +  Eval("profNo") + "|" + Eval("profName") %>'
                  ToolTip="Clone Profile" />
              </ItemTemplate>

            </asp:TemplateField>
          </Columns>

          <PagerSettings
            FirstPageImageUrl="~/styles/icons/grids/frst.png"
            LastPageImageUrl="~/styles/icons/grids/last.png"
            NextPageImageUrl="~/styles/icons/grids/next.png"
            PreviousPageImageUrl="~/styles/icons/grids/prev.png"
            Position="Bottom"
            Mode="NextPreviousFirstLast" />
          <PagerStyle CssClass="commands" HorizontalAlign="Center" />
          <EmptyDataRowStyle ForeColor="Yellow" Font-Size="Large" />
          <EmptyDataTemplate>
            There are currently no modules based on your Selection criteria.<br />
          </EmptyDataTemplate>

        </asp:GridView>

      </asp:Panel>

      <asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Label ID="panBotHeader" CssClass="resendAlerts" runat="server"
              Text="Add/Edit Profile" />
          </span>
          <asp:ImageButton runat="server"
            ID="titleAddAProfile"
            ImageUrl="~/styles/icons/portal/back.png"
            OnClick="listProfiles_Click"
            ToolTip="Return to Profile List" />
        </h1>

        <div class="thisTitle">
          <h2 style="text-align: left;">Note: Profile Name must be globally unique (like ABCD_EN). 
            Most fields can be defaulted but Customer Id is mandatory. 
            Note: clicking on any Field name (i.e. Profile Name) will provide a description above.
            Click on that description to hide it. 
            [Clicking the title shows/hides this section.]
          </h2>
        </div>

        <div style="margin-left: auto; margin-right: auto; text-align: center">
          <asp:Label runat="server" ID="labError" CssClass="labError" />
        </div>

        <asp:DetailsView runat="server"
          AutoGenerateRows="False"
          BorderStyle="None"
          CssClass="dvProfile"
          DataKeyNames="profNo"
          DataSourceID="SqlDataSource2"
          DefaultMode="Edit"
          HeaderStyle-Font-Bold="true"
          HeaderStyle-HorizontalAlign="Right"
          ID="dvProfile"
          OnDataBound="dvProfile_DataBound"
          OnItemInserting="dvProfile_ItemInserting"
          OnItemInserted="dvProfile_ItemInserted"
          OnItemUpdating="dvProfile_ItemUpdating"
          OnItemUpdated="dvProfile_ItemUpdated"
          OnItemDeleted="dvProfile_ItemDeleted">

          <Fields>

            <asp:TemplateField HeaderText="Profile Name">
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
                <asp:DropDownList ID="profContentSource" runat="server" AutoPostBack="true" SelectedValue='<%# Bind("profContentSource") %>'>
                  <asp:ListItem Selected="True" Text="Catalogue" Value="catalogue" />
                  <asp:ListItem Text="Ecommerce" Value="ecommerce" />
                  <asp:ListItem Text="Assigned" Value="assigned" />
                  <asp:ListItem Text="Ecom Assigned" Value="ecom-assigned" />
                </asp:DropDownList>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:DropDownList ID="profContentSource" runat="server" AutoPostBack="true" SelectedValue='<%# Bind("profContentSource") %>'>
                  <asp:ListItem Selected="True" Text="Catalogue" Value="catalogue" />
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

            <asp:TemplateField HeaderText="Courses Name (Tile)">
              <EditItemTemplate>
                <asp:TextBox ID="profNameCourses" runat="server" Text='<%# Bind("profNameCourses") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profNameCourses" runat="server" Text='<%# Bind("profNameCourses") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profNameCourses" runat="server" Text='<%# Bind("profNameCourses") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip nameCourses" />
              <ItemStyle CssClass="profNameCourses" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Course Tile Name">
              <EditItemTemplate>
                <asp:TextBox ID="profCourseTileName_en" runat="server" Text='<%# Bind("profCourseTileName_en") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profCourseTileName_en" runat="server" Text='<%# Bind("profCourseTileName_en") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profCourseTileName_en" runat="server" Text='<%# Bind("profCourseTileName_en") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip courseTileName_en" />
              <ItemStyle CssClass="profCourseTileName_en" />
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

            <asp:TemplateField HeaderText="Default Language" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Right">

              <EditItemTemplate>
                <asp:DropDownList ID="profLang" SelectedValue='<%# Bind("profLang") %>'
                  CssClass="profLang" runat="server">
                  <asp:ListItem Value="EN" Text="EN"></asp:ListItem>
                  <asp:ListItem Value="ES" Text="ES"></asp:ListItem>
                  <asp:ListItem Value="FR" Text="FR"></asp:ListItem>
                </asp:DropDownList>
                <asp:HiddenField ID="hidProfLang" Value='<%# Bind("profLang") %>' runat="server" />
                <br />
                <asp:Literal runat="server" Text="The Level value should NOT be changed once updated since other values depend on its state." />
              </EditItemTemplate>

              <InsertItemTemplate>
                <asp:DropDownList ID="profLang" runat="server" AutoPostBack="true" CssClass="profLangxx" SelectedValue='<%# Bind("profLang") %>'>
                  <asp:ListItem Value="EN" Text="EN"></asp:ListItem>
                  <asp:ListItem Value="ES" Text="ES"></asp:ListItem>
                  <asp:ListItem Value="FR" Text="FR"></asp:ListItem>
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
                <asp:TextBox ID="profStoreId" runat="server" CssClass="profStoreId" Text='<%# Bind("profStoreId") %>' />
                <asp:RegularExpressionValidator ID="profStoreId_validation" runat="server" ControlToValidate="profStoreId" ErrorMessage="&lt;br&gt;Enter a valid numeric Store Id, ie 0-99999." ForeColor="Yellow" ValidationExpression="^[0-9]*$">
                </asp:RegularExpressionValidator>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="profStoreId" runat="server" CssClass="profStoreId" Text='<%# Bind("profStoreId") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="profStoreId" runat="server" CssClass="profStoreId" Text='<%# Bind("profStoreId") %>' />
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

            <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icons2">
              <EditItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/update.png" ID="btnUpdate" runat="server"
                  CausesValidation="False" CommandName="Update" ToolTip="Update Profile" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/cancel.png" ID="btnCancel" runat="server"
                  CausesValidation="False" CommandName="" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </EditItemTemplate>
              <InsertItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/update.png" ID="btnInsert" runat="server"
                  CausesValidation="True" CommandName="Insert" ToolTip="Add a Profile" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/cancel.png" ID="btnCancel" runat="server"
                  CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </InsertItemTemplate>
              <ItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/edit.png" ID="btnEdit" runat="server"
                  CausesValidation="True" CommandName="Edit" ToolTip="Edit Profile" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/delete.png" ID="btnDelete" runat="server"
                  CausesValidation="True" CommandArgument='<%# "Delete|" +  Eval("profNo") + "|" + Eval("profName") %>'
                  OnCommand="btnConfirm_Command" ToolTip="Delete Profile" />
              </ItemTemplate>
            </asp:TemplateField>

          </Fields>

        </asp:DetailsView>

      </asp:Panel>

    </asp:Panel>

  </div>

  <%--  this will retrieve all profiles for the profiles.aspx home page --%>
  <asp:SqlDataSource runat="server"
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
        apps.dbo.profile_new
      ORDER BY
        lastDate DESC, 
        name
    "></asp:SqlDataSource>

  <asp:SqlDataSource runat="server"
    ID="SqlDataSource2"
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
        courseTileName_en           AS profCourseTileName_en, 
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
        nameCourses                 AS profNameCourses, 
        password                    AS profPassword, 
        portal                      AS profPortal, 
        returnUrl                   AS profReturnUrl, 
        showSoloPrograms            AS profShowSoloPrograms, 
        sso                         AS profSso, 
        storeId                     AS profStoreId, 
        videos                      AS profVideos, 
        vukidz                      AS profVukidz
      FROM 
        apps.dbo.profile_new 
      WHERE 
        no = @profNo
    "
    UpdateCommand="
      UPDATE 
        apps.dbo.profile_new 
      SET 
        alias                       = UPPER(@profAlias),
        autoEnroll                  = @profAutoEnroll, 
        autoEnrollWs                = @profAutoEnrollWs, 
        autoSignIn                  = @profAutoSignIn, 
        certPrograms                = UPPER(@profCertPrograms), 
        certPrograms_E              = UPPER(@profCertPrograms_E), 
        contentSource               = @profContentSource, 
        courseTileName_en           = @profCourseTileName_en, 
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
        nameCourses                 = @profNameCourses, 
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
      <asp:Parameter Name="profNameCourses" />
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

    <DeleteParameters>
      <asp:Parameter Name="profNo" />
    </DeleteParameters>

    <InsertParameters>
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
      <asp:Parameter Name="profNameCourses" />
      <asp:Parameter Name="profPassword" />
      <asp:Parameter Name="profPortal" />
      <asp:Parameter Name="profReturnUrl" />
      <asp:Parameter Name="profShowSoloPrograms" />
      <asp:Parameter Name="profSso" />
      <asp:Parameter Name="profStoreId" />
      <asp:Parameter Name="profVideos" />
      <asp:Parameter Name="profLastDate" />
    </InsertParameters>

  </asp:SqlDataSource>

</asp:Content>
