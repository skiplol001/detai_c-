using System;
using System.Collections.Generic;
using System.Configuration; // Thêm thư viện này
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace lab05
{
    public partial class Default : System.Web.UI.MasterPage
    {
        // Sử dụng ConfigurationManager để lấy chuỗi kết nối từ Web.config (Khuyên dùng)
        // Hoặc dùng chuỗi cứng của bạn: 
        string connectionString = "Data Source=.;Initial Catalog=BookStoreDB;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                KiemTraDangNhap();
                CapNhatSoLuongGioHang();
            }
        }

     
        protected string GetMasterFilterUrl(string paramName, string value)
        {
            // Luôn hướng về trang danhsach.aspx khi nhấn vào bộ lọc ở Sidebar
            string url = "danhsach.aspx?";
            var query = Request.QueryString;

            // Quét qua các tham số hiện có trên URL để giữ lại (Ví dụ: đang search thì giữ lại search)
            foreach (string key in query.AllKeys)
            {
                // Bỏ qua tham số đang muốn thay đổi và tham số phân trang (reset về trang 1)
                if (key != null && key != paramName && key != "page")
                {
                    url += key + "=" + Server.UrlEncode(query[key]) + "&";
                }
            }
            // Thêm tham số mới vào
            return url + paramName + "=" + value;
        }

        /// <summary>
        /// Xử lý sự kiện khi nhấn nút Tìm kiếm
        /// </summary>
        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect("~/danhsach.aspx?search=" + Server.UrlEncode(query));
            }
            else
            {
                Response.Redirect("~/danhsach.aspx");
            }
        }

        /// <summary>
        /// Cập nhật số lượng sách hiển thị trên icon Giỏ hàng
        /// </summary>
        public void CapNhatSoLuongGioHang()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    // SQL lấy tổng số lượng từ đơn hàng chưa giao của khách hàng mặc định (MaKH = 2)
                    string sql = @"
                        SELECT ISNULL(SUM(Soluong), 0) 
                        FROM CTDatHang 
                        WHERE SoDH = (SELECT TOP 1 SoDH FROM DonDatHang WHERE MaKH = 2 AND Dagiao = 0 ORDER BY SoDH DESC)";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        object result = cmd.ExecuteScalar();
                        int total = (result != null && result != DBNull.Value) ? Convert.ToInt32(result) : 0;

                        // Hiển thị lên badge giỏ hàng
                        spCartCount.InnerText = total.ToString();
                        // Ẩn badge nếu không có hàng
                        spCartCount.Visible = (total > 0);
                    }
                }
            }
            catch
            {
                spCartCount.Visible = false;
            }

        }
        protected void BtnApplyPrice_Click(object sender, EventArgs e)
        {
            string min = txtMinPrice.Text.Trim();
            string max = txtMaxPrice.Text.Trim();

            // Tạo URL: danhsach.aspx?min=xxx&max=yyy
            // Đồng thời giữ lại MaCD hoặc search hiện tại
            string url = "danhsach.aspx?";
            var query = Request.QueryString;

            foreach (string key in query.AllKeys)
            {
                // Bỏ qua các tham số liên quan đến giá cũ và phân trang
                if (key != "price" && key != "min" && key != "max" && key != "page" && key != null)
                    url += key + "=" + Server.UrlEncode(query[key]) + "&";
            }

            if (!string.IsNullOrEmpty(min)) url += "min=" + min + "&";
            if (!string.IsNullOrEmpty(max)) url += "max=" + max;

            Response.Redirect(url.TrimEnd('&'));
        }
        private void KiemTraDangNhap()
        {
            // Giả sử sau khi đăng nhập thành công ở trang dangnhap.aspx, 
            // bạn đã gán Session["HoTen"] = dr["HoTenKH"];
            if (Session["HoTen"] != null)
            {
                phAnonymous.Visible = false; // Ẩn nút "Tài khoản"
                phUser.Visible = true;       // Hiện khối chào hỏi
                litUserName.Text = Session["HoTen"].ToString(); // Hiển thị tên người dùng
            }
            else
            {
                phAnonymous.Visible = true;
                phUser.Visible = false;
            }
        }

        // Xử lý khi nhấn nút Đăng xuất
        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            // Xóa sạch Session
            Session.Remove("MaKH");
            Session.Remove("HoTen");
            Session.Remove("TenDN");
            Session.Remove("IsAdmin");
            Session.Remove("Cart"); // Tùy chọn: Xóa luôn giỏ hàng nếu muốn

            // Quay về trang chủ
            Response.Redirect("~/trangchu.aspx");
        }
    }


}