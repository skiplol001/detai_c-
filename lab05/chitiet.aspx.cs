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
    public partial class chitiet : System.Web.UI.Page
    {
        // Chuỗi kết nối từ Web.config
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // Xử lý khi nhấn nút Thêm vào giỏ hàng
        protected void btnThemGioHang_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string maSach = btn.CommandArgument;

            // Lấy thông tin sách từ Database
            DataTable dtSach = new DataTable();
            using (SqlConnection con = new SqlConnection(strCon))
            {
                string sql = "SELECT MaSach, TenSach, AnhBia, Dongia FROM Sach WHERE MaSach = @MaSach";
                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.SelectCommand.Parameters.AddWithValue("@MaSach", maSach);
                da.Fill(dtSach);
            }

            if (dtSach.Rows.Count > 0)
            {
                DataRow r = dtSach.Rows[0];

                // Khởi tạo hoặc lấy giỏ hàng từ Session
                DataTable dtCart = new DataTable();
                if (Session["Cart"] == null)
                {
                    dtCart.Columns.Add("MaSach", typeof(int));
                    dtCart.Columns.Add("TenSach", typeof(string));
                    dtCart.Columns.Add("HinhAnh", typeof(string)); // Khớp với Eval("HinhAnh") bên giohang.aspx
                    dtCart.Columns.Add("Dongia", typeof(decimal));
                    dtCart.Columns.Add("Soluong", typeof(int));
                    dtCart.Columns.Add("Thanhtien", typeof(decimal));
                }
                else
                {
                    dtCart = (DataTable)Session["Cart"];
                }

                // Kiểm tra xem đã có sách này trong giỏ chưa
                bool exists = false;
                foreach (DataRow row in dtCart.Rows)
                {
                    if (row["MaSach"].ToString() == maSach)
                    {
                        row["Soluong"] = (int)row["Soluong"] + 1;
                        row["Thanhtien"] = (int)row["Soluong"] * (decimal)row["Dongia"];
                        exists = true;
                        break;
                    }
                }

                if (!exists)
                {
                    DataRow dr = dtCart.NewRow();
                    dr["MaSach"] = r["MaSach"];
                    dr["TenSach"] = r["TenSach"];
                    dr["HinhAnh"] = r["AnhBia"]; // Lấy AnhBia bỏ vào cột HinhAnh
                    dr["Dongia"] = r["Dongia"];
                    dr["Soluong"] = 1;
                    dr["Thanhtien"] = r["Dongia"];
                    dtCart.Rows.Add(dr);
                }

                Session["Cart"] = dtCart;
                Response.Write("<script>alert('Đã thêm vào giỏ hàng!'); window.location='giohang.aspx';</script>");
            }
        }

        // Fix lỗi hiển thị sách liên quan
        protected void SqlDataSourceSachCungChuDe_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.AffectedRows == 0) pnlNoRelated.Visible = true;
            else pnlNoRelated.Visible = false;
        }
    }
}