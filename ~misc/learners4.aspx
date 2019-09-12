<%@ Page Language="C#" AutoEventWireup="true"
	CodeBehind="learners4.aspx.cs"
	Inherits="portal.v7.facilitator.learners4" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>DetailsView ModeChanging Example</title>
</head>
<body>
	<form id="Form1" runat="server">

		<h3>DetailsView ModeChanging Example</h3>

		<asp:DetailsView ID="CustomerDetailView"
			DataSourceID="DetailsViewSource"
			DataKeyNames="CustomerID"
			AutoGenerateRows="False"
			AutoGenerateEditButton="True"
			OnDataBound="CustomerDetailView_DataBound"
			AllowPaging="True"
			runat="server">

			<FieldHeaderStyle BackColor="Navy"
				ForeColor="White" />

			<Fields>
				<asp:BoundField DataField="CustomerID" HeaderText="CustomerID" ReadOnly="True" SortExpression="CustomerID" />
				<asp:BoundField DataField="CompanyName" HeaderText="CompanyName" SortExpression="CompanyName" />
				<asp:BoundField DataField="Address" HeaderText="Address" SortExpression="Address" />
				<asp:BoundField DataField="City" HeaderText="City" SortExpression="City" />
				<asp:BoundField DataField="PostalCode" HeaderText="PostalCode" SortExpression="PostalCode" />
				<asp:BoundField DataField="Country" HeaderText="Country" SortExpression="Country" />
				<asp:CommandField ShowInsertButton="True" />
			</Fields>

		</asp:DetailsView>

		<!-- This example uses Microsoft SQL Server and connects  -->
		<!-- to the Northwind sample database. Use an ASP.NET     -->
		<!-- expression to retrieve the connection string value   -->
		<!-- from the web.config file.                            -->
		<asp:SqlDataSource ID="DetailsViewSource" runat="server"
			ConnectionString="<%$ ConnectionStrings:apps %>"
			InsertCommand="INSERT INTO [Customers]([CustomerID],
            [CompanyName], [Address], [City], [PostalCode], [Country]) 
            VALUES (@CustomerID, @CompanyName, @Address, @City, 
            @PostalCode, @Country)"
			SelectCommand="Select [CustomerID], [CompanyName], 
            [Address], [City], [PostalCode], [Country] From 
            [Customers]"></asp:SqlDataSource>
	</form>
</body>
</html>
