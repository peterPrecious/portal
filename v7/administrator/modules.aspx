<%@ Page
  AutoEventWireup="true"
  CodeBehind="modules.aspx.cs"
  Inherits="portal.v7.administrator.modules"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  Title="Modules" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/modules.min.css" rel="stylesheet" />
  <script>

    function setLabError(desc) {
      if ($(".labError").html() == "" || $(".labError").html() != desc) {
        $(".labError").html(desc);
      } else {
        $(".labError").html("");
      }
    }

    $(function () { // generates a yellow description in labError of panBottom - listed below in order rendered online
      $(".custNo").on("click", function () { $(".labError").html('This is the unique, system generated Customer No. It is only used by Support.') })
      $(".custId").on("click", function () { $(".labError").html('The Customer Id is the key for this Account. Once created it cannot be changed. It\'s format is AAAA9999 where the last 4 characters are system generated.') })
      $(".custTitle").on("click", function () { $(".labError").html('A short description of this Account.') })
      $(".custActive").on("click", function () { $(".labError").html('Defaults to ON. When OFF this Customer will not appear on any reports.') })
      $(".custLang").on("click", function () { $(".labError").html('Must be one of EN, FR or ES. You cannot specify multiple languages.') })
      $(".custParentId").on("click", function () { $(".labError").html('If this is a child account, this field contains the Account Id of the Parent. IE if the parent\'s Customer Id is CAAM3001 then this field will be 3001.') })
      $(".custAuto").on("click", function () { $(".labError").html('Allows Channel SSO for learners when authentication occurs behind the customer\'s firewall. Uncheck for V8 where the presence of a custGuid in the call invokes SSO.') })
      $(".custNop").on("click", function () { $(".labError").html('Set ON if this account uses NOP for ecommerce.') })
      $(".custV8").on("click", function () { $(".labError").html('Set ON if this account uses V8 to view content.') })
      $(".custGuests").on("click", function () { $(".labError").html('Check to enable the Guest Subsystem (used by CFIB/FCEI). Typically set to No. Should only be set to Yes if this is a Parent Account, ie the Parent Id is empty.') })
      $(".custProfile").on("click", function () { $(".labError").html('Profile is typically something like \'abcd_en\'. Note this is NOT the Alias, which is a simpler version for ease of use.') })
      $(".custLearners").on("click", function () { $(".labError").html('This is the computed number of Active Learners in this Account. If you plan to Delete this Account, all Active Learners must be inactivated or deleted.') })

      // clears the labError
      $(".labError").on("click", function () { setLabError("") })

      $("#MainContent_dvModule_modsLength").blur(function () {
        var str = $("#MainContent_dvModule_modsLength").val().toUpperCase();
        var len = str.length;
        var pat = new RegExp(/^(?=.*[1-9])[0-9]*[.,]?[0-9]{1,2}$/);
        var tst = pat.test(str);
        if (len == 0 || !tst) {
          //alert("Please enter a valid Length (number of hours of this module, ie 1.5");
          setLabError("Please enter a valid Length (hours) for this module, ie 1.5.")
        };
      })

    })

  </script>
  <style>
    textarea { height: 100px !important; width: 400px }
  </style>
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
            <asp:Literal runat="server" Text="Modules" />
          </span>

          <asp:ImageButton runat="server"
            ImageUrl="~/styles/icons/portal/add.png"
            OnClick="dvModule_ItemInit"
            ToolTip="Add a Module"
            Width="25" />
        </h1>

        <div class="thisTitle">
          Select
          <asp:DropDownList ID="ddActive" runat="server" CssClass="dropDown" cOnSelectedIndexChanged="ddActive_SelectedIndexChanged">
            <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
            <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
            <asp:ListItem Text="Active and Inactive" Value="9"></asp:ListItem>
          </asp:DropDownList>
          Modules whose Module Id or Title contains the Search Value.
          Note: if you leave the Search Value empty the list will start at the beginning.
          You can sort on the Module Id.

          <br /><br />
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" />

          <div style="margin-top: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="Start Value" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="Start" />
          </div>

        </div>

        <asp:GridView runat="server"
          AllowPaging="True"
          AllowSorting="True"
          AutoGenerateColumns="False"
          CssClass="gvModules"
          DataKeyNames="modsNo"
          DataSourceID="SqlDataSource1"
          HeaderStyle-BackColor="#0178B9"
          HeaderStyle-ForeColor="White"
          HorizontalAlign="Center"
          ID="gvModules"
          OnSelectedIndexChanged="gvModules_SelectedIndexChanged"
          PageSize="20"
          Width="800px">
          <Columns>
            <asp:BoundField DataField="modsNo" HeaderText="Mods_No" ReadOnly="True" InsertVisible="False" Visible="false" />
            <asp:BoundField DataField="modsId" HeaderText="Module Id" ItemStyle-HorizontalAlign="Center" SortExpression="modsId" />
            <asp:BoundField DataField="modsTitle" HeaderText="Title" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
            <asp:BoundField DataField="modsActive" HeaderText="Active" ItemStyle-HorizontalAlign="Center" />
            <asp:TemplateField HeaderText="Details" ItemStyle-HorizontalAlign="Center" >
              <ItemTemplate>
                <asp:ImageButton runat="server"
                  CausesValidation="True"
                  CommandName="Select"
                  CssClass="icons2"
                  ID="btnSelect"
                  ImageUrl="~/styles/icons/portal/details.png"
                  Text="Details"
                  ToolTip="Display details of this Module" />
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
            There are currently no Modules based on your Selection criteria.<br />
          </EmptyDataTemplate>

        </asp:GridView>

      </asp:Panel>

      <asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Label ID="panBotHeader" CssClass="resendAlerts" runat="server"
              Text="Add/Edit Module" />
          </span>
          <asp:ImageButton runat="server"
            ID="titleAddAModule"
            ImageUrl="~/styles/icons/portal/back.png"
            OnClick="listModules_Click"
            ToolTip="Return to Module List" />
        </h1>

        <div class="thisTitle">
          <h2 style="text-align: left;">Note: Module Name must be globally unique (like ABCD_EN). 
            Note: clicking on any Field name (i.e. Module Id) will provide a description above.
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
          CssClass="dvModule"
          DataKeyNames="modsNo"
          DataSourceID="SqlDataSource2"
          DefaultMode="Edit"
          HeaderStyle-Font-Bold="true"
          HeaderStyle-HorizontalAlign="Right"
          ID="dvModule"
          OnDataBound="dvModule_DataBound"
          OnItemInserting="dvModule_ItemInserting"
          OnItemInserted="dvModule_ItemInserted"
          OnItemUpdating="dvModule_ItemUpdating"
          OnItemUpdated="dvModule_ItemUpdated"
          OnItemDeleted="dvModule_ItemDeleted">

          <Fields>

            <asp:BoundField DataField="modsId" HeaderText="Module Id" ControlStyle-Width="150px" ItemStyle-Width="150px" />

            <asp:TemplateField HeaderText="Title">
              <EditItemTemplate>
                <asp:TextBox ID="modsTitle" runat="server" Text='<%# Bind("modsTitle") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="modsTitle" runat="server" Text='<%# Bind("modsTitle") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="modsTitle" runat="server" Text='<%# Bind("modsTitle") %>'></asp:Label>
              </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Description">
              <EditItemTemplate>
                <asp:TextBox ID="modsDesc" runat="server" Rows="14" TextMode="MultiLine" 
                  Text='<%# Bind("modsDesc") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="modsDesc" runat="server" Rows="14" TextMode="MultiLine" Text='<%# Bind("modsDesc") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="modsDesc" runat="server" Text='<%# Bind("modsDesc") %>'></asp:Label>
              </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Length (hours)" ControlStyle-Width="50px" ItemStyle-Width="50px">
              <EditItemTemplate>
                <asp:TextBox ID="modsLength" runat="server" Text='<%# Bind("modsLength") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="modsLength" runat="server" Text='<%# Bind("modsLength") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="modsLength" runat="server" Text='<%# Bind("modsLength") %>' />
              </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Active">
              <EditItemTemplate>
                <asp:CheckBox ID="modsActive" runat="server" Checked='<%# Bind("modsActive") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="modsActive" runat="server" Checked='<%# Bind("modsActive") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="modsActive" runat="server" Checked='<%# Bind("modsActive") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip active" />
              <ItemStyle CssClass="modsActive" />
            </asp:TemplateField>

            <asp:BoundField DataField="modsNo" HeaderText="[ Internal No ]" InsertVisible="False" ReadOnly="True" />

            <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icons2">
              <EditItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/update.png" ID="btnUpdate" runat="server"
                  CausesValidation="True" CommandName="Update" ToolTip="Update Module" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/cancel.png" ID="btnCancel" runat="server"
                  CausesValidation="False" CommandName="" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </EditItemTemplate>
              <InsertItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/update.png" ID="btnInsert" runat="server"
                  CausesValidation="True" CommandName="Insert" ToolTip="Add a Module" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/cancel.png" ID="btnCancel" runat="server"
                  CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </InsertItemTemplate>
              <ItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/edit.png" ID="btnEdit" runat="server"
                  CausesValidation="True" CommandName="Edit" ToolTip="Edit Module Profile" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/delete.png" ID="btnDelete" runat="server"
                  CausesValidation="False" CommandName="Delete" ToolTip="Delete Module"
                  OnClientClick="return confirm('Are you certain you want to delete this Module?')" />
              </ItemTemplate>
            </asp:TemplateField>

          </Fields>
        </asp:DetailsView>

      </asp:Panel>

    </asp:Panel>

  </div>

  <asp:SqlDataSource runat="server"
    ID="SqlDataSource1"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT 
        Mods_No               AS modsNo,
        Mods_Id               AS modsId,
        Mods_Title            AS modsTitle,
        Mods_Active           AS modsActive
      FROM 
        V5_Base.dbo.mods
      WHERE
    (
        LEN(@search) = 0 OR 
        @search IS NULL OR 
        @search = '*' OR 
        Mods_Id LIKE '%' + @search + '%' OR 
        Mods_Title LIKE '%' + @search + '%' 
    )
        AND
    (
        @active = 9 OR
        Mods_Active = @active
    )
      ORDER BY 
        ModsId
    ">
    <SelectParameters>
      <asp:ControlParameter Name="search" ControlID="txtSearch" DefaultValue="*" PropertyName="Text" />
      <asp:ControlParameter Name="active" ControlID="ddActive" DefaultValue="1" PropertyName="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource
    ID="SqlDataSource2"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT 
        Mods_No               AS modsNo,
        Mods_Id               AS modsId,
        Mods_Title            AS modsTitle,
        Mods_Desc             AS modsDesc,
        Mods_Active           AS modsActive,
        Mods_Length           AS modsLength
      FROM 
        V5_Base.dbo.mods
      WHERE 
        Mods_No = @modsNo
      "
    InsertCommand="
      INSERT 
        V5_Base.dbo.Mods 
      (
        Mods_Id,
        Mods_Title,
        Mods_Desc,
        Mods_Active,
        Mods_Length   
      ) VALUES (
        @modsId, 
        @modsTitle, 
        @modsDesc, 
        @modsActive, 
        @modsLength
      )
    "
    UpdateCommand="
      UPDATE 
        V5_Base.dbo.Mods
      SET 
        [Mods_Id]=UPPER(@ModsId), 
        [Mods_Title]=@ModsTitle, 
        [Mods_Desc]=@modsDesc, 
        [Mods_Active]=@ModsActive, 
        [Mods_Length]=@ModsLength
      WHERE 
        [Mods_No] = @ModsNo
    "
    DeleteCommand="
      DELETE 
        V5_Base.dbo.Mods
      WHERE 
        Mods_No = @ModsNo
     ">
    <SelectParameters>
      <asp:ControlParameter ControlID="gvModules" Name="modsNo" PropertyName="SelectedValue" Type="Int32" />
    </SelectParameters>

  </asp:SqlDataSource>

</asp:Content>
