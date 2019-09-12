<%@ Page
  Title="Profiles"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="profiles.aspx.cs"
  Inherits="portal.v7.administrator.profiles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/profiles.css" rel="stylesheet" />
  <script>
    $(function () {
      $(".deleteThis").on("click", function () {
        $(".gvProfile").hide();
      });
    });
  </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="Exit_Click" />
    <br /><br />

    <h1>
      <span onclick="fadeIn()" class="hoverUnderline" title="Click to show discription.">Profiles (coming)</span>
      <asp:ImageButton CssClass="icons" ImageUrl="~/styles/icons/vubiz/add.png" CommandName="Insert" ToolTip="Add a Learner" runat="server" />
    </h1>

    <div class="thisTitle">
      V8 requires a Profile which contains a series of parameters that will personalize the learning experience. 
			The Profile name should define both the Organization plus the language, ie 'cchs_fr'. 
			There are a lot of possible parameters you can use in the profile but only a few are mandatory.      
			Note: Once you have created the Profile then you can create a more friendly 'Alias' to access it. 
			For example you might create an Alias 'ccohs' for Profile 'cchs_en', or 'cchst' for 'cchs_fr'. 
			When you access /v8?profile=cchst, the 'cchst' is actually the Alias not the Profile Id, but they can be the same.
			Click on the Add Icon at top to Add a Profile, the Edit Icon for Profile Details. 
      When the Details appear you can edit any Profile Parameter Value.
      Note: if you wish to remove a Parameter, simply remove it, ie set its value to empty.
			<span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
    </div>

    <table class="tabProfiles">
      <tr>
        <td>
          <asp:GridView runat="server"
            ID="gvProfiles"
            CssClass="gvProfiles"
            AutoGenerateColumns="False"
            DataSourceID="SqlDataSource1"
            OnSelectedIndexChanged="gvProfiles_SelectedIndexChanged"
            DataKeyNames="profile, showAll">
            <Columns>
              <asp:BoundField DataField="profile" HeaderText="Profile"></asp:BoundField>
              <asp:TemplateField HeaderText="Show All?">
                <ItemTemplate><asp:CheckBox ID="showAll" runat="server" AutoPostBack="true" /></ItemTemplate>
              </asp:TemplateField>
              <asp:CommandField HeaderText="Details" ButtonType="Image" SelectImageUrl="~/styles/icons/grids/edit.png" ShowSelectButton="True" SelectText="Details"></asp:CommandField>
            </Columns>
          </asp:GridView>
        </td>
        <td>
          <asp:GridView runat="server"
            ID="gvProfile"
            CssClass="gvProfile"
            AutoGenerateColumns="False"
            DataSourceID="SqlDataSource2"
            AllowSorting="True"
            OnSelectedIndexChanged="gvProfile_SelectedIndexChanged"
            DataKeyNames="id">
            <Columns>
              <asp:CommandField HeaderText="Edit" ButtonType="Image" EditImageUrl="~/styles/icons/grids/edit.png" ShowEditButton="True" CancelImageUrl="~/styles/icons/grids/cancel.png" UpdateImageUrl="~/styles/icons/grids/update.png" />
              <asp:BoundField DataField="id"  ReadOnly="true"  />
              <asp:BoundField DataField="profile" HeaderText="Profile" ReadOnly="true" />
              <asp:BoundField DataField="parameter" HeaderText="Parameter" SortExpression="parameter" ReadOnly="true" />
              <asp:BoundField DataField="value" HeaderText="Value" />
              <asp:BoundField DataField="desc" HeaderText="Description" ReadOnly="true"></asp:BoundField>
            </Columns>
          </asp:GridView>
        </td>
      </tr>
    </table>
  </div>

  <%--        value IS NOT NULL--%>



  <%-- select all profiles that contain an underscore, ie cchs_fr --%>
  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="     
			SELECT DISTINCT
				profile,
        '1' AS showAll
			FROM 
				[apps].[dbo].[profiles] 
			WHERE 
				CHARINDEX('_', profile) != 0 
			ORDER BY  
				profile
		"></asp:SqlDataSource>

  <%-- select the requested profile --%>
  <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
			SELECT
				pr.id AS id,
				@profile AS profile, 
				name AS parameter, 
				value,
				[desc]		
			FROM            
				apps.dbo.parameter	pa	LEFT OUTER JOIN
				apps.dbo.profiles		pr	ON pr.parameter = pa.name AND pr.profile = @profile
      WHERE
				@showAll = 'N' AND value is NOT NULL
				OR
				@showAll = 'Y'
			ORDER BY 
				name
		"

    UpdateCommand="
      IF @id IS NULL
    		INSERT INTO
			    dbo.profiles
			    (profile, parameter, value)
		    VALUES
			    (@profile, parameter, 'xx')
      ELSE
 			  UPDATE 
				  dbo.profiles
			  SET 
				  value = @value
			  WHERE 
				  id=@id

		">

    <SelectParameters>
      <asp:SessionParameter DefaultValue="N" Name="showAll" SessionField="showAll" />
      <asp:ControlParameter ControlID="gvProfiles" Name="profile" PropertyName="SelectedValue" Type="String" />
    </SelectParameters>

    <UpdateParameters>
      <asp:Parameter Name="id" />
      <asp:ControlParameter ControlID="gvProfiles" Name="profile" PropertyName="SelectedValue" Type="String" />
      <asp:Parameter Name="parameter" />
      <asp:Parameter Name="value" />
    </UpdateParameters>

  </asp:SqlDataSource>

</asp:Content>
