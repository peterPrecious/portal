<%@ Page
  Title=""
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="modules.aspx.cs"
  Inherits="portal.v7.administrator.modules" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/modules.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server" DefaultButton="butSearch">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="Exit_Click" />

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

      <asp:Panel ID="panTop" CssClass="panTop" runat="server">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline" title="Click to show discription.">Modules (coming)</span>
          <asp:ImageButton CssClass="icons" ImageUrl="~/styles/icons/vubiz/add.png" CommandName="Insert" ToolTip="Add a Learner" runat="server" />
        </h1>

        <div class="thisTitle">
          Select
          <asp:DropDownList CssClass="dropDown" ID="ddActive" Style="border: none; background-color: #0178B9; color: white; border: 1px solid white;" runat="server">
            <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
            <asp:ListItem Value="2">Inactive</asp:ListItem>
            <asp:ListItem Value="*">All</asp:ListItem>
          </asp:DropDownList>
          Modules whose Module Id or Title contains the Search Value.
          Note: if you leave the Search Value empty the list will start at the beginning.
          You can sort on the Module Id.
			    <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
          <div style="margin-top: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="<%$  Resources:portal, searchValue%>" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="<%$  Resources:portal, search%>" />
          </div>

        </div>

        <asp:GridView runat="server"
          ID="gvModules"
          CssClass="gvModules"
          HorizontalAlign="Center"
          AutoGenerateColumns="False"
          PageSize="20"
          DataKeyNames="modsNo"
          OnSelectedIndexChanged="gvModules_SelectedIndexChanged"
          DataSourceID="SqlDataSource1"
          AllowPaging="True"
          AllowSorting="True">
          <Columns>
            <asp:BoundField DataField="modsNo" HeaderText="Mods_No" ReadOnly="True" InsertVisible="False" Visible="false" />
            <asp:BoundField DataField="modsId" HeaderText="Module Id" SortExpression="modsId" />
            <asp:BoundField DataField="modsTitle" HeaderText="Title" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
            <asp:TemplateField HeaderText="Details">
              <ItemTemplate>
                <asp:ImageButton
                  CssClass="icons info"
                  ID="btnSelect"
                  runat="server"
                  CausesValidation="True"
                  CommandName="Select"
                  ImageUrl="~/styles/icons/vubiz/info.png"
                  Text="Details" />
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

        <asp:ImageButton
          OnClick="ListLearners_Click"
          CssClass="icons"
          ImageUrl="~/styles/icons/vubiz/back.png"
          ToolTip="Return to List"
          runat="server" />

        <h1>
          <asp:Literal runat="server" Text="Add/Edit Module (coming)" />
          <asp:Label ForeColor="Yellow" Font-Bold="true" ID="labError" runat="server"></asp:Label>
        </h1>

        <h2 class="c2" style="margin-bottom: 22px;">Description is coming...</h2>

        <asp:DetailsView
          BorderStyle="None"
          ID="dvModule"
          runat="server"
          CssClass="dvModule"
          AutoGenerateRows="False"
          DataKeyNames="modsNo"
          DataSourceID="SqlDataSource2">
          <Fields>
            <asp:BoundField DataField="modsId" HeaderText="Module Id" />
            <asp:BoundField DataField="modsNo" HeaderText="[ Internal No ]" InsertVisible="False" ReadOnly="True" />
            <asp:BoundField DataField="modsTitle" HeaderText="Title" />
            <asp:BoundField DataField="modsDescription" HeaderText="Description" />
            <asp:BoundField DataField="modsActive" HeaderText="Active" />
            <asp:BoundField DataField="modsLength" HeaderText="Length (hours)" />

            <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icons">
              <EditItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnUpdate" runat="server" CausesValidation="True" CommandName="Update" ToolTip="Update Learner" />
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnInsert" runat="server" CausesValidation="True" CommandName="Insert" ToolTip="Add a Learner" />
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/edit.png" ID="btnEdit" runat="server" CausesValidation="True" CommandName="Edit" ToolTip="Edit Learner's Profile" />
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/delete.png" ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" ToolTip="Delete Learner" OnClientClick="return confirm('Are you certain you want to delete this Learner?')" />
              </ItemTemplate>
              <ControlStyle CssClass="icons edit" />
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
        Mods_Title            AS modsTitle
      FROM 
        V5_Base.dbo.mods
      WHERE
        LEN(@search) = 0 OR 
        @search IS NULL OR 
        @search = '*' OR 
        Mods_Id LIKE '%' + @search + '%' OR 
        Mods_Title LIKE '%' + @search + '%' 
      ORDER BY 
        Mods_Id
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
        Mods_Desc             AS modsDescription,
        Mods_Active           AS modsActive,
        Mods_Length           AS modsLength
      FROM 
        V5_Base.dbo.mods
      WHERE 
        Mods_No = @modsNo
      ">

    <SelectParameters>
      <asp:ControlParameter ControlID="gvmodules" Name="modsNo" PropertyName="SelectedValue" Type="Int32" />
    </SelectParameters>


  </asp:SqlDataSource>




</asp:Content>
