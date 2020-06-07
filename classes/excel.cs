/*******************************************************************************
 * You may amend and distribute as you like, but don't remove this header!
 * 
 * All rights reserved.
 * 
 * EPPlus is an Open Source project provided under the 
 * GNU General Public License (GPL) as published by the 
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 * 
 * See http://epplus.codeplex.com/ for details 
 * https://github.com/JanKallman/EPPlus (new site)
 * 
 * The GNU General Public License can be viewed at http://www.opensource.org/licenses/gpl-license.php
 * If you unfamiliar with this license or have questions about it, here is an http://www.gnu.org/licenses/gpl-faq.html
 * 
 * The code for this project may be used and redistributed by any means PROVIDING it is 
 * not sold for profit without the author's written consent, and providing that this notice 
 * and the author's name and all copyright notices remain intact.
 * 
 * All code and executables are provided "as is" with no warranty either express or implied. 
 * The author accepts no liability for any damage or loss of business that this product may cause.
 *
 * Code change notes:
 * 
 * Author							Change						Date
 *******************************************************************************
 * Jan Källman		    Added		          23-MAR-2010
 *******************************************************************************/

using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using OfficeOpenXml;

namespace portal
{
  public class Excel : FormBase
  {
    // these are the basic fields for the excelWriter
    private string docName, wsName, spName;

    // added Nov 27, 2019 to allow translation of excel column headers - returned via SQL
    private string lang;


    // these are the parameters used to populate the Stored Proc (can have 10 of each type)
    // in the SQL SP the parms must appear in the order below, ie @IntParm0, @DatParm0, @DatParm1, etc....
    private int?[] intParms = new int?[10];
    private string[] strParms = new string[10];
    private DateTime?[] datParms = new DateTime?[10];
    private bool?[] bitParms = new bool?[10];  // call bitParms since SQL uses bit for boolean

    #region setGet
    public string DocName
    {
      get
      {
        return docName;
      }

      set
      {
        docName = value;
      }
    }
    public string WsName
    {
      get
      {
        return wsName;
      }

      set
      {
        wsName = value;
      }
    }
    public string SpName
    {
      get
      {
        return spName;
      }

      set
      {
        spName = value;
      }
    }

    // added Nov 27, 2019 to enable translation of column headers retrieved from SQL
    public string Lang
    {
      get
      {
        return lang;
      }

      set
      {
        lang = value;
      }
    }


    public int?[] IntParms
    {
      get
      {
        return intParms;
      }

      set
      {
        intParms = value;
      }
    }
    public string[] StrParms
    {
      get
      {
        return strParms;
      }

      set
      {
        strParms = value;
      }
    }
    public DateTime?[] DatParms
    {
      get
      {
        return datParms;
      }

      set
      {
        datParms = value;
      }
    }
    public bool?[] BitParms
    {
      get
      {
        return bitParms;
      }

      set
      {
        bitParms = value;
      }
    }
    #endregion

    //public static string SafeGetString(this SqlDataReader reader, int colIndex)
    //{
    //	if (!reader.IsDBNull(colIndex)) return reader.GetString(colIndex);
    //	return string.Empty;
    //}

