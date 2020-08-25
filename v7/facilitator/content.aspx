<%@ Page
  Title="Assign Programs"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  EnableEventValidation="false"
  CodeBehind="content.aspx.cs"
  Inherits="portal.v7.facilitator.content" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/content.min.css" rel="stylesheet" />

  <script>
    // this is similiar to the one in v7.js except it only works on "enabled" checkboxes
    function selectAll2(ele, id) {
      $("." + id + " input").each(function (index) {
        if (!$(this)[0].disabled) {
          if (ele.checked) {
            $(this)[0].checked = true;
          } else {
            $(this)[0].checked = false;
          }
        }
      });
    }
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:Panel ID="panPage" CssClass="panPage" runat="server">

      <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

      <h1>
        <span onclick="fadeIn()" class="hoverUnderline" title="Click to show discription.">
          <asp:Literal runat="server" Text="<%$  Resources:portal, assignPurchasedContent%>" />
        </span>
      </h1>

      <div id="contentDesc" class="thisTitle">
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_1%>" />
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_2%>" />
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_3%>" />
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_4%>" />
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_5%>" />
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_6%>" />
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_61%>" />
        <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
      </div>

      <h3>
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_7%>" />
      </h3>


      <div style="width: 95%; overflow: auto; margin: auto;">
        <asp:GridView ID="gvUsers" CssClass="gvUsers" runat="server" AutoGenerateColumns="False"
          DataKeyNames="Memb_No"
          DataSourceID="SqlDataSource1"
          OnRowDataBound="gvUsers_RowDataBound"
          AllowSorting="True"
          CellPadding="3"
          Width="100%">
          <Columns>
            <asp:TemplateField>
              <HeaderTemplate>
                <asp:CheckBox ID="chkAllUsers" onclick="javascript: selectAll2(this, 'chkUsers');" runat="server" />
              </HeaderTemplate>
              <ItemTemplate>
                <asp:CheckBox CssClass="chkUsers" ID="chkRow" runat="server" />
              </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Learner Id" HeaderText="<%$  Resources:portal, uniqueId%>" SortExpression="Learner Id" />
            <asp:BoundField DataField="First Name" HeaderText="<%$  Resources:portal, firstName%>" SortExpression="First Name" />
            <asp:BoundField DataField="Last Name" HeaderText="<%$  Resources:portal, lastName%>" SortExpression="Last Name" />
            <asp:BoundField DataField="Programs Before" HeaderText="<%$ Resources:portal, programsAssigned%>" SortExpression="Programs Before" />
            <%--<asp:BoundField DataField="Programs After" HeaderText="<%$ Resources:portal, programsAfter%>" SortExpression="Programs After" />--%>
            <asp:BoundField DataField="Active" HeaderText="Active?" SortExpression="Active" />
          </Columns>
        </asp:GridView>
      </div>

      <h3>
        <%-- Next select the Programs you wish to assign to the above Learner(s).--%>
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_8%>" />
      </h3>

      <div style="width: 95%; overflow: auto; margin: auto;">
        <asp:GridView CssClass="gvProgs" ID="gvProgs" runat="server" AutoGenerateColumns="False"
          DataSourceID="SqlDataSource2"
          OnRowDataBound="gvProgs_RowDataBound"
          OnDataBound="gvProgs_DataBound"
          AllowSorting="True"
          CellPadding="3"
          Width="100%">
          <Columns>
            <asp:TemplateField ItemStyle-CssClass="c201">
              <HeaderTemplate>
                <asp:CheckBox ID="chkAllProgs" onclick="javascript: selectAll(this, 'chkProgs');" runat="server" />
              </HeaderTemplate>
              <ItemTemplate>
                <asp:CheckBox CssClass="chkProgs" ID="chkRow" runat="server" />
              </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Program Id" HeaderText="Program Id" SortExpression="Program Id" />
            <asp:BoundField DataField="Program Title" HeaderText="Program Title" SortExpression="Program Title" ReadOnly="True" />
            <asp:BoundField DataField="Purchased" HeaderText="Purchased" ReadOnly="True" SortExpression="Purchased" />
            <asp:TemplateField HeaderText="<%$  Resources:portal, assigned%>"></asp:TemplateField>
            <asp:TemplateField HeaderText="<%$  Resources:portal, available%>"></asp:TemplateField>
            <%--<asp:TemplateField HeaderText="<%$  Resources:portal, assignedAfter%>"></asp:TemplateField>
            <asp:TemplateField HeaderText="<%$  Resources:portal, availableAfter%>"></asp:TemplateField>--%>
          </Columns>
        </asp:GridView>
      </div>

      <h3>
        <%-- Then click Assign and the Program(s) will be moved to the Learner(s). You will then have an opportunity to Commit the assignment(s) or Restart.--%>
        <asp:Localize runat="server" Text="<%$  Resources:portal, content_9%>" />
      </h3>


      <div style="width: 100%; margin: 20px auto; text-align: center;">
        <asp:Button CssClass="button" ID="butAssign" runat="server" Text="<%$ Resources:portal, assign%>" OnClick="butAssign_Click" />
      </div>

      <asp:Panel ID="panAlert" Visible="false" runat="server" CssClass="panAlert">
        <asp:Label ID="labAlert" CssClass="labAlert" runat="server"></asp:Label>
        <div id="divExit">
          <asp:Button CssClass="button" ID="butRestart" OnClick="butRestart_Click" runat="server" Text="<%$  Resources:portal, restart%>" />
          <asp:Button CssClass="button" ID="butCommit" runat="server" Text="<%$ Resources:portal, commit%>" Visible="false" OnClick="butCommit_Click" />
        </div>
        <h1>
          <asp:Label ID="panWarning" Visible="false" runat="server" Text="<%$  Resources:portal, content_10%>" /><%-- NOTE: once content is assigned and committed, it cannot be unassigned!--%>
        </h1>
      </asp:Panel>
    </asp:Panel>

  </div>

  <asp:SqlDataSource
    ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="sp7groupUsers" SelectCommandType="StoredProcedure"
    UpdateCommand="UPDATE Memb SET Memb_Programs = @programs WHERE Memb_No = @membNo">
    <SelectParameters>
      <asp:SessionParameter Name="membAcctId" SessionField="custAcctId" />
    </SelectParameters>
    <UpdateParameters>
      <asp:Parameter Name="programs" />
      <asp:Parameter Name="membNo" />
    </UpdateParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource
    ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="sp7groupPrograms" SelectCommandType="StoredProcedure">
    <SelectParameters>
      <asp:SessionParameter Name="membAcctId" SessionField="custAcctId" Type="String" />
    </SelectParameters>
  </asp:SqlDataSource>

</asp:Content>
