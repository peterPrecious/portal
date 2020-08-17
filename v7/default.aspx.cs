using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal
{
  public partial class Default : FormBase
  {
    private readonly Cust cu = new Cust();
    private readonly Memb me = new Memb();
    private readonly Sess se = new Sess();
    private readonly Apps ap = new Apps();
    private readonly Mail ma = new Mail();
    private readonly Prof pr = new Prof();
    private readonly Ecom ec = new Ecom();

    protected override void InitializeCulture()
    {
      if (Session["culture"] == null) se.initialize();

      // change language (secure or not) or use system culture
      string culture = Request.Form["ctl00$MainContent$radLang"];
      if (culture != null)
      {
        Session["culture"] = culture;
      }
      else if (Session["culture"] is null)
      {
        Session["culture"] = Thread.CurrentThread.CurrentUICulture.Name.ToString();
      }

      // is there a querystring override?    
      if (Request["lang"] != null && Request["lang"].ToLower() == "en")
      {
        Session["culture"] = "en-US";
      }

      if (Request["lang"] != null && Request["lang"].ToLower() == "fr")
      {
        Session["culture"] = "fr-CA";
      }

      UICulture = Session["culture"].ToString();
      Culture = Session["culture"].ToString();
      Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
      Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());
      base.InitializeCulture();

      // store date format for EN or FR
      Session["dateFormat"] = (Session["culture"].ToString().Substring(0, 2) == "en") ? "MMM d, yyyy" : "d MMM yyyy";

    }

    protected void Page_Load(object sender, EventArgs e)
    {
      Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
      Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());

      // if Edge we don't need the hide/show eye
      if (Request.UserAgent.IndexOf("Edge") > -1)
      {
        eyeMembId.Visible = false;
        eyeMembPwd.Visible = false;
      }

      if (Session["secure"] == null)
      {
        Session["secure"] = false;
      }

      if (!IsPostBack)
      {
        // set default language before change
        if (Session["culture"].ToString() == "en-US")
        {
          radLang.Items.FindByValue("en-US").Selected = true;
          radLang.Items.FindByValue("fr-CA").Selected = false;
        }
        else if (Session["culture"].ToString() == "fr-CA")
        {
          radLang.Items.FindByValue("en-US").Selected = false;
          radLang.Items.FindByValue("fr-CA").Selected = true;
        }

        se.localize();

        // did we start with a SignIn call from NOP
        Session["isVisitor"] = false;        // assume is a not visitor unless we have them enrolled on V5.dbo.memb

        if (Request["storeId"] != null & Request["returnUrl"] != null & Request["cancelUrl"] != null & Request["custId"] != null)
        {
          Session["storeId"] = Request["storeId"];
          Session["nopReturnUrl"] = Request["returnUrl"];
          Session["nopCancelUrl"] = Request["cancelUrl"];
          Session["custId"] = Request["custId"];
          //Session["source"] = "nopSignIn";    // we will change this to "nop" later but need to know if we have to save the ReturnUrl

          // enable the Register button in case they haven't done this
          btnRegister.Visible = true;
        }

        if (Request["cancelUrl"] != null)
          butReturn.Visible = true;
        else
          butReturn.Visible = false;

        // did we start with membGuid?    
        if (Request["membGuid"] != null)
        {
          Session["source"] = Request["source"];

          if (Request["source"] == "nop")
          {
            me.membGuidTemp = Request["membGuid"];
            cu.custId = me.memberByGuid(me.membGuidTemp);
            Session["membGuidTemp"] = me.membGuidTemp;
            Session["profile"] = Request["profile"];
            Session["returnUrl"] = "";                          // we need to add on a valid token if using this returnUrl, ie: &token=aasdfasdfds
            Session["nopReturnUrl"] = Request["returnUrl"];

            // store the NOP returnUrl (not the Profile URL) in apps.dbo.ecomRegister.ecomReturnUrl so we can access the NOP Store
            // added the Ecom_NewAcctId for ease of NOP account management
            ap.saveNopReturnUrl(Session["membGuidTemp"].ToString(), Session["nopReturnUrl"].ToString(), cu.custId);
          }

          if (Request["source"] == "v8")
          {
            me.membGuidTemp = Request["membGuid"];
            cu.custId = me.memberByGuid(me.membGuidTemp);
            Session["membGuidTemp"] = me.membGuidTemp;
            Session["profile"] = Request["profile"];

            // if NOP get nopReturnUrl for Store tile
            ap.getNopReturnUrl(me.membId, out string nopReturnUrl);
            Session["nopReturnUrl"] = nopReturnUrl;
          }

          if (Request["source"] == "v5")
          {
            me.membGuidTemp = Request["membGuid"].ToString().Replace("{", "").Replace("}", ""); // remove V5 guid braces - V8 doesn't like them
            cu.custId = me.memberByGuid(me.membGuidTemp);
            Session["membGuidTemp"] = me.membGuidTemp;
            Session["nopReturnUrl"] = "";
          }

          // get profile data if available (it won't be for V5)
          cu.customerProfile(cu.custId, out string profileId, out string profileReturnUrl, out string profileColor, out string profileLogo);
          Session["profile"] = profileId;
          Session["returnUrl"] = profileReturnUrl;
          Session["color"] = fn.fDefault(profileColor, "#0178b9");          // no longer used
          Session["logo"] = fn.fDefault(profileLogo, "vubz.png");

          if (cu.custId != null)
          {
            // get some customer values
            cu.customer(cu.custId);

            Session["secure"] = true;

            // store key customer values
            Session["cust"] = fn.left(cu.custId, 4);
            Session["custId"] = cu.custId;
            Session["custAcctId"] = me.membAcctId;

            Session["custChannelManager"] = cu.custChannelManager;
            Session["custChannelNop"] = cu.custChannelNop;
            Session["custParentId"] = cu.custParentId;
            Session["custEmailAlert"] = cu.getEmailAlert(cu.custAcctId);

            Session["isChild"] = (cu.custParentId.Trim() == "") ? false : true; // used for tiles

            // store key member values
            Session["membGuid"] = me.membGuid;
            Session["membFirstName"] = me.membFirstName;
            Session["membLastName"] = me.membLastName;
            Session["membEmail"] = me.membEmail;
            Session["membId"] = me.membId;
            Session["membNo"] = me.membNo;
            Session["membLevel"] = me.membLevel;


            // temp hack
            if (Session["cust"].ToString() == "CCHS") { Session["logo"] = "cchs.png"; }

          }
        }

        // language passed in (lang=FR)
        if (Request["lang"] == null)
        {
          if (Session["lang"] == null)
          {
            Session["lang"] = "en";
            Session["culture"] = "en-US";
          }
        }
        else
        {
          if (Request["lang"].ToLower() == "en")
          {
            Session["lang"] = "en";
            Session["culture"] = "en-US";
          }
          if (Request["lang"].ToLower() == "fr")
          {
            Session["lang"] = "fr";
            Session["culture"] = "fr-CA";
          }
          // we need to reload this program to get rid of any lang parms in the URL, not kept in Session variable
          Response.Redirect("/portal/v7/default.aspx", true);
        }

        // first session visit?
        if ((bool)Session["secure"] == false)
        {
          tabSignIn.Visible = true;
        }
      }

      Session["lang"] = Session["culture"].ToString().Substring(0, 2);

      // get logo from profile
      if (Session["logo"] != null)
      {
        string imageUrl = "/vubizApps/styles/logos/" + Session["logo"].ToString();
        logo.ImageUrl = imageUrl;
      }

      // preset credentials for fast localhost testing ( mucks up signin to use anything else )
      if (fn.host() == "localhost")
      {
        txtMembId.Attributes["value"] = "TESTAUG2020-1";
        txtMembPwd.Attributes["value"] = "TEST";
      }

      // if secure, render tiles
      if ((bool)Session["secure"])
      {
        Session["curMenuItems"] = 0;
        Session["numMenuItems"] = lvTiles.Items.Count;
        lvTiles.Visible = true;
      }

      // capture tile click
      if (IsPostBack)
      {
        string targetType = Request["tileTargetType"]; // sender used for target type (1,2,3)
        string target = Request["tileTarget"]; // parameter used for target
        string tileName = Request["tileName"]; // need this for links to iFrame below
        if (targetType.Length > 0 && target.Length > 0)
        {
          Session["pageName"] = target;

          se.localize();

          // replace URLs with [[session]] 
          target = target.Replace("[[custAcctId]]", se.custAcctId);
          target = target.Replace("[[custId]]", se.custId);
          target = target.Replace("[[membId]]", se.membId);
          target = target.Replace("[[membNo]]", se.membNo.ToString());
          target = target.Replace("[[membGuidTemp]]", se.membGuidTemp);
          target = target.Replace("[[nopReturnUrl]]", se.nopReturnUrl);
          target = target.Replace("[[lang]]", se.lang);
          target = target.Replace("[[profile]]", se.profile);

          //ClientScript.RegisterStartupScript(GetType(), "hwa", "alert('Hello World');", true);

          // except [[token]] 
          target = target.Replace("[[token]]", ap.token(10));

          // link to same tab (typically local app)
          if (targetType == "1")
          {
            Response.Redirect(target);
          }

          // link to another tab (typically external app)
          if (targetType == "2")
          {
            // pass &title for determining browser title
            Response.Redirect("iFrame.aspx?url=" + Server.UrlEncode(target) + "&title=" + tileName);
          }

          // link to another menuGroup
          if (targetType == "3")
          {
            Session["tileGroup"] = target;
            lvTiles.DataBind();
          }
        }
      }
    }

    protected void btnMembId_Click(object sender, EventArgs e)
    {
      if (string.IsNullOrWhiteSpace(txtMembId.Text))
      {
        Response.Redirect("default.aspx", true);
      }
      else
      {
        Session["membId"] = txtMembId.Text.ToUpper();
        Session["isVisitor"] = false;
        Session["isNop"] = false;

        bool isNopV8 = true; // use this for next few steps

        // first check if Username is V8/NOP and unique
        if (isNopV8 & me.memberIsUnique(txtMembId.Text.ToUpper()))
        {
          isNopV8 = true;
        }
        else
        {
          isNopV8 = false;
        }

        //Retrieve member profile and populate usesPassword
        me.memberGetProfile(txtMembId.Text.ToUpper(), out string _profile);
        pr.profileValueByParameter(_profile, "password", out string _usesPassword);
        Session["usesPassword"] = (_usesPassword == "True");

        // first check Username and if V8 or NOP then show Password else show CustId  
        // Aug 2018: if there is no nopReturnUrl or ChildId on the apps table then insert it - means they bought courses in NOP but didn't hit Administration
        // Apr 2019: change memberIsNop to return "alias" as well as the mistakenly called "profile" plus usesPassword to determine if we need to render that field
        // checks for Nop AND V8 !!
        // _usesPassword : true if NOP or V8
        if (isNopV8 & me.memberIsNop(txtMembId.Text.ToUpper(), Convert.ToInt32(Session["storeId"]), Session["nopReturnUrl"].ToString(),
          out string _custId, out string _membPwd, out string _alias, out string _profile_old, out string _usesPassword_old))
        {
          // rowMembId.Visible = false;
          btnMembId.Visible = false;
          rowMembPwd.Visible = true;
          Session["custId"] = _custId.ToUpper();
          Session["membPwd"] = _membPwd.ToUpper();
          Session["alias"] = _alias.ToUpper(); // changed to alias from original profile Apr 2019  // Session["profile"] = _profile.ToUpper(); // used as profile when it was originally alias?
          Session["isNop"] = true;
          txtMembPwd.Focus();
        }

        // if not NOP then see if Visitor (ie registered in apps.dbo.ecomRegister but not V5/memb)
        else if (me.memberIsVisitor(txtMembId.Text.ToUpper(), Convert.ToInt32(Session["storeId"]), Session["custId"].ToString(),
          out string _ecomGuid, out string _ecomPwd))
        {
          btnMembId.Visible = false;
          rowMembPwd.Visible = true;
          Session["membPwd"] = _ecomPwd.ToUpper();
          Session["ecomGuid"] = _ecomGuid.ToUpper();
          Session["isVisitor"] = true;
          txtMembPwd.Focus();
        }

        // if neither NOP nor Visitor then assume V5, show CustId and hide Username and Password
        else
        {
          // rowMembId.Visible = false;
          btnMembId.Visible = false;
          rowCustId.Visible = true;
          Session["custId"] = "";
          Session["membPwd"] = "";
          txtCustId.Focus();
        }

        txtMembId.Attributes["value"] = Session["membId"].ToString();
      }

    }

    protected void btnMembPwd_Click(object sender, EventArgs e)
    {
      if (Session["membPwd"].ToString() == txtMembPwd.Text.ToUpper())
      {
        if ((bool)Session["isVisitor"] == true)
        {
          string url = Session["nopReturnUrl"].ToString();
          if (url.Length > 0)
          {
            url = url + "?ecomGuid=" + Session["ecomGuid"].ToString() + "&token=" + ap.token(10);
            Session.Abandon();
            Response.Redirect(url, true);
          }
        }

        else
        {
          membSignin(Session["custId"].ToString(), Session["membId"].ToString());
        }
      }
      else
      {
        labWelcome.Text = GetGlobalResourceObject("portal", "credentialPasswordError").ToString(); //That Password is incorrect
      }

    }

    protected void btnCustId_Click(object sender, EventArgs e)
    {
      membSignin(txtCustId.Text, Session["membId"].ToString());
    }

    protected void membSignin(string custId, string membId)
    {
      me.memberSignIn(custId, membId);

      if (me.membExists)
      {
        // enable tile button for testing
        Panel panHeader = Master.FindControl("panHeader") as Panel;
        panHeader.Visible = true;

        // guests doe not enter here (at this point) but might do down the road ... if (me.membLevel == 1) 

        Session["secure"] = true;

        // get some customer values (customer must exist)
        cu.customer(custId);

        // store key customer values
        Session["cust"] = fn.left(cu.custId, 4);
        Session["custId"] = cu.custId;
        Session["custAcctId"] = cu.custAcctId;

        Session["custChannelManager"] = cu.custChannelManager;
        Session["custChannelNop"] = cu.custChannelNop;
        Session["custParentId"] = cu.custParentId;
        Session["custEmailAlert"] = cu.getEmailAlert(cu.custAcctId);
        Session["custGuid"] = cu.custGuid;

        Session["isChild"] = (cu.custParentId.Trim() == "") ? false : true; // used for tiles

        // store key member values
        Session["membGuid"] = me.membGuid;
        Session["membFirstName"] = me.membFirstName;
        Session["membLastName"] = me.membLastName;
        Session["membId"] = me.membId;
        Session["membNo"] = me.membNo;
        Session["membLevel"] = me.membLevel;

        Session["membJobs"] = me.membJobs; // null or like 1 - 1,2 - 1,3 - 1,2,3 -etc. allows extended access for managers

        // store for V5/V8 access
        Session["source"] = "direct";
        me.membGuidTemp = me.memberGuidTemp(me.membGuid);         // get temp guid for V8
        Session["membGuidTemp"] = me.membGuidTemp;
        Session["nopReturnUrl"] = Session["nopReturnUrl"] ?? "";  // if null set to ""

        // if NOP get nopReturnUrl for Store tile
        ap.getNopReturnUrl(me.membId, out string nopReturnUrl);
        Session["nopReturnUrl"] = nopReturnUrl;

        cu.customerProfile(cu.custId, out string profileId, out string profileReturnUrl, out string profileColor, out string profileLogo);
        Session["profile"] = profileId;
        Session["returnUrl"] = profileReturnUrl;
        Session["color"] = fn.fDefault(profileColor, "#0178b9");          // (no longer using color) for testing....         Session["color"] = fn.fDefault(profileColor, "green");
        Session["logo"] = fn.fDefault(profileLogo, "vubz.png");

        // temp hack since CCHS is still V5-ish
        if (Session["cust"].ToString() == "CCHS") { Session["logo"] = "cchs.png"; }

        // if guest or learner then go directly to one of the LMSs
        if (me.membLevel < 3)
        {
          string url;
          // if we have a profile go to v8
          if (Session["profile"].ToString().Length > 0) // returns "evhr|https://somereturnURL.com" so if null will just return "|"
          {
            url = "/v8?profile=" + Session["profile"] + "&membGuid=" + Session["membGuidTemp"] + "&custId=" + Session["custId"];
          }
          // if we have a returnUrl go there
          else if (Session["returnUrl"].ToString().Length > 0)
          {
            url = "/V5/Default.asp?vCust=" + Session["custId"] + "&vId=" + Session["membId"] + "&vSource=" + Session["returnUrl"];
          }
          // render error: Access only avalable to Facilitators
          else
          {
            url = "/vubizApps/Errors.aspx?errorId=502&lang=" + Session["lang"];
          }
          Session.Abandon(); Response.Redirect(url);
        }

        // hide signin table
        tabSignIn.Visible = false;

        // get logo from profile
        if (Session["logo"] != null)
        {
          string imageUrl = "/vubizApps/styles/logos/" + Session["logo"].ToString();
          logo.ImageUrl = imageUrl;
        }

        // render tiles
        lvTiles.Visible = true;

      }
      else
      {
        labWelcome.Text = GetGlobalResourceObject("portal", "credentialError").ToString(); //Those Credentials are not on file!                                                                                         //       Session.Clear();
      }
    }

    protected void btnForgot_Click(object sender, EventArgs e)
    {
      forgotEmail.Visible = !forgotEmail.Visible ? true : false;
    }

    protected void btnEmail_Click(object sender, EventArgs e)
    {

      string emailFrom = "support@vubiz.com";
      string emailTo = txtEmail.Text;
      string subject = "Your credentials";
      string body;

      if (emailTo.Length == 0)
      {
        labEmail.Text = "Please enter a valid Email Address.";
        return;
      }

      // get credentials if email address is unique (ie count = 1)
      me.memberByEmail(emailTo, out int count, out string custId, out string membId, out string membPwd);

      if (count == 1)
      {

        if (membPwd.Length > 0)
        {
          body = "Email: " + emailTo + "<br /><br />" +
                 "Username: " + membId + "<br />" +
                 "Password: " + membPwd;
        }
        else
        {
          body = "Email: " + emailTo + "<br /><br />" +
                 "Username: " + membId + "<br />" +
                 "Customer Id: " + custId;
        }

        labEmail.Text = ma.sendMessage(emailFrom, emailTo, subject, body);
      }
      else if (count == 0)
      {
        labEmail.Text = "That Email is not on file.";
      }
      else if (count > 1)
      {
        labEmail.Text = "That Email is NOT Unique, ie more than one learner has that email address.";
      }

    }

    protected void lvTiles_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
      se.localize();

      if (e.Item.ItemType == ListViewItemType.DataItem)
      {
        Session["curMenuItems"] = ((int)Session["curMenuItems"]) + 1;

        ListViewDataItem item = (ListViewDataItem)e.Item;

        string tileName = (string)DataBinder.Eval(item.DataItem, "tileName"); // get tileName from DB

        // translate if level 3
        short tileMembLevel = (short)Convert.ToInt16(DataBinder.Eval(item.DataItem, "tileMembLevel"));
        if (tileMembLevel == 3)
        {
          string resourceName = "tile" + tileName.Replace(" ", "").Replace("/", "").Replace("(", "").Replace(")", ""); // craft a resource name for translation
          Label tileLabel = (Label)e.Item.FindControl("tileLabel") as Label;
          try
          {
            tileLabel.Text = (string)GetGlobalResourceObject("portal", resourceName);
          }
          catch (Exception) // no translation? --- not tested
          {
            tileLabel.Text = tileName;
          }
        }

        // only show "Certificate Report" if CustId starts with EVHR
        if (tileName == "Certificate Report" && (se.cust != "EVHR"))
        {
          item.Visible = false;
        }

        // only show "Assign Content" if isChild
        if (tileName == "Assign Content" && !(bool)Session["isChild"])
        {
          item.Visible = false;
        }

        // only show "Program Activity" if isChild
        if (tileName == "Program Activity (Overall)" && (bool)Session["isChild"])
        {
          item.Visible = false;
        }

        // only show "Sessions" if admin or on localhost, stagingweb.vubiz.com or corporate.vubiz.com
        if (tileName == "Sessions" && se.membLevel < 5)
        // changed Jun 25, 2020 to show "Sessions" if admin 
        //        if (tileName == "Sessions" && !(se.membLevel == 5 || fn.host() == "localhost"))
        {
          item.Visible = false;
        }

        // only show "My Content (V5)" if we have a v5 source       
        if (tileName == "My Content (V5)" && se.profile.Length > 0) //if (tileName == "My Content (V5)" && (se.source != "v5")
        {
          item.Visible = false;
        }

        // only show "My Content (V8)" if we have a profile
        if (tileName == "My Content (V8)" && se.profile.Length == 0)
        {
          item.Visible = false;
        }

        // only show "Store" if we have a nopReturnUrl
        if (tileName == "Store" && se.nopReturnUrl.Length == 0)
        {
          item.Visible = false;
        }

      }

      // render the New Purchase Notice ONCE if:
      if ((int)Session["curMenuItems"] > 1) return;

      //    we have completed listing the menu items, else will repeat all below X times;
      //    this a NOP account;
      //    this a facilitator;
      //    this fac has made one or more (single or multi seat) purchases;
      //    one or more of the purhases have not yet been assigned;
      //    all purchases have not been assigned to the NOP / FAC
      testClear.Visible = true;

      //    remove the fn.host() references when going live: should be as below:
      //if (cu.custChannelNop &&
      //    me.membLevel == 3 &&
      //      (fn.host() == "localhost" || fn.host() == "vubizstaging.com") // remove when live

      if (cu.custChannelNop && me.membLevel == 3)
      {
        // Create a new ListItemCollection (programs purchase)  ...  instantiated above at top
        //      ec.ecomPurchaseNotice(cu.custId, me.membId,
        ec.ecomPurchaseNotice(me.membId,
        out string _membPrograms,
        out string _ecomPrograms,
        out string _progTitles,
        out string _ecomQuantitys);

        // confirm we have purchases above (start assuming true), all or some of these fields contain values
        if (
          !string.IsNullOrEmpty(_membPrograms) &&
          !string.IsNullOrEmpty(_ecomPrograms) &&
          !string.IsNullOrEmpty(_progTitles) &&
          !string.IsNullOrEmpty(_ecomQuantitys)
          )
        {

          // put the purchase values into string arrays
          string[] __membProgram = _membPrograms.Split('|');
          string[] __ecomProgram = _ecomPrograms.Split('|');
          string[] __progTitle = _progTitles.Split('|');
          string[] __ecomQuantity = _ecomQuantitys.Split('|');

          int noPurchases = __ecomProgram.Length; // noPurchases equals number of values in the array
          string assigned = GetGlobalResourceObject("portal", "noticeAssigned").ToString();

          // clear out the purchases table
          //       while (tabPurchases.Rows.Count > 0) tabPurchases.Rows.RemoveAt(0);

          // this is the number of programs that have been assigned to the person running this (self).  
          // important: if all programs have been assigned to "self" then no need to render the purchase notice panel
          int isSelfAssigned = 0, canSelfAssign = 0; int exists;

          // get membPrograms before running this app so we can see if all programs in this section are already assigned
          string membPrograms = "";
          //        Session["menuItems"] = "";

          me.memberPrograms2a((int)Session["membNo"], out membPrograms);

          // loop through the purchases (1-x), skipping the first entry(0) as it will always be empty 
          // (since we start at 1 we reduce noPurchases by 1)
          for (int i = 1; i <= noPurchases - 1; i++)
          {
            // this determines how many of each program have been assigned, across the account
            ec.noPurchasedAssigned(cu.custId, __ecomProgram[i], out string _noAssigned);

            // only continue if we have some programs left to assign
            if (Int32.Parse(_noAssigned) < Int32.Parse(__ecomQuantity[i]))
            {
              // has this program been self assigned to the NOP fac (ie the program is in the membPrograms field
              // only show programs that have not been isSelfAssigned
              exists = membPrograms.IndexOf(__ecomProgram[i]);
              if (exists > -1)
              {
                isSelfAssigned++;
              }
              else
              {
                canSelfAssign++;
                Session["menuItems"] += __ecomProgram[i] + " ";

                TableRow row = new TableRow();
                TableCell cell = new TableCell();
                cell.Text = __progTitle[i] + " (" + __ecomProgram[i] + ")";

                row.Cells.Add(cell);
                tabPurchases.Rows.Add(row);
              }
            }
          }

          Session["menuItems"] = Session["menuItems"].ToString().Trim();
          // render the table (if we have some values assigned)
          notice.Visible = canSelfAssign > 0;
        }
      }
    }

    protected void butReturn_Click(object sender, EventArgs e)
    {
      //    string url = Request["returnUrl"];
      string url = Request["cancelUrl"];
      Response.Redirect(url, true);
    }

    protected void butRestart_Click(object sender, EventArgs e)
    {
      // if the source is NOP then we need to ensure we don't lose the url parameters if we restart
      string url = Request.Url.AbsoluteUri;
      Response.Redirect(url, true);
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
      // from: http://localhost/portal/v7/default.aspx?custId=SAFE3SPN&storeId=1010&returnUrl=https://csc.vubiz.com/store//Plugins/ExternalAuthVubiz/Login&cancelUrl=https://csc.vubiz.com/store/&appId=nopSignIn
      // to:   https://vubiz.com/vubizApps/Default.aspx?custId=VUBZ3JGP&storeId=1&returnUrl=https://vubiz.com/home/Plugins/ExternalAuthVubiz/Login&cancelUrl=https://vubiz.com/home&appId=nopRegister

      string url = "" +
        fn.scheme() +
        "://" +
        fn.host() +
        "/vubizApps/Default.aspx" +
        "?custId=" + Session["custId"] +
        "&storeId=" + Session["storeId"] +
        "&returnUrl=" + Session["nopReturnUrl"] +
        "&cancelUrl=" + Session["nopCancelUrl"] +
        "&appId=nopRegister";

      Response.Redirect(url, true);
    }

    protected void butBrowser_Click(object sender, EventArgs e)
    {
      string url = "" +
        fn.scheme() +
        "://" +
        fn.host() +
        "/vubizApps/Default.aspx" +
        "?lang=" + Session["lang"] +
        "&email=support@vubiz.com" +
        "&returnToPortal=y" +
        "&appId=browser.3";

      Response.Redirect(url, false);

    }

    protected void lnkNoticeN_Click(object sender, EventArgs e)
    {
      notice.Visible = false;
    }

    protected void lnkNoticeY_Click(object sender, EventArgs e)
    {
      notice.Visible = false;

      // we need to collect/save programs that are not already on the learner profile else they will be duplicated 
      string membPrograms = "";

      // get membPrograms before running this app
      me.memberPrograms2a((int)Session["membNo"], out membPrograms);

      membPrograms += " " + Session["menuItems"]; // add to existing membPrograms
      membPrograms = cleanMembPrograms(membPrograms); // cleaning sorts and removes duplicates
      me.memberPrograms((int)Session["membNo"], membPrograms);

      // if the source is NOP then we need to ensure we don't lose the url parameters if we restart
      //string url = Request.Url.AbsoluteUri;

      // using this link from the tiles table, it is where a tile click for My Content (V8) goes
      // v8?profile=[[profile]]&membGuid=[[membGuidTemp]]&custId=[[custId]]&lang=[[lang]]

      //localhost/v8/Default.aspx?appId=vubiz.8&profile=vubz&parms=Jm1lbWJHdWlkPUYwREJCMzA4LTE4MzgtNEFEOC1CNzA5LTUyNTkzOERGNkJBNSZjdXN0SWQ9VlVCWjNZRTkmbGFuZz1lbg==
      // Thread.Sleep(TimeSpan.FromSeconds(10)); // pause before jumping to another app - doesn't seem to help

      // this is the tileTarget for My Content (v8)
      //             /v8?profile=[[profile]]&membGuid=[[membGuidTemp]]&custId=[[custId]]

      string parms = ""
        + "&membGuid=" + Session["membGuidTemp"].ToString().ToUpper()
        + "&custId=" + Session["custId"].ToString().ToUpper()
        + "&lang=" + Session["lang"].ToString().ToUpper()
        + "&startPage=" + "page_programs"
        + "&returnUrl=" + HttpContext.Current.Request.Url.AbsoluteUri;
      byte[] bytes = Encoding.Default.GetBytes(parms);
      parms = Encoding.UTF8.GetString(bytes);
      byte[] byte2 = System.Text.Encoding.UTF8.GetBytes(parms);
      parms = Convert.ToBase64String(byte2);

      string url = "/v8?profile=" + Session["profile"].ToString() + "&parms=" + parms;

      Response.Redirect(url, true);
    }

    protected string cleanMembPrograms(string membPrograms)
    {
      string[] programs = membPrograms.Split();
      Array.Sort(programs);
      programs = RemoveDuplicates(programs);
      membPrograms = string.Join(" ", programs);
      return membPrograms.Trim();
    }

    public static string[] RemoveDuplicates(string[] s)
    {// https://stackoverflow.com/questions/9673/how-do-i-remove-duplicates-from-a-c-sharp-array      

      HashSet<string> set = new HashSet<string>(s);
      string[] result = new string[set.Count];
      set.CopyTo(result);
      return result;
    }

    protected void testClear_Click(object sender, EventArgs e)
    {
      me.memberPrograms2b((int)Session["membNo"]);
    }

  }

}