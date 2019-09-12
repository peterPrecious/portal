<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="learners3.aspx.cs" Inherits="portal.v7.facilitator.learners3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title></title>
  <link href="../../styles/css/learners.css" rel="stylesheet" />
</head>
<body>
  <form id="form1" runat="server">
    <div class="divPage" style="width: 1000px;">

      <asp:ImageButton OnClick="dvLearner_ItemInit" CssClass="icons add" ImageUrl="~/styles/icons/vubiz/add.png" CommandName="Insert" ToolTip="Add a Learner" runat="server" />

      <asp:GridView runat="server"
        ID="gvLearners"
        DataKeyNames="membNo"
        DataSourceID="SqlDataSource1"
        AutoGenerateColumns="False">
        <Columns>
          <asp:BoundField DataField="membNo" HeaderText="membNo" SortExpression="membNo" InsertVisible="False" ReadOnly="True" />
          <asp:BoundField DataField="membId" HeaderText="membId" SortExpression="membId" />
          <asp:BoundField DataField="membFirstName" HeaderText="membFirstName" SortExpression="membFirstName" />
          <asp:BoundField DataField="membLastName" HeaderText="membLastName" SortExpression="membLastName" />
          <asp:BoundField DataField="membEmail" HeaderText="membEmail" SortExpression="membEmail" />
          <asp:TemplateField HeaderText="Details">
            <ItemTemplate>
              <asp:ImageButton CssClass="icons info" ID="btnSelect" runat="server" CausesValidation="True"
                CommandName="Select" ImageUrl="~/styles/icons/vubiz/info.png" Text="Details" />
            </ItemTemplate>
          </asp:TemplateField>
        </Columns>
      </asp:GridView>

      <asp:DetailsView runat="server"
        ID="dvLearner"
        DataSourceID="SqlDataSource2"
        DataKeyNames="membNo"
        OnDataBound="dvLearner_DataBound"
        OnItemUpdating="dvLearner_ItemUpdating"
        OnItemInserting="dvLearner_ItemInserting"
        OnPreRender="dvLearner_PreRender"
        AutoGenerateRows="False">
        <Fields>
          <asp:BoundField DataField="membId" HeaderText="membId" />
          <asp:BoundField DataField="membPwd" HeaderText="membPwd" />
          <asp:BoundField DataField="membFirstName" HeaderText="membFirstName" />
          <asp:BoundField DataField="membLastName" HeaderText="membLastName" />
          <asp:BoundField DataField="membEmail" HeaderText="membEmail" />
          <asp:BoundField DataField="membOrganization" HeaderText="membOrganization" />
          <asp:BoundField DataField="membMemo" HeaderText="membMemo" />
          <asp:BoundField DataField="membPrograms" HeaderText="membPrograms" />
          <asp:TemplateField HeaderText="membLevel">

            <ItemTemplate>
              <asp:Label ID="labMembLevel" runat="server" Text='<%# Bind("membLevel") %>'></asp:Label>
            </ItemTemplate>

            <EditItemTemplate>
              <asp:DropDownList SelectedValue='<%# Bind("membLevel") %>' ID="membLevel" runat="server">
                <asp:ListItem Value="1" Text="Guest"></asp:ListItem>
                <asp:ListItem Value="2" Text="Learner" Selected="True"></asp:ListItem>
                <asp:ListItem Value="3" Text="Facilitator"></asp:ListItem>
                <asp:ListItem Value="4" Text="Manager"></asp:ListItem>
                <asp:ListItem Value="5" Text="Administrator"></asp:ListItem>
              </asp:DropDownList>
              <%--              <asp:Label ID="labMembLevel" runat="server"></asp:Label>
              <asp:HiddenField ID="txtMembLevel" runat="server" />--%>
            </EditItemTemplate>

            <InsertItemTemplate>
              <asp:DropDownList SelectedValue='<%# Bind("membLevel") %>' ID="membLevel" runat="server">
                <asp:ListItem Value="1" Text="Guest"></asp:ListItem>
                <asp:ListItem Value="2" Text="Learner" Selected="True"></asp:ListItem>
                <asp:ListItem Value="3" Text="Facilitator"></asp:ListItem>
                <asp:ListItem Value="4" Text="Manager"></asp:ListItem>
                <asp:ListItem Value="5" Text="Administrator"></asp:ListItem>
              </asp:DropDownList>
              <%--              <asp:Label ID="labMembLevel" runat="server"></asp:Label>
              <asp:HiddenField ID="txtMembLevel" runat="server" />--%>
            </InsertItemTemplate>

          </asp:TemplateField>
          <asp:CheckBoxField DataField="membEmailAlert" HeaderText="membEmailAlert" />
          <asp:TemplateField HeaderText="membActive">
            <EditItemTemplate>
              <asp:CheckBox ID="membActive" runat="server" Checked='<%# Bind("membActive") %>' />
            </EditItemTemplate>
            <InsertItemTemplate>
              <asp:CheckBox ID="membActive" runat="server" Checked='<%# Bind("membActive") %>' />
            </InsertItemTemplate>
            <ItemTemplate>
              <asp:CheckBox ID="membActive" runat="server" Checked='<%# Bind("membActive") %>' Enabled="false" />
            </ItemTemplate>
          </asp:TemplateField>



          <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icons">
            <EditItemTemplate>
              <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnUpdate" runat="server" CausesValidation="True" CommandName="Update" ToolTip="Update Learner" />
              <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
            </EditItemTemplate>
            <InsertItemTemplate>
              <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnInsert" runat="server" CausesValidation="True" CommandName="Insert" ToolTip="Add a Learner" />
              <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
            </InsertItemTemplate>
            <ItemTemplate>
              <asp:ImageButton ImageUrl="~/styles/icons/vubiz/edit.png" ID="btnEdit" runat="server" CausesValidation="False" CommandName="Edit" ToolTip="Edit Learner's Profile" />
              <asp:ImageButton ImageUrl="~/styles/icons/vubiz/delete.png" ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" OnClientClick="return confirm('Are you certain you want to delete this Learner?')" ToolTip="Delete Learner" />
            </ItemTemplate>
            <ControlStyle CssClass="icons edit" />
          </asp:TemplateField>





          <asp:TemplateField ShowHeader="False">
            <EditItemTemplate>
              <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Update" Text="Update"></asp:LinkButton>
              &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
            </EditItemTemplate>
            <InsertItemTemplate>
              <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert"></asp:LinkButton>
              &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
            </InsertItemTemplate>
            <ItemTemplate>
              <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"></asp:LinkButton>
              &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="New" Text="New"></asp:LinkButton>
              &nbsp;<asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"></asp:LinkButton>
            </ItemTemplate>
          </asp:TemplateField>



        </Fields>
      </asp:DetailsView>

    </div>
    <h1>
      <asp:Label ForeColor="Red" ID="labError" runat="server" Visible="false" />
    </h1>


  </form>

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
      <asp:Parameter Name="membActive" DefaultValue="1" />
    </InsertParameters>

  </asp:SqlDataSource>

</body>
</html>
