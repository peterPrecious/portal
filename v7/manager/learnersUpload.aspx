<%@ Page
  Language="C#"
  MasterPageFile="~/v7/site.master"
  AutoEventWireup="true"
  ValidateRequest="false"
  CodeBehind="learnersUpload.aspx.cs"
  Inherits="portal.v7.manager.learnersUpload" %>

<asp:Content ID="headContent" ContentPlaceHolderID="HeadContent" runat="server">
  <style>
    .labCustId1,
    .labCustId2,
    .labCustId3 { color: yellow; font-weight: bold; font-size: smaller; }

    .statusLabel,
    .statusLabel2 { color: yellow; width: 600px; margin: auto; text-align: left; }
    .statusLabel { font-weight: bold; }
    .statusLabel2 { font-weight: normal; }

    a { color: yellow; text-decoration: underline; font-size: larger; font-weight: bold; text-transform: uppercase; font-size: 9pt; }
    /* this is so the underline from a above is ignored */
    .newButton { text-decoration: none }
    .light { font-weight: 600 !important; text-transform: capitalize; }
    /* need to twig the fonts in the buttons for some reason */

    .description { padding: 10px; border: 1px solid white; display: none; }
      .description tr td { vertical-align: top; }

    .tabUploadLearners { width: 800px; margin: auto; }
      .tabUploadLearners tr td { width: 45%; padding: 0px; }
        .tabUploadLearners tr td:first-child { text-align: right; padding-right: 10px; vertical-align: top; }
        .tabUploadLearners tr td:last-child { text-align: left; }
      .tabUploadLearners .tabRow { padding-top: 20px; }
      .tabUploadLearners .custId { padding-left: 7px; }
      .tabUploadLearners .txtCustId { text-align: center; }

      .tabUploadLearners .upload { vertical-align: top; }


    .button { margin: 20px 0 30px 30px; }
    table, tr, td { border: none; }

    .details tr td { padding-bottom: 15px; padding-right: 10px; }
    .details tr:first-child td { font-weight: bold; }
    .details tr:not(:first-child) td:first-child { text-align: center; }
    code { color: yellow; font-weight: bold; font-size: larger }

    label { left: 120px; }

    .listContainer { padding-left: 20px; text-indent: -29px; }
      .listContainer input { width: 20px; }


    .panStatus { margin: 40px 20%; }
    .bulletedList { text-align: left; }
  </style>
  <link href="/portal/styles/css/default.min.css" rel="stylesheet" />
  <script>
    function fadeIn2() { // same as v7.js fadeIn() but with added toggle
      $(".thisTitle").toggle();
      $(".tabUploadLearners").toggle();
      $(".newButton").toggle();
    }


    $(function () {
      $(".butUpload").on("click", function () { $(".tabUploadLearners").hide(); })
    });




  </script>
</asp:Content>

