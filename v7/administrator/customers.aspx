<%@ Page
  Title="Customers"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="customers.aspx.cs"
  Inherits="portal.v7.administrator.customers" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/customers.min.css" rel="stylesheet" />
  <script>
    $(function () { // generates a yellow description in labError of panBottom
      $(".custNo").on("click", function () { $(".labError").html('This is the unique, system generated Customer No. It is only used by Support.') })
      $(".custId").on("click", function () { $(".labError").html('The Customer Id is the key for this Account. Once created it cannot be changed. It\'s format is AAAA9999 where the last 4 characters are system generated.') })
      $(".custTitle").on("click", function () { $(".labError").html('A short description of this Account.') })
      $(".custActive").on("click", function () { $(".labError").html('Defaults to ON. When OFF this Customer will not appear on any reports.') })
      $(".custLang").on("click", function () { $(".labError").html('Must be one of EN, FR or ES. You cannot specify multiple languages.') })
      $(".custParentId").on("click", function () { $(".labError").html('If this is a child account, this field contains the Account Id of the Parent. IE if the parent\'s Customer Id is CAAM3001 then this field will be 3001.') })
      $(".custAuto").on("click", function () { $(".labError").html('Allows Channel SSO for learners when authentication occurs behind the customer\'s firewall. Uncheck for V8 where the presence of a custGuid in the call invokes SSO.') })
      $(".custNop").on("click", function () { $(".labError").html('Set ON if this account uses NOP for ecommerce.') })
      $(".custV8").on("click", function () { $(".labError").html('Set ON if this account uses V8 to view content.') })
      $(".custGuests").on("click", function () { $(".labError").html('Check to enable the Guest Subsystem (used by CFIB/FCEI). Typically set to No. Should only be set to Yes if this is a Parent Account, ie the Parent Id is empty.') })
      $(".custProfile").on("click", function () { $(".labError").html('Profile is typically something like \'abcd_en\'. Note this is NOT the Alias, which is a simpler version for ease of use.') })
      $(".custLearners").on("click", function () { $(".labError").html('This is the computed number of Active Learners in this Account. If you plan to Delete this Account, all Active Learners must be inactivated or deleted.') })

      // clears the labError
      $(".labError").on("click", function () { $(".labError").html('') })

      $(".txtCustPrefix").on("blur", function () {
        var str = $(".txtCustPrefix").val().toUpperCase();
        var len = str.length;
        var pat = new RegExp(/^[A-Z]+$/);
        if (str.length !== 4 || !pat.test(str)) { $(".labError").html('Please enter a 4 character Customer Prefix.'); }
      })
    })
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <asp:Panel ID="panConfirmShell" CssClass="panConfirmShell" runat="server" Visible="false">
      <asp:Panel ID="panConfirm" CssClass="panConfirm" runat="server">
        <table style="width: 380px; margin: 0px; margin: auto; border: none;">
          <tr>
            <td>
              <h1>
                <asp:Label ID="labConfirmTitle" runat="server"></asp:Label>
              </h1>
            </td>
          </tr>
          <tr>
            <td style="height: 125px; vertical-align: text-top">
              <h2>
                <asp:Label ID="labConfirmMessage" runat="server"></asp:Label></h2>
            </td>
          </tr>
          <tr>
            <td>
              <asp:LinkButton CssClass="newButton" ID="btnConfirmCancel" OnClientClick='$(".panConfirm").hide(); return false;' runat="server"></asp:LinkButton>
              &nbsp;&nbsp;
              <asp:LinkButton CssClass="newButton" ID="btnConfirmOk" OnClick="btnConfirmOk_Click" runat="server"></asp:LinkButton>
            </td>
          </tr>
        </table>
      </asp:Panel>
    </asp:Panel>

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

      <asp:Panel ID="panTop" CssClass="panTop" runat="server" DefaultButton="butSearch">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline" title="Click to hide/show discription.">Customers</span>
          <asp:ImageButton OnClick="dvCustomer_ItemInit" CssClass="icons add" ImageUrl="~/styles/icons/vubiz/add.png" ToolTip="Add a Customer" runat="server" />
        </h1>

        <div class="thisTitle">
          Select
          <asp:DropDownList CssClass="dropDown" ID="ddActive" runat="server">
            <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
            <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
            <asp:ListItem Text="Active and Inactive" Value="*"></asp:ListItem>
          </asp:DropDownList>
          V8/NOP Customers whose Customer Id or Title contains the Search Value.
          If you leave the Search Value empty the list will start at the beginning alphabetically by Customer Id.
          You can sort on the <b>Customer Id</b> and <b>Last Date</b> (which is the date this Customer Profile was last updated).
          This service is only used to Add or Edit Customers designated for V8 and/or NOP. 
          Legacy Accounts must be accessed via the V5 System.<br />
          <br />

          Cloning a Customer creates a new account with the same values as the Account you are cloning.
          The only exception is the Customer Id which is generated starting with the 4 characters of the <b>Cust</b> column.
          Once cloned the new Account will appear at the top of the list where you can edit it like any other Account.<br />
          <br />

          <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>

          <div style="margin-top: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="<%$  Resources:portal, searchValue%>" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="<%$  Resources:portal, search%>" />
          </div>

        </div>

        <asp:GridView runat="server"
          ID="gvCustomers"
          CssClass="gvCustomers"
          HorizontalAlign="Center"
          AutoGenerateColumns="False"
          AllowSorting="True"
          AllowPaging="True"
          PageSize="20"
          Width="850px"
          DataKeyNames="custNo"
          OnSelectedIndexChanged="gvCustomers_SelectedIndexChanged"
          DataSourceID="SqlDataSource1">
          <Columns>
            <asp:BoundField DataField="custId" ItemStyle-Width="100px" HeaderText="Customer Id" ItemStyle-HorizontalAlign="Left" SortExpression="custId" />
            <asp:BoundField DataField="custTitle" ItemStyle-Width="450px" HeaderText="Title" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
            <asp:BoundField DataField="custDate" ItemStyle-Width="100px" HeaderText="Last Date" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:MMM d, yyyy}" SortExpression="custDate" />
            <asp:TemplateField ItemStyle-Width="050px" HeaderText="Details">
              <ItemTemplate>
                <asp:ImageButton
                  CssClass="icons info"
                  ID="btnSelect"
                  ToolTip="Display details of this Customer"
                  runat="server"
                  CausesValidation="True"
                  CommandName="Select"
                  ImageUrl="~/styles/icons/vubiz/info.png"
                  Text="Details" />
              </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ItemStyle-Width="100px" HeaderText="Cust">
              <ItemTemplate>
                <asp:TextBox
                  ID="txtClone"
                  CssClass="txtClone"
                  MaxLength="4"
                  Width="50"
                  Text='<%#Eval("custPrefix")%>'
                  runat="server" />
              </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ItemStyle-Width="050px" HeaderText="Clone">
              <ItemTemplate>
                <asp:ImageButton
                  runat="server"
                  CssClass="icons info btnClone"
                  ImageUrl="~/styles/icons/vubiz/clone.png"
                  ID="btnClone"
                  ToolTip="Clone this Customer with a new Customer Id starting with the Cust prefix value at left."
                  CausesValidation="True"
                  OnCommand="btnConfirm_Command"
                  CommandArgument='<%# "Clone|" +  Eval("custId") + "|" + Eval("custPrefix")%>' />
              </ItemTemplate>
            </asp:TemplateField>
          </Columns>
          <PagerSettings
            FirstPageImageUrl="~/styles/icons/grids/frst.png"
            LastPageImageUrl="~/styles/icons/grids/last.png"
            NextPageImageUrl="~/styles/icons/grids/next.png"
            PreviousPageImageUrl="~/styles/icons/grids/prev.png"
            Position="Bottom"
            Mode="NextPreviousFirstLast" />
          <PagerStyle CssClass="commands" HorizontalAlign="Center" />
          <EmptyDataRowStyle CssClass="empty" />
          <EmptyDataTemplate>
            Oops. There are no V8/NOP Customers on file based on your selection criteria.<br />
          </EmptyDataTemplate>

        </asp:GridView>

      </asp:Panel>

      <asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">

        <asp:Panel ID="panBot_1" CssClass="panBot_1" runat="server" Visible="true">

          <h1>
            <asp:Literal ID="litBot_1" runat="server" Text="Add A Customer" />
            <asp:ImageButton
              OnClick="listCustomers_Click"
              CssClass="icons"
              ImageUrl="~/styles/icons/vubiz/back.png"
              ToolTip="Return to List"
              runat="server" />
            <br />
            <br />
            <asp:Label ID="labError_1" CssClass="labError" runat="server" />
          </h1>

          Each new Customer account requires a unique Customer Id.
          Start by entering an approriate 4 alpha character Customer Prefix below
          (ie "<asp:Label ID="labCust" runat="server"></asp:Label>") then click Add.
          The system will assign the next 4 unique digits and affix them to your prefix. 
          The new Customer ID (ie "<asp:Label ID="labCustId" runat="server"></asp:Label>99AB") 
          is now ready and you can enter the details. 
          Note: Once a Customer (Id) is generated it cannot be modified - it can only be deleted.

          <asp:Panel ID="panCustPrefix" runat="server" CssClass="panCustPrefix">
            <asp:TextBox runat="server"
              ID="txtCustPrefix"
              MaxLength="4"
              CssClass="txtCustPrefix"
              Text="" />
            <asp:Button runat="server"
              ID="btnCustPrefix"
              CssClass="btnCustPrefix"
              Text="Add"
              OnClick="btnCustPrefix_Click" />
          </asp:Panel>

        </asp:Panel>

        <asp:Panel ID="panBot_2" CssClass="panBot_2" runat="server" Visible="false">

          <h1>
            <asp:Literal ID="lit_Bot_2" runat="server" Text="Edit This Customer" />
            <asp:ImageButton
              OnClick="listCustomers_Click"
              CssClass="icons"
              ImageUrl="~/styles/icons/vubiz/back.png"
              ToolTip="Return to List"
              runat="server" />
            <br />
            <br />
            <asp:Label ID="labError_2" CssClass="labError" runat="server" />
          </h1>

          <asp:DetailsView
            BorderStyle="None"
            ID="dvCustomer"
            runat="server"
            CssClass="dvCustomer"
            DataSourceID="SqlDataSource2"
            DataKeyNames="custNo"
            OnItemDeleted="dvCustomer_ItemDeleted"
            AutoGenerateRows="False">
            <Fields>

              <asp:TemplateField HeaderText="Customer Id">

                <EditItemTemplate>
                  <asp:Label ID="labCustId" runat="server" Text='<%# Bind("custId") %>'></asp:Label>
                  <asp:HiddenField ID="custId" Value='<%# Bind("custId") %>' runat="server" />
                </EditItemTemplate>

                <InsertItemTemplate>
                  <asp:Label ID="labCustId" runat="server" Text='<%# Session["custId"] %>'></asp:Label>
                  <asp:HiddenField ID="custId" Value='<%# Session["custId"] %>' runat="server" />
                </InsertItemTemplate>

                <ItemTemplate>
                  <asp:Label ID="labCustId" runat="server" Text='<%# Bind("custId") %>'></asp:Label>
                  <asp:HiddenField ID="custId" Value='<%# Bind("custId") %>' runat="server" />
                </ItemTemplate>

                <HeaderStyle CssClass="tip custId" />
                <ControlStyle Width="100px" />

              </asp:TemplateField>

              <asp:TemplateField HeaderText="Title">
                <EditItemTemplate>
                  <asp:TextBox ID="custTitle" runat="server" Text='<%# Bind("custTitle") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:TextBox ID="custTitle" runat="server" Text='<%# Bind("custTitle") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:Label ID="custTitle" runat="server" Text='<%# Bind("custTitle") %>'></asp:Label>
                </ItemTemplate>
                <HeaderStyle CssClass="tip custTitle" />
                <ControlStyle Width="300px" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Language" HeaderStyle-CssClass="tip custLang">
                <EditItemTemplate>
                  <asp:DropDownList ID="custLang" runat="server" Height="23" AutoPostBack="true" SelectedValue='<%# Bind("custLang") %>'>
                    <asp:ListItem Value="EN" Text="EN"></asp:ListItem>
                    <asp:ListItem Value="FR" Text="FR"></asp:ListItem>
                    <asp:ListItem Value="ES" Text="ES"></asp:ListItem>
                  </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:DropDownList ID="custLang" runat="server" Height="23" AutoPostBack="true" SelectedValue='<%# Bind("custLang") %>'>
                    <asp:ListItem Value="EN" Text="EN"></asp:ListItem>
                    <asp:ListItem Value="FR" Text="FR"></asp:ListItem>
                    <asp:ListItem Value="ES" Text="ES"></asp:ListItem>
                  </asp:DropDownList>
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:Label ID="custLang" runat="server" Text='<%# Eval("custLang") %>'></asp:Label>
                </ItemTemplate>
                <HeaderStyle CssClass="tip custLang" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Parent Id">
                <EditItemTemplate>
                  <asp:TextBox ID="custParentId" runat="server" Text='<%# Bind("custParentId") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:TextBox ID="custParentId" runat="server" Text='<%# Bind("custParentId") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:Label ID="custParentId" runat="server" Text='<%# Bind("custParentId") %>'></asp:Label>
                </ItemTemplate>
                <ControlStyle Width="80px" />
                <HeaderStyle CssClass="tip custParentId" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Is SSO (Auto)">
                <EditItemTemplate>
                  <asp:CheckBox ID="custAuto" runat="server" Checked='<%# Bind("custAuto") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:CheckBox ID="custAuto" runat="server" Checked='<%# Bind("custAuto") %>' />
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:CheckBox ID="custAuto" runat="server" Checked='<%# Bind("custAuto") %>' Enabled="false" />
                </ItemTemplate>
                <HeaderStyle CssClass="tip custAuto" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Is NOP">
                <EditItemTemplate>
                  <asp:CheckBox ID="custChannelNop" runat="server" Checked='<%# Bind("custChannelNop") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:CheckBox ID="custChannelNop" runat="server" Checked='<%# Bind("custChannelNop") %>' />
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:CheckBox ID="custChannelNop" runat="server" Checked='<%# Bind("custChannelNop") %>' Enabled="false" />
                </ItemTemplate>
                <HeaderStyle CssClass="tip custNop" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Is V8">
                <EditItemTemplate>
                  <asp:CheckBox ID="custChannelV8" runat="server" Checked='<%# Bind("custChannelV8") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:CheckBox ID="custChannelV8" runat="server" Checked="true" />
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:CheckBox ID="custChannelV8" runat="server" Checked='<%# Bind("custChannelV8") %>' Enabled="false" />
                </ItemTemplate>
                <HeaderStyle CssClass="tip custV8" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Has Guests">
                <EditItemTemplate>
                  <asp:CheckBox ID="custChannelGuests" runat="server" Checked='<%# Bind("custChannelGuests") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:CheckBox ID="custChannelGuests" runat="server" Checked='<%# Bind("custChannelGuests") %>' />
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:CheckBox ID="custChannelGuests" runat="server" Checked='<%# Bind("custChannelGuests") %>' Enabled="false" />
                </ItemTemplate>
                <HeaderStyle CssClass="tip custGuests" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Profile">
                <EditItemTemplate>
                  <asp:TextBox ID="custProfile" runat="server" Text='<%# Bind("custProfile") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:TextBox ID="custProfile" runat="server" Text='<%# Bind("custProfile") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:Label ID="custProfile" runat="server" Text='<%# Bind("custProfile") %>'></asp:Label>
                </ItemTemplate>
                <ControlStyle Width="150px" />
                <HeaderStyle CssClass="tip custProfile" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="Active Customer">
                <EditItemTemplate>
                  <asp:CheckBox ID="custActive" runat="server" Checked='<%# Bind("custActive") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:CheckBox ID="custActive" runat="server" Checked="true" />
                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:CheckBox ID="custActive" runat="server" Checked='<%# Bind("custActive") %>' Enabled="false" />
                </ItemTemplate>
                <HeaderStyle CssClass="tip custActive" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="[ Active Learners ]">
                <EditItemTemplate>
                  <asp:Label ID="custLearners" runat="server" Text='<%# Eval("custLearners") %>'></asp:Label>

                </EditItemTemplate>
                <InsertItemTemplate>
                  <asp:Label ID="custLearners" runat="server" Text='<%# Eval("custLearners") %>'></asp:Label>

                </InsertItemTemplate>
                <ItemTemplate>
                  <asp:Label ID="custLearners" runat="server" Text='<%# Eval("custLearners") %>'></asp:Label>
                </ItemTemplate>
                <HeaderStyle CssClass="tip custLearners" />
              </asp:TemplateField>

              <asp:TemplateField HeaderText="[ Internal No ]">
                <EditItemTemplate>
                  <asp:Label ID="custNo" runat="server" Text='<%# Eval("custNo") %>' Enabled="false"></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                  <asp:Label ID="custNo" runat="server" Text='<%# Eval("custNo") %>' Enabled="false"></asp:Label>
                </ItemTemplate>
                <HeaderStyle CssClass="tip custNo" />
              </asp:TemplateField>

              <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icons">

                <EditItemTemplate>
                  <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnUpdate" runat="server" CausesValidation="False" CommandName="Update" ToolTip="Update Customer" />
                  <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="" ToolTip="Cancel Operation" OnClick="btnEditCancel_Click" />
                </EditItemTemplate>

                <InsertItemTemplate>
                  <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnUpdate" runat="server" CausesValidation="False" CommandName="" ToolTip="Add Customer" OnClick="btnUpdate_Click" />
                  <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnInsertCancel_Click" />
                </InsertItemTemplate>

                <ItemTemplate>
                  <asp:ImageButton ImageUrl="~/styles/icons/vubiz/edit.png" ID="btnEdit" runat="server" CausesValidation="True" CommandName="Edit" ToolTip="Edit Customer Profile" />
                  <asp:ImageButton ImageUrl="~/styles/icons/vubiz/delete.png" ID="btnDelete" runat="server" CausesValidation="True" OnCommand="btnConfirm_Command" CommandArgument='<%# "Delete|" + Eval("custId") + "|" + Eval("custGuid") + "|" + Eval("custLearners") %>' ToolTip="Delete this Learner. Note: this action cannot be reversed." />
                </ItemTemplate>

                <ControlStyle CssClass="icons edit" />

              </asp:TemplateField>

            </Fields>
          </asp:DetailsView>

        </asp:Panel>

      </asp:Panel>

    </asp:Panel>

  </div>

  <asp:SqlDataSource runat="server"
    ID="SqlDataSource1"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
	    SELECT 
		    Cust_No           AS custNo, 
		    Cust_Id           AS custId, 
		    Cust_Title        AS custTitle, 
		    Cust_Modified     AS custDate,
        LEFT(Cust_Id, 4)  AS custPrefix
	    FROM
		    V5_Vubz.dbo.Cust
	    WHERE 
        (
          Cust_ChannelV8 = 1 OR
          Cust_ChannelNOP = 1
        )
          AND
		    (
          LEN(@search) = 0 OR 
          @search IS NULL OR 
          @search = '*' OR 
          Cust_Id LIKE '%' + @search + '%' OR 
          Cust_Title LIKE '%' + @search + '%' 
		    )
        AND
		    (
			    (@active = '1' AND Cust_Active = 1)
			    OR
			    (@active = '0' AND Cust_Active = 0)
			    OR
			    (@active = '*')
		    )
	    ORDER BY
        custDate DESC
    ">
    <SelectParameters>
      <asp:ControlParameter Name="search" ControlID="txtSearch" DefaultValue="*" PropertyName="Text" Type="String" />
      <asp:ControlParameter Name="active" ControlID="ddActive" DefaultValue="1" PropertyName="Text" Type="String" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource
    ID="SqlDataSource2"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT 
        [Cust_No]                         AS custNo, 
        [Cust_Id]                         AS custId, 
        [Cust_Title]                      AS custTitle,
        [Cust_Active]                     AS custActive,
        [Cust_Lang]                       AS custLang,
        [Cust_ParentId]                   AS custParentId,
        [Cust_Auto]                       AS custAuto,
        [Cust_ChannelNop]                 AS custChannelNop,
        [Cust_ChannelV8]                  AS custChannelV8,
        [Cust_ChannelGuests]              AS custChannelGuests,
        [Cust_Profile]                    AS custProfile,
        apps.dbo.noLearners(Cust_AcctId)  AS custLearners,
        [Cust_Guid]                       AS custGuid
      FROM 
        V5_Vubz.dbo.Cust
      WHERE 
        [Cust_No] = @custNo
      "
    UpdateCommand="
      UPDATE 
        V5_Vubz.dbo.Cust
      SET 
        [Cust_Id]=UPPER(@custId), 
        [Cust_Title]=@custTitle, 
        [Cust_Active]=@custActive, 
        [Cust_Lang]=@custLang, 
        [Cust_ParentId]=@custParentId, 
        [Cust_Auto]=@custAuto, 
        [Cust_ChannelNop]=@custChannelNop, 
        [Cust_ChannelV8]=@custChannelV8, 
        [Cust_ChannelGuests]=@custChannelGuests, 
        [Cust_Profile]=@custProfile,
        [Cust_Modified]=GETDATE()
      WHERE 
        [Cust_No] = @custNo
    "
    DeleteCommand="
      DELETE 
        V5_Vubz.dbo.Cust  
      WHERE 
        Cust_No = @custNo
     ">

    <SelectParameters>
      <asp:ControlParameter ControlID="gvCustomers" Name="custNo" PropertyName="SelectedValue" Type="Int32" />
    </SelectParameters>

    <UpdateParameters>
      <asp:Parameter Name="custId" />
      <asp:Parameter Name="custTitle" />
      <asp:Parameter Name="custActive" />
      <asp:Parameter Name="custLang" />
      <asp:Parameter Name="custParentId" />
      <asp:Parameter Name="custAuto" />
      <asp:Parameter Name="custChannelNop" />
      <asp:Parameter Name="custChannelV8" />
      <asp:Parameter Name="custChannelGuests" />
      <asp:Parameter Name="custProfile" />
      <asp:Parameter Name="custNo" />
    </UpdateParameters>

    <DeleteParameters>
      <asp:Parameter Name="custNo" />
    </DeleteParameters>

  </asp:SqlDataSource>

</asp:Content>
