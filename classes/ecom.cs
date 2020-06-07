using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace portal
{
  public class Ecom
  {
    public int ecomNo, ecomMembNo, ecomQuantity, ecomCatlNo;
    public double ecomLogNo = -1;
    public decimal ecomPrices, ecomTaxes, ecomAmount;
    public string ecomAcctId, ecomCustId, ecomId, ecomPwd, ecomOrderId, ecomLineId, ecomPrograms, ecomLang, ecomFirstName, ecomLastName, ecomCardName, ecomAddress, ecomCity, ecomPostal, ecomProvince, ecomCountry, ecomPhone, ecomEmail, ecomCurrency, ecomNewAcctId, ecomMedia, ecomMemo, ecomOrganization, ecomSource, ecomGuid; // ecomGuid added Nov 14, 2017 to capture the GUID returned from the general function: public static void logPost 
    public DateTime ecomIssued;
    public DateTime? ecomExpires;

    // post ecommerce transaction, get values from above class values
    public void ecommmercePost()
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6ecommercePost";
          cmd.CommandType = CommandType.StoredProcedure;

          cmd.Parameters.Add(new SqlParameter("@ecomCustId", ecomCustId));
          cmd.Parameters.Add(new SqlParameter("@ecomAcctId", ecomAcctId));
          cmd.Parameters.Add(new SqlParameter("@ecomOrderId", ecomOrderId));
          cmd.Parameters.Add(new SqlParameter("@ecomId", ecomId));
          cmd.Parameters.Add(new SqlParameter("@ecomPwd", ecomPwd));
          cmd.Parameters.Add(new SqlParameter("@ecomMembNo", ecomMembNo));
          cmd.Parameters.Add(new SqlParameter("@ecomCatlNo", ecomCatlNo));
          cmd.Parameters.Add(new SqlParameter("@ecomLineId", ecomLineId));
          cmd.Parameters.Add(new SqlParameter("@ecomPrograms", ecomPrograms));
          cmd.Parameters.Add(new SqlParameter("@ecomPrices", ecomPrices));
          cmd.Parameters.Add(new SqlParameter("@ecomTaxes", ecomTaxes));
          cmd.Parameters.Add(new SqlParameter("@ecomIssued", ecomIssued));
          cmd.Parameters.Add(new SqlParameter("@ecomExpires", ecomExpires));
          cmd.Parameters.Add(new SqlParameter("@ecomAmount", ecomAmount));
          cmd.Parameters.Add(new SqlParameter("@ecomCurrency", ecomCurrency));
          cmd.Parameters.Add(new SqlParameter("@ecomLang", ecomLang));
          cmd.Parameters.Add(new SqlParameter("@ecomFirstName", ecomFirstName ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomLastName", ecomLastName ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomCardName", ecomCardName ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomAddress", ecomAddress ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomCity", ecomCity ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomPostal", ecomPostal ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomProvince", ecomProvince ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomCountry", ecomCountry ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomPhone", ecomPhone ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomEmail", ecomEmail ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomQuantity", ecomQuantity));
          cmd.Parameters.Add(new SqlParameter("@ecomNewAcctId", ecomNewAcctId));
          cmd.Parameters.Add(new SqlParameter("@ecomMedia", ecomMedia));
          cmd.Parameters.Add(new SqlParameter("@ecomMemo", ecomMemo ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomOrganization", ecomOrganization ?? ""));
          cmd.Parameters.Add(new SqlParameter("@ecomSource", ecomSource));
          cmd.Parameters.Add(new SqlParameter("@ecomLogNo", ecomLogNo));

          cmd.ExecuteNonQuery();
        }
      }
    }

    // returns the Ecom_Id (password) if ecomOrderId is on ecom table for this ecomCustId
    public string isEcomUnique(string ecomCustId, string ecomOrderId)
    {
      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6IsEcomUnique";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@ecomCustId", ecomCustId));
          cmd.Parameters.Add(new SqlParameter("@ecomOrderId", ecomOrderId));
          cmd.Parameters.Add("@ecomId", SqlDbType.VarChar, 128).Direction = ParameterDirection.Output;
          cmd.ExecuteNonQuery();
          return (cmd.Parameters["@ecomId"].Value.ToString());
        }

      }
    }


    // returns purchased items and assignment status (used in Default.asp for the Purchase Notice)
    public void ecomPurchaseNotice(
      string custId,
      string membId,
      out string _membProgram,
      out string _ecomProgram,
      out string _progTitle,
      out string _ecomQuantity
      )
    {
      _membProgram = _ecomProgram = _progTitle = _ecomQuantity = null;

      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.sp6purchaseNotice";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.Add(new SqlParameter("@membId", membId));
          SqlDataReader drd = cmd.ExecuteReader();
          while (drd.Read())
          {
            _membProgram += "|" + drd["membPrograms"] as string;
            _ecomProgram += "|" + drd["ecomPrograms"] as string;
            _progTitle += "|" + drd["progTitle"] as string;
            _ecomQuantity += "|" + drd["ecomQuantity"].ToString();
          }
          drd.Close();
        }
      }
    }




    // returns no of seats assigned for submitted purchased program (used in Default.asp for the Purchase Notice)
    public void noPurchasedAssigned(
      string custId,
      string progId,
      out string _noAssigned
      )
    {
      _noAssigned = "0";

      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.Connection = con;
          cmd.CommandText = "dbo.[sp6noPurchasedAssigned]";
          cmd.CommandType = CommandType.StoredProcedure;
          cmd.Parameters.Add(new SqlParameter("@custId", custId));
          cmd.Parameters.Add(new SqlParameter("@progId", progId));
          SqlDataReader drd = cmd.ExecuteReader();
          while (drd.Read())
          {
            _noAssigned = drd["noAssigned"].ToString();
          }
          drd.Close();
        }
      }
    }















  }

}