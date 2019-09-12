using System;
using System.Web;

namespace portal
{
  public partial class ecomGenerateId3 : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      #region Initialize & Post

      // instantiate classes
      Parm pa = new Parm();
      Ecom ec = new Ecom();
      Memb me = new Memb();
      Cust cu = new Cust();
      Catl ca = new Catl();
      Prog pr = new Prog();
      Apps ap = new Apps();

      #region Log Raw Input
      // first thing we do is log (to txt and db) what came in and when (can be nothing when testing)

      // start by getting a random title for the log txt file 
      Random rnd = new Random();
      pa.logId = DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss-fff") + "_" + rnd.Next().ToString();

      // extract the logNo - key for tracking (if using simulator create -1)
      pa.logNo = Convert.ToInt64(fn.fDefault(Request.Form["logNo"], "-1"));

      fn.logTxt(pa.logId, Request.Form.ToString());
      fn.logForm(pa.logNo, Request.Form.ToString());

      #endregion

      #region Set flags
      // only continue if we have received a valid form post 
      if (Request.Form.Keys.Count == 0 || Request.Form.ToString() == "") return;

      //  if a test display results locally rather than to the web service
      pa.bTest = fn.nullToString(Request["vTest"]).ToLower() == "y" ? true : false;

      // log the steps taken for testing and optionally for live
      pa.bStep = false;
      if (HttpContext.Current.Request.IsLocal || System.Web.HttpContext.Current.Request.Url.Host != "vubiz.com") pa.bStep = true;
      if (pa.bStep == false && fn.nullToString(Request["v5Step"]).ToLower() == "y") pa.bStep = true;

      pa.bSuspend = false; // suspend Group2/Addon2 (not used - was just for special test circumstances)
      #endregion

      // post the transaction
      try
      {
        pa.status = Post3(pa, ec, me, cu, ca, pr, ap);
      }
      catch (Exception ex)
      {
        pa.status = fn.err(490, ex.Message, fn.leftPlus(ex.StackTrace, 400));
        fn.logTxt(pa.logId, pa.status);
      }

      #endregion

      #region Return Status

      // a successful status is either for posting or validating
      if (pa.status == "" && pa.bCommit) pa.status = "200 Successfully Posted";
      if (pa.status == "" && !pa.bCommit) pa.status = "200 Transaction Validated";

      if (!pa.bCommit) // return dummy fields as they are not used for validation
      {
        ec.ecomCustId = "XXXX0000";
        ec.ecomNewAcctId = "0000";
        ec.ecomId = "Password";
        ec.ecomExpires = new DateTime(2000, 1, 1);
      }

      #region Error Status (return error status data)
      if (fn.left(pa.status, 3) != "200")
      {
        fn.logPost(pa.logNo, pa.dataIn, pa.status, ec);

        ec.ecomId = null;
        if (pa.bTest)
        {
          Response.Write(pa.status + "<br />");
        }
        else
        {
          Response.Status = pa.status + "<br />";
        }

      }
      #endregion

      else

