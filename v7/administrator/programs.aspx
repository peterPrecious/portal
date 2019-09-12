<%@ Page
  Title="Programs"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="programs.aspx.cs"
  Inherits="portal.v7.administrator.programs" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/programs.css" rel="stylesheet" />

</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="Exit_Click" />

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server" DefaultButton="butSearch">

      <asp:Panel ID="panTop" CssClass="panTop" runat="server">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline" title="Click to show discription.">Programs (coming)</span>
          <asp:ImageButton CssClass="icons" ImageUrl="~/styles/icons/vubiz/add.png" CommandName="Insert" ToolTip="Add a Learner" runat="server" />
        </h1>

        <div class="thisTitle">
          Select Programs whose Program Id or Title contains the Search value.
          Note: if you leave the search selector empty the list will start at the beginning.
			    <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>

          <div style="margin-top: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="<%$  Resources:portal, searchValue%>" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="<%$  Resources:portal, search%>" />
          </div>
        </div>

        <asp:GridView runat="server"
          ID="gvPrograms"
          CssClass="gvPrograms"
          HorizontalAlign="Center"
          AutoGenerateColumns="False"
          AllowPaging="True"
          Width="300px"
          PageSize="20"
          CellPadding="5"
          DataKeyNames="progId"
          OnSelectedIndexChanged="gvPrograms_SelectedIndexChanged"
          DataSourceID="SqlDataSource1">
          <Columns>
            <asp:BoundField DataField="progId" HeaderText="Program Id" />
            <asp:BoundField DataField="progTitle" HeaderText="Title"
              HeaderStyle-HorizontalAlign="Left"
              ItemStyle-HorizontalAlign="Left" />
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
            <br />
            There are currently no Programs based on your Selection criteria.<br />
            <br />
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
          <asp:Literal runat="server" Text="Add/Edit Program (coming)" />
          <asp:Label ForeColor="Yellow" Font-Bold="true" ID="labError" runat="server"></asp:Label>
        </h1>

        <h2 class="c2" style="margin-bottom: 22px;">Description is coming...</h2>

        <asp:DetailsView
          BorderStyle="None"
          ID="dvPrograms"
          runat="server"
          CssClass="dvPrograms"
          AutoGenerateRows="False"
          DataKeyNames="progId"
          DataSourceID="SqlDataSource2">
          <Fields>
            <asp:BoundField DataField="progId" HeaderText="Program Id" />
            <asp:BoundField DataField="progNo" HeaderText="(Internal No)" InsertVisible="False" ReadOnly="True" />
            <asp:TemplateField HeaderText="Title">
              <EditItemTemplate>
                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("progTitle") %>' TextMode="MultiLine"
                  
                    Height="50" Width="300"
                  ></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("progTitle") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%# Bind("progTitle") %>'></asp:Label>
              </ItemTemplate>
              <ItemStyle Height="100px" />
            </asp:TemplateField>
            <asp:BoundField DataField="progDescription" HeaderText="Description" />
            <asp:BoundField DataField="progModules" HeaderText="Modules" />

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
        Prog_Id               AS progId,
        Prog_Title1           AS progTitle
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
        Prog_Title1           AS progTitle,
        Prog_Desc             AS progDescription,
        Prog_Mods             AS progModules
      FROM 
        V5_Base.dbo.Prog
      WHERE 
        Prog_Id = @progId
    ">
    <SelectParameters>
      <asp:ControlParameter ControlID="gvPrograms" Name="progId" PropertyName="SelectedValue" Type="String" />
    </SelectParameters>
  </asp:SqlDataSource>

</asp:Content>