    public void excelWriter()
    {
      // the excelWriter is driven by SQL and requires
      //    - document name
      //    - worksheet name (can be the same as the document name)
      //    - stored proc name
      //    - stored proc parameters (bit tricky)
      //        - parameters must be passed in by type (max 10 per type)
      //        - ie @IntParm0, @IntParm1, @StrParm0, @DatParm0, @BitParm0
      //        - if other types needed, the expland code below (ie for decimal/float, etc)

      // you can only have one worksheet populated per call

      string cols = "ABCDEFGHIJKLMNOPQRSTUVQXYZ";
      string cellId;

      System.Web.HttpContext.Current.Response.Clear();
      ExcelPackage excelPackage = new ExcelPackage();
      var worksheet = excelPackage.Workbook.Worksheets.Add(wsName);

      using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["apps"].ConnectionString))
      {
        con.Open();
        using (SqlCommand cmd = new SqlCommand())
        {
          cmd.CommandTimeout = 100;
          cmd.Connection = con;
          cmd.CommandText = SpName;
          cmd.CommandType = CommandType.StoredProcedure;

          // generate the parameters (if any)
          if (IntParms[0] != null) cmd.Parameters.Add(new SqlParameter("@IntParm0", IntParms[0]));
          if (IntParms[1] != null) cmd.Parameters.Add(new SqlParameter("@IntParm1", IntParms[1]));
          if (IntParms[2] != null) cmd.Parameters.Add(new SqlParameter("@IntParm2", IntParms[2]));
          if (IntParms[3] != null) cmd.Parameters.Add(new SqlParameter("@IntParm3", IntParms[3]));
          if (IntParms[4] != null) cmd.Parameters.Add(new SqlParameter("@IntParm4", IntParms[4]));
          if (IntParms[5] != null) cmd.Parameters.Add(new SqlParameter("@IntParm5", IntParms[5]));
          if (IntParms[6] != null) cmd.Parameters.Add(new SqlParameter("@IntParm6", IntParms[6]));
          if (IntParms[7] != null) cmd.Parameters.Add(new SqlParameter("@IntParm7", IntParms[7]));
          if (IntParms[8] != null) cmd.Parameters.Add(new SqlParameter("@IntParm8", IntParms[8]));
          if (IntParms[9] != null) cmd.Parameters.Add(new SqlParameter("@IntParm9", IntParms[9]));

          if (StrParms[0] != null) cmd.Parameters.Add(new SqlParameter("@StrParm0", StrParms[0]));
          if (StrParms[1] != null) cmd.Parameters.Add(new SqlParameter("@StrParm1", StrParms[1]));
          if (StrParms[2] != null) cmd.Parameters.Add(new SqlParameter("@StrParm2", StrParms[2]));
          if (StrParms[3] != null) cmd.Parameters.Add(new SqlParameter("@StrParm3", StrParms[3]));
          if (StrParms[4] != null) cmd.Parameters.Add(new SqlParameter("@StrParm4", StrParms[4]));
          if (StrParms[5] != null) cmd.Parameters.Add(new SqlParameter("@StrParm5", StrParms[5]));
          if (StrParms[6] != null) cmd.Parameters.Add(new SqlParameter("@StrParm6", StrParms[6]));
          if (StrParms[7] != null) cmd.Parameters.Add(new SqlParameter("@StrParm7", StrParms[7]));
          if (StrParms[8] != null) cmd.Parameters.Add(new SqlParameter("@StrParm8", StrParms[8]));
          if (StrParms[9] != null) cmd.Parameters.Add(new SqlParameter("@StrParm9", StrParms[9]));

          if (DatParms[0] != null) cmd.Parameters.Add(new SqlParameter("@DatParm0", DatParms[0]));
          if (DatParms[1] != null) cmd.Parameters.Add(new SqlParameter("@DatParm1", DatParms[1]));
          if (DatParms[2] != null) cmd.Parameters.Add(new SqlParameter("@DatParm2", DatParms[2]));
          if (DatParms[3] != null) cmd.Parameters.Add(new SqlParameter("@DatParm3", DatParms[3]));
          if (DatParms[4] != null) cmd.Parameters.Add(new SqlParameter("@DatParm4", DatParms[4]));
          if (DatParms[5] != null) cmd.Parameters.Add(new SqlParameter("@DatParm5", DatParms[5]));
          if (DatParms[6] != null) cmd.Parameters.Add(new SqlParameter("@DatParm6", DatParms[6]));
          if (DatParms[7] != null) cmd.Parameters.Add(new SqlParameter("@DatParm7", DatParms[7]));
          if (DatParms[8] != null) cmd.Parameters.Add(new SqlParameter("@DatParm8", DatParms[8]));
          if (DatParms[9] != null) cmd.Parameters.Add(new SqlParameter("@DatParm9", DatParms[9]));

          if (BitParms[0] != null) cmd.Parameters.Add(new SqlParameter("@BitParm0", BitParms[0]));
          if (BitParms[1] != null) cmd.Parameters.Add(new SqlParameter("@BitParm1", BitParms[1]));
          if (BitParms[2] != null) cmd.Parameters.Add(new SqlParameter("@BitParm2", BitParms[2]));
          if (BitParms[3] != null) cmd.Parameters.Add(new SqlParameter("@BitParm3", BitParms[3]));
          if (BitParms[4] != null) cmd.Parameters.Add(new SqlParameter("@BitParm4", BitParms[4]));
          if (BitParms[5] != null) cmd.Parameters.Add(new SqlParameter("@BitParm5", BitParms[5]));
          if (BitParms[6] != null) cmd.Parameters.Add(new SqlParameter("@BitParm6", BitParms[6]));
          if (BitParms[7] != null) cmd.Parameters.Add(new SqlParameter("@BitParm7", BitParms[7]));
          if (BitParms[8] != null) cmd.Parameters.Add(new SqlParameter("@BitParm8", BitParms[8]));
          if (BitParms[9] != null) cmd.Parameters.Add(new SqlParameter("@BitParm9", BitParms[9]));


          SqlDataReader drd = cmd.ExecuteReader();

          // column headers - row 1
          for (int i = 1; i <= drd.FieldCount; i++)
          {
            cellId = cols.Substring(i - 1, 1) + "1";
            // modified Nov 27, 2019 to get the headers from SQL then see if there's a translated value for it  
            // worksheet.Cells[cellId].Value = drd.GetName(i - 1);
            string header = drd.GetName(i - 1);
            try
            {
              header = GetGlobalResourceObject("portal", header.Replace(" ", "")).ToString();
            }
            catch (Exception) { }
            worksheet.Cells[cellId].Value = header;
            worksheet.Cells[cellId].Style.Font.Bold = true;

            // column positioning and formatting
            switch (drd.GetFieldType(i - 1).Name)
            {
              case "Guid":
              case "String":
                break;
              case "DateTime":
                worksheet.Column(i).Style.Numberformat.Format = "mmm d, yyyy";
                worksheet.Column(i).Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                break;
              case "Int16":
              case "Int32":
              case "Int64":
              case "Single":
              case "Double":
                worksheet.Column(i).Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Right;
                break;
              case "Decimal":
                worksheet.Column(i).Style.Numberformat.Format = "###,###.00";
                worksheet.Column(i).Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Right;
                break;
            }
          }

          // row details starting at 3 - be datatype specific
          int row = 3;
          while (drd.Read())
          {
            for (int i = 1; i <= drd.FieldCount; i++)
            {
              //cellId = cols.Substring(i - 1, 1) + row.ToString(); // statement not needed?
              switch (drd.GetFieldType(i - 1).Name)
              {
                case "String":
                  if (drd.GetSqlString(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlString(i - 1);
                  break;
                case "Guid":
                  if (drd.GetSqlGuid(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlGuid(i - 1);
                  break;
                case "DateTime":
                  if (drd.GetSqlDateTime(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlDateTime(i - 1);
                  break;
                case "Int16":
                  if (drd.GetSqlInt16(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlInt16(i - 1);
                  break;
                case "Int32":
                  if (drd.GetSqlInt32(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlInt32(i - 1);
                  break;
                case "Int64":
                  if (drd.GetSqlInt64(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlInt64(i - 1);
                  break;
                case "Single":
                  if (drd.GetSqlSingle(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlSingle(i - 1);
                  break;
                case "Double":
                  if (drd.GetSqlDouble(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlDouble(i - 1);
                  break;
                case "Decimal":
                  if (drd.GetSqlMoney(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlMoney(i - 1);
                  break;
                case "SqlBoolean":
                  if (drd.GetSqlBoolean(i - 1).IsNull) worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = "";
                  else worksheet.Cells[cols.Substring(i - 1, 1) + row.ToString()].Value = drd.GetSqlBoolean(i - 1);
                  break;
              }
            }
            row++;
          }

          // auto fit the columns (12-50 width)
          worksheet.Cells.AutoFitColumns();
          for (int i = 1; i <= drd.FieldCount; i++)
          {
            if (worksheet.Column(i).Width > 50) worksheet.Column(i).Width = 50;
            if (worksheet.Column(i).Width < 12) worksheet.Column(i).Width = 12;
          }

          // close the datareader and the spreadsheet
          drd.Close();
          excelPackage.SaveAs(System.Web.HttpContext.Current.Response.OutputStream);
          System.Web.HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
          System.Web.HttpContext.Current.Response.AddHeader("content-disposition", "attachment;  filename=" + DocName + ".xlsx");
          System.Web.HttpContext.Current.Response.End();
        }
      }
    }
  }
}