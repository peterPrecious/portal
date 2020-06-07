<%@ Page
  Title="Customer Sales Details"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="customerSalesDetails.aspx.cs"
  Inherits="portal.v7.customerSalesDetails" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="portal/styles/css/customerSalesDetails.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <h1>Customer Sales Details</h1>

    <h2 class="c2">This shows Ecommerce Sales of the top &nbsp;
      <asp:DropDownList ID="ddTop" Style="border: 1px solid white; background-color: #0178B9; color: white;" runat="server">
        <asp:ListItem>10</asp:ListItem>
        <asp:ListItem>25</asp:ListItem>
        <asp:ListItem>100</asp:ListItem>
      </asp:DropDownList>&nbsp;
      customers during the selected period.
      Select the starting and ending Month/Year then on each calendar, the particular day.
      The Sales Details will ONLY appear when both start and end DAYS are selected.
      Click on the icons at bottom right for graphical and spreasheet renderings.
    </h2>

    <table class="tabContain" style="margin: 30px auto; border: none;">
      <tr>
        <td class="tdParent" style="vertical-align: top; border: none;">
          <table class="tbDates" style="border: none;">
            <tr>
              <td class="tdParent" style="vertical-align: top; border: none;">Start Date:</td>
              <td class="tdParent" style="vertical-align: top; border: none;">
                <table style="border: none;">
                  <tr>
                    <td style="vertical-align: top; border: none;">
                      <asp:DropDownList ID="drpCalMonth1" runat="Server" OnSelectedIndexChanged="setCalendar1" AutoPostBack="true"></asp:DropDownList>
                      <asp:DropDownList ID="drpCalYear1" runat="Server" OnSelectedIndexChanged="setCalendar1" AutoPostBack="true"></asp:DropDownList>
                    </td>
                  </tr>
                  <tr>
                    <td style="vertical-align: top; border: none;">
                      <asp:Calendar ID="Calendar1" CssClass="calendar1" NextPrevStyle-CssClass="nextPrev" OtherMonthDayStyle-ForeColor="#8DC640" TitleStyle-BackColor="#8DC640" DayHeaderStyle-Font-Bold="false" TitleStyle-ForeColor="black" DayStyle-ForeColor="white" DayHeaderStyle-ForeColor="White" runat="server"></asp:Calendar>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td class="tdParent" style="vertical-align: top; border: none;">End Date:</td>
              <td class="tdParent" style="vertical-align: top; border: none;">
                <table style="border: none;">
                  <tr>
                    <td style="vertical-align: top; border: none;">
                      <asp:DropDownList ID="drpCalMonth2" runat="Server" OnSelectedIndexChanged="setCalendar2" AutoPostBack="true"></asp:DropDownList>
                      <asp:DropDownList ID="drpCalYear2" runat="Server" OnSelectedIndexChanged="setCalendar2" AutoPostBack="true"></asp:DropDownList>
                    </td>
                  </tr>
                  <tr>
                    <td style="vertical-align: top; border: none;">
                      <asp:Calendar ID="Calendar2" CssClass="calendar2" NextPrevStyle-CssClass="nextPrev" OtherMonthDayStyle-ForeColor="#8DC640" TitleStyle-BackColor="#8DC640" DayHeaderStyle-Font-Bold="false" TitleStyle-ForeColor="black" DayStyle-ForeColor="white" DayHeaderStyle-ForeColor="White" runat="server"></asp:Calendar>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
        <td class="tdParent">
          <div style="margin: auto; width: 250px;">
            <table class="tbSales" style="border: none;">
              <tr>
                <td style="width: 100px; border: none;" class="customerSales"><a href="javascript:__doPostBack('ctl00$MainContent$gvSales','Sort$Customer')" style="color: white; font-weight: bold;">Customer</a></td>
                <td style="width: 150px; border: none;" class="customerSales"><a href="javascript:__doPostBack('ctl00$MainContent$gvSales','Sort$Sales')" style="color: white; font-weight: bold;">Sales</a></td>
              </tr>
            </table>
            <div style="height: 470px; width: 280px; overflow: auto; margin: auto;">
              <asp:GridView
                Width="250px"
                ID="gvSales" runat="server"
                ShowHeader="False" AutoGenerateColumns="False"
                DataSourceID="SqlDataSource1"
                BorderStyle="None"
                AllowSorting="True">
                <Columns>
                  <asp:BoundField ItemStyle-BorderStyle="None" ItemStyle-Width="100px" ItemStyle-ForeColor="White" DataField="Customer" HeaderText="Customer" ReadOnly="True" SortExpression="Customer" />
                  <asp:BoundField ItemStyle-BorderStyle="None" ItemStyle-Width="150px" ItemStyle-ForeColor="White" DataField="Sales" HeaderText="Sales" ReadOnly="True" SortExpression="Sales" />
                </Columns>
              </asp:GridView>
            </div>
            <hr />
            <asp:GridView
              Width="250px"
              ID="gvSalesTotal"
              OnDataBound="gvSalesTotal_DataBound"
              runat="server"
              ShowHeader="False"
              BorderStyle="None"
              AutoGenerateColumns="False"
              DataSourceID="SqlDataSource2"
              AllowSorting="True">
              <Columns>
                <asp:BoundField ItemStyle-BorderStyle="None" ItemStyle-Width="100px" ItemStyle-ForeColor="White" DataField="Customer" ReadOnly="True" ItemStyle-Font-Bold="true" />
                <asp:BoundField ItemStyle-BorderStyle="None" ItemStyle-Width="150px" ItemStyle-ForeColor="White" DataField="Sales" ReadOnly="True" DataFormatString="{0:C0}" />
              </Columns>
            </asp:GridView>


          </div>
          <br />
          <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" Visible="false" runat="server" />
          <asp:ImageButton ID="imgChart" OnClick="imgChart_Click" ImageUrl="~/styles/icons/chart.png" CssClass="chart" Visible="false" runat="server" />



        </td>
      </tr>
    </table>



  </div>

  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7customerSalesDetails" SelectCommandType="StoredProcedure">
    <SelectParameters>
      <asp:ControlParameter ControlID="ddTop" DefaultValue="10" Name="top" PropertyName="SelectedValue" Type="Int32" />
      <asp:ControlParameter ControlID="Calendar1" Name="strDate" PropertyName="SelectedDate" Type="DateTime" />
      <asp:ControlParameter ControlID="Calendar2" Name="endDate" PropertyName="SelectedDate" Type="DateTime" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7customerSalesDetailsTotal" SelectCommandType="StoredProcedure">
    <SelectParameters>
      <asp:ControlParameter ControlID="Calendar1" Name="strDate" PropertyName="SelectedDate" Type="DateTime" />
      <asp:ControlParameter ControlID="Calendar2" Name="endDate" PropertyName="SelectedDate" Type="DateTime" />
    </SelectParameters>
  </asp:SqlDataSource>

</asp:Content>