<asp:Content ID="mainContent" ContentPlaceHolderID="MainContent" runat="server">

  <div class="divPage">

    <asp:ImageButton CssClass="exit" ImageUrl="~/styles/icons/vubiz/cancel.png" ID="ImageButton1" runat="server" OnClick="exit_Click" />

    <h1><span onclick="fadeIn2()" class="hoverUnderline" title="Click to show/hide description.">Upload Learners (via Tab Delimited File)</span></h1>
    <h2>[Clicking on the Title shows/hides this app's description and functionality.]</h2>
    <%--    <h3 class="statusLabel" id="StatusLabel" style="display:none;">    </h3>--%>
    <asp:Label ID="StatusLabel" runat="server"></asp:Label>


    <asp:Panel runat="server" CssClass="panStatus" ID="panStatus" Visible="false">
      To Confirm, you wish to:<br />
      <asp:BulletedList ID="BulletedList1" CssClass="bulletedList" BulletStyle="Numbered" runat="server">
        <asp:ListItem Value="1"></asp:ListItem>
        <asp:ListItem Value="2"></asp:ListItem>
        <asp:ListItem Value="3"></asp:ListItem>
      </asp:BulletedList>
      If this is correct then click <b>Upload</b> else <b>Restart</b>.
    </asp:Panel>

    <asp:Panel ID="divDetails" CssClass="thisTitle description" runat="server">

      <h2>About The Upload Learners App</h2>

      You can upload any number of Learner profiles using a <b>Tab Delimited Text File</b> stored on your system as 
      <asp:Label ID="labCustId1" CssClass="labCustId1" runat="server" />
      (case insensitive).&nbsp; 
      <b>DO NOT</b> upload a comma separated values (CSV) text file. 
      New learner profiles will be added to the account while existing learners will have their profile updated accordingly. 
      All profiles setup mucst be &quot;Learners&quot;, i.e. you cannot upload Facilitators, Managers, etc.<br>
      <br>If you wish, you can <a href="learnersDownload.aspx">click here</a>
      and the system will download (extract) <b>All Active Learners</b>
      from this account which you can save on your desktop as
      <asp:Label ID="labCustId3" CssClass="labCustId3" runat="server" />.
      You can then open and edit that file then save it as a Text (Tab delimited) *.txt file for uploading.<br>
      <br>
      <span style="font-weight: bold">First</span>: Start with an Excel spreadsheet of your learners and 
      arrange the columns so they conform to the sample file here: 
      <a style="color: yellow" target="_blank" href="/portal/repository/DEMO0000_LEARNERS.xlsx">DEMO0000_LEARNERS.xlsx</a>. 
      Do not remove any unused columns from this spreadsheet. 
      Leave the column contents blank if it is not applicable, but do not remove it.&nbsp; 
      Your spreadsheet MUST contain a header row that MUST be exactly the same as in the sample file. 
      If you use Program Ids, ensure you separate multiple entries with a space.<br>
      <br>
      <span style="font-weight: bold">Second</span>: Save the .xls file as a Text (Tab Delimited) file for uploading. 
      Click here for a sample text file: <a style="color: yellow" target="_blank" href="/portal/repository/DEMO0000_LEARNERS.txt">DEMO0000_LEARNERS.txt</a>.<br>
      <br>
      <span style="font-weight: bold">Third</span>: Follow the steps below to upload your .txt file. 
      If you are updating your Learner database by uploading ALL active Learners, you should "Inactivate all existing Learners..." 
      first, leaving just the Learners being uploaded as active.<br />
      <br />
      These are the fields in the file upload and must appear in this order:<br />
      <br />
      <br />
      <div style="text-align: left">
        <table class="details">
          <tr>
            <td>Col</td>
            <td style="width: 100px;">Name</td>
            <td>Constraints</td>
            <td>Description</td>
            <td>Example</td>
          </tr>
          <tr>
            <td>1</td>
            <td>Learner ID</td>
            <td>Mandatory</td>
            <td>Can only contain characters <i>A-Z</i>, <i>0-9</i> and <i>-_@.</i>.</td>
            <td>A_12345</td>
          </tr>
          <tr>
            <td>2</td>
            <td>Password</td>
            <td>Depends on Account Setup</td>
            <td>If used, this field can be modified by the Learner at a later stage. Case insensitive.</td>
            <td>myPassword</td>
          </tr>
          <tr>
            <td>3</td>
            <td>First Name</td>
            <td>Mandatory</td>
            <td>&nbsp;</td>
            <td>Jean</td>
          </tr>
          <tr>
            <td>4</td>
            <td>Last Name</td>
            <td>Mandatory</td>
            <td>&nbsp;</td>
            <td>Smith</td>
          </tr>
          <tr>
            <td>5</td>
            <td>Email Address</td>
            <td>Mandatory if issuing email alerts; optional otherwise</td>
            <td>&nbsp;</td>
            <td>jean.smith@email.com</td>
          </tr>
          <tr>
            <td>6</td>
            <td>Programs</td>
            <td>Optional</td>
            <td>If used, enter Program IDs separated by <b>spaces</b>.</td>
            <td>P1234EN P1235EN P9995EN</td>
          </tr>
          <tr>
            <td>7</td>
            <td>Memo</td>
            <td>Optional</td>
            <td>If used and if values contain more than one field, separate by <b>pipes</b></td>
            <td>Scranton|PA</td>
          </tr>
        </table>
        <br>
      </div>
    </asp:Panel>

    <asp:Table CssClass="tabUploadLearners" ID="tabUploadLearners" runat="server">

      <asp:TableRow>
        <asp:TableCell CssClass="tabRow">
          Click Browse to find the file on your system called
          <asp:Label ID="labCustId2" CssClass="labCustId2" runat="server" />
          (file name is case insensitive) :
        </asp:TableCell><asp:TableCell CssClass="tabRow upload">
          <div style="padding-top: 5px;">
            <asp:FileUpload ID="FileUploadControl" runat="server" />
          </div>
        </asp:TableCell>
      </asp:TableRow>

      <asp:TableRow>
        <asp:TableCell CssClass="tabRow">If you are uploading ALL active learners, specify action<br />
          (else leave the top option selected) :</asp:TableCell><asp:TableCell CssClass="tabRow">
            <asp:RadioButtonList ID="radAction" CssClass="listContainer" runat="server">
              <asp:ListItem Value="-1" Text="Do not modify the learner table before uploading. New learners will be added while existing learner profiles will be updated (default)" Selected="True" />
              <asp:ListItem Value="00" Text="Inactivate <code>ALL</code> existing Learners before uploading the active learners" />
              <asp:ListItem Value="10" Text="Inactivate <code>ALL</code> existing Learners before uploading, <code>except</code> those that have been added with the last <code>10</code> days" />
              <asp:ListItem Value="30" Text="Inactivate <code>ALL</code> existing Learners before uploading, <code>except</code> those that have been added with the last <code>30</code> days" />
              <asp:ListItem Value="99" Text="<code>DELETE ALL</code> existing Learners (active or inactive) before uploading the active learners. <code>This option should only be used when setting up a new Account</code> and is only available to Administrators" />
            </asp:RadioButtonList>
          </asp:TableCell>
      </asp:TableRow>

      <asp:TableRow>
        <asp:TableCell CssClass="tabRow">If you are uploading Program Ids, specify action<br />(else leave the top option selected) :</asp:TableCell><asp:TableCell CssClass="tabRow">
          <asp:RadioButtonList ID="radProgs" CssClass="listContainer" runat="server">
            <asp:ListItem Value="1" Text="Add (append) uploaded Program Ids to any that might be on file (default)" Selected="True" />
            <asp:ListItem Value="2" Text="Replace any Program Ids on file with uploaded Program Ids" />
          </asp:RadioButtonList>
        </asp:TableCell>
      </asp:TableRow>

    </asp:Table>

    <div style="padding: 30px 0 20px 0;">
      <asp:Button ID="butConfirm" CssClass="newButton" OnClick="butConfirm_Click" runat="server" Text="Confirm" />
      <asp:Button ID="butUpload" CssClass="newButton butUpload" OnClick="butUpload_Click" runat="server" Text="Upload" Visible="false" />
      <asp:Button ID="butRestart" CssClass="newButton" OnClick="butRestart_Click" runat="server" Text="Restart" />
    </div>

  </div>

</asp:Content>
