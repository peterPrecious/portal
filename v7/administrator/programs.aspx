<%@ Page
  AutoEventWireup="true"
  CodeBehind="programs.aspx.cs"
  Inherits="portal.v7.administrator.programs"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  Title="Programs"
  ValidateRequest="false" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/programs.min.css" rel="stylesheet" />

  <style>
    textarea { height: 100px !important; width: 400px }
    .description { height: 250px !important; }
    .modules { height: 150px !important; }
  </style>

  <script>
    $(function () {

      // generates a yellow description in labError of panBottom - listed below in order rendered online
      $(".progNo").on("click", function () { $(".labError").html('This is the unique, system generated progomer No. It is only used by Support.') })
      $(".progId").on("click", function () { $(".labError").html('The Program Id is the key for this Program. Once created it cannot be changed. It\'s format is P9999LL, ie P1234EN.') })
      $(".progTitle").on("click", function () { $(".labError").html('A short description of this Program.') })
      $(".progDesc").on("click", function () { $(".labError").html('A more detailed description of this Program.') })
      $(".progMods").on("click", function () { $(".labError").html('These are the module Ids contained in this program. Enter as: "1234EN 2345EN 4567FR".') })

      // clears the labError
      $(".labError").on("click", function () {
        setLabError("");
      })

    })

    function setLabError(desc) {
      if ($(".labError").html() == "" || $(".labError").html() != desc) {
        $(".labError").html(desc);
      } else {
        $(".labError").html("");
      }
    }

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
        <br /><br /><br /><br />

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Literal runat="server" Text="Programs" />
          </span>
          <asp:ImageButton runat="server"
            ImageUrl="~/styles/icons/portal/add.png"
            OnClick="dvProgram_ItemInit"
            ToolTip="Add a Program"
            Width="25" />
        </h1>

        <div class="thisTitle">
          Select Programs whose Program Id or Title contains the Search value.
          Note: if you leave the search selector empty the list will start at the beginning.


          <br /><br />
          <asp:Literal runat="server" Text="[Clicking the title shows/hides this section.]" />

          <div style="margin-top: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="Start Value" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="Start" />
          </div>
        </div>

        <asp:GridView runat="server"
          AllowPaging="True"
          AllowSorting="True"
          AutoGenerateColumns="False"
          CssClass="gvPrograms"
          DataKeyNames="progNo"
          DataSourceID="SqlDataSource1"
          HeaderStyle-BackColor="#0178B9"
          HeaderStyle-ForeColor="White"
          HorizontalAlign="Center"
          ID="gvPrograms"
          OnSelectedIndexChanged="gvPrograms_SelectedIndexChanged"
          PageSize="20"
          Width="800px">
          <Columns>
            <asp:BoundField DataField="progNo" HeaderText="Prog_No" ReadOnly="True" InsertVisible="False" Visible="false" />
            <asp:BoundField DataField="progId" HeaderText="Program Id" ItemStyle-HorizontalAlign="Center" SortExpression="progId" />
            <asp:BoundField DataField="progTitle" HeaderText="Title" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
            <asp:TemplateField HeaderText="Details" ItemStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:ImageButton runat="server"
                  CausesValidation="True"
                  CommandName="Select"
                  CssClass="icons2"
                  ID="btnSelect"
                  ImageUrl="~/styles/icons/portal/details.png"
                  Text="Details"
                  ToolTip="Display details of this Program" />
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
            <br />
            There are currently no Programs based on your Selection criteria.<br />
            <br />
          </EmptyDataTemplate>
        </asp:GridView>

      </asp:Panel>

      <asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Label ID="panBotHeader" CssClass="resendAlerts" runat="server"
              Text="Add/Edit Program" />
          </span>
          <asp:ImageButton runat="server"
            ID="titleAddAProgram"
            ImageUrl="~/styles/icons/portal/back.png"
            OnClick="listPrograms_Click"
            ToolTip="Return to Program List" />

          <asp:Panel runat="server" ID="panBotTitle" CssClass="thisTitle">

            <asp:Panel runat="server" CssClass="c3">
              <br />
              Note: Program Id must be globally unique (like P1234_EN). 
              Note: clicking on any Field name (i.e. Program Id) will provide a description above.
              Click on that description to hide it. [Clicking the title shows/hides this section.]
            </asp:Panel>

          </asp:Panel>
        </h1>

        <div style="margin-left: auto; margin-right: auto; text-align: center">
          <asp:Label ID="labError" runat="server" CssClass="labError" />
        </div>


        <asp:DetailsView runat="server" 
          AutoGenerateRows="False" 
          BorderStyle="None" 
          CssClass="dvProgram" 
          DataKeyNames="progNo" 
          DataSourceID="SqlDataSource2" 
          DefaultMode="Edit" 
          HeaderStyle-Font-Bold="true" 
          HeaderStyle-HorizontalAlign="Right" 
          ID="dvProgram" 
          OnDataBound="dvProgram_DataBound" 
          OnItemDeleted="dvProgram_ItemDeleted" 
          OnItemInserted="dvProgram_ItemInserted" 
          OnItemInserting="dvProgram_ItemInserting" 
          OnItemUpdated="dvProgram_ItemUpdated" 
          OnItemUpdating="dvProgram_ItemUpdating">

          <Fields>
            <asp:BoundField ControlStyle-Width="150px" DataField="progId" HeaderStyle-CssClass="progId" HeaderText="Program Id" ItemStyle-Width="150px" />
            <asp:TemplateField HeaderText="Title">
              <EditItemTemplate>
                <asp:TextBox ID="progTitle" runat="server" Text='<%# Bind("progTitle") %>' TextMode="MultiLine"></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="progTitle" runat="server" Text='<%# Bind("progTitle") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="progTitle" runat="server" Text='<%# Bind("progTitle") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="progTitle" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Description">
              <EditItemTemplate>
                <asp:TextBox ID="progDesc" runat="server" CssClass="description" Text='<%# Bind("progDesc") %>' TextMode="MultiLine"></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="progDesc" runat="server" CssClass="description" Text='<%# Bind("progDesc") %>' TextMode="MultiLine"></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="progDesc" runat="server" Text='<%# Bind("progDesc") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="progDesc" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Modules">
              <EditItemTemplate>
                <asp:TextBox ID="progMods" runat="server" CssClass="modules" Text='<%# Bind("progMods") %>' TextMode="MultiLine"></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="progMods" runat="server" CssClass="modules" Text='<%# Bind("progMods") %>' TextMode="MultiLine"></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="progMods" runat="server" Text='<%# Bind("progMods") %>'></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="progMods" />
            </asp:TemplateField>
            <asp:BoundField DataField="progNo" HeaderStyle-CssClass="progNo" HeaderText="[ Internal No ]" InsertVisible="False" ReadOnly="True" />
            <asp:TemplateField ControlStyle-CssClass="icons2" ShowHeader="False">
              <EditItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ID="btnUpdate" runat="server" CausesValidation="True" CommandName="Update" ImageUrl="~/styles/icons/portal/update.png" ToolTip="Update Learner" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  <asp:ImageButton ID="btnCancel" runat="server" CausesValidation="False" CommandName="" ImageUrl="~/styles/icons/portal/cancel.png" OnClick="btnCancel_Click" ToolTip="Cancel Operation" />
              </EditItemTemplate>
              <InsertItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ID="btnInsert" runat="server" CausesValidation="True" CommandName="Insert" ImageUrl="~/styles/icons/portal/update.png" ToolTip="Add a Learner" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  <asp:ImageButton ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel" ImageUrl="~/styles/icons/portal/cancel.png" OnClick="btnCancel_Click" ToolTip="Cancel Operation" />
              </InsertItemTemplate>
              <ItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ID="btnEdit" runat="server" CausesValidation="True" CommandName="Edit" ImageUrl="~/styles/icons/portal/edit.png" ToolTip="Edit Learner's Profile" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  <asp:ImageButton ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" ImageUrl="~/styles/icons/portal/delete.png" OnClientClick="return confirm('Are you certain you want to delete this Learner?')" ToolTip="Delete Program" />
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
        Prog_No               AS progNo,
        Prog_Id               AS progId,
        Prog_Title1           AS progTitle,
        Prog_Desc             AS progDesc
      FROM 
        V5_Base.dbo.Prog
      WHERE
        LEN(@search) = 0 OR 
        @search IS NULL OR 
        @search = '*' OR 
        Prog_Id LIKE '%' + @search + '%' OR 
        Prog_Title1 LIKE '%' + @search + '%' 
      ORDER BY 
        Prog_Id
    ">
    <SelectParameters>
      <asp:ControlParameter Name="search" ControlID="txtSearch" DefaultValue="*" PropertyName="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource
    ID="SqlDataSource2"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT 
        Prog_No               AS progNo,
        Prog_Id               AS progId,
        Prog_Mods             AS progMods,
        Prog_Title1           AS progTitle,
        Prog_Desc             AS progDesc
      FROM 
        V5_Base.dbo.Prog
      WHERE 
        Prog_No = @progNo
    "
    InsertCommand="
      INSERT 
        V5_Base.dbo.Prog 
      (
        Prog_Id,
        Prog_Mods,
        Prog_Title1,
        Prog_Desc
      ) VALUES (
        @progId, 
        @progMods,
        @progTitle,
        @progDesc
      )
    "
    UpdateCommand="
      UPDATE 
        V5_Base.dbo.Prog
      SET 
        [Prog_Id]=UPPER(@ProgId), 
        [Prog_Mods]=@ProgMods,
        [Prog_Title1]=@ProgTitle,
        [Prog_Desc]=@ProgDesc
      WHERE 
        [Prog_No] = @ProgNo
    "
    DeleteCommand="
      DELETE 
        V5_Base.dbo.Prog
      WHERE 
        Prog_No = @ProgNo
     ">
    <SelectParameters>
      <asp:ControlParameter ControlID="gvPrograms" Name="progNo" PropertyName="SelectedValue" Type="Int32" />
    </SelectParameters>

  </asp:SqlDataSource>

</asp:Content>