      #region Return Success (return success status data)
      {

        fn.logPost(pa.logNo, pa.dataIn, pa.status, ec);
        if (pa.bTest)
        {
          Response.Write(pa.status + "<br />");
        }
        else
        {
          Response.Status = (pa.status + "<br />");
        }

        #region Group2 Sale
        // for a Group2 sale, return new Account ID, Password and Expiry Date
        if (ec.ecomMedia == "Group2" && !pa.bUpdateGroup2)
        {
          Response.AddHeader("Account Id", fn.left(ec.ecomCustId, 4) + ec.ecomNewAcctId);
          Response.AddHeader("Password", ec.ecomId);
          Response.AddHeader("Expiry Date", ec.ecomExpires.ToString());
          Response.AddHeader("ResponseGUID", ec.ecomGuid.ToString());
          if (pa.bTest)
          {
            Response.Write("'Account Id', '" + fn.left(ec.ecomCustId, 4) + ec.ecomNewAcctId + "'<br />");
            Response.Write("'Password', '" + ec.ecomId + "'<br />");
            Response.Write("'Expiry Date', '" + ec.ecomExpires.ToString() + "'<br />");
            Response.Write("'ResponseGUID', '" + ec.ecomGuid.ToString() + "'<br />");
          }
        }
        #endregion

        #region AddOn2 Sale
        // for an AddOn2 sales, return new Expiry Date
        else if (ec.ecomMedia == "Group2" && pa.bUpdateGroup2)
        //  ElseIf vEcom_Media = "Group2" And bUpdateGroup2 Then
        //    Response.AddHeader "Expiry Date", vEcom_Expires
        //    If bTest Then
        //      Response.Write """Expiry Date""" & ",""" & vEcom_Expires & """<br>"
        //      If bLogs Then Response.Write """ResponseGUID""" & ",""" & logGuid & """<br>"
        //    End If
        {
          Response.AddHeader("Expiry Date", ec.ecomExpires.ToString());
          Response.AddHeader("ResponseGUID", ec.ecomGuid.ToString());
          if (pa.bTest)
          {
            Response.Write("'Expiry Date', '" + ec.ecomExpires.ToString() + "'<br />");
            Response.Write("'ResponseGUID', '" + ec.ecomGuid.ToString() + "'<br />");
          }
        }
        #endregion

        #region Online (generate ID)
        // for a new Online sale, and not an update to an existing learner Id, return assigned Password and Expiry Date
        else if (!pa.bUpdateOnline && !pa.bUpdateGroup2)
        //  '...return a password for individual sales unless one is passed through (bUpdateOnline = True)
        //  ElseIf Not bUpdateOnline And Not bUpdateGroup2 Then
        //    Response.AddHeader "Password", vEcom_Id
        //    If bTest Then Response.Write """Password""" & ",""" & vEcom_Id & """<br>"
        //    '...currently returning 90 days from today - may need to modify if they sell courses that expire in other than 90 days (ie 365 days) 
        //    Response.AddHeader "Expiry Date", vEcom_Expires
        //    If bTest Then
        //      Response.Write """Expiry Date""" & ",""" & vEcom_Expires & """<br>"
        //      If bLogs Then Response.Write """ResponseGUID""" & ",""" & logGuid & """<br>"
        //    End If
        {
          Response.AddHeader("Password", ec.ecomId);
          Response.AddHeader("Expiry Date", ec.ecomExpires.ToString());
          Response.AddHeader("ResponseGUID", ec.ecomGuid.ToString());
          if (pa.bTest)
          {
            Response.Write("'Password', '" + ec.ecomId + "'<br />");
            Response.Write("'Expiry Date', '" + ec.ecomExpires.ToString() + "'<br />");
            Response.Write("'ResponseGUID', '" + ec.ecomGuid.ToString() + "'<br />");
          }
        }
        #endregion

        #region Online (existing ID)
        // an Online sale added to an existing learner return new expiry date 
        else if (pa.bUpdateOnline && !pa.bUpdateGroup2)
        //  ElseIf bUpdateOnline And Not bUpdateGroup2 Then
        //    '...currently returning 90 days from today - may need to modify if they sell courses that expire in other than 90 days (ie 365 days) 
        //    Response.AddHeader "Expiry Date", vEcom_Expires
        //    If bTest Then
        //      Response.Write """Expiry Date""" & ",""" & vEcom_Expires & """<br>"
        //      If bLogs Then Response.Write """ResponseGUID""" & ",""" & logGuid & """<br>"
        //    End If
        //  End If
        {
          Response.AddHeader("Expiry Date", ec.ecomExpires.ToString());
          Response.AddHeader("ResponseGUID", ec.ecomGuid.ToString());
          if (pa.bTest)
          {
            Response.Write("'Expiry Date', '" + ec.ecomExpires.ToString() + "'<br />");
            Response.Write("'ResponseGUID', '" + ec.ecomGuid.ToString() + "'<br />");
          }
        }
        #endregion
      }
      #endregion

      #endregion

