using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration; 
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05.Seller
{
    public partial class QLDonHang : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 2. Kiểm tra bảo mật: Nếu chưa đăng nhập hoặc không phải là người bán (Role 2)
            if (Session["MaRole"] == null || Convert.ToInt32(Session["MaRole"]) != 2)
            {
                // Đẩy về trang đăng nhập nếu truy cập trái phép
                Response.Redirect("~/khach/dangnhap.aspx");
            }

            // 3. Chỉ load dữ liệu ở lần đầu tiên (tránh load lại khi bấm nút)
            if (!IsPostBack)
            {
                LoadDonHang();
            }
        }

        protected void LoadDonHang()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    // Truy vấn kết hợp bảng Khách hàng để lấy tên người mua
                    string sql = @"SELECT d.SoDH, d.NgayDH, d.Trigia, d.Dagiao, k.HoTenKH 
                                 FROM DonDatHang d 
                                 JOIN KhachHang k ON d.MaKH = k.MaKH 
                                 ORDER BY d.NgayDH DESC";

                    SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvDonHang.DataSource = dt;
                    gvDonHang.DataBind();
                }
            }
            catch (Exception ex)
            {
                // Có thể thêm nhãn thông báo lỗi trên giao diện nếu cần
                Response.Write("<script>alert('Lỗi khi tải đơn hàng: " + ex.Message + "');</script>");
            }
        }

        protected void gvDonHang_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // 4. Xử lý nút "Đổi trạng thái" (UpdateStatus)
            if (e.CommandName == "UpdateStatus")
            {
                int soDH = Convert.ToInt32(e.CommandArgument);
                try
                {
                    using (SqlConnection conn = new SqlConnection(strCon))
                    {
                        // Cập nhật trạng thái thành Đã giao (Dagiao = 1) và set ngày giao là hiện tại
                        string sql = "UPDATE DonDatHang SET Dagiao = 1, Ngaygiao = GETDATE() WHERE SoDH = @id";
                        SqlCommand cmd = new SqlCommand(sql, conn);
                        cmd.Parameters.AddWithValue("@id", soDH);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }

                    // 5. Thông báo thành công và tải lại danh sách
                    LoadDonHang();
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Lỗi khi cập nhật trạng thái: " + ex.Message + "');</script>");
                }
            }
        }
    }
}