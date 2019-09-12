using System;

namespace portal
{
  public class Post
  {
    // this is not currently being used!


    public string ecomGenerateId4(string postString, Parm pa, Ecom ec)
    {

      // this method is the same as ecomGenerateId3 except all legacy comments have been removed and now this is in a separate class called "Post"
      // called by vuEcom.svc.cs (new) and the new ecomGenerateId4.aspx (coming)

      //Parm pa = new Parm();
      //Ecom ec = new Ecom();
      Memb me = new Memb();
      Cust cu = new Cust();
      Catl ca = new Catl();
      Prog pr = new Prog();

      #region Parse Input
      string[] postPairs = postString.Split('&');
      foreach (string item in postPairs)
      {
        string[] postPair = item.Split('=');
        string key = postPair[0];
        string value = postPair[1];
        switch (key)
        {
          case "vAction": pa.action = value.ToLower(); break;

          case "OldPassword": pa.oldPassword = value.ToUpper(); break;                               // this is a new field for the Action:P - changing oldPassword, ie 123456-SEWR to new Password: Ecom_Id

          case "vEcom_CustId": ec.ecomCustId = value.ToUpper(); break;                               //...if used then update existing online account
          case "vEcom_Id": ec.ecomId = value.ToUpper(); break;                                       //...if used then update existing online account
          case "vGroupCustId": pa.groupCustId = value.ToUpper(); break;                              //...if used then update existing group account
          case "vGroupId": pa.groupId = value.ToUpper(); break;                                      //...if used then update existing group account

          case "vEcom_Source": ec.ecomSource = value; break;                                         // CCOHS, etc will not send anything thus assume default "C", NOP will send "E"
          case "vEcom_Memo": ec.ecomMemo = fn.coll(value); break;                                    //         case "vEcom_Memo": ec.ecomMemo = Replace(Replace(value, ", ", ","), ",", "|"); break;
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

          // new WS does not use a form so we need to concatenate values
          case "vEcom_Programs": pa.cPrograms = fn.conc(pa.cPrograms, value); break;
          case "vPrice": pa.cPrice = fn.conc(pa.cPrice, value); break;                   // unit price
          case "vEcom_Quantity": pa.cQuantity = fn.conc(pa.cQuantity, value); break;
          case "vEcom_Prices": pa.cPrices = fn.conc(pa.cPrices, value); break;            // unit price * quantity
          case "vGST": pa.cGst = fn.conc(pa.cGst, value); break;
          case "vPST": pa.cPst = fn.conc(pa.cPst, value); break;
          case "vHST": pa.cHst = fn.conc(pa.cHst, value); break;
          case "vEcom_Amount": pa.cAmount = fn.conc(pa.cAmount, value); break;            // unit price * quantity  + taxes

          case "vTot_Quantity": pa.totQuantity = Convert.ToInt16(fn.fDefault(value, "0")); break;
          case "vTot_Prices": pa.totPrices = Convert.ToDecimal(fn.fDefault(value, "0")); break;
          case "vTot_GST": pa.totGst = Convert.ToDecimal(fn.fDefault(value, "0")); break;
          case "vTot_PST": pa.totPst = Convert.ToDecimal(fn.fDefault(value, "0")); break;
          case "vTot_HST": pa.totHst = Convert.ToDecimal(fn.fDefault(value, "0")); break;
          case "vTot_Amount": pa.totAmount = Convert.ToDecimal(fn.fDefault(value, "0")); break;

        }
      }
      #endregion

      #region Error Check
      ec.ecomLogNo = pa.logNo;

      fn.logStep(pa.bStep, pa.logNo, "00.0"); // check for missing fields 

      if ((ec.ecomCustId ?? "").Length != 8) return (fn.err(450, "CustomerID"));
      if ((ec.ecomMedia ?? "").Length == 0) return (fn.err(450, "TransactionType"));
      if ((ec.ecomCurrency ?? "").Length == 0) return fn.err(450, "Currency");

      if ((pa.cPrograms ?? "").Length == 0) return (fn.err(450, "ProgramId"));

      if ((pa.cPrice ?? "").Length == 0) return (fn.err(450, "UnitPrice"));
      if ((pa.cQuantity ?? "").Length == 0) return (fn.err(450, "Seats"));
      if ((pa.cPrices ?? "").Length == 0) return (fn.err(450, "LineTotal"));
      if ((pa.cAmount ?? "").Length == 0) return (fn.err(450, "ExtendedPrice"));
      if ((pa.cPst ?? "").Length == 0) return (fn.err(450, "PSTAmount"));
      if ((pa.cHst ?? "").Length == 0) return (fn.err(450, "HSTAmount"));

      if ((pa.totQuantity) == null) return (fn.err(450, "SeatsTotal"));
      if ((pa.totPrices) == null) return (fn.err(450, "ExtendedTotal"));
      if ((pa.totGst) == null) return (fn.err(450, "GSTTotal"));
      if ((pa.totPst) == null) return (fn.err(450, "PSTTotal"));
      if ((pa.totHst) == null) return (fn.err(450, "HSTTotal"));
      if ((pa.totAmount) == null) return (fn.err(450, "OrderTotal"));

      fn.logStep(pa.bStep, pa.logNo, "02.0");  // check for invalid fields

      cu.customer(ec.ecomCustId);
      if (cu.custParentId.Trim().Length > 0) return (fn.err(452, ec.ecomCustId));
      if (cu.custEof) return (fn.err(451, "CustomerID"));
      if ("Online Group2 AddOn2".IndexOf(ec.ecomMedia) == -1) return fn.err(451, "Transaction Type"); //  valid entry? this service only supports Online, Group2 and Addon2 // status = "469 Service was accessed with an incorrect Transaction Type.";

      #endregion

      #region Refine Values

      fn.logStep(pa.bStep, pa.logNo, "03.0");  // refine values

      // validating a request, committing (default) or changing a password
      pa.bNewPwd = false;

      if (pa.action == null) { pa.bCommit = true; }
      else if (pa.action == "c") { pa.bCommit = true; }
      else if (pa.action == "v") { pa.bCommit = false; }
      else if (pa.action == "p") { pa.bNewPwd = true; }
      else { pa.status = fn.err(443); }

      ec.ecomLang = (ec.ecomLang == null) ? "EN" : ec.ecomLang.ToUpper();
      ec.ecomSource = (ec.ecomSource == null) ? "C" : ec.ecomSource; //  CCOHS, IAPA etc default to "C" - customer.   NOP will pass in an "E" - ecommerce.Length == 0) 
      ec.ecomIssued = DateTime.Now;
      ec.ecomOrganization = fn.nullToString(ec.ecomOrganization); // optional
      pa.groupCustId = fn.nullToString(pa.groupCustId); // for Password section

      me.membFirstName = fn.reQuote(ec.ecomFirstName);
      me.membLastName = fn.reQuote(ec.ecomLastName);
      me.membEmail = ec.ecomEmail;
      me.membOrganization = ec.ecomOrganization;

      if (pa.cPrograms.Replace("|", "").Trim().Length < 7) return (fn.err(467));
      pa.maxUsers = -1; //  no contraints for group2 but need this for My Content  
      ec.ecomAcctId = fn.right(ec.ecomCustId, 4);
      pa.programCnt = -1; //  this is number of programs that were received (base 0)

      pa.bUpdateOnline = (fn.length(ec.ecomId) > 0) ? true : false; // if not password was submitted then we create a Password

      fn.logStep(pa.bStep, pa.logNo, "04.0");

      #endregion

      #region Password
      if (pa.bNewPwd) // if we are changing a password then that's all we do
      {
        string acctId = "";
        if (pa.groupCustId.Length > 0 && ec.ecomMedia != "Online") acctId = pa.groupCustId.Substring(4, 4); else acctId = ec.ecomCustId.Substring(4, 4);
        string strResult = me.memberChangeId(acctId, ec.ecomId, pa.oldPassword);
        int intResult = Int32.Parse(strResult);
        fn.logStep(pa.bStep, pa.logNo, "04.5");
        return (fn.err(intResult));
      }
      #endregion

      #region Addon2
      if (ec.ecomMedia == "AddOn2")
      {
        if (pa.groupCustId.Length > 0 && pa.groupId.Length > 0)
        {
          if (pa.groupCustId.Length != 8) return (fn.err(451, "vGroupCustId"));
          if (!cu.isCustomer(pa.groupCustId)) return (fn.err(470));

          if (pa.groupCustId == ec.ecomCustId) return (fn.err(445));
          if (!cu.isCustomerG2(pa.groupCustId)) return (fn.err(446));
          me.memberById(fn.right(pa.groupCustId, 4), pa.groupId); // if the GroupId is not on file then it might have been changed, so see if you can use the one submitted, which should be the original works
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
          ec.ecomMedia = "Group2"; //  rename back - can't remember why
        }
        else
        {
          return ("472 You are trying to Add On to a Group site without including the Group CustId and/or the Group Password.");
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
              me.init();  // clean out Memb parms
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

            }
            // if not on file and not auto-enroll then error                
            else
            {
              return ("486 Password is not on file.");
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
          ec.ecomExpires = DateTime.Today.AddDays(365);
          ec.ecomNewAcctId = cu.customerClone(ec.ecomCustId, pa.cPrograms.Replace('|', ' '), ec.ecomExpires);

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

        //  '...add a default manager and the 4 internals - revised from 5 sps above to 1 Nov 1, 2016
        if (pa.bCommit)
        {
          fn.logStep(pa.bStep, pa.logNo, "09.0");
          me.memberInsertSpecialsNew(me.membAcctId, fn.left(ec.ecomCustId, 4) + "_SALES", me.membPassword2, me.membPassword3, me.membPassword4, me.membPassword5);

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
        pa.aPrograms = pa.cPrograms.Split('|');

        pa.aTmp = pa.cPrice.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aPrice[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cQuantity.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aQuantity[i] = int.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cPrices.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aPrices[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cGst.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aGst[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cPst.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aPst[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cHst.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aHst[i] = decimal.Parse(pa.aTmp[i]); }
        pa.aTmp = pa.cAmount.Split('|'); for (int i = 0; i < pa.aTmp.Length; i++) { pa.aAmount[i] = decimal.Parse(pa.aTmp[i]); }

        // loop through to confirm all totals and programs are ok - not use vProgramCnt (generated at top) to avoid empty values
        pa.tmpQuantity = 0;
        pa.tmpGst = pa.tmpPst = pa.tmpHst = pa.tmpAmount = 0;

        for (int i = 0; i <= pa.programCnt; i++)
        {
          ec.ecomPrograms = pa.aPrograms[i];
          pa.price = pa.aPrice[i];
          ec.ecomQuantity = pa.aQuantity[i];
          ec.ecomPrices = pa.aPrices[i];
          ec.ecomTaxes = pa.aGst[i] + pa.aPst[i] + pa.aHst[i];
          ec.ecomAmount = pa.aAmount[i];
          ec.ecomCatlNo = pa.aCatlNo[i];

          // check line item values
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