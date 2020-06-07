<%@ Page
  Title="Customer Sales Summary"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="customerSalesSummary.aspx.cs"
  Inherits="portal.v7.analytics.customerSalesSummary" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/customerSalesSummary.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <h1>Customer Sales Summary</h1>

    <h2>Ecommerce Sales of the top 
    &nbsp;<asp:DropDownList ID="ddTop" AutoPostBack="true" Style="border: 1px solid white; background-color: #0178B9; color: white;" runat="server">
      <asp:ListItem>10</asp:ListItem>
      <asp:ListItem>25</asp:ListItem>
      <asp:ListItem>100</asp:ListItem>
      <asp:ListItem>999</asp:ListItem>
    </asp:DropDownList>&nbsp;
    Customers over the past twelve months.<br />
      Click DETAILS for complete list of Annual Sales by the selected Customer.<br />
    </h2>

    <table class="tabContain">
      <tr>

        <td style="padding: 20px;">
          <table class="tbSales" style="width: 325px; border: none;">
            <tr>
              <td class="customerSales"></td>
              <td class="customerSales"><a style="color: white; font-weight: bold;" href="javascript:__doPostBack('ctl00$MainContent$gvSales','Sort$Customer')">Customer</a></td>
              <td class="customerSales"><a style="color: white; font-weight: bold;" href="javascript:__doPostBack('ctl00$MainContent$gvSales','Sort$Sales')">Sales</a></td>
              <td class="customerSales"><a style="color: white; font-weight: bold;" href="javascript:__doPostBack('ctl00$MainContent$gvSales','Sort$Percent')">Percent</a></td>
            </tr>
          </table>
          <div style="height: 300px; width: 350px; overflow: auto; margin: auto;">

            <asp:GridView
              ID="gvSales"
              runat="server"
              Width="320px"
              ShowHeader="False"
              AutoGenerateColumns="False"
              BorderStyle="none"
              DataSourceID="SqlDataSource1"
              AllowSorting="True"
              DataKeyNames="Customer">
              <Columns>
                <asp:CommandField ItemStyle-CssClass="customerSales gridLink" SelectText="DETAILS"
                  ItemStyle-ForeColor="White" ShowSelectButton="True" ButtonType="Button">
                  <ItemStyle CssClass="customerSales gridLink" ForeColor="White"></ItemStyle>
                </asp:CommandField>
                <asp:BoundField
                  ItemStyle-CssClass="customerSales"
                  DataField="Customer"
                  ReadOnly="True"
                  SortExpression="Customer">
                  <ItemStyle CssClass="customerSales"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField ItemStyle-CssClass="customerSales" DataField="Sales" HeaderText="Sales" ReadOnly="True" SortExpression="Sales" DataFormatString="{0:C0}">
                  <ItemStyle CssClass="customerSales"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField ItemStyle-CssClass="customerSales" DataField="Percent" HeaderText="Percent" ReadOnly="True" SortExpression="Percent" DataFormatString="{0:0.0}">
                  <ItemStyle CssClass="customerSales"></ItemStyle>
                </asp:BoundField>
              </Columns>
            </asp:GridView>
          </div>
          <hr />
          <asp:GridView
            Width="320px" ID="gvSalesTotal"
            runat="server" AutoGenerateColumns="False" ShowHeader="False"
            BorderStyle="None"
            DataSourceID="SqlDataSource2">
            <Columns>
              <asp:BoundField ItemStyle-CssClass="customerSales" />
              <asp:BoundField ItemStyle-Font-Bold="true" ItemStyle-CssClass="customerSales" DataField="Customer" HeaderText="Customer" ReadOnly="True" SortExpression="Customer" />
              <asp:BoundField ItemStyle-CssClass="customerSales" DataField="Sales" HeaderText="Sales" ReadOnly="True" SortExpression="Sales" DataFormatString="{0:C0}" />
              <asp:BoundField ItemStyle-CssClass="customerSales" DataField="Percent" HeaderText="Percent" ReadOnly="True" SortExpression="Percent" DataFormatString="{0:0.0}" />
            </Columns>
          </asp:GridView>
          <br />
          <asp:ImageButton ID="imgExcel1" OnClick="imgExcel1_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" runat="server" />
          <asp:ImageButton ID="imgChart1" OnClick="imgChart1_Click" ImageUrl="~/styles/icons/chart.png" CssClass="chart" runat="server" />
        </td>

        <td style="padding: 20px; vertical-align: top; border: none;">
          <asp:GridView
            Width="240px" ID="gvAnnual" runat="server" DataSourceID="SqlDataSource3"
            HeaderStyle-Font-Bold="true"
            HeaderStyle-BorderStyle="none"
            BorderStyle="none"
            AutoGenerateColumns="False">
            <Columns>
              <asp:BoundField ItemStyle-BorderStyle="None" ItemStyle-CssClass="customerSales" DataField="Customer" HeaderText="Customer" ReadOnly="True" />
              <asp:BoundField ItemStyle-BorderStyle="None" ItemStyle-CssClass="customerSales" DataField="Year" HeaderText="Year" ReadOnly="True" />
              <asp:BoundField ItemStyle-BorderStyle="None" ItemStyle-CssClass="customerSales" DataField="Sales" HeaderText="Sales" ReadOnly="True" DataFormatString="{0:C0}" />
            </Columns>
          </asp:GridView>
          <hr />
          <asp:GridView Width="240px" ID="GridView1" runat="server"
            BorderStyle="None"
            AutoGenerateColumns="False"
            ShowHeader="False"
            DataSourceID="SqlDataSource4">
            <Columns>
              <asp:BoundField ItemStyle-Font-Bold="true" ItemStyle-CssClass="customerSales" DataField="Customer" HeaderText="Customer" ReadOnly="True" />
              <asp:BoundField ItemStyle-Font-Bold="true" ItemStyle-CssClass="customerSales" DataField="Year" HeaderText="Year" ReadOnly="True" />
              <asp:BoundField ItemStyle-CssClass="customerSales" DataField="Sales" HeaderText="Sales" ReadOnly="True" DataFormatString="{0:C0}" />
            </Columns>
          </asp:GridView>
          <br />
          <asp:ImageButton ID="imgExcel2" OnClick="imgExcel2_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" runat="server" />
          <asp:ImageButton ID="imgChart2" OnClick="imgChart2_Click" ImageUrl="~/styles/icons/chart.png" CssClass="chart" runat="server" />
        </td>

      </tr>
    </table>
  </div>


  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7customerSales" SelectCommandType="StoredProcedure">
    <SelectParameters>
      <asp:ControlParameter ControlID="ddTop" Name="IntParm0" PropertyName="SelectedValue" Type="Int32" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7customerSalesTotal" SelectCommandType="StoredProcedure"></asp:SqlDataSource>

  <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7customerSalesAnnual" SelectCommandType="StoredProcedure">
    <SelectParameters>
      <asp:ControlParameter ControlID="gvSales" DefaultValue="CCHS" Name="cust" PropertyName="SelectedValue" Type="String" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7customerSalesAnnualTotal" SelectCommandType="StoredProcedure">
    <SelectParameters>
      <asp:ControlParameter ControlID="gvSales" DefaultValue="CCHS" Name="cust" PropertyName="SelectedValue" Type="String" />
    </SelectParameters>
  </asp:SqlDataSource>

</asp:Content>
