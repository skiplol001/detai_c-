using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace lab05
{
    public partial class dangky : System.Web.UI.Page
    {
        // Lấy chuỗi kết nối từ Web.config
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnthem_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(strCon))
                    {
                        conn.Open();

                        // 1. Kiểm tra tên đăng nhập đã tồn tại chưa
                        string checkSql = "SELECT COUNT(*) FROM KhachHang WHERE TenDN = @user";
                        SqlCommand cmdCheck = new SqlCommand(checkSql, conn);
                        cmdCheck.Parameters.AddWithValue("@user", txtTendangnhap.Text.Trim());
                        int count = (int)cmdCheck.ExecuteScalar();

                        if (count > 0)
                        {
                            lblThongBao.Text = "Tên đăng nhập đã tồn tại!";
                            lblThongBao.ForeColor = System.Drawing.Color.Red;
                            return;
                        }

                        // 2. Xác định MaRole (1: Người mua, 2: Người bán)
                        int maRole = chkBanHang.Checked ? 2 : 1;

                        // 3. Tiến hành INSERT thêm cột MaRole
                        string sql = @"INSERT INTO KhachHang (HoTenKH, Diachi, Dienthoai, TenDN, Matkhau, Ngaysinh, Email, MaRole) 
                                      VALUES (@hoten, @diachi, @sdt, @tendn, @mk, @ngaysinh, @email, @marole)";

                        SqlCommand cmd = new SqlCommand(sql, conn);
                        cmd.Parameters.AddWithValue("@hoten", txtHoTen.Text.Trim());
                        cmd.Parameters.AddWithValue("@diachi", txtDiachi.Text.Trim());
                        cmd.Parameters.AddWithValue("@sdt", txtSDT.Text.Trim());
                        cmd.Parameters.AddWithValue("@tendn", txtTendangnhap.Text.Trim());
                        cmd.Parameters.AddWithValue("@mk", txtMatkhau.Text);
                        cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@marole", maRole);

                        // Xử lý ngày sinh nếu để trống
                        if (string.IsNullOrEmpty(txtNgay.Text))
                            cmd.Parameters.AddWithValue("@ngaysinh", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@ngaysinh", txtNgay.Text);

                        int result = cmd.ExecuteNonQuery();
                        if (result > 0)
                        {
                            lblThongBao.Text = "Đăng ký thành công! Đang chuyển hướng...";
                            lblThongBao.ForeColor = System.Drawing.Color.Green;

                            // Chuyển hướng sau 2 giây
                            string script = "setTimeout(function(){ window.location='dangnhap.aspx'; }, 2000);";
                            ClientScript.RegisterStartupScript(this.GetType(), "Redirect", script, true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblThongBao.Text = "Lỗi hệ thống: " + ex.Message;
                    lblThongBao.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}