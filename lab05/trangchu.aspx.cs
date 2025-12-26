using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace lab05
{
    public partial class trangchu : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
        

        protected void rptSach_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

            if (e.CommandName == "ThemGioHang")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                int maSach = Convert.ToInt32(args[0]);
                decimal donGia = Convert.ToDecimal(args[1]);

                ThemVaoCTDatHang(maSach, donGia);

                string script = "showMessage('Đã thêm sản phẩm vào giỏ hàng!', true);";
                ClientScript.RegisterStartupScript(this.GetType(), "SuccessMessage", script, true);
            }
        }

        private void ThemVaoCTDatHang(int maSach, decimal donGia)
        {
            string connectionString = "Data Source=.;Initial Catalog=BookStoreDB;Integrated Security=True";
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    int soDH = 0;
                    string getSoDHSql = "SELECT TOP 1 SoDH FROM DonDatHang WHERE MaKH = 2 AND Dagiao = 0 ORDER BY SoDH DESC";
                    using (SqlCommand cmdGetID = new SqlCommand(getSoDHSql, conn))
                    {
                        object result = cmdGetID.ExecuteScalar();
                        if (result == null)
                        {
                            string insertOrder = "INSERT INTO DonDatHang (MaKH, NgayDH, Trigia, Dagiao) VALUES (2, GETDATE(), 0, 0); SELECT SCOPE_IDENTITY();";
                            using (SqlCommand cmdInsert = new SqlCommand(insertOrder, conn))
                            {
                                soDH = Convert.ToInt32(cmdInsert.ExecuteScalar());
                            }
                        }
                        else { soDH = Convert.ToInt32(result); }
                    }

                    string sql = @"
                IF NOT EXISTS (SELECT * FROM CTDatHang WHERE MaSach = @MaSach AND SoDH = @SoDH)
                BEGIN
                    INSERT INTO CTDatHang (MaSach, SoDH, Soluong, Dongia, Thanhtien)
                    VALUES (@MaSach, @SoDH, 1, @Dongia, @Dongia)
                END
                ELSE
                BEGIN
                    UPDATE CTDatHang 
                    SET Soluong = Soluong + 1,
                        Thanhtien = (Soluong + 1) * Dongia
                    WHERE MaSach = @MaSach AND SoDH = @SoDH
                END";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaSach", maSach);
                        cmd.Parameters.AddWithValue("@Dongia", donGia);
                        cmd.Parameters.AddWithValue("@SoDH", soDH);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Lỗi: " + ex.Message);
            }
        }

        private void KiemTraDonHang(SqlConnection conn)
        {
            try
            {
                string checkSql = "SELECT COUNT(*) FROM DonDatHang WHERE SoDH = 1";
                using (SqlCommand cmd = new SqlCommand(checkSql, conn))
                {
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    if (count == 0)
                    {
                        string insertSql = @"
                            INSERT INTO DonDatHang (SoDH, MaKH, NgayDH, Trigia, Dagiao, Ngaygiao)
                            VALUES (1, 2, GETDATE(), 0, 0, NULL)";

                        using (SqlCommand cmdInsert = new SqlCommand(insertSql, conn))
                        {
                            cmdInsert.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch
            {
            }
        }
    }
}