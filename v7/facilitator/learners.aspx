<%@ Page
  Title="Learners"
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="learners.aspx.cs"
  Inherits="portal.v7.facilitator.learners" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/learners.css" rel="stylesheet" />
  <script>
    var trSave = "";  // this is where we save the managerAccess row, which we hide and then show
    function managerAccess(action, usesPassword) {
      // determine which row to hide/show depending on whether this account usesPassword or not
      var rowNo = 8;
      if (usesPassword == 'True') rowNo = 9;
      var trRow = $(".detailsView")[0].rows[rowNo]; // get row9, normally managerAccess unless that has been detached
      var tdTxt = $(".detailsView")[0].rows[rowNo].cells[0].innerHTML; // get row9, normally managerAccess unless that has been detached
      if (action === "hide" && tdTxt === "Manager Access") {
        trRowSave = trRow;
        trRow.remove();
      } if (action === "show" && tdTxt != "Manager Access" && trRowSave != "") {
        trRow.before(trRowSave);  // if it was detached then plop the row back into the table
      }
    }
    function membIdValidate(action) {
      if (action === "onFocus") { // this will reset any invalid membId plus associated label
        $("#MainContent_dvLearner_membId").val("");
        $("#MainContent_labError").hide();
        $("#MainContent_dvLearner_labNotUnique").hide();
      } else if (action === "onBlur") { // this will check if this learnerId is unique
        __doPostBack('ctl00$MainContent$dvLearner$membId', "");
      }
    }
    function toggleService() {
      // if we don't want to receive Alert then disable button to resend Alerts
      // if we are checking this feature then show else hide;
      if ($("#MainContent_dvLearner_membEmailAlert")[0].checked) {
        $(".resendAlerts").show();
      } else {
        $(".resendAlerts").hide();
      }
    }

    $(function () {
      if ($("#MainContent_dvLearner_lab_membEmailAlert")[0] !== undefined) {
        if ($("#MainContent_dvLearner_lab_membEmailAlert")[0].checked) {
          $(".resendAlerts").show();
        } else {
          $(".resendAlerts").hide();
        }
      }
      if ($("#MainContent_dvLearner_membEmailAlert")[0] !== undefined) {
        if ($("#MainContent_dvLearner_membEmailAlert")[0].checked) {
          $(".resendAlerts").show();
        } else {
          $(".resendAlerts").hide();
        }
      }
      $(".membLevel").on("change", function () {  // only show the managerAccess options to Mgr and Adm levels, else hide
        var membLevel = parseInt($(this).val());
        if (membLevel < 4) {
          managerAccess("hide");
        } else {
          managerAccess("show");
        }
      })
      var keyStop = {
        // used to ignore enter in textbox [https://stackoverflow.com/questions/585396/how-to-prevent-enter-keypress-to-submit-a-web-form ]
        // before this when you hit Enter while in the Search text box the page would be lost
        8: ":not(input:text, textarea, input:file, input:password)", // stop backspace = back
        13: "input:text, input:password", // stop enter = submit 
        end: null
      };
      $(document).bind("keydown", function (event) {
        var selector = keyStop[event.which];
        if (selector !== undefined && $(event.target).is(selector)) {
          event.preventDefault(); //stop event
        }
        return true;
      });
    });

    $(function () { // generates a yellow description in labError of panBottom
      $(".membNo").on("click", function () { $(".labError").html('This is an Internal value used by Vubiz Support.') })
      $(".membId").on("click", function () { $(".labError").html('A globally unique value for this learner. Once assigned it cannot be changed.') })
      // clears the labError
      $(".labError").on("click", function () { $(".labError").html('') })
    })
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

      <asp:Panel ID="panTop" CssClass="panTop" runat="server">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline" title="Click to hide/show discription."><asp:Literal runat="server" Text="<%$  Resources:portal, learners%>" /></span>
          <asp:ImageButton OnClick="dvLearner_ItemInit" CssClass="icons add" ImageUrl="~/styles/icons/vubiz/add.png" ToolTip="Add a Learner" runat="server" />
        </h1>

        <div class="thisTitle">
          <asp:Literal ID="noLearners" runat="server" />A learner must have a name and email address to appear on this list.
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1a%>" />
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1b%>" />
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1c%>" />
          <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
          <div style="margin: 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="alignCenter" placeholder="<%$  Resources:portal, searchValue%>" runat="server" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="<%$  Resources:portal, search%>" />
          </div>
        </div>

        <asp:GridView runat="server"
          AllowPaging="True"
          AllowSorting="True"
          AutoGenerateColumns="False"
          ID="gvLearners"
          CssClass="gvLearners"
          DataKeyNames="membNo"
          DataSourceID="SqlDataSource1"
          HorizontalAlign="Center"
          OnSelectedIndexChanged="gvLearners_SelectedIndexChanged"
          PageSize="20"
          RowStyle-HorizontalAlign="Left">
          <Columns>
            <asp:BoundField DataField="membId" HeaderText="Username" SortExpression="membId" />
            <asp:BoundField DataField="membFirstName" HeaderText="First Name" SortExpression="membFirstName" />
            <asp:BoundField DataField="membLastName" HeaderText="Last Name" SortExpression="membLastName" />
            <asp:BoundField DataField="membEmail" HeaderText="Email" SortExpression="membEmail" />
            <asp:BoundField DataField="membLevel" HeaderText="Level" SortExpression="membLevel" />
            <asp:TemplateField HeaderText="Details">
              <ItemTemplate>
                <asp:ImageButton
                  CssClass="icons info"
                  ID="btnSelect"
                  ToolTip="Display details of this Learner"
                  runat="server"
                  CausesValidation="True"
                  CommandName="Select"
                  ImageUrl="~/styles/icons/vubiz/info.png"
                  Text="Details" />
              </ItemTemplate>
            </asp:TemplateField>
          </Columns>

          <RowStyle HorizontalAlign="Left" />

          <PagerSettings
            FirstPageImageUrl="~/styles/icons/grids/frst.png"
            LastPageImageUrl="~/styles/icons/grids/last.png"
            NextPageImageUrl="~/styles/icons/grids/next.png"
            PreviousPageImageUrl="~/styles/icons/grids/prev.png"
            Position="Bottom"
            Mode="NextPreviousFirstLast" />
          <PagerStyle CssClass="commands" HorizontalAlign="Center" />

          <EmptyDataRowStyle ForeColor="Yellow" Font-Size="Large" />
          <EmptyDataTemplate>
            <br />
            There are currently no Learners in this Account.  Use the Add icon above to Add learners.<br />
            <br />
          </EmptyDataTemplate>
        </asp:GridView>

      </asp:Panel>

      <asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline" title="Add/Edit Learner">
            <asp:Literal runat="server" Text="Add/Edit Learner" />
          </span>
          <asp:ImageButton
            OnClick="ListLearners_Click"
            CssClass="icons"
            ImageUrl="~/styles/icons/vubiz/back.png"
            ToolTip="Return to List"
            runat="server" />
        </h1>

        <div class="thisTitle">
          Note: <b>Username</b> must be globally unique (suggest email).
          Fields up to and including Email are mandatory.
          The <b>Programs</b> field is assigned elsewhere thus is read only. 
          <asp:Label ID="labAlerts" CssClass="resendAlerts" runat="server" Text="If this learner did not receive their 'Welcome' email alert(s), for whatever reason, click the Email icon and the system will resend any outstanding Email Alerts."></asp:Label>
          When done, click the icon at top to return to the Learner List.
        </div>

        <asp:Label
          ID="labError"
          CssClass="labError"
          ForeColor="Yellow"
          Font-Bold="true"
          Width="600"
          runat="server" />

        <asp:DetailsView runat="server"
          AutoGenerateRows="False"
          BorderStyle="None"
          CssClass="dvLearner"
          DataKeyNames="membNo"
          DataSourceID="SqlDataSource2"
          DefaultMode="Edit"
          HeaderStyle-Font-Bold="true"
          HeaderStyle-HorizontalAlign="Right"
          ID="dvLearner"
          OnDataBound="dvLearner_DataBound"
          OnItemInserting="dvLearner_ItemInserting"
          OnItemInserted="dvLearner_ItemInserted"
          OnItemUpdating="dvLearner_ItemUpdating"
          OnItemUpdated="dvLearner_ItemUpdated"
          OnItemDeleted="dvLearner_ItemDeleted">

          <Fields>
            <asp:TemplateField HeaderText="<%$ Resources:portal, uniqueId%>" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Right">
              <EditItemTemplate>
                <asp:Label ID="lab_membId" runat="server" Text='<%# Bind("membId") %>' Enabled="false"></asp:Label>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="membId" CssClass="upper" OnBlur="return membIdValidate('onBlur')" OnFocus="return membIdValidate('onFocus')" runat="server" Text='<%# Bind("membId") %>' />
                <asp:Label ID="labNotUnique" runat="server" Text="Not Unique!" ForeColor="Yellow" Visible="false" />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="lab_membId" runat="server" Text='<%# Bind("membId") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip membId" Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, password%>">
              <EditItemTemplate>
                <asp:TextBox ID="membPwd" CssClass="upper" runat="server" Text='<%# Bind("membPwd") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="membPwd" CssClass="upper" runat="server" Text='<%# Bind("membPwd") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="membPwd" runat="server" Text='<%# Bind("membPwd") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, firstName%>">
              <EditItemTemplate>
                <asp:TextBox ID="membFirstName" runat="server" Text='<%# Bind("membFirstName") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="membFirstName" runat="server" Text='<%# Bind("membFirstName") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="lab_membFirstName" runat="server" Text='<%# Bind("membFirstName") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, lastName%>">
              <EditItemTemplate>
                <asp:TextBox ID="membLastName" runat="server" Text='<%# Bind("membLastName") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="membLastName" runat="server" Text='<%# Bind("membLastName") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="lab_membLastName" runat="server" Text='<%# Bind("membLastName") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, email%>">
              <EditItemTemplate>
                <asp:TextBox ID="membEmail" runat="server" Text='<%# Bind("membEmail") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="membEmail" runat="server" Text='<%# Bind("membEmail") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="lab_membEmail" runat="server" Text='<%# Bind("membEmail") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, organization%>">
              <EditItemTemplate>
                <asp:TextBox ID="membOrganization" runat="server" Text='<%# Bind("membOrganization") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="membOrganization" runat="server" Text='<%# Bind("membOrganization") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="lab_membOrganization" runat="server" Text='<%# Bind("membOrganization") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, memo%>">
              <EditItemTemplate>
                <asp:TextBox ID="membMemo" runat="server" Text='<%# Bind("membMemo") %>'></asp:TextBox>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="membMemo" runat="server" Text='<%# Bind("membMemo") %>'></asp:TextBox>
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="membMemo" runat="server" Text='<%# Bind("membMemo") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, programs%>">
              <ItemTemplate>
                <asp:Label ID="membPrograms" runat="server" Text='<%# Bind("membPrograms") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, level%>" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Right">
              <EditItemTemplate>
                <asp:DropDownList Height="23" ID="membLevel" SelectedValue='<%# Bind("membLevel") %>' CssClass="membLevel" runat="server">
                  <asp:ListItem Value="1" Text="Guest"></asp:ListItem>
                  <asp:ListItem Value="2" Text="Learner"></asp:ListItem>
                  <asp:ListItem Value="3" Text="Facilitator"></asp:ListItem>
                  <asp:ListItem Value="4" Text="Manager"></asp:ListItem>
                  <asp:ListItem Value="5" Text="Administrator"></asp:ListItem>
                </asp:DropDownList>
                <asp:HiddenField ID="hidMembLevel" Value='<%# Bind("membLevel") %>' runat="server" />
                <br />
                The Level value should NOT be changed once updated since other values depend on its state.
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:DropDownList Height="23" ID="membLevel" SelectedValue='<%# Bind("membLevel") %>' CssClass="membLevel" runat="server">
                  <asp:ListItem Value="1" Text="Guest"></asp:ListItem>
                  <asp:ListItem Value="2" Text="Learner"></asp:ListItem>
                  <asp:ListItem Value="3" Text="Facilitator"></asp:ListItem>
                  <asp:ListItem Value="4" Text="Manager"></asp:ListItem>
                  <asp:ListItem Value="5" Text="Administrator"></asp:ListItem>
                </asp:DropDownList>
                <asp:Label ID="labMembLevel" runat="server">Level</asp:Label>
                <asp:HiddenField ID="hidMembLevel" Value='<%# Bind("membLevel") %>' runat="server" />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="membLevel" runat="server" Text='<%# Bind("membLevelText") %>'></asp:Label>
                <asp:HiddenField ID="hidMembLevel" Value='<%# Bind("membLevel") %>' runat="server" />
              </ItemTemplate>

            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, managerAccess%>" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Right">
              <ItemTemplate>
                <asp:Label ID="membManagerAccess" runat="server" Text='<%# Eval("membManagerAccess") %>'></asp:Label>
              </ItemTemplate>

              <EditItemTemplate>
                <asp:ListBox ID="membManagerAccess" SelectionMode="Multiple" CssClass="membManagerAccess" Rows="4" runat="server">
                  <asp:ListItem Value="0" Text="No Special Access"></asp:ListItem>
                  <asp:ListItem Value="1" Text="Manage Programs"></asp:ListItem>
                  <asp:ListItem Value="2" Text="Manage Modules"></asp:ListItem>
                  <asp:ListItem Value="3" Text="Extend Ecommerce"></asp:ListItem>
                </asp:ListBox>
                <asp:HiddenField ID="hidMembManagerAccess" Value='<%# Eval("membManagerAccess") %>' runat="server" />
                <br />
                Note: select/highlight either 'No Special Access' OR any combination of the other values. Use CTRL click to select/highlight multiple values.
              </EditItemTemplate>

              <InsertItemTemplate>
                <asp:ListBox ID="membManagerAccess" SelectionMode="Multiple" CssClass="membManagerAccess" Rows="4" runat="server">
                  <asp:ListItem Value="0" Text="No Special Access"></asp:ListItem>
                  <asp:ListItem Value="1" Text="Manage Programs"></asp:ListItem>
                  <asp:ListItem Value="2" Text="Manage Modules"></asp:ListItem>
                  <asp:ListItem Value="3" Text="Extend Ecommerce"></asp:ListItem>
                </asp:ListBox>
                <asp:Label ID="labMembManagerAccess" runat="server"></asp:Label>
                <asp:HiddenField ID="txtMembManagerAccess" runat="server" />
              </InsertItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, receiveAlerts %>">
              <EditItemTemplate>
                <asp:CheckBox onclick="toggleService()" ID="membEmailAlert" runat="server" Checked='<%# Bind("membEmailAlert") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="membEmailAlert" runat="server" Checked='<%# Bind("membEmailAlert") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="lab_membEmailAlert" runat="server" Checked='<%# Bind("membEmailAlert") %>' Enabled="false" />
              </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField Visible="true" HeaderText="Resend Alerts">
              <ItemStyle CssClass="resendAlerts" />
              <HeaderStyle CssClass="resendAlerts" />
              <ItemTemplate>
                <asp:ImageButton ID="butResendEmailAlerts" CssClass="icons email" OnClick="butResendEmailAlerts_Click" ImageUrl="~/styles/icons/vubiz/emailSolo.png" runat="server" CausesValidation="false" Text="Resend" ToolTip="<%$ Resources:portal, alertsResend%>" />
                &nbsp;&nbsp;&nbsp;<asp:Label ID="labResendEmailAlerts" runat="server" Visible="false" Text="<%$ Resources:portal, alertsResent%>"></asp:Label>
              </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Active">
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

            <asp:TemplateField HeaderText="[ Vubiz Internal ]">
              <EditItemTemplate>
                <asp:Label ID="membNo" runat="server" Text='<%# Eval("membNo") %>' Enabled="false"></asp:Label>
              </EditItemTemplate>
              <ItemTemplate>
                <asp:Label ID="membNo" runat="server" Text='<%# Eval("membNo") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip membNo" />
            </asp:TemplateField>

            <asp:TemplateField ShowHeader="False" ControlStyle-CssClass="icons">
              <EditItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnUpdate" runat="server" CausesValidation="True" CommandName="Update" ToolTip="Update Learner" />
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/update.png" ID="btnInsert" runat="server" CausesValidation="True" CommandName="Insert" ToolTip="Add a Learner" />
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/cancel.png" ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel" ToolTip="Cancel Operation" OnClick="btnCancel_Click" />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/edit.png" ID="btnEdit" runat="server" CausesValidation="True" CommandName="Edit" ToolTip="Edit Learner's Profile" />
                <asp:ImageButton ImageUrl="~/styles/icons/vubiz/delete.png" ID="btnDelete" runat="server" CausesValidation="False" CommandName="Delete" ToolTip="Delete Learner" OnClientClick="return confirm('Are you certain you want to permanently delete this Learner?')" />
              </ItemTemplate>
              <ControlStyle CssClass="icons edit" />
            </asp:TemplateField>

          </Fields>
          <HeaderStyle Font-Bold="True" HorizontalAlign="Right" />
        </asp:DetailsView>

      </asp:Panel>

    </asp:Panel>

  </div>

  <%-- Note: we are using the Memb_Jobs field to contain the MembAccess Values, either null or 0-3 or a combo of, ie: 1,3 --%>
  <asp:SqlDataSource
    ID="SqlDataSource1" runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT TOP 200 
        [Memb_No]               AS membNo, 
        [Memb_Id]               AS membId, 
        [Memb_FirstName]        AS membFirstName, 
        [Memb_LastName]         AS membLastName,
        [Memb_Email]            AS membEmail,
        [Memb_Organization]     AS membOrganization,
        [Memb_Level]            AS membLevel
      FROM 
        V5_Vubz.dbo.Memb
      WHERE
        Memb_Email              != '' AND 
        Memb_FirstName          != '' AND 
        Memb_LastName           != '' AND 
        Memb_Level              &lt; @membLevel AND 
        Memb_AcctId             = @membAcctId AND 
        Memb_Internal           = 0 AND 
        (
          LEN(@search)          = 0 OR 
          @search               IS NULL OR 
          @search               = '*' OR 
          Memb_Id               LIKE '%' + @search + '%' OR 
          Memb_FirstName        LIKE '%' + @search + '%' OR 
          Memb_LastName         LIKE '%' + @search + '%' OR 
          Memb_Email            LIKE '%' + @search + '%' OR 
          Memb_Organization     LIKE '%' + @search + '%' 
        ) 
      ORDER BY 
        Memb_LastName, 
        Memb_FirstName 
    ">
    <SelectParameters>
      <asp:SessionParameter Name="membLevel" SessionField="membLevel" />
      <asp:SessionParameter Name="membAcctId" DefaultValue="" SessionField="custAcctId" />
      <asp:ControlParameter Name="search" ControlID="txtSearch" DefaultValue="*" PropertyName="Text" />
    </SelectParameters>

  </asp:SqlDataSource>

  <asp:SqlDataSource
    ID="SqlDataSource2"
    runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      SELECT 
        Memb_No                           AS membNo,
        Memb_Id                           AS membId,
        Memb_Pwd                          AS membPwd,
        Memb_FirstName                    AS membFirstName, 
        Memb_LastName                     AS membLastName, 
        Memb_Email                        AS membEmail,
        Memb_Organization                 AS membOrganization, 
        Memb_Memo                         AS membMemo,
        Memb_Programs                     AS membPrograms,
        Memb_Level                        AS membLevel,
        CASE Memb_Level
          WHEN '1' THEN 'Guest'
          WHEN '2' THEN 'Learner'
          WHEN '3' THEN 'Facilitator'
          WHEN '4' THEN 'Manager'
          WHEN '5' THEN 'Administrator'
        END                               AS membLevelText,
        Memb_Jobs	                        AS membManagerAccess,
        Memb_EcomG2Alert                  AS membEmailAlert,
        Memb_Active                       AS membActive
      FROM 
        V5_Vubz.dbo.Memb  
      WHERE 
        Memb_No = @membNo
    "
    UpdateCommand="
      UPDATE 
        V5_Vubz.dbo.Memb 
      SET 
        Memb_Id=UPPER(@membId),
        Memb_Pwd=UPPER(ISNULL(@membPwd, '')),
        Memb_FirstName=@membFirstName, 
        Memb_LastName=@membLastName, 
        Memb_Email=LOWER(@membEmail),
        Memb_Organization=@membOrganization, 
        Memb_Memo=@membMemo, 
        Memb_Level=@membLevel, 
        Memb_Jobs=@membManagerAccess,
        Memb_EcomG2Alert=@membEmailAlert, 
        Memb_Active=@membActive
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
        (
          Memb_Id, 
          Memb_Pwd, 
          Memb_AcctId, 
          Memb_FirstName, 
          Memb_LastName, 
          Memb_Email, 
          Memb_Organization, 
          Memb_Memo, 
          Memb_Level, 
          Memb_Jobs, 
          Memb_EcomG2Alert, 
          Memb_Active
        ) 
      VALUES 
        (
          UPPER(@membId), 
          UPPER(ISNULL(@membPwd, '')), 
          @membAcctId, 
          @membFirstName, 
          @membLastName, 
          LOWER(@membEmail), 
          @membOrganization, 
          @membMemo, 
          @membLevel, 
          @membManagerAccess,
          @membEmailALert, 
          @membActive
        )
      ">

    <SelectParameters>
      <asp:ControlParameter ControlID="gvLearners" Name="membNo" PropertyName="SelectedValue" Type="Int32" />
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
      <asp:Parameter Name="membManagerAccess" />
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
      <asp:SessionParameter Name="membAcctId" DefaultValue="" SessionField="custAcctId" />
      <asp:Parameter Name="membFirstName" />
      <asp:Parameter Name="membLastName" />
      <asp:Parameter Name="membEmail" />
      <asp:Parameter Name="membOrganization" />
      <asp:Parameter Name="membMemo" />
      <asp:Parameter Name="membLevel" />
      <asp:Parameter Name="membManagerAccess" />
      <asp:Parameter Name="membEmailAlert" />
      <asp:Parameter Name="membActive" />
    </InsertParameters>

  </asp:SqlDataSource>

</asp:Content>
