namespace portal
{
  public class Parm
  {
    #region Fields
    public bool bSuspend, bTest, bCommit, bNewPwd, bLogs, bStep, bUpdateOnline, bUpdateGroup2;

    public long logNo = -1;
    public string logId = "", action = "";
    public string dataIn = "", logGuid, oldPassword = "";
    public string status = "", logMisc = "";
    public string groupCustId, groupId;
    public int programCnt, maxUsers = 0;

    // totalAmount, cnt, loop;
    // values that are not sent to the ecom DB but used as form collections

    public string 
      cLineId, 
      cPrograms, 
      cPrice, 
      cQuantity, 
      cPrices, 
      cGst, 
      cPst, 
      cHst, 
      cAmount;
    public string[] 
      aTmp, 
      aLineId, 
      aPrograms;
    public int[]
      aCatlNo = new int[99],
      aQuantity = new int[99];
    public decimal[]
      aPrices = new decimal[99],
      aTaxes = new decimal[99],
      aAmount = new decimal[99],
      aPrice = new decimal[99],
      aGst = new decimal[99],
      aPst = new decimal[99],
      aHst = new decimal[99];
    public decimal price, gst, pst, hst, prices, tax, amount;
    public int? totQuantity = null;
    public decimal?
      totPrices,
      totGst,
      totPst,
      totHst,
      totAmount = null;

    public int tmpQuantity;
    public decimal tmpGst, tmpPst, tmpHst, tmpAmount;

    public string _membId;
    public int _membNo;

    #endregion
  }
}