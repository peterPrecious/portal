<%@ Page
  Title="Module Usage"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="moduleUsage.aspx.cs"
  Inherits="portal.v7.analytics.moduleUsage" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/moduleUsage.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <h2>List of the top 20 modules accessed during the last twelve months.
      <br />
      Click on the icons at bottom right for graphical and spreasheet renderings.
    </h2>

    <table class="tabContain" style="margin: auto;">
      <tr>
        <td class="tdParent">
          <div style="height: 450px; width: 665px; overflow: auto; margin: auto;">

            <asp:GridView
              ID="gvUsage" runat="server"
              Width="640px"
              CssClass="gvUsage"
              AutoGenerateColumns="False"
              BorderStyle="None"
              HeaderStyle-CssClass="borderLine"
              HeaderStyle-ForeColor="White"
              DataSourceID="SqlDataSource1">
              <Columns>
                <asp:BoundField HeaderStyle-CssClass="borderLine" HeaderStyle-BorderStyle="None" HeaderStyle-HorizontalAlign="Left" ItemStyle-ForeColor="White" ItemStyle-HorizontalAlign="Left" DataField="Module" HeaderText="Module" ReadOnly="True" />
                <asp:BoundField HeaderStyle-BorderStyle="None" ItemStyle-ForeColor="White" ItemStyle-HorizontalAlign="Center" DataField="Count" HeaderText="# Sessions" ReadOnly="True" />
              </Columns>
            </asp:GridView>
          </div>
        </td>
      </tr>
      <tr>
        <td>
          <asp:ImageButton ID="imgExcel" OnClick="imgExcel_Click" ImageUrl="~/styles/icons/excel.png" CssClass="excel" runat="server" />
          <asp:ImageButton ID="imgChart" OnClick="imgChart_Click" ImageUrl="~/styles/icons/chart.png" CssClass="excel" runat="server" />
        </td>
      </tr>

    </table>

    <%--    <asp:Label CssClass="labDate" ID="labDate" runat="server" Text=""></asp:Label>--%>
  </div>

  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>" SelectCommand="sp7moduleUsage" SelectCommandType="StoredProcedure"></asp:SqlDataSource>

</asp:Content>
