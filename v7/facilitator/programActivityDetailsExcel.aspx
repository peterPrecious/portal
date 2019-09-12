﻿<%@ Page
  Title="Program Activity Details"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="programActivityDetailsExcel.aspx.cs"
  Inherits="portal.v7.facilitator.programActivityDetailsExcel" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/programActivityDetailsExcel.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage" style="width: 800px;">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" /><br />
    <h1>Program Activity Details (Excel)</h1>
    <h2>Select the Start and End Dates and optionally a Learner Id (leave empty for all Learners) then click on the Excel Icon at the bottom right. Dates default to the previous month.</h2>
    <table class="tabContain" style="margin: 50px auto 0;">
      <tr>
        <td class="tdPrompt">Start Date:</td>
        <td class="tdCalendar">
          <table>
            <tr>
              <td>
                <asp:DropDownList ID="drpCalMonth1" runat="Server" OnSelectedIndexChanged="setCalendar1" AutoPostBack="true"></asp:DropDownList>
                <asp:DropDownList ID="drpCalYear1" runat="Server" OnSelectedIndexChanged="setCalendar1" AutoPostBack="true"></asp:DropDownList>
              </td>
            </tr>
            <tr>
              <td>
                <asp:Calendar ID="Calendar1" CssClass="calendar1" NextPrevStyle-CssClass="nextPrev" OtherMonthDayStyle-ForeColor="#8DC640" TitleStyle-BackColor="#8DC640" DayHeaderStyle-Font-Bold="false" TitleStyle-ForeColor="black" DayStyle-ForeColor="white" DayHeaderStyle-ForeColor="White" runat="server"></asp:Calendar>
              </td>
            </tr>
          </table>
        </td>
        <td class="tdPrompt">End Date:</td>
        <td class="tdCalendar">
          <table>
            <tr>
              <td>
                <asp:DropDownList ID="drpCalMonth2" runat="Server" OnSelectedIndexChanged="setCalendar2" AutoPostBack="true"></asp:DropDownList>
                <asp:DropDownList ID="drpCalYear2" runat="Server" OnSelectedIndexChanged="setCalendar2" AutoPostBack="true"></asp:DropDownList>
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
      <tr class="trData">
        <td colspan="4" style="text-align: center; color: white;">Learner Id (optional);
        <asp:TextBox Width="300px" ID="txtMembId" runat="server"></asp:TextBox>
        </td>
      </tr>
      <tr class="trData">
        <td colspan="4">
          <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" runat="server" /><br /><br />
        </td>
      </tr>
    </table>
  </div>

  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7customerSalesDetails" SelectCommandType="StoredProcedure">
    <SelectParameters>
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
