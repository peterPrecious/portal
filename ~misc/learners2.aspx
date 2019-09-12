<%@ Page
	Title="Learners"
	Language="C#"
	MasterPageFile="~/v7/site.master"
	AutoEventWireup="true"
	CodeBehind="learners2.aspx.cs"
	Inherits="portal.v7.facilitator.learners2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

	<div class="divPage" style="width: 1000px;">

		<asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

		<asp:ImageButton CssClass="icons add" OnClick="dvLearner_ItemInit" ImageUrl="~/styles/icons/vubiz/add.png" CommandName="Insert" ToolTip="Add a Learner" runat="server" />

		<asp:GridView runat="server"
			ID="gvLearners"
			DataKeyNames="membNo"
			DataSourceID="SqlDataSource1"
			AutoGenerateColumns="False">
			<Columns>
				<asp:CommandField ShowSelectButton="True" />
				<asp:BoundField DataField="membNo" HeaderText="membNo" SortExpression="membNo" InsertVisible="False" ReadOnly="True" />
				<asp:BoundField DataField="membId" HeaderText="membId" SortExpression="membId" />
				<asp:BoundField DataField="membFirstName" HeaderText="membFirstName" SortExpression="membFirstName" />
				<asp:BoundField DataField="membLastName" HeaderText="membLastName" SortExpression="membLastName" />
				<asp:BoundField DataField="membEmail" HeaderText="membEmail" SortExpression="membEmail" />
			</Columns>
		</asp:GridView>


		<asp:DetailsView runat="server"
			ID="dvLearner"
			DataSourceID="SqlDataSource2"
			DataKeyNames="membNo"
			AutoGenerateRows="False">
			<Fields>
				<asp:BoundField DataField="membNo" HeaderText="membNo" InsertVisible="False" ReadOnly="True" SortExpression="membNo" />
				<asp:BoundField DataField="membId" HeaderText="membId" SortExpression="membId" />
				<asp:BoundField DataField="membPwd" HeaderText="membPwd" SortExpression="membPwd" />
				<asp:BoundField DataField="membFirstName" HeaderText="membFirstName" SortExpression="membFirstName" />
				<asp:BoundField DataField="membLastName" HeaderText="membLastName" SortExpression="membLastName" />
				<asp:BoundField DataField="membEmail" HeaderText="membEmail" SortExpression="membEmail" />
				<asp:BoundField DataField="membOrganization" HeaderText="membOrganization" SortExpression="membOrganization" />
				<asp:BoundField DataField="membMemo" HeaderText="membMemo" SortExpression="membMemo" />
				<asp:BoundField DataField="membPrograms" HeaderText="membPrograms" SortExpression="membPrograms" />
				<asp:BoundField DataField="membLevel" HeaderText="membLevel" SortExpression="membLevel" />
				<asp:CheckBoxField DataField="membEmailAlert" HeaderText="membEmailAlert" SortExpression="membEmailAlert" />
				<asp:CheckBoxField DataField="membActive" HeaderText="membActive" SortExpression="membActive" />
				<asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" />
			</Fields>
		</asp:DetailsView>

	</div>

	<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
		SelectCommand="
      SELECT TOP 20 
        [Memb_No] AS membNo, 
        [Memb_Id] AS membId, 
        [Memb_FirstName] AS membFirstName, 
        [Memb_LastName] AS membLastName,
        [Memb_Email] AS membEmail 
      FROM 
        V5_Vubz.dbo.Memb
      WHERE
        Memb_AcctId = '3HP5' AND
				Memb_Internal = 0

      ORDER BY 
        Memb_LastName, 
        Memb_FirstName 
    "></asp:SqlDataSource>

	<asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
		SelectCommand="
      SELECT 
        [Memb_No] AS membNo,
        [Memb_Id] AS membId,
        [Memb_Pwd] AS membPwd,
        [Memb_FirstName] AS membFirstName, 
        [Memb_LastName] AS membLastName, 
        [Memb_Email] AS membEmail,
        [Memb_Organization] AS membOrganization, 
        [Memb_Memo] AS membMemo,
        [Memb_Programs] AS membPrograms,
        [Memb_Level] AS membLevel,
        [Memb_EcomG2Alert] AS membEmailAlert,
        [Memb_Active] AS membActive
      FROM 
        V5_Vubz.dbo.Memb  
      WHERE 
        ([Memb_No] = @membNo)
    "
		UpdateCommand="
      UPDATE 
        V5_Vubz.dbo.Memb 
      SET 
        [Memb_Id]=UPPER(@membId),
        [Memb_Pwd]=UPPER(ISNULL(@membPwd, '')),
        [Memb_FirstName]=@membFirstName, 
        [Memb_LastName]=@membLastName, 
        [Memb_Email]=LOWER(@membEmail),
        [Memb_Organization]=@membOrganization, 
        [Memb_Memo]=@membMemo, 
        [Memb_Level]=@membLevel, 
        [Memb_EcomG2Alert]=@membEmailAlert, 
        [Memb_Active]=@membActive
      WHERE 
        Memb_No = @membNo
    "
		DeleteCommand="
      DELETE 
        V5_Vubz.dbo.Memb  
      WHERE 
        Memb_No = @membNo
    "
		InsertCommand="
      INSERT 
        V5_Vubz.dbo.Memb   
        (Memb_Id, Memb_Pwd, Memb_AcctId, Memb_FirstName, Memb_LastName, Memb_Email, Memb_Organization, Memb_Memo, Memb_Level, Memb_EcomG2Alert, Memb_Active) 
      VALUES 
        (UPPER(@membId), UPPER(ISNULL(@membPwd, '')), @membAcctId, @membFirstName, @membLastName, LOWER(@membEmail), @membOrganization, @membMemo, @membLevel, @membEmailALert, @membActive)
      ">

		<SelectParameters>
			<asp:ControlParameter ControlID="gvLearners" Name="membNo"
				PropertyName="SelectedValue" Type="Int32" />
		</SelectParameters>

		<UpdateParameters>
			<asp:Parameter Name="membId" />
			<asp:Parameter Name="membPwd" />
			<asp:Parameter Name="membFirstName" />
			<asp:Parameter Name="membLastName" />
			<asp:Parameter Name="membEmail" />
			<asp:Parameter Name="membOrganization" />
			<asp:Parameter Name="membMemo" />
			<asp:Parameter Name="membLevel" />
			<asp:Parameter Name="membEmailAlert" />
			<asp:Parameter Name="membActive" />
			<asp:Parameter Name="membNo" />
		</UpdateParameters>

		<DeleteParameters>
			<asp:Parameter Name="membNo" />
		</DeleteParameters>

		<InsertParameters>
			<asp:Parameter Name="membId" />
			<asp:Parameter Name="membPwd" />
			<asp:Parameter Name="membAcctId" DefaultValue="3HP5" />
			<asp:Parameter Name="membFirstName" />
			<asp:Parameter Name="membLastName" />
			<asp:Parameter Name="membEmail" />
			<asp:Parameter Name="membOrganization" />
			<asp:Parameter Name="membMemo" />
			<asp:Parameter Name="membLevel" />
			<asp:Parameter Name="membEmailAlert" />
			<asp:Parameter Name="membActive" />
		</InsertParameters>

	</asp:SqlDataSource>

</asp:Content>
