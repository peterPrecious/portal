<%@ Page
  Title="Ecommerce"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="ecommerceDateExcel.aspx.cs"
  Inherits="portal.v7.manager.ecommerceDateExcel" %>


<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/ecommerceDateExcel.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage" style="width: 500px">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

    <h1>Ecommerce Transactions by Date (Excel)</h1>
    <h2 class="c2">Retrieve up to&nbsp;
    <asp:DropDownList ID="ddTop" Style="border: none; background-color: #0178B9; color: white; border: 1px solid white;" runat="server">
      <asp:ListItem>100</asp:ListItem>
      <asp:ListItem Selected="True">1000</asp:ListItem>
      <asp:ListItem>10000</asp:ListItem>
    </asp:DropDownList>
      transactions that occurred on or after the selected Start Date but not beyond the End Date.
    Once you have selected both the start and end days then click the Excel Icon.
    </h2>

    <table class="tabContain" style="margin: 30px auto 50px;">
      <tr>
        <td class="tdParent">
          <table class="tbDates">
            <tr>
              <th class="tdParent">Start Date:</th>
              <td class="tdParent">
                <table>
                  <tr>
                    <td>
                      <asp:DropDownList ID="drpCalMonth1" runat="Server" OnSelectedIndexChanged="setCalendar1" CssClass="drp" AutoPostBack="true"></asp:DropDownList>
                      <asp:DropDownList ID="drpCalYear1" runat="Server" OnSelectedIndexChanged="setCalendar1" CssClass="drp" AutoPostBack="true"></asp:DropDownList>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <asp:Calendar
                        ID="Calendar1"
                        CssClass="calendar1"
                        NextPrevStyle-CssClass="nextPrev"
                        OtherMonthDayStyle-ForeColor="#8DC640"
                        TitleStyle-BackColor="#8DC640"
                        DayHeaderStyle-Font-Bold="false"
                        TitleStyle-ForeColor="black"
                        DayStyle-ForeColor="white"
                        DayHeaderStyle-ForeColor="White"
                        runat="server"></asp:Calendar>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <th class="tdParent">End Date:</th>
              <td class="tdParent">
                <table>
                  <tr>
                    <td>
                      <asp:DropDownList ID="drpCalMonth2" runat="Server" OnSelectedIndexChanged="setCalendar2" CssClass="drp" AutoPostBack="true"></asp:DropDownList>
                      <asp:DropDownList ID="drpCalYear2" runat="Server" OnSelectedIndexChanged="setCalendar2" CssClass="drp" AutoPostBack="true"></asp:DropDownList>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <asp:Calendar ID="Calendar2" CssClass="calendar2" NextPrevStyle-CssClass="nextPrev" OtherMonthDayStyle-ForeColor="#8DC640" TitleStyle-BackColor="#8DC640" DayHeaderStyle-Font-Bold="false" TitleStyle-ForeColor="black" DayStyle-ForeColor="white" DayHeaderStyle-ForeColor="White" runat="server"></asp:Calendar>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" runat="server" />
              </td>
            </tr>
            <tr>
              <td colspan="2" style="vertical-align: middle; font-size: larger; color: white;">
                <asp:Panel ID="panError" runat="server" Visible="false">Your dates are wonky!</asp:Panel>
              </td>
            </tr>
          </table>
        </td>

      </tr>
    </table>

  </div>

</asp:Content>
