<%@ Page
  Title="Pofile Aliases"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="aliases.aspx.cs"
  Inherits="portal.v7.administrator.aliases" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/aliases.min.css" rel="stylesheet" />
  <script>
    function validateAlias(button) {
      var ok = true;
      if ($("#MainContent_dvAlias_alias")[0].value === "") {
        alert("Please enter an Alias");
        ok = false;
      }
      if ($("#MainContent_dvAlias_profile")[0].value === "") {
        alert("Please enter a Profile");
        ok = false;
      }
      return ok;
    }
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />
    <br /><br />

    <asp:Panel ID="panPage" CssClass="panPage" runat="server">

      <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

        <asp:Panel ID="panTop" CssClass="panTop" runat="server">

          <h1>
            <span onclick="fadeIn()" class="hoverUnderline" title="Click to show discription.">Profile Aliases</span>
            <asp:ImageButton OnClick="btnAdd_Click" CssClass="btnAdd commands icons" ID="btnAdd" ImageUrl="~/styles/icons/vubiz/add.png" ToolTip="Add an Alias" runat="server" />
          </h1>

          <div class="thisTitle">
            An Alias is a simpler name for a Profile.&nbsp; While a Profile Id typically consists of the 4 character Customer Id plus the language, ie &quot;cchs_en&quot;, the Alias can be a more customer friendly, &quot;ccohs&quot; (for example). Note that the Alias table and Profile table are NOT automatically connected; adding an Alias and the related Profile values are separate functions. The Guest option is for Accounts that use the Guest subsystem. Click on the Action icons at right to Edit or Delete an existing alias or the icon at top to Add an alias.
            You can sort the Aliases by clicking on the left 3 column headers.
            <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
          </div>

          <asp:GridView runat="server"
            ID="gvAliases"
            CssClass="gvAliases"
            HorizontalAlign="Center"
            Width="550px"
            AutoGenerateColumns="False"
            DataSourceID="SqlDataSource"
            DataKeyNames="id"
            AllowSorting="True"
            AllowPaging="True"
            PageSize="20">
            <Columns>
              <asp:BoundField DataField="id" HeaderText="Id" InsertVisible="False" ReadOnly="True" Visible="false" />
              <asp:BoundField DataField="alias" HeaderText="Alias" HeaderStyle-Width="150px" SortExpression="alias">
                <HeaderStyle Width="150px" />
              </asp:BoundField>
              <asp:BoundField DataField="profile" HeaderText="Profile" HeaderStyle-Width="150px" SortExpression="profile">
                <HeaderStyle Width="150px" />
              </asp:BoundField>
              <asp:CheckBoxField DataField="guest" HeaderText="Guest" SortExpression="guest"></asp:CheckBoxField>
              <asp:TemplateField HeaderText="Action">
                <EditItemTemplate>
                  <asp:ImageButton ID="butUpdate" runat="server" CausesValidation="True" CommandName="Update" ImageUrl="~/styles/icons/grids/update.png" Text="Update" ToolTip="Save/Update this Alias" />
                  <asp:ImageButton ID="butCancel" runat="server" CausesValidation="False" CommandName="Cancel" ImageUrl="~/styles/icons/grids/cancel.png" Text="Cancel" ToolTip="Cancel Editting this Alias" />
                </EditItemTemplate>
                <ItemTemplate>
                  <asp:ImageButton ID="butEdit" runat="server" CausesValidation="False" CommandName="Edit" ImageUrl="~/styles/icons/grids/edit.png" Text="Edit" ToolTip="Edit this Alias" />
                  <asp:ImageButton ID="butDelete" runat="server" CausesValidation="False" CommandName="Delete" ImageUrl="~/styles/icons/grids/delete.png" Text="Delete" ToolTip="Delete this Alias" OnClientClick="return confirm('Are you certain you want to delete this Alias?');" />
                </ItemTemplate>
                <ControlStyle CssClass="commands" />
              </asp:TemplateField>
            </Columns>

            <PagerSettings
              FirstPageImageUrl="~/styles/icons/grids/frst.png"
              LastPageImageUrl="~/styles/icons/grids/last.png"
              NextPageImageUrl="~/styles/icons/grids/next.png"
              PreviousPageImageUrl="~/styles/icons/grids/prev.png"
              Position="Bottom"
              Mode="NextPreviousFirstLast" />

            <PagerStyle HorizontalAlign="Center" CssClass="commands" />

          </asp:GridView>
        </asp:Panel>

        <asp:Panel ID="panBot" CssClass="panBot" runat="server">
          <h1 class="title2">
            <asp:Literal runat="server" Text="Add a New Alias" />
            <asp:ImageButton OnClick="btnList_Click" CssClass="btnList" ID="btnList" ImageUrl="~/styles/icons/grids/list.png" ToolTip="Return to List" runat="server" />
          </h1>
          <asp:DetailsView runat="server"
            ID="dvAlias"
            DefaultMode="Insert"
            CssClass="detailsView"
            AutoGenerateRows="False"
            DataKeyNames="id"
            DataSourceID="SqlDataSource"
            HorizontalAlign="Center"
            HeaderStyle-VerticalAlign="Top"
            HeaderStyle-HorizontalAlign="Right"
            HeaderStyle-Font-Bold="true">
            <Fields>
              <asp:BoundField DataField="id" HeaderText="Id" InsertVisible="False" ReadOnly="True" />

              <asp:TemplateField HeaderText="Alias :&nbsp;" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Right">
                <InsertItemTemplate>
                  <asp:TextBox ID="alias" runat="server" Text='<%# Bind("alias") %>'></asp:TextBox>
                </InsertItemTemplate>
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Profile :&nbsp;">
                <InsertItemTemplate>
                  <asp:TextBox ID="profile" runat="server" Text='<%# Bind("profile") %>'></asp:TextBox>
                </InsertItemTemplate>
                <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Guest :&nbsp;">
                <InsertItemTemplate>
                  <asp:CheckBox ID="guest" runat="server" Checked='<%# Bind("guest") %>' />
                </InsertItemTemplate>
                <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
              </asp:TemplateField>

              <asp:TemplateField ShowHeader="False">
                <InsertItemTemplate>
                  <asp:ImageButton ID="btnInsert" CssClass="commands" runat="server" OnClientClick="return validateAlias()" CausesValidation="True" OnClick="btnInsert_Click" CommandName="Insert" ImageUrl="~/styles/icons/grids/update.png" Text="Insert" />
                  <asp:ImageButton ID="btnCancel" CssClass="commands" runat="server" CausesValidation="False" OnClick="btnCancel_Click" CommandName="Cancel" ImageUrl="~/styles/icons/grids/cancel.png" Text="Cancel" />
                </InsertItemTemplate>
                <ControlStyle CssClass="commands" />
              </asp:TemplateField>
            </Fields>

            <HeaderStyle Font-Bold="True" HorizontalAlign="Right" VerticalAlign="Top" />

          </asp:DetailsView>
        </asp:Panel>

      </asp:Panel>

    </asp:Panel>

  </div>

  <asp:SqlDataSource ID="SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="SELECT * FROM [alias]"
    UpdateCommand="UPDATE [alias] SET [alias]=@alias, [profile]=@profile, [guest]=@guest WHERE id = @id"
    DeleteCommand="DELETE [alias] WHERE id = @id"
    InsertCommand="INSERT [alias] (alias, profile, guest) VALUES (@alias, @profile, @guest) ">

    <DeleteParameters>
      <asp:Parameter Name="id" />
    </DeleteParameters>

    <InsertParameters>
      <asp:Parameter Name="alias" />
      <asp:Parameter Name="profile" />
      <asp:Parameter Name="guest" />
    </InsertParameters>

    <UpdateParameters>
      <asp:Parameter Name="alias" />
      <asp:Parameter Name="profile" />
      <asp:Parameter Name="guest" />
      <asp:Parameter Name="id" />
    </UpdateParameters>

  </asp:SqlDataSource>

</asp:Content>
