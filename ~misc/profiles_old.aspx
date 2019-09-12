<%@ Page
  Title="Learners"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="profiles.aspx.cs"
  Inherits="portal.v7.administrator.profiles" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">

  <style>
    .divPage {
      width: 800px;
    }

    .gvProfiles tr:first-child th,
    .gvProfiles tr:first-child th a {
      color: white;
      font-weight: bold;
      height: 30px;
    }

    .gvProfiles th:nth-child(1),
    .gvProfiles tr:not(:last-child) td:nth-child(1) {
      text-align: left;
    }

    .gvProfiles tr:last-child td * {
      border: none;
      text-align: center;
      margin: 5px;
    }
  </style>

</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/x.png" ID="exit" runat="server" OnClick="exit_Click" />

    <asp:Panel ID="panPage" CssClass="panPage" runat="server">

      <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

        <asp:Panel ID="panTop" CssClass="panTop" runat="server">

          <h1 class="title1">
            <asp:Literal runat="server" Text="">Profiles (coming)</asp:Literal>
            <asp:ImageButton CssClass="commands" ImageUrl="~/styles/icons/grids/add.png" CommandName="Insert" ToolTip="Add a Learner" runat="server" />
          </h1>

          <%--         <p class="c3">
            <asp:Literal runat="server" Text="
              Click on the Profile column header to Sort the Profiles, the Add icon at top to Add a Profile 
              and the Details icon at Right for Profile Details. 
              You can narrow this list by searching Profiles for ..." /><br />
            <table style="margin: auto; border: none;">
              <tr>
                <td style="vertical-align: top; border: none;">
                  <asp:TextBox ID="txtSearch" CssClass="alignCenter" placeholder="Profile" runat="server" />
                </td>
                <td style="vertical-align: top; border: none;">
                  <asp:Button ID="butSearch" CssClass="button" OnClick="butSearch_Click" runat="server" Text="Search" />
                </td>
              </tr>
            </table>
          </p>--%>

          <%--       <asp:GridView runat="server"
            ID="gvProfiles"
            CssClass="gvProfiles"
            HorizontalAlign="Center"
            Width="90%"
            AutoGenerateColumns="False"
            DataSourceID="SqlDataSource1"
            DataKeyNames="profile"
            AllowSorting="True"
            AllowPaging="True"
            PageSize="15">

            <Columns>
              <asp:BoundField DataField="profile" HeaderText="Profile" SortExpression="profile" />
              <asp:TemplateField HeaderText="Details">
                <ItemTemplate>
                  <asp:ImageButton CssClass="commands" ID="btnSelect" runat="server" CausesValidation="True"
                    CommandName="Select" ImageUrl="~/styles/icons/grids/details.png" Text="Details" />
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

            <PagerStyle HorizontalAlign="Center" CssClass="commands" />

          </asp:GridView>--%>

          <asp:Table runat="server" class="tbProfiles" Style="border: none; margin: auto;">
            <asp:TableRow>

              <asp:TableCell ID="tdProfileList" CssClass="tdProfileList">

                <div style="margin: 0px auto; margin-bottom: 20px; text-align: center;" class="c3">
                  Click on the Profile header to sort the Profile list.
                <table style="margin: auto; border: none;">
                  <tr>
                    <td style="vertical-align: top; border: none;">
                      <asp:TextBox ID="txtSearch1" CssClass="alignCenter" placeholder="Profile" runat="server" />
                    </td>
                    <td style="vertical-align: top; border: none;">
                      <asp:Button ID="butSearch1" CssClass="button" xOnClick="butSearch_Click" runat="server" Text="Search" />
                    </td>
                  </tr>
                </table>
                </div>

                <table class="tbProfileList">
                  <tr class="gradient">
                    <td class="h01">
                      <a href="javascript:__doPostBack('ctl00$MainContent$gvProfileList','Sort$profile')">Profile</a>
                    </td>
                  </tr>
                </table>

                <div style="overflow: scroll; height: 500px;">
                  <asp:GridView CssClass="gvProfileList" ShowHeader="False" ID="gvProfileList" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="profile" DataSourceID="SqlDataSource1" AllowSorting="True" AlternatingRowStyle-BackColor="#e6e6e6"
                    OnSelectedIndexChanged="gvProfileList_SelectedIndexChanged">
                    <Columns>
                      <asp:BoundField ItemStyle-CssClass="c01" DataField="profile" HeaderText="Profile" SortExpression="profile" />
                      <asp:CommandField ItemStyle-CssClass="c02" ShowSelectButton="True" ControlStyle-CssClass="button" SelectText="Details" />
                    </Columns>
                  </asp:GridView>
                </div>

              </asp:TableCell><asp:TableCell ID="tdProfileData" CssClass="tdProfileData">

                <%--     <div style="margin: 0px auto; margin-bottom: 20px; text-align: center;" class="c3">
                  Click "Edit" to modify any Value. Click the any Parameter for a description.
                </div>--%>

                <table class="tbProfileData">
                  <tr class="gradient">
                    <td class="h01">
                      <asp:Localize runat="server" Text="Profile" /></td>
                    <td class="h02">
                      <asp:Localize runat="server" Text="Parameter" /></td>
                    <td class="h03">
                      <asp:Localize runat="server" Text="Value" /></td>
                    <td class="h04">
                      <asp:Localize runat="server" Text="Action" /></td>
                  </tr>
                </table>

                <asp:GridView CssClass="gvProfileData" ShowHeader="False" ID="GridView1" runat="server" AutoGenerateColumns="False"
                  DataKeyNames="profile, parameter" DataSourceID="SqlDataSource2" AllowSorting="True" AlternatingRowStyle-BackColor="#e6e6e6"
                  OnSelectedIndexChanged="gvProfileData_SelectedIndexChanged">
                  <Columns>
                    <asp:BoundField DataField="profile" HeaderText="Profile" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Parameter">
                      <ItemTemplate>
                        <asp:LinkButton ID="lnkPopupDesc" Text='<%# Eval("Parameter") %>' OnCommand="lnkPopupDesc_Command" CommandArgument='<%# Eval("Popup") %>' runat="server">LinkButton</asp:LinkButton>
                      </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="value" HeaderText="Value" />
                    <asp:CommandField ControlStyle-CssClass="button" HeaderText="Action" ShowEditButton="True" />
                  </Columns>
                </asp:GridView>

                <asp:Button ID="butBack" CssClass="butBack" runat="server" OnClick="butBack_Click" Text="Back" />

              </asp:TableCell></asp:TableRow></asp:Table></asp:Panel><asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">
          <asp:DetailsView runat="server"
            ID="dvProfiles"
            CssClass="detailsView"
            AutoGenerateRows="False"
            Height="50px"
            Width="125px"
            DataSourceID="SqlDataSource2">
            <Fields>
              <asp:BoundField DataField="Profile" HeaderText="Profile" ReadOnly="True" SortExpression="Profile" />
              <asp:BoundField DataField="Parameter" HeaderText="Parameter" SortExpression="Parameter" />
              <asp:BoundField DataField="Value" HeaderText="Value" SortExpression="Value" />
              <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
              <asp:BoundField DataField="Popup" HeaderText="Popup" ReadOnly="True" SortExpression="Popup" />
            </Fields>
          </asp:DetailsView>

          <img class="panProfileExit" src="/portal/styles/icons/x.png" />
          <div class="divProfileDesc">
            <asp:Label CssClass="labProfileDesc" ID="labProfileDesc" runat="server" Text=""></asp:Label></div></asp:Panel></asp:Panel></asp:Panel></div><asp:SqlDataSource
    ID="SqlDataSource1"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT DISTINCT
        profile
      FROM 
        [apps].[dbo].[profiles] 
      WHERE 
        CHARINDEX('_', profile) &gt; 0 AND 
        (LEN(@search) = 0 OR @search IS NULL OR  @search = '*' OR profile LIKE '%' + @search + '%' ) 
      ORDER BY  
        profile">
    <SelectParameters>
      <asp:ControlParameter ControlID="txtSearch" DefaultValue="*" Name="search" PropertyName="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource
    ID="SqlDataSource2"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
        SELECT 
          @profile              As Profile,
          [name]                AS Parameter,
          [value]               AS Value,
          [desc]                AS Description,
          [name] + '|' + [desc] AS Popup
        FROM 
          [apps].dbo.parameter as pa left outer join 
          [apps].[dbo].[profiles] as pr on parameter = name and profile=@profile
        ORDER BY 
          name
      "
    UpdateCommand="
        UPDATE 
          apps.dbo.profiles 
        SET 
          [value] = @value
        WHERE 
          [profile] = @profile AND [parameter] = @parameter 
      ">

    <SelectParameters>
      <asp:ControlParameter ControlID="gvProfiles" Name="profile"
        PropertyName="SelectedValue" Type="String" />
    </SelectParameters>

    <UpdateParameters>
      <asp:Parameter Name="profile" Type="String" />
      <asp:Parameter Name="parameter" Type="String" />
      <asp:Parameter Name="value" Type="String" />
    </UpdateParameters>

  </asp:SqlDataSource>
</asp:Content>
