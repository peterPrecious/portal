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
 * Jan Källman		Added		23-MAR-2010
 *******************************************************************************/

 using System;
using OfficeOpenXml;

namespace portal
{
  public partial class GetSample : System.Web.UI.Page
  {
    protected void Page_Load(object sender, EventArgs e)
    {
      ExcelPackage excelPackage = new ExcelPackage();
      var ws = excelPackage.Workbook.Worksheets.Add("Sample1");

      ws.Cells["A1"].Value = "Sample 1";
      ws.Cells["A1"].Style.Font.Bold = true;

      excelPackage.SaveAs(Response.OutputStream);
      Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
      Response.AddHeader("content-disposition", "attachment;  filename=Sample1.xlsx");
    }
  }
}
