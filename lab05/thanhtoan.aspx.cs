using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lab05
{
    public partial class thanhtoan : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Cart"] == null || ((DataTable)Session["Cart"]).Rows.Count == 0)
            {
                Response.Redirect("danhsach.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrderSummary();
            }
        }

        private void LoadOrderSummary()
        {
            DataTable dt = (DataTable)Session["Cart"];
            rptSummary.DataSource = dt;
            rptSummary.DataBind();

            decimal total = 0;
            foreach (DataRow r in dt.Rows) total += Convert.ToDecimal(r["Thanhtien"]);
            lblTongTien.Text = string.Format("{0:#,##0} VNĐ", total);
        }

        protected void btnDatHang_Click(object sender, EventArgs e)
        {
            DataTable dtCart = (DataTable)Session["Cart"];
            decimal tongTien = 0;
            foreach (DataRow r in dtCart.Rows) tongTien += Convert.ToDecimal(r["Thanhtien"]);

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction(); // Bắt đầu giao dịch

                try
                {
                    // 1. Thêm vào bảng DonDatHang
                    string sqlDonHang = @"INSERT INTO DonDatHang (MaKH, NgayDH, Trigia, Dagiao, Ngaygiao) 
                                         VALUES (@MaKH, GETDATE(), @Trigia, 0, @NgayGiao);
                                         SELECT SCOPE_IDENTITY();"; // Lấy mã SoDH vừa tạo tự động

                    SqlCommand cmdDH = new SqlCommand(sqlDonHang, conn, trans);
                    cmdDH.Parameters.AddWithValue("@MaKH", 2); // Giả định MaKH = 2 như các bài trước
                    cmdDH.Parameters.AddWithValue("@Trigia", tongTien);
                    cmdDH.Parameters.AddWithValue("@NgayGiao", string.IsNullOrEmpty(txtNgayGiao.Text) ? (object)DBNull.Value : txtNgayGiao.Text);

                    int soDH = Convert.ToInt32(cmdDH.ExecuteScalar());

                    // 2. Thêm danh sách sách vào bảng CTDatHang
                    foreach (DataRow row in dtCart.Rows)
                    {
                        string sqlCT = @"INSERT INTO CTDatHang (SoDH, MaSach, Soluong, Dongia, Thanhtien) 
                                        VALUES (@SoDH, @MaSach, @Soluong, @Dongia, @Thanhtien)";
                        SqlCommand cmdCT = new SqlCommand(sqlCT, conn, trans);
                        cmdCT.Parameters.AddWithValue("@SoDH", soDH);
                        cmdCT.Parameters.AddWithValue("@MaSach", row["MaSach"]);
                        cmdCT.Parameters.AddWithValue("@Soluong", row["Soluong"]);
                        cmdCT.Parameters.AddWithValue("@Dongia", row["Dongia"]);
                        cmdCT.Parameters.AddWithValue("@Thanhtien", row["Thanhtien"]);
                        cmdCT.ExecuteNonQuery();
                    }

                    trans.Commit(); // Thành công hết thì xác nhận lưu vào DB

                    // 3. Xóa giỏ hàng và thông báo
                    Session["Cart"] = null;
                    Response.Write("<script>alert('Chúc mừng! Đơn hàng của bạn đã được đặt thành công.'); window.location='trangchu.aspx';</script>");
                }
                catch (Exception ex)
                {
                    trans.Rollback(); // Nếu có lỗi thì hủy bỏ toàn bộ dữ liệu đã insert ở trên
                    Response.Write("<script>alert('Lỗi hệ thống: " + ex.Message + "');</script>");
                }
            }
        }
    }
}