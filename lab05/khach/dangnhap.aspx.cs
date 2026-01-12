using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lab05
{
    public partial class dangnhap : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["TenDN"] != null)
            {
                Response.Redirect("trangchu.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string user = txtUsername.Text.Trim();
            string pass = txtPassword.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    // Lấy thêm cột MaRole để phân quyền
                    string sql = "SELECT MaKH, HoTenKH, TenDN, MaRole FROM KhachHang WHERE TenDN = @user AND Matkhau = @pass";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@user", user);
                    cmd.Parameters.AddWithValue("@pass", pass);

                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // 1. Lưu thông tin cơ bản vào Session
                        Session["MaKH"] = dr["MaKH"];
                        Session["HoTen"] = dr["HoTenKH"];
                        Session["TenDN"] = dr["TenDN"];

                        // Lấy giá trị MaRole (ép kiểu an toàn)
                        int maRole = 0;
                        if (dr["MaRole"] != DBNull.Value)
                        {
                            maRole = Convert.ToInt32(dr["MaRole"]);
                        }
                        Session["MaRole"] = maRole;

                        // 2. Điều hướng dựa trên MaRole
                        // Giả định: 1 là Người mua, 2 là Người bán
                        if (maRole == 2)
                        {
                            // Nếu là người bán hàng
                            Response.Redirect("~/Seller/Dashboard.aspx");
                        }
                        else
                        {
                            // Nếu là người mua hoặc mặc định
                            Response.Redirect("trangchu.aspx");
                        }
                    }
                    else
                    {
                        HienLoi("Tài khoản hoặc mật khẩu không chính xác!");
                    }
                }
            }
            catch (Exception ex)
            {
                HienLoi("Lỗi hệ thống: " + ex.Message);
            }
        }

        private void HienLoi(string msg)
        {
            lblMessage.Text = msg;
            lblMessage.Visible = true;
        }
    }
}