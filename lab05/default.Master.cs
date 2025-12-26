using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class _default : System.Web.UI.MasterPage
    {
        string connectionString = "Data Source=.;Initial Catalog=BookStoreDB;Integrated Security=True";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CapNhatSoLuongGioHang();
            }
        }

        public void CapNhatSoLuongGioHang()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    // Lấy tổng số lượng (SUM) của đơn hàng chưa giao mới nhất của MaKH = 2
                    string sql = @"
                        SELECT ISNULL(SUM(Soluong), 0) 
                        FROM CTDatHang 
                        WHERE SoDH = (SELECT TOP 1 SoDH FROM DonDatHang WHERE MaKH = 2 AND Dagiao = 0 ORDER BY SoDH DESC)";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        int total = Convert.ToInt32(cmd.ExecuteScalar());
                        spCartCount.InnerText = total.ToString();

                        // Ẩn số 0 nếu giỏ hàng trống (tùy chọn)
                        spCartCount.Visible = (total > 0);
                    }
                }
            }
            catch (Exception )
            {
                spCartCount.InnerText = "0";
            }
        }
    }
}