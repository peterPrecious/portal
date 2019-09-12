using System;
using System.Globalization;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace portal
{
  public partial class Default : FormBase
  {
    private Cust cu = new Cust();
    private Memb me = new Memb();
    private Sess se = new Sess();
    private Apps ap = new Apps();
    private Mail ma = new Mail();

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

      // page title which shows on header
      //      Page.Title = Resources.portal.pageTitleDefault;
      Page.Title = "Administration Home";

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
        }


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

        // language passed in? ie lang=FR (only checked if valid guid passed in --- ??) 
        if (Request["lang"] == null)
        {
          Session["culture"] = "en-US";
        }
        else
        {
          if (Request["lang"].ToLower() == "en")
          {
            Session["culture"] = "en-US";
          }
          if (Request["lang"].ToLower() == "fr")
          {
            Session["culture"] = "fr-CA";
          }
        }
        Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(Session["culture"].ToString());
        Thread.CurrentThread.CurrentUICulture = new CultureInfo(Session["culture"].ToString());

        // first session visit?
        if ((bool)Session["secure"] == false)
        {
          tabSignIn.Visible = true;
        }
      }

      //      Session["lang"] = "xx";
      Session["lang"] = Session["culture"].ToString().Substring(0, 2);

      // get logo from profile
      if (Session["logo"] != null)
      {
        string imageUrl = "/vubizApps/styles/logos/" + Session["logo"].ToString();
        logo.ImageUrl = imageUrl;
      }

      // preset credentials for fast testing ( mucks up signin to use anything else )
      if (fn.host() == "localhost")
      {
        //txtMembId.Attributes["value"] = "VUV5_FAC";
        //txtCustId.Text = "CCHS2544";

        //txtMembId.Attributes["value"] = "BBP@VUBIZ.COM";
        //txtMembPwd.Text = "password";

        txtMembId.Attributes["value"] = "VUV8_ADM";
        txtCustId.Text = "CFIB5288";

        //txtCustId.Text = "EVHR3DUX";


        //txtMembId.Attributes["value"] = "JANBOSS";
        //txtMembPwd.Attributes["value"] = "TANGERINE";
      }

      // manage tiles
      if ((bool)Session["secure"])
      {
        lvTiles.Visible = true;
      }

      // capture tile click
      if (IsPostBack)
      {
        string targetType = Request["tileTargetType"]; // sender used for target type (1,2,3)
        string target = Request["tileTarget"]; // parameter used for target
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
            //         ScriptManager.RegisterStartupScript(Page, Page.GetType(), "popup", "window.open('" + target + "','_blank')", true);
            Response.Redirect("iFrame.aspx?url=" + Server.UrlEncode(target));

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

        string _custId;

        // first check Username to see if this is a V8 or NOP system wide unique ID (on memb table), if so then check Password else show CustId     
        if (me.memberIsNop(txtMembId.Text.ToUpper(), out _custId, out string _membPwd, out string _profile, out bool _isAdmin)) // true if is NOP
        {
          // rowMembId.Visible = false;
          btnMembId.Visible = false;
          rowMembPwd.Visible = true;
          Session["custId"] = _custId.ToUpper();
          Session["membPwd"] = _membPwd.ToUpper();
          Session["profile"] = _profile.ToUpper();
          Session["isNop"] = true;
          Session["isAdmin"] = _isAdmin;
          txtMembPwd.Focus();
        }
        // if not NOP then see if Visitor (ie registered in apps.dbo.ecomRegister but not v5/memb)
        else if (me.memberIsVisitor(txtMembId.Text.ToUpper(), Convert.ToInt32(Session["storeId"]), Session["custId"].ToString(), out string _ecomGuid, out string _ecomPwd))
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
        // txtMembPwd.Attributes["value"] = "TANGERINE";
      }

    }

    protected void btnMembPwd_Click(object sender, EventArgs e)
    {
      if (Session["membPwd"].ToString() == txtMembPwd.Text.ToUpper())
      {
        if (
          (bool)Session["isVisitor"] == true
        )
        {
          string url = Session["nopReturnUrl"].ToString();
          if (url.Length > 0)
          {
            url = url + "?ecomGuid=" + Session["ecomGuid"].ToString() + "&token=" + ap.token(10);
            Session.Abandon();
            Response.Redirect(url, true);
          }
        }
       // else if (
       //  (bool)Session["isAdmin"] == false && Session["nopReturnUrl"].ToString().Length > 0
       //)
       // {
       //   string url = Session["nopReturnUrl"].ToString();

       //   url = "https://stagingweb.vubiz.com/store41//Plugins/ExternalAuthVubiz/Login?ecomGuid=20B056A5-A611-4039-84F2-B81CD18E1024";


       //   Session["nopReturnUrl"] = url;



       //   if (url.Length > 0)
       //   {
       //     Session.Abandon();
       //     Response.Redirect(url, true);
       //   }
       // }

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

        Session["isChild"] = (cu.custParentId.Trim() == "") ? false : true; // used for tiles

        // store key member values
        Session["membGuid"] = me.membGuid;
        Session["membFirstName"] = me.membFirstName;
        Session["membLastName"] = me.membLastName;
        Session["membId"] = me.membId;
        Session["membNo"] = me.membNo;
        Session["membLevel"] = me.membLevel;

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
        Session["color"] = fn.fDefault(profileColor, "#0178b9");          // for testing....         Session["color"] = fn.fDefault(profileColor, "green");
        Session["logo"] = fn.fDefault(profileLogo, "vubz.png");

        // temp hack
        if (Session["cust"].ToString() == "CCHS") { Session["logo"] = "cchs.png"; }


        // if guest or learner then go directly to one of the LMSs
        if (me.membLevel < 3)
        {
          string url = "";
          // if we have a profile go to v8
          if (Session["profile"].ToString().Length > 0) // returns "evhr|https://somereturnURL.com" so if null will just return "|"
          {
            url = "/v8?profile=" + Session["profile"] + "&membGuid=" + Session["membGuidTemp"] + "&custId=" + Session["custId"];
          }
          // if we have a returnUrl or nothing, go to v5
          else
          {
            if (Session["returnUrl"].ToString().Length > 0)
            {
              url = "/V5/Default.asp?vCust=" + Session["custId"] + "&vId=" + Session["membId"] + "&vSource=" + Session["returnUrl"];
            }
            else
            {
              url = "/V5/Default.asp?vCust=" + Session["custId"] + "&vId=" + Session["membId"];
            }
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
        ListViewDataItem item = (ListViewDataItem)e.Item;
        string tileName = (string)DataBinder.Eval(item.DataItem, "tileName");

        // translate if level 3
        short tileMembLevel = (short)Convert.ToInt16(DataBinder.Eval(item.DataItem, "tileMembLevel"));
        if (tileMembLevel == 3)
        {
          Label tileLabel = (Label)e.Item.FindControl("tileTitle") as Label;
          tileLabel.Text = GetGlobalResourceObject("portal", "tile_" + tileName.Replace(" ", "").Replace("/", "").Replace("(", "").Replace(")", "")).ToString();
        }

        // only show "Assign Content" if isChild
        if (tileName == "Assign Content" && !(bool)Session["isChild"])
        {
          item.Visible = false;
        }

        // only show "Sessions" if admin or on localhost, stagingweb.vubiz.com or corproate.vubiz.com
        if (tileName == "Sessions" && !(se.membLevel == 5 || fn.host() == "localhost"))
        {
          item.Visible = false;
        }

        // only show "My Content (V5)" if we have a v5 source
        //if (tileName == "My Content (V5)" && (se.source != "v5")
        if (tileName == "My Content (V5)" && se.profile.Length > 0)
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
    }

    protected void butRestart_Click(object sender, EventArgs e)
    {
      // if the source is NOP then we need to ensure we don't lose the url parameters if we restart
      string url = Request.Url.AbsoluteUri;
      Response.Redirect(url, true);
    }

  }

}