      fn.logTxt(pa.logId, pa.status);
    }

    public string Post3(Parm pa, Ecom ec, Memb me, Cust cu, Catl ca, Prog pr, Apps ap)
    {
      #region Parse Input

      if (Request.Form.Count == 0) return fn.err(444);

      pa.status = "";

      foreach (string key in Request.Form)
      {
        string value = Server.UrlDecode(Request[key].ToString());
        if (key.Substring(0, 2) != "__") pa.dataIn += "&" + key + "=" + fn.coll(value);
        switch (key)
        {
          case "vEcom_CustId": ec.ecomCustId = value.ToUpper(); break;
          case "vEcom_Id": ec.ecomId = value.ToUpper(); break;          // check below when determining customer to get NOP ecomPwd
          case "vGroupCustId": pa.groupCustId = value.ToUpper(); break;
          case "vGroupId": pa.groupId = value.ToUpper(); break;

          case "vEcom_OrderId": ec.ecomOrderId = value; break;
          case "vEcom_Source": ec.ecomSource = value; break;
          case "vEcom_Memo": ec.ecomMemo = fn.coll(value); break;
          case "vEcom_Currency": ec.ecomCurrency = value; break;
          case "vEcom_Lang": ec.ecomLang = value; break;
          case "vEcom_Media": ec.ecomMedia = value; break;

          case "vEcom_FirstName": ec.ecomFirstName = value; break;
          case "vEcom_LastName": ec.ecomLastName = value; break;
          case "vEcom_Email": ec.ecomEmail = value; break;
          case "vEcom_CardName": ec.ecomCardName = value; break;
          case "vEcom_Address": ec.ecomAddress = value; break;
          case "vEcom_City": ec.ecomCity = value; break;
          case "vEcom_Postal": ec.ecomPostal = value; break;
          case "vEcom_Province": ec.ecomProvince = value; break;
          case "vEcom_Country": ec.ecomCountry = value; break;
          case "vEcom_Phone": ec.ecomPhone = value; break;
          case "vEcom_Organization": ec.ecomOrganization = value; break;

          case "vEcom_LineId": pa.cLineId = fn.coll(value); break;
          case "vEcom_Programs": pa.cPrograms = fn.coll(value); break;
          case "vPrice": pa.cPrice = fn.coll(value); break;
          case "vEcom_Quantity": pa.cQuantity = fn.coll(value); break;
          case "vEcom_Prices": pa.cPrices = fn.coll(value); break;
          case "vGST": pa.cGst = fn.coll(value); break;
          case "vPST": pa.cPst = fn.coll(value); break;
          case "vHST": pa.cHst = fn.coll(value); break;
          case "vEcom_Amount": pa.cAmount = fn.coll(value); break;

          case "vTot_Quantity": pa.totQuantity = Convert.ToInt16(fn.fDefault(value, "0")); break;
          case "vTot_Prices": pa.totPrices = Convert.ToDecimal(fn.fDefault(value, "0")); break;
          case "vTot_GST": pa.totGst = Convert.ToDecimal(fn.fDefault(value, "0")); break;
          case "vTot_PST": pa.totPst = Convert.ToDecimal(fn.fDefault(value, "0")); break;
          case "vTot_HST": pa.totHst = Convert.ToDecimal(fn.fDefault(value, "0")); break;
          case "vTot_Amount": pa.totAmount = Convert.ToDecimal(fn.fDefault(value, "0")); break;

        }
      }

      // strip off leading "&" in dataIn (just for optics in log)
      if (fn.left(pa.dataIn, 1) == "&") pa.dataIn = pa.dataIn.Substring(1);

      #endregion

      #region Error Check

      ec.ecomLogNo = pa.logNo;

      fn.logStep(pa.bStep, pa.logNo, "00.0"); // check for missing fields 

      if ((ec.ecomCustId ?? "").Length != 8) return (fn.err(450, "CustomerID"));
      //if ((ec.ecomEmail ?? "").Length == 0) return (fn.err(450, "UserEmail")); // only check if new online or new group2 - not addon2 or online topup (tricky)
      if ((ec.ecomMedia ?? "").Length == 0) return (fn.err(450, "TransactionType"));
      if ((ec.ecomCurrency ?? "").Length == 0) return fn.err(450, "Currency");

      if ((pa.cPrograms ?? "").Length == 0) return (fn.err(450, "ProgramId"));

      if ((pa.cPrice ?? "").Length == 0) return (fn.err(450, "UnitPrice"));
      if (fn.missing(pa.cPrice)) return (fn.err(451, "UnitPrice"));

      if ((pa.cQuantity ?? "").Length == 0) return (fn.err(450, "Seats"));
      if (fn.missing(pa.cQuantity)) return (fn.err(451, "Seats"));

      if ((pa.cPrices ?? "").Length == 0) return (fn.err(450, "LineTotal"));
      if (fn.missing(pa.cPrices)) return (fn.err(451, "LineTotal"));

      if ((pa.cAmount ?? "").Length == 0) return (fn.err(450, "ExtendedPrice"));
      if (fn.missing(pa.cAmount)) return (fn.err(451, "ExtendedPrice"));

      if ((pa.cPst ?? "").Length == 0) return (fn.err(450, "PSTAmount"));
      if (fn.missing(pa.cPst)) return (fn.err(451, "PSTAmount"));

      if ((pa.cHst ?? "").Length == 0) return (fn.err(450, "HSTAmount"));
      if (fn.missing(pa.cHst)) return (fn.err(451, "HSTAmount"));

      if ((pa.totQuantity) == null) return (fn.err(450, "SeatsTotal"));
      if ((pa.totPrices) == null) return (fn.err(450, "ExtendedTotal"));
      if ((pa.totGst) == null) return (fn.err(450, "GSTTotal"));
      if ((pa.totPst) == null) return (fn.err(450, "PSTTotal"));
      if ((pa.totHst) == null) return (fn.err(450, "HSTTotal"));
      if ((pa.totAmount) == null) return (fn.err(450, "OrderTotal"));

      fn.logStep(pa.bStep, pa.logNo, "02.0");  // check for invalid fields

      cu.customer(ec.ecomCustId);
      if (cu.custEof) return (fn.err(451, "CustomerID"));
      if (cu.custParentId.Trim().Length > 0) return (fn.err(452, ec.ecomCustId));
      if ("Online Group2 AddOn2".IndexOf(ec.ecomMedia) == -1) return fn.err(451, "Transaction Type");

      // if there is an orderId then ensure there are no transactions on file with this Order Id (added Aug 13, 2018).
      if (!string.IsNullOrEmpty(ec.ecomOrderId) && !string.IsNullOrEmpty(ec.isEcomUnique(ec.ecomCustId, ec.ecomOrderId)))
      {
        return fn.err(453, ec.ecomOrderId, ec.ecomCustId, ec.isEcomUnique(ec.ecomCustId, ec.ecomOrderId));
      }

      // if NOP get password from app.ecomRegister (added for Portal access Feb 12, 2018) - easier than passing this through the ecom service
      ec.ecomPwd = ap.password(cu.custChannelNop, ec.ecomId);

      #endregion

      #region Refine Values

      fn.logStep(pa.bStep, pa.logNo, "03.0");  // refine values

      // validating a request, committing (default)
      //pa.bNewPwd = false;
      string temp = Request["vAction"];
      if (temp == null) { pa.bCommit = true; }
      else if (temp.ToLower() == "c") { pa.bCommit = true; }
      else if (temp.ToLower() == "v") { pa.bCommit = false; }
      else { pa.status = fn.err(443); }

      ec.ecomLang = (ec.ecomLang == null) ? "EN" : ec.ecomLang.ToUpper();
      ec.ecomSource = ec.ecomSource ?? "C";
      ec.ecomIssued = DateTime.Now;
      ec.ecomOrganization = fn.nullToString(ec.ecomOrganization);
      pa.groupCustId = fn.nullToString(pa.groupCustId);

      me.membPwd = ec.ecomPwd; // added Feb 22, 2018 to support NOP
      me.membFirstName = fn.reQuote(ec.ecomFirstName);
      me.membLastName = fn.reQuote(ec.ecomLastName);
      me.membEmail = ec.ecomEmail;
      me.membOrganization = ec.ecomOrganization;

      if (pa.cPrograms.Replace("|", "").Trim().Length < 7) return (fn.err(467));
      pa.maxUsers = -1;
      ec.ecomAcctId = fn.right(ec.ecomCustId, 4);
      pa.programCnt = -1;

      // if no password/userName was submitted then we create one
      pa.bUpdateOnline = (fn.length(ec.ecomId) > 0) ? true : false;

      fn.logStep(pa.bStep, pa.logNo, "04.0");

      #endregion

      #region AddOn2
      if (ec.ecomMedia == "AddOn2")
      {
        if (pa.groupCustId.Length > 0 && pa.groupId.Length > 0)
        {
          if (pa.groupCustId.Length != 8) return (fn.err(451, "vGroupCustId"));
          if (!cu.isCustomer(pa.groupCustId)) return (fn.err(470));

          if (pa.groupCustId == ec.ecomCustId) return (fn.err(445));
          if (!cu.isCustomerG2(pa.groupCustId)) return (fn.err(446));
          me.memberById(fn.right(pa.groupCustId, 4), pa.groupId);
          if (me.membEof) return (fn.err(471));
          if (me.membLevel != 3) return (fn.err(472));

          pa.bUpdateGroup2 = true;
          ec.ecomMembNo = me.membNo;
          ec.ecomId = me.membId;
          ec.ecomFirstName = fn.reQuote(me.membFirstName);
          ec.ecomLastName = fn.reQuote(me.membLastName);
          ec.ecomEmail = me.membEmail;
          ec.ecomNewAcctId = fn.right(pa.groupCustId, 4);
          ec.ecomExpires = DateTime.Today.AddDays(365);
          ec.ecomMedia = "Group2";
        }
        else
        {
          return (fn.err(472));
          //	return ("472 You are trying to Add On to a Group site without including the Group CustId and/or the Group Password.");
        }
      }
      else
      {
        pa.bUpdateGroup2 = false;
      }
      #endregion

      #region Parse Data
      //  get the original catalogue value based on the programs selected (normally passed in via vubiz ecommerce)
      pa.aPrograms = pa.cPrograms.Split('|');
      pa.programCnt = -1; //  temp CatlNo;
      foreach (string program in pa.aPrograms)
      {
        pa.programCnt++;
        if (fn.length(program) != 7 || !pr.isProgram(program)) return (fn.err(473, (pa.programCnt + 1).ToString(), program));
        ec.ecomCatlNo = ca.catalogueNo(ec.ecomCustId, program);
        if (ec.ecomCatlNo == 0) return (fn.err(466, (pa.programCnt + 1).ToString(), program));
        pa.aCatlNo[pa.programCnt] = ec.ecomCatlNo;
      }

      //  if there is only one program ordered then ensure we only grab first value in case there are multiple values (rare)
      if (pa.programCnt == 0)
      {
        fn.logStep(pa.bStep, pa.logNo, "06.0");

        if (pa.cLineId != null) ec.ecomLineId = pa.cLineId.Split('|')[0]; // LineId is an optional field
        ec.ecomPrograms = pa.cPrograms.Split('|')[0];

        ec.ecomCatlNo = pa.aCatlNo[0];
        pa.price = Convert.ToDecimal(pa.cPrice.Split('|')[0]);
        ec.ecomQuantity = Convert.ToInt32(pa.cQuantity.Split('|')[0]);
        ec.ecomPrices = Convert.ToDecimal(pa.cPrices.Split('|')[0]);
        ec.ecomAmount = Convert.ToDecimal(pa.cAmount.Split('|')[0]);
        pa.gst = Convert.ToDecimal(pa.cGst.Split('|')[0]);
        pa.pst = Convert.ToDecimal(pa.cPst.Split('|')[0]);
        pa.hst = Convert.ToDecimal(pa.cHst.Split('|')[0]);

      }
      #endregion

      #region Online
      // process Online - individual orders
      if (ec.ecomMedia == "Online")
      {
        fn.logStep(pa.bStep, pa.logNo, "07.0");

        // passing in a password (ie do not generate one - below)
        if (fn.length(ec.ecomId) > 0)
        {
          //  get member, if not on file and auto-enroll then add member
          if (!me.memberById(ec.ecomAcctId, ec.ecomId))
          {
            // if not on file and auto-enroll then add member                
            if (cu.custAuto)
            {
              me.init();
              me.membAcctId = ec.ecomAcctId;
              me.membId = fn.reQuote(ec.ecomId);
              me.membFirstName = fn.reQuote(ec.ecomFirstName);
              me.membLastName = fn.reQuote(ec.ecomLastName);
              me.membEmail = fn.reQuote(ec.ecomEmail);
              me.membOrganization = fn.reQuote(ec.ecomOrganization);
              me.membLevel = 2;

              fn.logStep(pa.bStep, pa.logNo, "07.1", "me.memberInsertUpdate('Insert')");
              if (pa.bCommit) me.memberInsertUpdate("Insert");
              fn.logStep(pa.bStep, pa.logNo, "07.2", "me.memberInsertUpdate('Insert')");

              // added Jan 16, 2018 - need to put the new membNo into ecom (for v8)
              if (me.memberById(me.membAcctId, me.membId)) ec.ecomMembNo = me.membNo;

              fn.logStep(pa.bStep, pa.logNo, "07.25", "me.memberInsertUpdate('Insert')");
            }
            // if not on file and not auto-enroll then error                
            else
            {
              // return ("486 Can only add learner if account is auto-enroll.");
              return (fn.err(486));
            }
          }
          // if on file add to what we retrieved else ignore
          else
          {
            if (ec.ecomFirstName.Length > 0) me.membFirstName = fn.reQuote(ec.ecomFirstName);
            if (ec.ecomLastName.Length > 0) me.membLastName = fn.reQuote(ec.ecomLastName);
            if (ec.ecomEmail.Length > 0) me.membEmail = fn.reQuote(ec.ecomEmail);
            if (ec.ecomOrganization.Length > 0) me.membOrganization = fn.reQuote(ec.ecomOrganization);

            ec.ecomMembNo = me.membNo;
            fn.logStep(pa.bStep, pa.logNo, "07.3", "me.memberInsertUpdate('Update')");
            if (pa.bCommit) me.memberInsertUpdate("Update");
            fn.logStep(pa.bStep, pa.logNo, "07.4", "me.memberInsertUpdate('Update')");
          }
        }

        // individual sale - need to generate a system password
        else
        {
          me.init();
          me.membAcctId = ec.ecomAcctId;
          me.membFirstName = fn.reQuote(ec.ecomFirstName);
          me.membLastName = fn.reQuote(ec.ecomLastName);
          me.membEmail = fn.reQuote(ec.ecomEmail);
          me.membOrganization = fn.reQuote(ec.ecomOrganization);
          if (pa.bCommit)
          {
            fn.logStep(pa.bStep, pa.logNo, "07.5", "me.memberNextId('...'')");
            me.memberNextId(me.membAcctId, out pa._membId, out pa._membNo);
            fn.logStep(pa.bStep, pa.logNo, "07.6", "me.memberNextId('...'')");
            ec.ecomId = pa._membId;
            ec.ecomMembNo = pa._membNo;
          }

        }

      }
      #endregion

      #region Group2
      // process Group2 but NOT an AddOn2, create/clone customer, catalogue and add facilitator and Vubiz Internals plus the local support manager
      else if (!pa.bUpdateGroup2)
      {
        fn.logStep(pa.bStep, pa.logNo, "08.0");

        if (pa.bCommit)
        {
          ec.ecomExpires = DateTime.Today.AddDays(365);                                                         // new account expires in 1 year
          ec.ecomNewAcctId = cu.customerClone(ec.ecomCustId, pa.cPrograms.Replace('|', ' '), ec.ecomExpires);   // create/clone a new cust using currenct cust Id

          if (ec.ecomNewAcctId == "0000") return (fn.err(497));
          if (ec.ecomNewAcctId.Length == 5) return (fn.err(498, ec.ecomNewAcctId.Substring(1, 4)));

          //  add purchaser to the member table as a facilitator
          me.membAcctId = ec.ecomNewAcctId;
          me.membLevel = 3;
          if (fn.length(ec.ecomId) == 0)  //  if no member Id then create one
          {
            me.memberNextId(me.membAcctId, out pa._membId, out pa._membNo);
            ec.ecomId = pa._membId;
            ec.ecomMembNo = pa._membNo;
          }
          else // add to member table
          {
            ec.ecomMembNo = me.memberNextNo(me.membAcctId, ec.ecomId);
          }
        }

        //  '...add a default channel manager (get from cust_ChannelManager) and the 4 internals
        if (pa.bCommit)
        {
          fn.logStep(pa.bStep, pa.logNo, "09.0");
          string newChannelManagerPwd = fn.fDefault(cu.custChannelManager, fn.left(ec.ecomCustId, 4) + "_SALES"); // added Jan 4, 2018 to handle programmable customer channelManager passwords
          me.memberInsertSpecialsNew(me.membAcctId, newChannelManagerPwd, me.membPassword2, me.membPassword3, me.membPassword4, me.membPassword5);

          // log SQL
          pa.logMisc = "acctId: " + me.membAcctId.ToString() + ", dbo.sp6memberInsertSpecialsNew (" + fn.left(ec.ecomCustId, 4) + "_SALES" + ", " + me.membPassword2 + ", " + me.membPassword3 + ", " + me.membPassword4 + ", " + me.membPassword5 + ")";
          fn.logStep(pa.bStep, pa.logNo, "09.1", pa.logMisc);
        }

      }
      #endregion

      #region AddOn2
      // if AddOn2 then extend the expiry date
      else if (pa.bUpdateGroup2)
      {
        fn.logStep(pa.bStep, pa.logNo, "10.0");
        ec.ecomExpires = DateTime.Today.AddDays(365);
        if (pa.bCommit)
        {
          cu.customerExpiryDate(ec.ecomNewAcctId, ec.ecomExpires);
        }
      }
      #endregion

      #region Post Single Purchases
      //  post transactions to ecom table, one program per transacton
      //  note that each program might have a different expiry date
      fn.logStep(pa.bStep, pa.logNo, "11.0");

      if (pa.programCnt == 0)  // post single purchase
      {

        if (pa.price < 0) return (fn.err(461, (pa.programCnt + 1).ToString()));

        ec.ecomTaxes = pa.gst + pa.pst + pa.hst;
        if (ec.ecomMedia == "Online" && ec.ecomQuantity != 1) return (fn.err(477));
        if (ec.ecomPrices != pa.price * ec.ecomQuantity) return (fn.err(474));
        if (ec.ecomAmount != (ec.ecomPrices + ec.ecomTaxes)) return (fn.err(475));


        if (ec.ecomMedia == "Online")
        {
          int days = ca.catalogueProgramExpires(ec.ecomCustId, ec.ecomPrograms);
          ec.ecomExpires = DateTime.Now.AddDays(days);
        };

        if (pa.bCommit)
        {
          ec.ecommmercePost();
          fn.logStep(pa.bStep, pa.logNo, "11.1", "ec.ecomercePost()");
        }


      }
      #endregion

      #region Post Multiple Purchases
      else  // post multiple purchases 
      {
        if (pa.aLineId != null) pa.aLineId = pa.cLineId.Split('|');
        pa.aPrograms = pa.cPrograms.Split('|');

        pa.aTmp = pa.cPrice.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aPrice[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cQuantity.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aQuantity[i] = int.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cPrices.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aPrices[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cGst.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aGst[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cPst.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aPst[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cHst.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aHst[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cAmount.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aAmount[i] = decimal.Parse(pa.aTmp[i]); }

        //  '...loop through to confirm all totals and programs are ok - do not use vProgramCnt (generated at top) to avoid empty values

        pa.tmpQuantity = 0;
        pa.tmpGst = pa.tmpPst = pa.tmpHst = pa.tmpAmount = 0;

        for (int i = 0; i <= pa.programCnt; i++)
        {
          if (pa.aLineId != null) ec.ecomLineId = pa.aLineId[i];
          ec.ecomPrograms = pa.aPrograms[i];
          pa.price = pa.aPrice[i];
          ec.ecomQuantity = pa.aQuantity[i];
          ec.ecomPrices = pa.aPrices[i];
          ec.ecomTaxes = pa.aGst[i] + pa.aPst[i] + pa.aHst[i];
          ec.ecomAmount = pa.aAmount[i];
          ec.ecomCatlNo = pa.aCatlNo[i];

          // check line item values

          if (pa.price < 0) return (fn.err(461, (pa.programCnt + 1).ToString()));

          if (ec.ecomMedia == "Online" && ec.ecomQuantity != 1) return (fn.err(477, (pa.programCnt + 1).ToString()));
          pa.tmpQuantity = pa.tmpQuantity + ec.ecomQuantity;
          pa.tmpGst = pa.tmpGst + pa.aGst[i];
          pa.tmpPst = pa.tmpPst + pa.aPst[i];
          pa.tmpHst = pa.tmpHst + pa.aHst[i];
          pa.tmpAmount = pa.tmpAmount + pa.aAmount[i];

          if (ec.ecomPrices != (pa.price * ec.ecomQuantity)) return (fn.err(478, (pa.programCnt + 1).ToString()));
          if (ec.ecomAmount != (ec.ecomPrices + ec.ecomTaxes)) return (fn.err(479, (pa.programCnt + 1).ToString()));
          if (ec.ecomCatlNo == 0) return (fn.err(480, ec.ecomPrograms, (pa.programCnt + 1).ToString()));
        }

        // check total values
        if (pa.tmpQuantity != pa.totQuantity) return (fn.err(481));
        if (pa.tmpGst != pa.totGst) return (fn.err(482));
        if (pa.tmpPst != pa.totPst) return (fn.err(483));
        if (pa.tmpHst != pa.totHst) return (fn.err(484));
        if (pa.tmpAmount != pa.totAmount) return (fn.err(485));

        //  '...post line items into the ecom table
        fn.logStep(pa.bStep, pa.logNo, "12.0");

        for (int i = 0; i <= pa.programCnt; i++)
        {
          if (pa.aLineId != null) ec.ecomLineId = pa.aLineId[i];
          ec.ecomPrograms = pa.aPrograms[i];
          ec.ecomCatlNo = pa.aCatlNo[i];
          ec.ecomQuantity = pa.aQuantity[i];
          ec.ecomPrices = pa.aPrices[i];
          ec.ecomTaxes = pa.aTaxes[i];
          ec.ecomAmount = pa.aAmount[i];

          if (ec.ecomMedia == "Online")
          {
            int days = ca.catalogueProgramExpires(ec.ecomCustId, ec.ecomPrograms);
            ec.ecomExpires = DateTime.Now.AddDays(days);
          };


          //    If vEcom_Media = "Online" Then vEcom_Expires = fFormatSqlDate(Now + fCatlExpires(vEcom_CustId, vEcom_Programs)) End If
          if (pa.bCommit) ec.ecommmercePost();
        }

      }

      #endregion

      #region Update Member Table
      // update Member table for online orders with values above and below
      fn.logStep(pa.bStep, pa.logNo, "13.0");

      me.membNo = ec.ecomMembNo;
      me.membAcctId = fn.fstrDefault(ec.ecomNewAcctId, ec.ecomAcctId);
      me.membLevel = fn.fintDefault(me.membLevel, 2);
      me.membId = ec.ecomId;
      me.membPwd = ec.ecomPwd;    // added Feb 13, 2018 when developing Nop

      if (pa.bCommit && ec.ecomMedia == "Online")
      {
        // add to member table unless member ordered a course previously - note that Group2 member(s) were added above
        me.memberInsertUpdate("InsertUpdate");
      }

      #endregion

      #region Recreate the Group Catl for both Group2 and AddOn2 sales

      fn.logStep(pa.bStep, pa.logNo, "14.0");
      if (pa.bCommit)
      {
        if (ec.ecomMedia == "Group2")
          ca.catalogueReCreate(fn.left(ec.ecomCustId, 4) + ec.ecomNewAcctId);
        else if (ec.ecomMedia == "AddOn2")
          ca.catalogueReCreate(fn.left(ec.ecomCustId, 4) + pa.groupCustId);
      }
      #endregion

      fn.logStep(pa.bStep, pa.logNo, "99.0");
      return pa.status;

    }
  }
}