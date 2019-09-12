<%@ Page
  Title="Customer Activity"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="customerActivity.aspx.cs"
  Inherits="portal.v7.analytics.customerActivity" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/customerActivity.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div id="divPage" class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <h2 class="c2">List of Accounts with at least 100 LMS learner visits in the last twelve months.
      Click on the icons at bottom right for graphical and spreasheet renderings.
    </h2>

    <table class="tabContain" style="margin: auto;">
      <tr>
        <td class="tdParent">
          <%--          <table class="tbActvity" style="width: 242px;">
            <tr>
              <th class="h101"><a href="javascript:__doPostBack('ctl00$MainContent$gvActivity','Sort$Customer')">Customer</a></th>
              <th class="h102"><a href="javascript:__doPostBack('ctl00$MainContent$gvActivity','Sort$Visitors')">Visitors</a></th>
              <th class="h103"><a href="javascript:__doPostBack('ctl00$MainContent$gvActivity','Sort$Percent')">Percent</a></th>
            </tr>
          </table>--%>
          <div style="height: 300px; width: 265px; overflow: auto; margin: auto;">

            <asp:GridView
              ID="gvActivity"
              runat="server"
              Width="240px"
              BorderStyle="None"
              ShowHeader="True"
              HeaderStyle-ForeColor="White"
              HeaderStyle-CssClass="borderLine"
              AutoGenerateColumns="False"
              DataSourceID="SqlDataSource1"
              AllowSorting="True">
              <Columns>
                <asp:BoundField
                  ItemStyle-Width="35%"
                  ItemStyle-ForeColor="White"
                  DataField="Customer"
                  ReadOnly="True"
                  HeaderText="Customer"
                  HeaderStyle-BorderStyle="none"
                  SortExpression="Customer" />
                <asp:BoundField
                  HeaderStyle-BorderStyle="none"
                  ItemStyle-Width="35%" ItemStyle-ForeColor="White" DataField="Visitors" ShowHeader="false" HeaderText="Visitors" ReadOnly="True" SortExpression="Visitors" />
                <asp:BoundField
                  HeaderStyle-BorderStyle="none"
                  ItemStyle-Width="35%" ItemStyle-ForeColor="White" DataField="Percent" ShowHeader="false" HeaderText="Percent" ReadOnly="True" SortExpression="Percent" />
              </Columns>
            </asp:GridView>
          </div>
          <hr />
          <asp:GridView
            Width="240px"
            ID="gvActivityTotal" runat="server"
            AutoGenerateColumns="False"
            ShowHeader="false"
            BorderStyle="None"
            DataSourceID="SqlDataSource2">
            <Columns>
              <asp:BoundField ItemStyle-Width="35%" ItemStyle-Font-Bold="true" ItemStyle-ForeColor="White" DataField="Customer" HeaderText="Customer" ReadOnly="True" />
              <asp:BoundField ItemStyle-Width="35%" ItemStyle-ForeColor="White" DataField="Visitors" HeaderText="Visitors" ReadOnly="True" />
              <asp:BoundField ItemStyle-Width="35%" ItemStyle-ForeColor="White" DataField="Percent" HeaderText="Percent" ReadOnly="True" />
            </Columns>
          </asp:GridView>
        </td>
      </tr>
      <tr>
        <td>
          <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" runat="server" />
          <asp:ImageButton ID="imgChart" OnClick="imgChart_Click" ImageUrl="~/styles/icons/chart.png" CssClass="excel" runat="server" />
        </td>
      </tr>
    </table>
  </div>

  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7CustomerActivity" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
  <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7CustomerActivityTotal" SelectCommandType="StoredProcedure"></asp:SqlDataSource>

</asp:Content>
