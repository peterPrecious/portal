<%@ Page 
  Title="Assessmentgs" 
  Language="C#" 
  AutoEventWireup="true"
  MasterPageFile="~/v7/site.master"
  CodeBehind="assessments.aspx.cs"
  Inherits="portal.v7.manager.assessments" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/assessments.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server" DefaultButton="butSearch">

      <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

      <h1>
        <span onclick="fadeIn()" class="hoverUnderline" title="Click to show discription.">Learner Assessments</span>
      </h1>

      <div class="thisTitle">
        Select an Active Learner whose Username, First Name, Last Name or Email Address contains the Search Value. 
			  From the list returned (maximum 100) find the Learner.
			  If there is an Edit Icon (in the Action column) then clicking that allows you to view their Assessments.
			  If there is no Icon then there are no Assessments on file for this learner.
        You can scroll down after your selection as the new screens appear at the top.
			  <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
        <div style="margin: 30px; text-align: center;">
          <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="<%$  Resources:portal, searchValue%>" runat="server" />
          <asp:Button ID="butSearch" CssClass="button" runat="server" Text="<%$  Resources:portal, search%>" />
        </div>
      </div>

      <asp:GridView runat="server"
        ID="gvLearner"
        CssClass="gvLearner"
        Width="95%"
        HorizontalAlign="Center"
        ShowHeader="False"
        DataSourceID="SqlDataSource2"
        AutoGenerateColumns="False">
        <Columns>
          <asp:BoundField DataField="name" HeaderText="name" ReadOnly="True" />
        </Columns>
      </asp:GridView>

      <asp:GridView runat="server"
        ID="gvAssess"
        Width="95%"
        CssClass="gvAssess"
        AutoGenerateColumns="False"
        HorizontalAlign="Center"
        AllowSorting="True"
        AllowPaging="True"
        PageSize="12"
        OnSelectedIndexChanged="gvAssess_SelectedIndexChanged"
        DataKeyNames="membNo, modsNo, progNo, sessId"
        DataSourceID="SqlDataSource3">
        <Columns>
          <asp:BoundField DataField="progId" HeaderText="Program" SortExpression="progId" />
          <asp:BoundField DataField="modsId" HeaderText="Module" SortExpression="modsId" />
          <asp:BoundField DataField="sesTitle" HeaderText="Title" SortExpression="sesTitle" />
          <asp:BoundField DataField="sesLastPosted" HeaderText="Posted" SortExpression="sesLastPosted" DataFormatString="{0:MMM d, yyyy hh:mm}" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
          <asp:BoundField DataField="sesExpires" HeaderText="Expires" SortExpression="sesExpires" DataFormatString="{0:g}" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
          <asp:BoundField DataField="sesObjScoreRaw" HeaderText="Score" SortExpression="sesObjScoreRaw" />
          <asp:BoundField DataField="sesCompleted" HeaderText="Completed" SortExpression="sesCompleted" DataFormatString="{0:MMM d, yyyy hh:mm}" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
          <asp:CommandField HeaderText="Edit" HeaderStyle-Width="45px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ButtonType="Image" SelectImageUrl="~/styles/icons/grids/edit.png" ShowSelectButton="True" SelectText="Details" />
        </Columns>
        <PagerSettings
          FirstPageImageUrl="~/styles/icons/grids/frst.png"
          LastPageImageUrl="~/styles/icons/grids/last.png"
          NextPageImageUrl="~/styles/icons/grids/next.png"
          PreviousPageImageUrl="~/styles/icons/grids/prev.png"
          Position="Bottom"
          Mode="NextPreviousFirstLast" />
        <PagerStyle CssClass="commands" HorizontalAlign="Center" />
      </asp:GridView>

      <asp:GridView runat="server"
        ID="gvLearners"
        CssClass="gvLearners"
        Width="95%"
        AutoGenerateColumns="False"
        HorizontalAlign="Center"
        AllowSorting="True"
        AllowPaging="True"
        PageSize="12"
        DataKeyNames="membNo,numAssessments"
        DataSourceID="SqlDataSource1">
        <Columns>
          <asp:BoundField DataField="membId" HeaderText="Username" SortExpression="membId" />
          <asp:BoundField DataField="membFirstName" HeaderText="First Name" SortExpression="membFirstName" />
          <asp:BoundField DataField="membLastName" HeaderText="Last Name" SortExpression="membLastName" />
          <asp:BoundField DataField="membEmail" HeaderText="Email" SortExpression="membEmail" />
          <asp:TemplateField HeaderText="Action" ShowHeader="False" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="45px">
            <ItemTemplate>
              <asp:ImageButton runat="server" ID="ImageButton1" CausesValidation="False" CommandName="Select" ImageUrl="~/styles/icons/grids/edit.png" Visible='<%# hasAssessments((int)Eval("numAssessments")) %>' />
            </ItemTemplate>
          </asp:TemplateField>
        </Columns>
        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
        <RowStyle HorizontalAlign="Left"></RowStyle>
        <PagerSettings
          FirstPageImageUrl="~/styles/icons/grids/frst.png"
          LastPageImageUrl="~/styles/icons/grids/last.png"
          NextPageImageUrl="~/styles/icons/grids/next.png"
          PreviousPageImageUrl="~/styles/icons/grids/prev.png"
          Position="Bottom"
          Mode="NextPreviousFirstLast" />
        <PagerStyle CssClass="commands" HorizontalAlign="Center" />
      </asp:GridView>

    </asp:Panel>

  </div>

  <%-- this pulls up Bryan's mini ScormEditor --%>
  <asp:Panel ID="miniEditorShell" CssClass="miniEditorShell" runat="server" Visible="false">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="imgClose" runat="server" OnClick="imgClose_Click" />
    <iframe class="miniEditor" id="miniEditor" runat="server"></iframe>
  </asp:Panel>

  <%-- this reads all selected learners --%>
  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
			SELECT TOP (100) 
				Memb_No                   AS membNo, 
				Memb_Id                   AS membId, 
				Memb_FirstName            AS membFirstName, 
				Memb_LastName             AS membLastName, 
				Memb_Email                AS membEmail,
				COUNT(so.sesObjScoreRaw)  AS numAssessments 
			FROM 
				V5_Vubz.dbo.Memb AS me                                          LEFT OUTER JOIN
				vuGoldSCORM.dbo.Session AS se ON se.sesMembID = me.Memb_No      LEFT OUTER JOIN
				vuGoldSCORM.dbo.SessionObjective AS so ON so.sesId = se.sesID     
			WHERE 
				(Memb_AcctId = @custAcctId) 
        AND 
        (Memb_Active = 1) 
        AND 
        (Memb_Internal = 0)
				AND
				(
					LEN(@search)    = 0                      OR
					Memb_FirstName  LIKE '%' + @search + '%' OR
					Memb_LastName   LIKE '%' + @search + '%' OR
					Memb_Id         LIKE '%' + @search + '%' OR
					Memb_Email      LIKE '%' + @search + '%' 
				)
			GROUP BY
				Memb_No, 
				Memb_Id, 
				Memb_FirstName, 
				Memb_LastName, 
				Memb_Email
			ORDER BY
				Memb_LastName, 
        Memb_FirstName
		">
    <SelectParameters>
      <asp:SessionParameter Name="custAcctId" SessionField="custAcctId" DefaultValue="2544" />
      <asp:ControlParameter ControlID="txtSearch" DefaultValue="a" Name="search" PropertyName="Text" />
    </SelectParameters>
  </asp:SqlDataSource>

  <%-- this reads the learners name for the grid header --%>
  <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
			SELECT            
				me.Memb_FirstName + ' ' + me.Memb_LastName + ' (' + me.Memb_Id + ')' + ' - ' + me.Memb_Email AS name
			FROM            
				V5_Vubz.dbo.Memb AS me 
			WHERE        
				(me.Memb_No = @membId)  
		">
    <SelectParameters>
      <asp:ControlParameter ControlID="gvLearners" Name="membId" PropertyName="SelectedValue" />
    </SelectParameters>
  </asp:SqlDataSource>

  <%-- this reads the assessment info the the selected learner --%>
  <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
			SELECT        
				me.Memb_No AS membNo, 
				me.Memb_Id AS membId, 
				pr.Prog_NO AS progNo, 
				pr.Prog_Id AS progId, 
				mo.Mods_No AS modsNo, 
				mo.Mods_Id AS modsId, 
				se.sesID   AS sessId,
				se.sesTitle, 
				se.sesLastPosted, 
				se.sesExpires,
				se.sesCompleted,
				so.sesObjScoreRaw
			FROM            
				V5_Vubz.dbo.Memb AS me                                              INNER JOIN
				vuGoldSCORM.dbo.Session AS se ON se.sesMembID = me.Memb_No          LEFT OUTER JOIN
				vuGoldSCORM.dbo.SessionObjective AS so ON so.sesId = se.sesID       LEFT OUTER JOIN
				V5_Base.dbo.Prog AS pr ON pr.Prog_No = se.sesProgramID              LEFT OUTER JOIN
				V5_Base.dbo.Mods AS mo ON mo.Mods_No = se.sesModuleID
			WHERE        
				(me.Memb_No = @membId) 
			ORDER BY
				se.sesLastPosted DESC, se.sesID DESC   
		">
    <SelectParameters>
      <asp:ControlParameter ControlID="gvLearners" Name="membId" PropertyName="SelectedValue" />
    </SelectParameters>
  </asp:SqlDataSource>

</asp:Content>
