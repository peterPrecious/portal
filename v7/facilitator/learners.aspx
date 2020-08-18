<%@ Page
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  CodeBehind="learners.aspx.cs"
  Inherits="portal.v7.facilitator.learners" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <link href="/portal/styles/css/learners.css" rel="stylesheet" />
  <script>
    var trSave = "";  // this is where we save the managerAccess row, which we hide and then show
    var trIndex = -1;

    function managerAccess(action, usesPassword) {
      if (action === "hide" ) {
        $("table.dvLearner > tbody  > tr").each(function (index) {
          if ($(".dvLearner")[0].rows[index].cells[0].innerHTML === "Manager Access") {
            trIndex = index;  //store row index for future use
            var trRow = $(".dvLearner")[0].rows[trIndex]; // get managerAccess row
            trRowSave = trRow;  //store row for future use
            trRow.remove();
            return false;
          }
        });
      }
      else if (action === "show" && trRowSave != "" && trIndex > -1) {
        var trRow = $(".dvLearner")[0].rows[trIndex];
        trRow.before(trRowSave);  // if it was detached then plop the row back into the table
        trSave = "";  //reset holding variable
        trIndex = -1; //reset holding variable
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

    //SH - 07/02/20 - Kick off search when enter is pressed inside search value field
    function txtSearch_EnterEvent(e) {
      if (e.keyCode == 13) {
        $('input[name="<%=butSearch.UniqueID%>"]').click();
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

    function setLabError(desc) {
      if ($(".labError").html() == "" || $(".labError").html() != desc) {
        $(".labError").html(desc);
      } else {
        $(".labError").html("");
      }
    }

    $(function () {

      var lang = "<%=Session["lang"]%>";  // get language from C#

      // generates a yellow description in labError of panBottom
      if (lang !== "fr") {
        $(".membAcctId").on("click", function () { setLabError("Customer ID represents the account the learner is assigned to."); });
        $(".membId").on("click", function () { setLabError("Username is a globally unique value for this learner (i.e. Email Address). Once assigned it cannot be changed."); });
        $(".membPwd").on("click", function () { setLabError("Password provides extra security. It can be modified at a later stage."); });
        $(".membFirstName").on("click", function () { setLabError("First Name is used in reports and certificates."); });
        $(".membLastName").on("click", function () { setLabError("Last Name is used in reports and certificates."); });
        $(".membEmail").on("click", function () { setLabError("Email is used when you wish certain documents to be forwarded to you."); });
        $(".membOrganization").on("click", function () { setLabError("Organization appears on certain reports."); });
        $(".membMemo").on("click", function () { setLabError("Memo is meant to maintain fields of value to your organization."); });
        $(".membPrograms").on("click", function () { setLabError("Programs are assigned in a different app and are listed here for convenience."); });
        $(".membLevel").on("click", function () { setLabError("The Level determines the features accessible to this person. Can be Learner or Facilitator."); });
        $(".membManagerAccess").on("click", function () { setLabError("Manager Access are special apps optionally available to a Manager."); });
        $(".membReceiveAlerts").on("click", function () { setLabError("Receive Alerts enables this person to receive Email Alerts."); });
        $(".membResendAlerts").on("click", function () { setLabError("Resend Alerts will resend any outstanding Email Alerts."); });
        $(".membActive").on("click", function () { setLabError("Active is a key field. If set 'off' then this individual will no longer have access to the system."); });
        $(".membNo").on("click", function () { setLabError("[Vubiz Internal] is a system value used by Vubiz Support for support purposes."); });
      } else {
        $(".membAcctId").on("click", function () { setLabError("L’identification du client représente le compte auquel l'apprenant est affecté."); });
        $(".membId").on("click", function () { setLabError("Le nom d'utilisateur est une valeur unique à l'échelle mondiale pour cet apprenant (c.-à-d. adresse e-mail). Une fois assigné, il ne peut pas être changé."); });
        $(".membPwd").on("click", function () { setLabError("Mot de passe offre une sécurité supplémentaire. Il peut être modifié à un stade ultérieur."); });
        $(".membFirstName").on("click", function () { setLabError("Le prénom est utilisé dans les rapports et les certificats."); });
        $(".membLastName").on("click", function () { setLabError("Le nom de famille est utilisé dans les rapports et les certificats."); });
        $(".membEmail").on("click", function () { setLabError("L'e-mail est utilisé lorsque vous souhaitez que certains documents vous soient transmis."); });
        $(".membOrganization").on("click", function () { setLabError("L'organisation apparaît sur certains rapports."); });
        $(".membMemo").on("click", function () { setLabError("Memo est destiné à maintenir des champs de valeur pour votre organisation."); });
        $(".membPrograms").on("click", function () { setLabError("Les programmes sont attribués dans une application différente et sont répertoriés ici pour plus de commodité."); });
        $(".membLevel").on("click", function () { setLabError("Le niveau détermine les caractéristiques accessibles à cette personne. Peut être apprenant ou facilitateur."); });
        $(".membManagerAccess").on("click", function () { setLabError("Manager Access sont des applications spéciales disponibles en option pour un Manager."); });
        $(".membReceiveAlerts").on("click", function () { setLabError("Recevoir des alertes permet à cette personne de recevoir des alertes par e-mail."); });
        $(".membResendAlerts").on("click", function () { setLabError("Les alertes de réception permettent à cette personne de recevoir des alertes par e-mail."); });
        $(".membActive").on("click", function () { setLabError("L'activité est un domaine clé. S'il est mis hors tension, cette personne n'aura plus accès au système."); });
        $(".membNo").on("click", function () { setLabError("[Vubiz Internal] est une valeur système utilisée par Vubiz Support à des fins de support."); });
      }

    })
  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">
    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="exit" runat="server" OnClick="exit_Click" />

    <asp:Panel ID="panBoth" CssClass="panBoth" runat="server">

      <asp:Panel ID="panTop" CssClass="panTop" runat="server">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Literal runat="server" Text="<%$  Resources:portal, title%>" />
            <asp:Literal runat="server" Text="<%$  Resources:portal, learners%>" />
          </span>
          <asp:ImageButton OnClick="dvLearner_ItemInit" CssClass="icons add" ImageUrl="~/styles/icons/vubiz/add.png" ToolTip="Add a Learner" runat="server" />
        </h1>

        <div class="thisTitle">
          <asp:Literal ID="noLearners" runat="server" />    <%--A learner must have a name and email address to appear on this list.--%>
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1a%>" />
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1b%>" />
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_1c%>" />

          <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>
          <div style="margin: 30px 30px 0px 30px; text-align: center;">
            <asp:TextBox ID="txtSearch" Text="" CssClass="txtSearch" placeholder="<%$  Resources:portal, searchValue%>" runat="server" onkeydown="return txtSearch_EnterEvent(event)" />
            <asp:Button ID="butSearch" OnClick="butSearch_Click" CssClass="button" runat="server" Text="<%$  Resources:portal, search%>" />
            <asp:Button ID="butClear" OnClick="butClear_Click" CssClass="button newButton1" runat="server" Text="<%$  Resources:portal, clear%>" />
          </div>
          <div style="margin: 0px 30px 30px 30px; text-align: center;">
            <asp:CheckBox ID="chkIncludeChildAccounts" runat="server" Visible="false" checked="false" Text="<%$  Resources:portal, includeChildAccounts%>" />
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
          OnRowDataBound="gvLearners_RowDataBound"
          OnSelectedIndexChanged="gvLearners_SelectedIndexChanged"
          PageSize="20"
          RowStyle-HorizontalAlign="Left">
          <Columns>
            <asp:BoundField DataField="membId" HeaderText="<%$  Resources:portal, username%>" SortExpression="membId" />
            <asp:BoundField DataField="membFirstName" HeaderText="<%$  Resources:portal, firstName%>" SortExpression="membFirstName" />
            <asp:BoundField DataField="membLastName" HeaderText="<%$  Resources:portal, lastName%>" SortExpression="membLastName" />
            <asp:BoundField DataField="membEmail" HeaderText="<%$  Resources:portal, email%>" SortExpression="membEmail" />
            <asp:BoundField DataField="membLevel" HeaderText="<%$  Resources:portal, level%>" SortExpression="membLevel" />
            <asp:BoundField DataField="membChild" HeaderText="Child" HeaderStyle-CssClass="gvLearners_hiddencol" ItemStyle-CssClass="gvLearners_hiddencol" InsertVisible="false" />
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
            <asp:Literal runat="server" Text="<%$ Resources:portal, learners_3%>" />
            <br /><br />
          </EmptyDataTemplate>
        </asp:GridView>

      </asp:Panel>

      <asp:Panel ID="panBot" CssClass="panBot" runat="server" Visible="false">

        <h1>
          <span onclick="fadeIn()" class="hoverUnderline">
            <asp:Label CssClass="resendAlerts" runat="server" Text="<%$  Resources:portal, learners_7%>"></asp:Label>
          </span>
          <asp:ImageButton
            OnClick="ListLearners_Click"
            CssClass="icons"
            ImageUrl="~/styles/icons/vubiz/back.png"
            ToolTip="Return to List"
            runat="server" />
        </h1>

        <div class="thisTitle">
          <asp:Label CssClass="resendAlerts" runat="server" Text="<%$  Resources:portal, learners_6%>"></asp:Label>
          <asp:Label CssClass="resendAlerts" runat="server" Text="<%$  Resources:portal, learners_4%>"></asp:Label>
          <asp:Label CssClass="resendAlerts" runat="server" Text="<%$  Resources:portal, learners_5%>"></asp:Label>
          <asp:Label CssClass="resendAlerts" runat="server" Text="<%$  Resources:portal, learners_9%>"></asp:Label>
          <span style="color: yellow"><asp:Literal runat="server" Text="<%$  Resources:portal, learners_1d%>" /></span>

        </div>

        <asp:Label
          ID="labError"
          CssClass="labError"
          ForeColor="Yellow"
          Font-Bold="true"
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

            <asp:TemplateField HeaderText="<%$ Resources:portal, custId%>">
              <EditItemTemplate>
                <asp:Label ID="membAcctId" runat="server" Text='<%# Bind("membAcctId") %>' Enabled="false"></asp:Label>
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:TextBox ID="membAcctId" CssClass="upper" Enabled="false" runat="server" Text='<%# Bind("membAcctId") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:Label ID="membAcctId" runat="server" Text='<%# Bind("membAcctId") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip membAcctId" Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, uniqueId%>">
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
              <HeaderStyle CssClass="tip membPwd" Font-Bold="True" HorizontalAlign="Right" />
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
              <HeaderStyle CssClass="tip membFirstName" Font-Bold="True" HorizontalAlign="Right" />
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
              <HeaderStyle CssClass="tip membLastName" Font-Bold="True" HorizontalAlign="Right" />
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
              <HeaderStyle CssClass="tip membEmail" Font-Bold="True" HorizontalAlign="Right" />
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
              <HeaderStyle CssClass="tip membOrganization" Font-Bold="True" HorizontalAlign="Right" />
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
              <HeaderStyle CssClass="tip membMemo" Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, programs%>">
              <ItemTemplate>
                <asp:Label ID="membPrograms" runat="server" Text='<%# Bind("membPrograms") %>' Enabled="false"></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip membPrograms" Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, level%>" HeaderStyle-Font-Bold="true" HeaderStyle-HorizontalAlign="Right">
              <EditItemTemplate>
                <asp:DropDownList ID="membLevel" SelectedValue='<%# Bind("membLevel") %>' CssClass="membLevel" runat="server">
                  <asp:ListItem Value="1" Text="Guest"></asp:ListItem>
                  <asp:ListItem Value="2" Text="Learner"></asp:ListItem>
                  <asp:ListItem Value="3" Text="Facilitator"></asp:ListItem>
                  <asp:ListItem Value="4" Text="Manager"></asp:ListItem>
                  <asp:ListItem Value="5" Text="Administrator"></asp:ListItem>
                </asp:DropDownList>
                <asp:HiddenField ID="hidMembLevel" Value='<%# Bind("membLevel") %>' runat="server" />
                <br />
                <asp:Literal runat="server" Text="<%$ Resources:portal, learners_11%>" />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:DropDownList ID="membLevel" SelectedValue='<%# Bind("membLevel") %>' CssClass="membLevel" runat="server">
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
              <HeaderStyle CssClass="tip membLevel" Font-Bold="True" HorizontalAlign="Right" />
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
                <%-- Note: select/highlight either 'No Special Access' OR any combination of the other values. Use CTRL click to select/highlight multiple values.--%>
                <asp:Literal runat="server" Text="<%$ Resources:portal, learners_10%>" />
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
              <HeaderStyle CssClass="tip membManagerAccess" Font-Bold="True" HorizontalAlign="Right" />
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
              <HeaderStyle CssClass="tip membReceiveAlerts" Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField Visible="true" HeaderText="<%$ Resources:portal, resendAlerts %>">
              <ItemStyle CssClass="resendAlerts" />
              <HeaderStyle CssClass="resendAlerts" />
              <ItemTemplate>
                <asp:ImageButton ID="butResendEmailAlerts" CssClass="icons email" OnClick="butResendEmailAlerts_Click" ImageUrl="~/styles/icons/vubiz/emailSolo.png" runat="server" CausesValidation="false" Text="Resend" ToolTip="<%$ Resources:portal, alertsResend%>" />
                &nbsp;&nbsp;&nbsp;<asp:Label ID="labResendEmailAlerts" runat="server" Visible="false" Text="<%$ Resources:portal, alertsResent%>"></asp:Label>
              </ItemTemplate>
              <HeaderStyle CssClass="tip membResendAlerts" Font-Bold="True" HorizontalAlign="Right" />
            </asp:TemplateField>

            <asp:TemplateField HeaderText="<%$ Resources:portal, active %>">
              <EditItemTemplate>
                <asp:CheckBox ID="membActive" runat="server" Checked='<%# Bind("membActive") %>' />
              </EditItemTemplate>
              <InsertItemTemplate>
                <asp:CheckBox ID="membActive" runat="server" Checked='<%# Bind("membActive") %>' />
              </InsertItemTemplate>
              <ItemTemplate>
                <asp:CheckBox ID="membActive" runat="server" Checked='<%# Bind("membActive") %>' Enabled="false" />
              </ItemTemplate>
              <HeaderStyle CssClass="tip membActive" Font-Bold="True" HorizontalAlign="Right" />
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

            <%-- These icons are being overriden and set in portal\styles\css\styles.css --%>
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

        <asp:Panel ID="panIncludeChildAccounts_Message" CssClass="panIncludeChildAccounts_Message" runat="server" Visible="false">
          <asp:Literal runat="server" Text="<%$  Resources:portal, learners_child_1%>" /><br /><asp:Literal runat="server" Text="<%$  Resources:portal, learners_child_2%>" />
        </asp:Panel>

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
        [Memb_Level]            AS membLevel,
        0						            AS membChild
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
        Memb_AcctId                       AS membAcctId,
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

  <asp:SqlDataSource
    ID="SqlDataSource3" runat="server"
    ConnectionString="<%$ ConnectionStrings:apps %>"
    SelectCommand="
      DECLARE @Temp_Table AS TABLE (membNo INTEGER, membId VARCHAR(128), membFirstName VARCHAR(32), membLastName VARCHAR(64), membEmail VARCHAR(128), membOrganization VARCHAR(128), membLevel INTEGER, membChild INTEGER)

      INSERT INTO @Temp_Table
      SELECT
	      [Memb_No]               AS membNo,
	      [Memb_Id]               AS membId,
	      [Memb_FirstName]        AS membFirstName,
	      [Memb_LastName]         AS membLastName,
	      [Memb_Email]            AS membEmail,
	      [Memb_Organization]     AS membOrganization,
	      [Memb_Level]            AS membLevel,
	      0						            AS membChild
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

      INSERT INTO @Temp_Table
      SELECT
	      M.[Memb_No]               AS membNo,
	      M.[Memb_Id]               AS membId,
	      M.[Memb_FirstName]        AS membFirstName,
	      M.[Memb_LastName]         AS membLastName,
	      M.[Memb_Email]            AS membEmail,
	      M.[Memb_Organization]     AS membOrganization,
	      M.[Memb_Level]            AS membLevel,
	      1						              AS membChild
      FROM 
	      V5_Vubz.dbo.Memb AS M
	      INNER JOIN V5_Vubz.dbo.Cust AS C
		      ON M.Memb_AcctId = C.Cust_AcctId
      WHERE
	      C.Cust_ParentId			= @membAcctId AND
	      Memb_Email              != '' AND
	      Memb_FirstName          != '' AND
	      Memb_LastName           != '' AND
	      Memb_Level              &lt; @membLevel AND
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

      SELECT
	      membNo,
	      membId,
	      membFirstName,
	      membLastName,
	      membEmail,
	      membOrganization,
	      membLevel,
	      membChild
      FROM
	      @Temp_Table
      ORDER BY 
	      membLastName,
	      membFirstName
    ">
    <SelectParameters>
      <asp:SessionParameter Name="membLevel" SessionField="membLevel" />
      <asp:SessionParameter Name="membAcctId" DefaultValue="" SessionField="custAcctId" />
      <asp:ControlParameter Name="search" ControlID="txtSearch" DefaultValue="*" PropertyName="Text" />
    </SelectParameters>

  </asp:SqlDataSource>

</asp:Content>
