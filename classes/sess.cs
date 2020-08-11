using System;
using System.Web;

namespace portal
{
  public class Sess
  {
    #region Fields
    public bool
      secure,
      custEmailAlert,
      isChild,
      isNop,            // isNop has purchased content
      isAdmin,          // isAdmin has purchased content but did not clicked the Administration button thus on apps table there is no ecomReturnUrl or ecomChildId
      isVisitor,        // isVisitor has registerd in NOP in apps.dbo.ecomRegister BUT has not purchased content - when they login they are send to NOP
      usesPassword;     // usesPassword is determined a SignIn, needed for the learners app to determine if we need to ask/capture password

    public int
      membNo, membLevel,
      userCount, storeId,
      curMenuItems, numMenuItems;

    public string
      cust, custAcctId, custId, custChannelManager, custParentId,
      membFirstName, membLastName, membId, membPwd, membGuid, membGuidTemp,
      culture, ecomGuid, lang, menuItems, nopCancelUrl, nopReturnUrl, source, profile, tileGroup;
    #endregion

    // run in site.master.cs
    public void initialize()
    {
      HttpContext.Current.Session["secure"] = false;
      HttpContext.Current.Session["custEmailAlert"] = false;
      HttpContext.Current.Session["isChild"] = false;
      HttpContext.Current.Session["isNop"] = false;
      HttpContext.Current.Session["isVisitor"] = false;
      HttpContext.Current.Session["isAdmin"] = false;
      HttpContext.Current.Session["usesPassword"] = false;

      HttpContext.Current.Session["curMenuItems"] = 0;
      HttpContext.Current.Session["numMenuItems"] = 0;
      HttpContext.Current.Session["membNo"] = 0;
      HttpContext.Current.Session["membLevel"] = 0;
      HttpContext.Current.Session["userCount"] = 0;
      HttpContext.Current.Session["storeId"] = 0;

      HttpContext.Current.Session["cust"] = "";
      HttpContext.Current.Session["custAcctId"] = "";
      HttpContext.Current.Session["custId"] = "";
      HttpContext.Current.Session["custChannelManager"] = "";
      HttpContext.Current.Session["custParentId"] = "";
      HttpContext.Current.Session["membFirstName"] = "";
      HttpContext.Current.Session["membLastName"] = "";
      HttpContext.Current.Session["membId"] = "";
      HttpContext.Current.Session["membPwd"] = "";
      HttpContext.Current.Session["membGuid"] = "";
      HttpContext.Current.Session["membGuidTemp"] = "";
      HttpContext.Current.Session["culture"] = null;
      HttpContext.Current.Session["ecomGuid"] = "";
      HttpContext.Current.Session["lang"] = "en";
      HttpContext.Current.Session["menuItems"] = "";
      HttpContext.Current.Session["nopCancelUrl"] = "";
      HttpContext.Current.Session["nopReturnUrl"] = "";
      HttpContext.Current.Session["source"] = "";
      HttpContext.Current.Session["profile"] = "";
      HttpContext.Current.Session["tileGroup"] = "";
    }


    public bool localize()
    {
      if (HttpContext.Current.Session.Count == 0)
      {
        return false;
      }

      // boolean
      secure = (bool)HttpContext.Current.Session["secure"];
      custEmailAlert = (bool)HttpContext.Current.Session["custEmailAlert"];
      isChild = (bool)HttpContext.Current.Session["isChild"];
      isNop = (bool)HttpContext.Current.Session["isNop"];
      isAdmin = (bool)HttpContext.Current.Session["isAdmin"];
      isVisitor = (bool)HttpContext.Current.Session["isVisitor"];
      usesPassword = (bool)HttpContext.Current.Session["usesPassword"];

      // integer
      curMenuItems = Convert.ToInt32(HttpContext.Current.Session["curMenuItems"]);
      numMenuItems = Convert.ToInt32(HttpContext.Current.Session["numMenuItems"]);
      membNo = Convert.ToInt32(HttpContext.Current.Session["membNo"]);
      membLevel = Convert.ToInt32(HttpContext.Current.Session["membLevel"]);
      userCount = Convert.ToInt32(HttpContext.Current.Session["userCount"]);
      storeId = Convert.ToInt32(HttpContext.Current.Session["storeId"]);

      // string
      cust = HttpContext.Current.Session["cust"].ToString();
      custAcctId = HttpContext.Current.Session["custAcctId"].ToString();
      custId = HttpContext.Current.Session["custId"].ToString();
      custChannelManager = HttpContext.Current.Session["custChannelManager"].ToString();
      custParentId = HttpContext.Current.Session["custParentId"].ToString();
      membFirstName = HttpContext.Current.Session["membFirstName"].ToString();
      membLastName = HttpContext.Current.Session["membLastName"].ToString();
      membId = HttpContext.Current.Session["membId"].ToString();
      membPwd = HttpContext.Current.Session["membPwd"].ToString();
      membGuid = HttpContext.Current.Session["membGuid"].ToString();
      membGuidTemp = HttpContext.Current.Session["membGuidTemp"].ToString();
      menuItems = HttpContext.Current.Session["menuItems"].ToString();
      culture = HttpContext.Current.Session["culture"].ToString();
      ecomGuid = HttpContext.Current.Session["ecomGuid"].ToString();
      lang = HttpContext.Current.Session["lang"].ToString();
      nopCancelUrl = HttpContext.Current.Session["nopCancelUrl"].ToString();
      nopReturnUrl = HttpContext.Current.Session["nopReturnUrl"].ToString();
      profile = HttpContext.Current.Session["profile"].ToString();
      source = HttpContext.Current.Session["source"].ToString();
      tileGroup = HttpContext.Current.Session["tileGroup"].ToString();

      return true;
    }


    public bool isSecure()
    {
      return (
        HttpContext.Current.Session == null ||
        HttpContext.Current.Session.Count == 0 ||
        HttpContext.Current.Session["secure"] == null ||
        (bool)HttpContext.Current.Session["secure"] == false
        ) ? false : true;
    }
  }
}