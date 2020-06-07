<%@ Page
  Title="Programs Purchased And Assigned"
  Language="C#"
  AutoEventWireup="true"
  MasterPageFile="~/v7/site.master"
  EnableEventValidation="true"
  CodeBehind="programsPurchasedAndAssigned.aspx.cs"
  Inherits="portal.v7.facilitator.programsPurchasedAndAssigned" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/programsPurchasedAndAssigned.min.css" rel="stylesheet" />
  <script>
    $(function () {
      $(".panConfirmShell").hide();
    })
    function displayProgDetails(progId, progTitle) {
      $('.labTitle').text(progId)
      $('.labBody').text(progTitle)
      $('.panConfirmShell').show()
    }
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

    <asp:Panel ID="panConfirmShell" CssClass="panConfirmShell" runat="server"  Height="200px">
      <asp:Panel ID="panConfirm" CssClass="panConfirm" runat="server">
        <table style="width: 300px;  margin: 0px; margin: auto; border: none;">
          <tr>
            <td>
              <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnExit" runat="server"
                OnClientClick='$(".panConfirmShell").hide(); return false;' />
            </td>
          </tr>
          <tr>
            <td>
              <h1>
                <asp:Label CssClass="labTitle" runat="server"></asp:Label>
              </h1>
            </td>
          </tr>
          <tr>
            <td  vertical-align: text-top">
              <h2><asp:Label CssClass="labBody" runat="server"></asp:Label></h2>
            </td>
          </tr>
        </table>
      </asp:Panel>
    </asp:Panel>

    <h1>
      <span onclick="fadeIn()" class="hoverUnderline" title="Click to hide/show discription.">
        <asp:Label ID="labHeader" runat="server" />
      </span>
    </h1>


    <%--     
        <asp:Literal ID="litMembCount" runat="server" /> Active and Inactive Learners have had 
        <asp:Literal ID="litProgCount" runat="server" /> Program(s) assigned to them.

        Click on any Program Id for the Program Title.
        Click on the Learners Icon to see which learners were assigned that Program Id.
    --%>



    <div class="thisTitle">
      <asp:Panel runat="server">
        <asp:Literal runat="server" Text="<%$  Resources:portal, progsPurch_2%>" />
        <asp:Literal runat="server" Text="<%$  Resources:portal, progsPurch_3%>" />
        <asp:Label ID="labInactive" Visible="false" Text="<%$  Resources:portal, progsPurch_5%>" runat="server" />
        <asp:Literal ID="litNone" runat="server" Visible="false">Because this Account does not contain any Purchased Programs, it cannot be generated.</asp:Literal>
      </asp:Panel>
    </div>

    <asp:GridView runat="server"
      AllowPaging="True"
      AutoGenerateColumns="False"
      CellPadding="3"
      CssClass="gvPurchasedAndAssigned"
      DataKeyNames="progId"
      DataSourceID="SqlDataSource1"
      HorizontalAlign="Center"
      ID="gvPurchasedAndAssigned"
      OnPreRender="gvPurchasedAndAssigned_PreRender"
      OnRowDataBound="gvPurchasedAndAssigned_RowDataBound"
      OnSelectedIndexChanged="gvPurchasedAndAssigned_SelectedIndexChanged"
      PageSize="20"
      Visible="True">
      <Columns>
        <asp:BoundField DataField="progId" HeaderText="<%$  Resources:portal, programId%>" />
        <asp:BoundField DataField="progPurchased" HeaderText="<%$  Resources:portal, purchased%>" ReadOnly="True" />
        <asp:BoundField DataField="progAssigned" HeaderText="<%$  Resources:portal, assigned%>" />
        <asp:TemplateField HeaderText="<%$  Resources:portal, learners%>">
          <ItemTemplate>
            <asp:ImageButton
              CssClass="icons info"
              ID="btnSelect"
              ToolTip="<%$  Resources:portal, progsPurch_4%>"
              runat="server"
              CausesValidation="True"
              CommandName="Select"
              ImageUrl="~/styles/icons/vubiz/info.png"
              />
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
      <PagerStyle CssClass="commands" HorizontalAlign="center" />
    </asp:GridView>

    <asp:GridView runat="server"
      AllowPaging="True"
      AutoGenerateColumns="False"
      CellPadding="5"
      CssClass="gvPurchasedAndAssigned"
      DataKeyNames="progId,membActive"
      DataSourceID="SqlDataSource2"
      ID="gvLearners"
      OnRowDataBound="gvLearners_RowDataBound"
      OnPreRender="gvLearners_PreRender"
      PageSize="40"
      Visible="False">
      <Columns>
        <asp:BoundField DataField="progId" HeaderText="<%$  Resources:portal, programId%>" />
        <asp:BoundField DataField="membId" HeaderText="<%$  Resources:portal, learners_1%>"  HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="left" />
        <asp:BoundField DataField="membFirstName" HeaderText="<%$  Resources:portal, firstName%>"  HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
        <asp:BoundField DataField="membLastName" HeaderText="<%$  Resources:portal, lastName%>"  HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
      </Columns>
      <PagerSettings
        FirstPageImageUrl="~/styles/icons/grids/frst.png"
        LastPageImageUrl="~/styles/icons/grids/last.png"
        NextPageImageUrl="~/styles/icons/grids/next.png"
        PreviousPageImageUrl="~/styles/icons/grids/prev.png"
        Position="Bottom"
        Mode="NextPreviousFirstLast" />
      <PagerStyle CssClass="commands" HorizontalAlign="center" />
    </asp:GridView>

    <asp:Panel ID="panRestart" runat="server" CssClass="panButtons" Visible="true">
      <asp:LinkButton CssClass="newButton panButton" OnClick="btnBack_Click" ID="btnBack" Text="<%$  Resources:portal, back%>" Visible="false" runat="server"></asp:LinkButton>
      <asp:LinkButton CssClass="newButton panButton" OnClick="btnRestart_Click" ID="btnRestart" Text="<%$  Resources:portal, restart%>" Visible="false" runat="server"></asp:LinkButton>
    </asp:Panel>

    <asp:SqlDataSource runat="server"
      ID="SqlDataSource1"
      ConnectionString="<%$ ConnectionStrings:apps %>"
      SelectCommand="
      	SELECT 
          @accounts                   AS custAcctId,
      		ec.Ecom_Programs				    AS progId,
          SUM(ABS(ec.Ecom_Quantity))  AS progPurchased,
                                         progAssigned = 
          (
 			      SELECT 
				      COUNT(pr.Prog_Id)
			      FROM 
				      V5_Vubz.dbo.Cust	      AS cu	INNER JOIN 
				      V5_Vubz.dbo.Memb	      AS me	ON cu.Cust_AcctId = me.Memb_AcctId INNER JOIN	
				      V5_Base.dbo.Prog	      AS pr ON CHARINDEX(pr.Prog_Id, me.Memb_Programs) &gt; 0
			      WHERE 
				      LEN(me.Memb_Programs)   &gt; 6        AND
				      me.Memb_Internal        = 0           AND
				      cu.Cust_AcctId          = @accounts   AND
				      pr.Prog_Id              = ec.Ecom_Programs
			      GROUP BY 
				      cu.Cust_Id,
				      pr.Prog_Id
          )
	      FROM 
		      V5_Vubz.dbo.Cust            AS cu		INNER JOIN 
		      V5_Vubz.dbo.Ecom            AS ec		ON cu.Cust_AcctId = ec.Ecom_NewAcctId     
	      WHERE 
          cu.Cust_AcctId = @accounts AND 
          ec.Ecom_Archived IS NULL  
        GROUP BY 
		      ec.Ecom_Programs
	      ORDER BY
		      ec.Ecom_Programs
      ">

      <SelectParameters>
        <asp:SessionParameter Name="accounts" SessionField="custAcctId" />
      </SelectParameters>

    </asp:SqlDataSource>

    <asp:SqlDataSource runat="server"
      ID="SqlDataSource2"
      ConnectionString="<%$ ConnectionStrings:apps %>"
      SelectCommand="
        SELECT 
          @progId                       AS progId, 
          me.Memb_Id                    AS membId, 
          me.Memb_FirstName             AS membFirstName, 
          me.Memb_LastName              AS membLastName, 
          me.Memb_Active                AS membActive, 
          CASE me.Memb_Active
            WHEN '0' THEN 'N'
            WHEN '1' THEN 'Y'
          END                           AS membActiveText
        FROM 
          V5_Vubz.dbo.Memb              AS me
        WHERE 
          me.Memb_AcctId                = @accounts AND
          CHARINDEX(@progId, me.Memb_Programs) &gt; 0 AND
          me.Memb_Internal              = 0 
        ORDER BY 
          me.Memb_LastName, 
          me.Memb_FirstName
      ">


      <SelectParameters>
        <asp:SessionParameter Name="accounts" SessionField="custAcctId" DefaultValue="3KWD" />
        <asp:ControlParameter Name="progId" ControlID="gvPurchasedAndAssigned" DefaultValue="P4610EN" PropertyName="SelectedValue" />
      </SelectParameters>

    </asp:SqlDataSource>

  </div>

</asp:Content>
