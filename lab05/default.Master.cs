using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class Default : System.Web.UI.MasterPage
    {
        // Chuỗi kết nối Database
        string connectionString = "Data Source=.;Initial Catalog=BookStoreDB;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CapNhatSoLuongGioHang();
            }
        }

        /// <summary>
        /// Truy vấn Database để lấy tổng số lượng sách trong giỏ hàng hiện tại
        /// </summary>
        public void CapNhatSoLuongGioHang()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    // Query lấy tổng số lượng từ đơn hàng mới nhất chưa giao của MaKH = 2
                    string sql = @"
                        SELECT ISNULL(SUM(Soluong), 0) 
                        FROM CTDatHang 
                        WHERE SoDH = (SELECT TOP 1 SoDH FROM DonDatHang WHERE MaKH = 2 AND Dagiao = 0 ORDER BY SoDH DESC)";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        object result = cmd.ExecuteScalar();
                        int total = (result != null && result != DBNull.Value) ? Convert.ToInt32(result) : 0;

                        // Hiển thị lên giao diện
                        spCartCount.InnerText = total.ToString();

                        // Ẩn badge nếu giỏ hàng trống (0)
                        spCartCount.Visible = (total > 0);
                    }
                }
            }
            catch (Exception)
            {
                spCartCount.InnerText = "0";
                spCartCount.Visible = false;
            }
        }

        /// <summary>
        /// Xử lý sự kiện khi nhấn nút Tìm kiếm
        /// </summary>
        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                // Redirect sang trang danh sách kèm tham số search trên URL
                Response.Redirect("~/danhsach.aspx?search=" + Server.UrlEncode(query));
            }
        }
    }
}