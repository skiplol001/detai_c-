using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lab05.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Bảo mật: Kiểm tra nếu không phải người bán (Role 2) thì mời ra trang chủ
            if (Session["MaRole"] == null || Convert.ToInt32(Session["MaRole"]) != 2)
            {
                Response.Redirect("../khach/trangchu.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStatistics();
                LoadRecentOrders();
            }
        }

        private void LoadStatistics()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                conn.Open();

                // 1. Tính tổng doanh thu
                SqlCommand cmdRev = new SqlCommand("SELECT SUM(Trigia) FROM DonDatHang", conn);
                object rev = cmdRev.ExecuteScalar();
                litRevenue.Text = rev != DBNull.Value ? string.Format("{0:#,##0}", rev) : "0";

                // 2. Tổng số đơn hàng
                SqlCommand cmdOrd = new SqlCommand("SELECT COUNT(*) FROM DonDatHang", conn);
                litOrders.Text = cmdOrd.ExecuteScalar().ToString();

                // 3. Tổng số đầu sách
                SqlCommand cmdBook = new SqlCommand("SELECT COUNT(*) FROM Sach", conn);
                litBooks.Text = cmdBook.ExecuteScalar().ToString();
            }
        }

        private void LoadRecentOrders()
        {
            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = @"SELECT TOP 5 d.SoDH, d.NgayDH, d.Trigia, d.Dagiao, k.HoTenKH 
                             FROM DonDatHang d JOIN KhachHang k ON d.MaKH = k.MaKH 
                             ORDER BY d.NgayDH DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvRecentOrders.DataSource = dt;
                gvRecentOrders.DataBind();
            }
        }
    }
}