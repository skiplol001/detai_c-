using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lab05
{
    public partial class dangnhap : System.Web.UI.Page
    {
        // Lấy chuỗi kết nối an toàn từ Web.config
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Nếu đã đăng nhập thì không cho vào trang này nữa, đẩy về trang chủ
            if (!IsPostBack && Session["TenDN"] != null)
            {
                Response.Redirect("trangchu.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Kiểm tra Validation phía Server lần nữa cho an toàn
            if (!Page.IsValid) return;

            string user = txtUsername.Text.Trim();
            string pass = txtPassword.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    // Truy vấn lấy các thông tin cần thiết để lưu vào Session
                    string sql = "SELECT MaKH, HoTenKH, TenDN FROM KhachHang WHERE TenDN = @user AND Matkhau = @pass";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@user", user);
                    cmd.Parameters.AddWithValue("@pass", pass); // Trong thực tế nên dùng mật khẩu đã mã hóa MD5/Bcrypt

                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // 1. Lưu thông tin vào Session
                        Session["MaKH"] = dr["MaKH"];
                        Session["HoTen"] = dr["HoTenKH"];
                        Session["TenDN"] = dr["TenDN"];

                        // 2. Phân quyền: Kiểm tra nếu là Admin
                        // Lưu ý: Có thể kiểm tra bằng cột Quyen trong DB sẽ tốt hơn là check tên cứng
                        if (user.ToLower() == "admin")
                        {
                            Session["IsAdmin"] = true;
                            // Đảm bảo thư mục Admin và trang Dashboard.aspx có tồn tại
                            Response.Redirect("~/Admin/Dashboard.aspx");
                        }
                        else
                        {
                            // Người dùng bình thường về trang chủ
                            Response.Redirect("trangchu.aspx");
                        }
                    }
                    else
                    {
                        // Sai tài khoản hoặc mật khẩu
                        HienLoi("Tài khoản hoặc mật khẩu không chính xác!");
                    }
                }
            }
            catch (Exception ex)
            {
                HienLoi("Lỗi kết nối hệ thống: " + ex.Message);
            }
        }

        // Hàm dùng chung để hiển thị thông báo lỗi
        private void HienLoi(string msg)
        {
            lblMessage.Text = msg;
            lblMessage.Visible = true;
        }
    }
}