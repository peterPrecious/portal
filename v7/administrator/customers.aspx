<%@ Page
  AutoEventWireup="true"
  CodeBehind="customers.aspx.cs"
  EnableEventValidation="false"
  Inherits="portal.v7.administrator.customers"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  Title="Customers" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/customers.min.css" rel="stylesheet" />

  <style>
    table { margin: 0; padding: 0; }
    td, th { border: none; }
  </style>

  <script>
    $(function () {
      var lang = "<%=Session["lang"]%>";  // get language (not used on ADMIN services)

      // generates a yellow description in labError of panBottom - listed below in order rendered online
      $(".custNo").on("click", function () { setLabError("This is the unique, system generated Customer No. It is only used by Support.") });
      $(".custId").on("click", function () { setLabError("The Customer Id is the key for this Account.Once created it cannot be changed.It\'s format is AAAA9999 where the last 4 characters are system generated."); });
      $(".custTitle").on("click", function () { setLabError("A short description of this Account.") })
      $(".custActive").on("click", function () { setLabError("Defaults to ON. When OFF this Customer will not appear on any reports.") })
      $(".custLang").on("click", function () { setLabError("Must be one of EN, FR or ES. You cannot specify multiple languages.") })
      $(".custParentId").on("click", function () { setLabError("If this is a child account, this field contains the Account Id of the Parent. IE if the parent\'s Customer Id is CAAM3001 then this field will be 3001.") })
      $(".custAuto").on("click", function () { setLabError("Allows Channel SSO for learners when authentication occurs behind the customer\'s firewall. Uncheck for V8 where the presence of a custGuid in the call invokes SSO.") })
      $(".custNop").on("click", function () { setLabError("Set ON if this account uses NOP for ecommerce.") })
      $(".custV8").on("click", function () { setLabError("Set ON if this account uses V8 to view content.") })
      $(".custGuests").on("click", function () { setLabError("Check to enable the Guest Subsystem (used by CFIB/FCEI). Typically set to No. Should only be set to Yes if this is a Parent Account, ie the Parent Id is empty.") })
      $(".custProfile").on("click", function () { setLabError("Profile is typically something like \'abcd_en\'. Note this is NOT the Alias, which is a simpler version for ease of use.") })
      $(".custLearners").on("click", function () { setLabError("This is the computed number of Active Learners in this Account. If you plan to Delete this Account, all Active Learners must be inactivated or deleted.") })

      $(".txtCustPrefix").on("blur", function () {
        var str = $(".txtCustPrefix").val().toUpperCase();
        var len = str.length;
        var pat = new RegExp(/^[A-Z]+$/);
        if (str.length !== 4 || !pat.test(str)) { setLabError("Please enter a 4 character Customer Prefix.") };
      })

      // clears the labError
      $(".labError").on("click", function () {
        setLabError("");
        $(".txtCustPrefix").html("");
      })

    })

    function setLabError(desc) {
      if ($(".labError").html() == "" || $(".labError").html() != desc) {
        $(".labError").html(desc);
      } else {
        $(".labError").html("");
      }
    }

  </script>

</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png"
      ID="exit" runat="server" OnClick="exit_Click" />

    <asp:Panel ID="panConfirmShell" CssClass="panConfirmShell" runat="server" Visible="false">
      <asp:Panel ID="panConfirm" CssClass="panConfirm" runat="server">
        <table>
          <tr>
            <td>
              <h1>
                <asp:Label ID="labConfirmTitle" runat="server"></asp:Label></h1>
              <h2>
                <asp:Label ID="labConfirmMessage" runat="server"></asp:Label><br /><br />
                <asp:LinkButton CssClass="newButton" ID="btnConfirmCancel" OnClientClick='$(".panConfirm").hide(); return false;' runat="server"></asp:LinkButton>&nbsp;&nbsp;
                <asp:LinkButton CssClass="newButton" ID="btnConfirmOk" OnClick="btnConfirmOk_Click" runat="server"></asp:LinkButton>
              </h2>
            </td>
          </tr>
        </table>
      </asp:Panel>
    </asp:Panel>

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

      <asp:Panel ID="panTop" CssClass="panTop" runat="server">
        <br /><br />

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Literal runat="server" Text="Customers" />
          </span>
          <asp:ImageButton runat="server"
            ImageUrl="~/styles/icons/portal/add.png"
            OnClick="dvCustomer_ItemInit"
            ToolTip="Add a Customer"
            Width="25" />
        </h1>

        <div class="thisTitle">
          Select
          <asp:DropDownList ID="ddActive" runat="server"
            CssClass="dropDown" OnSelectedIndexChanged="ddActive_SelectedIndexChanged">
            <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
            <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
            <asp:ListItem Text="Active and Inactive" Value="*"></asp:ListItem>
          </asp:DropDownList>
          V8/NOP Customers whose Customer Id or Title contains the Start Value below.
          If you leave the Start Value empty the list will start at the beginning alphabetically by Customer Id.
          You can sort on the <b>Customer Id</b> and <b>Last Date</b> (which is the date this Customer Profile was last updated).
          Clicking on one of these two headers will sort the values in Ascending order, clicking again will sort them in Descending order.
          Note: this service is only used to Add or Edit Customers designated for V8 and/or NOP. 
          Legacy Accounts must be accessed via the V5 System.<br />
          <br />

          Cloning a Customer creates a new account with the same values as the Account you are cloning.
          The only exception is the Customer Id which is generated starting with the 4 characters of the <b>Cust</b> column.
          Once cloned the new Account will appear at the top of the list where you can edit it like any other Account.<br />

          <br />
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" />


          <div style="margin-top: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="Start Value" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="Start" />
            <asp:Button ID="butRestart" OnClick="butRestart_Click" CssClass="button newButton1" runat="server" Text="<%$  Resources:portal, restart%>" />
          </div>

        </div>

        <asp:GridView runat="server"
          AllowPaging="True"
          AllowSorting="True"
          AutoGenerateColumns="False"
          CssClass="gvCustomers"
          DataKeyNames="custNo"
          DataSourceID="SqlDataSource1"
          HeaderStyle-BackColor="#0178B9"
          HeaderStyle-ForeColor="White"
          HorizontalAlign="Center"
          ID="gvCustomers"
          OnRowDataBound="gvCustomers_RowDataBound"
          OnSelectedIndexChanged="gvCustomers_SelectedIndexChanged"
          PageSize="20"
          Width="800px">
          <Columns>
            <asp:BoundField DataField="custId" ItemStyle-Width="100px" HeaderText="Customer Id" ItemStyle-HorizontalAlign="Center" SortExpression="custId" />
            <asp:BoundField DataField="custTitle" ItemStyle-Width="450px" HeaderText="Title" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left" />
            <asp:BoundField DataField="custDate" ItemStyle-Width="100px" HeaderText="Last Date" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:MMM d, yyyy}" SortExpression="custDate" />
            <asp:TemplateField HeaderText="Details" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:ImageButton runat="server"
                  CssClass="icons2"
                  CausesValidation="True"
                  CommandName="Select"
                  ID="btnSelect"
                  ImageUrl="~/styles/icons/portal/details.png"
                  Text="Details"
                  ToolTip="Display details of this Customer" />
              </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Center" HeaderText="Cust" HeaderStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:TextBox
                  ID="txtClone"
                  CssClass="txtClone"
                  MaxLength="4"
                  Width="80"
                  Text='<%#Eval("custPrefix")%>'
                  runat="server" />
              </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField
              ItemStyle-Width="050px" ItemStyle-HorizontalAlign="Center"
              HeaderText="Clone" HeaderStyle-HorizontalAlign="Center">
              <ItemTemplate>
                <asp:ImageButton
                  runat="server"
                  Width="25"
                  CssClass="icons2"
                  ImageUrl="~/styles/icons/portal/clone.png"
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
            <br />
            Oops. There are no V8/NOP Customers on file based on your selection criteria.<br />
            <br /><br />
          </EmptyDataTemplate>
        </asp:GridView>

      </asp:Panel>

      <asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">
        <br /><br />

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Label ID="panBotHeader" CssClass="resendAlerts" runat="server" Text="Add/Edit Customer" />
          </span>

          <asp:ImageButton runat="server"
            ID="titleAddACustomer"
            ImageUrl="~/styles/icons/portal/back.png"
            OnClick="listCustomers_Click"
            ToolTip="Return to Customer List" />

          <asp:Panel runat="server" ID="panBotTitle" CssClass="thisTitle">

            <asp:Panel runat="server" CssClass="c3">
              Each new Customer profile (account) requires a unique <b>Customer Id</b>.
              Start by entering an approriate 4 alpha character customer prefix below
              (ie "<asp:Label ID="labCust" runat="server">ABCD</asp:Label>") then click Add.
              The system will assign the next available 4 unique digits (ie "1234")          
              and affix them to your prefix. 
            </asp:Panel>

            <asp:Panel ID="panCustPrefix" runat="server" CssClass="panCustPrefix">
              <asp:TextBox runat="server"
                ID="txtCustPrefix"
                MaxLength="4"
                CssClass="txtCustPrefix"
                OnPreRender="txtCustPrefix_PreRender"
                Text="" />
              <asp:Button runat="server"
                ID="btnCustPrefix"
                CssClass="btnCustPrefix"
                Text="Add"
                OnClick="btnCustPrefix_Click" />
            </asp:Panel>

          </asp:Panel>
        </h1>

        <asp:Panel ID="panPooh" runat="server" CssClass="thisTitle" Visible="false">
          <b>Customer Id</b>
          <asp:Label ID="labCustId" runat="server">xxxx</asp:Label>
          has now been reserved. This Id cannot be modified, only deleted.
          Please enter the customer details then update the record. 
        </asp:Panel>

        <div style="margin-left: auto; margin-right: auto; text-align: center;">
          <asp:Label runat="server" ID="labError" CssClass="labError" />
        </div>

        <asp:DetailsView runat="server"
          AutoGenerateRows="False"
          BorderStyle="None"
          CssClass="dvCustomer"
          DataKeyNames="custNo"
          DataSourceID="SqlDataSource2"
          DefaultMode="Edit"
          HeaderStyle-Font-Bold="true"
          HeaderStyle-HorizontalAlign="Right"
          ID="dvCustomer"
          OnDataBound="dvCustomer_DataBound"
          OnItemInserting="dvCustomer_ItemInserting"
          OnItemInserted="dvCustomer_ItemInserted"
          OnItemUpdating="dvCustomer_ItemUpdating"
          OnItemUpdated="dvCustomer_ItemUpdated"
          OnItemDeleted="dvCustomer_ItemDeleted"
          Visible="false">

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

            <asp:TemplateField HeaderText="Language">
              <EditItemTemplate>
                <asp:DropDownList ID="custLang" runat="server">
                  <asp:ListItem Value="EN"></asp:ListItem>
                  <asp:ListItem Value="ES"></asp:ListItem>
                  <asp:ListItem Value="FR"></asp:ListItem>
                </asp:DropDownList>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:DropDownList ID="custLang" runat="server">
                  <asp:ListItem Value="EN"></asp:ListItem>
                  <asp:ListItem Value="ES"></asp:ListItem>
                  <asp:ListItem Value="FR"></asp:ListItem>
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

            <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icons2">
              <EditItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/update.png" ID="btnUpdate" runat="server"
                  CausesValidation="True" CommandName="Update" ToolTip="Update Customer" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/cancel.png" ID="btnCancel" runat="server"
                  CausesValidation="False" CommandName="" ToolTip="Cancel Operation" OnClick="btnEditCancel_Click" />
              </EditItemTemplate>
              <InsertItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/update.png" ID="btnUpdate" runat="server"
                  CausesValidation="False" CommandName="" ToolTip="Add Customer" OnClick="btnUpdate_Click" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/cancel.png" ID="btnCancel" runat="server"
                  CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnInsertCancel_Click" />
              </InsertItemTemplate>
              <ItemTemplate>
                <br /><br /><br />
                <asp:ImageButton ImageUrl="~/styles/icons/portal/edit.png" ID="btnEdit" runat="server"
                  CausesValidation="True" CommandName="Edit" ToolTip="Edit Customer Profile" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:ImageButton ImageUrl="~/styles/icons/portal/delete.png" ID="btnDelete" runat="server"
                  CausesValidation="True"
                  OnCommand="btnConfirm_Command"
                  CommandArgument='<%# "Delete|" + Eval("custId") + "|" + Eval("custGuid") + "|" + Eval("custLearners") %>'
                  ToolTip="Delete this Customer. Note: this action cannot be reversed." />
              </ItemTemplate>
            </asp:TemplateField>

          </Fields>

          <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />

        </asp:DetailsView>

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
          Cust_ChannelV8  = 1 OR
          Cust_ChannelNOP = 1
        )
          AND
		    (
          LEN(@search)    = 0 OR 
          @search         IS NULL OR 
          @search         = '*' OR 
          Cust_Id         LIKE '%' + @search + '%' OR 
          Cust_Title      LIKE '%' + @search + '%' 
		    )
        AND
		    (
			    (@active        = '1' AND Cust_Active = 1) OR
			    (@active        = '0' AND Cust_Active = 0) OR
			    (@active        = '*')
		    )
	    ORDER BY
        Cust_Modified DESC,
        Cust_Id
    ">
    <SelectParameters>
      <asp:ControlParameter Name="search" ControlID="txtSearch" DefaultValue="*" PropertyName="Text" Type="String" />
      <asp:ControlParameter Name="active" ControlID="ddActive" DefaultValue="1" PropertyName="Text" Type="String" />
    </SelectParameters>
  </asp:SqlDataSource>

  <asp:SqlDataSource runat="server"
    ID="SqlDataSource2"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT 
        Cust_No                           AS custNo, 
        Cust_Id                           AS custId, 
        Cust_Title                        AS custTitle,
        Cust_Active                       AS custActive,
        Cust_Lang                         AS custLang,
        Cust_ParentId                     AS custParentId,
        Cust_Auto                         AS custAuto,
        Cust_ChannelNop                   AS custChannelNop,
        Cust_ChannelV8                    AS custChannelV8,
        Cust_ChannelGuests                AS custChannelGuests,
        Cust_Profile                      AS custProfile,
        apps.dbo.noLearners(Cust_AcctId)  AS custLearners,
        Cust_Guid                         AS custGuid
      FROM 
        V5_Vubz.dbo.Cust
      WHERE 
        Cust_No = @custNo
      "
    UpdateCommand="
      UPDATE
        V5_Vubz.dbo.Cust
      SET 
        Cust_Id=UPPER(@custId), 
        Cust_Title=@custTitle, 
        Cust_Active=@custActive, 
        Cust_Lang=@custLang, 
        Cust_ParentId=@custParentId, 
        Cust_Auto=@custAuto, 
        Cust_ChannelNop=@custChannelNop, 
        Cust_ChannelV8=@custChannelV8, 
        Cust_ChannelGuests=@custChannelGuests, 
        Cust_Profile=@custProfile,
        Cust_Modified=GETDATE()
      WHERE 
        Cust_No = @custNo
    "
    DeleteCommand="
      DELETE 
        V5_Vubz.dbo.Cust  
      WHERE 
        Cust_No = @custNo
     "
    InsertCommand="
      INSERT 
        V5_Vubz.dbo.Cust   
        (
          Cust_Id, 
          Cust_Title, 
          Cust_Active, 
          Cust_Lang, 
          Cust_ParentId, 
          Cust_Auto, 
          Cust_ChannelNop, 
          Cust_ChannelV8, 
          Cust_ChannelGuests, 
          Cust_Profile, 
          Cust_Active
        ) 
      VALUES 
        (
          UPPER(@CustId), 
          @CustTitle, 
          @CustActive, 
          @CustLang, 
          @CustParentId, 
          @CustAuto, 
          @CustChannelNop,
          @CustChannelV8,
          @CustChannelGuests,
          @CustProfile, 
          @CustActive
        )
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

    <InsertParameters>
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
    </InsertParameters>

  </asp:SqlDataSource>

  <asp:SqlDataSource runat="server"
    ID="SqlDataSource3"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      DECLARE @Temp_Table AS TABLE 
        (custNo INTEGER, custId VARCHAR(128), custFirstName VARCHAR(32), custLastName VARCHAR(64), custEmail VARCHAR(128), custOrganization VARCHAR(128), custLevel INTEGER, custChild INTEGER)

      INSERT INTO @Temp_Table
      SELECT
	      Cust_No                 AS custNo,
	      Cust_Id                 AS custId,
	      Cust_FirstName          AS custFirstName,
	      Cust_LastName           AS custLastName,
	      Cust_Email              AS custEmail,
	      Cust_Organization       AS custOrganization,
	      Cust_Level              AS custLevel,
	      0						            AS custChild
      FROM 
	      V5_Vubz.dbo.Cust
      WHERE
	      Cust_Email              != '' AND
	      Cust_FirstName          != '' AND
	      Cust_LastName           != '' AND
	      Cust_Level              &lt; @custLevel AND
	      Cust_AcctId             = @custAcctId AND
	      Cust_Internal           = 0 AND
	      (
		      LEN(@search)          = 0 OR
		      @search               IS NULL OR
		      @search               = '*' OR
		      Cust_Id               LIKE '%' + @search + '%' OR
		      Cust_FirstName        LIKE '%' + @search + '%' OR
		      Cust_LastName         LIKE '%' + @search + '%' OR
		      Cust_Email            LIKE '%' + @search + '%' OR
		      Cust_Organization     LIKE '%' + @search + '%'
	      )

      INSERT INTO @Temp_Table
      SELECT
	      Cust_No                 AS custNo,
	      Cust_Id                 AS custId,
	      Cust_FirstName          AS custFirstName,
	      Cust_LastName           AS custLastName,
	      Cust_Email              AS custEmail,
	      Cust_Organization       AS custOrganization,
	      Cust_Level              AS custLevel,
	      1						            AS custChild
      FROM 
	      V5_Vubz.dbo.Cust
      WHERE
	      Cust_Level              &lt; @custLevel AND
	      (
		      LEN(@search)          = 0 OR
		      @search               IS NULL OR
		      @search               = '*' OR
		      Cust_Id               LIKE '%' + @search + '%' OR
		      Cust_FirstName        LIKE '%' + @search + '%' OR
		      Cust_LastName         LIKE '%' + @search + '%' OR
		      Cust_Email            LIKE '%' + @search + '%' OR
		      Cust_Organization     LIKE '%' + @search + '%'
	      )

      SELECT
	      custNo,
	      custId
      FROM
	      @Temp_Table
    ">
    <SelectParameters>
      <asp:SessionParameter Name="custAcctId" DefaultValue="" SessionField="custAcctId" />
      <asp:ControlParameter Name="search" ControlID="txtSearch" DefaultValue="*" PropertyName="Text" />
    </SelectParameters>

  </asp:SqlDataSource>

</asp:Content>
