using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class giohang : System.Web.UI.Page
    {
        string strConn = ConfigurationManager.ConnectionStrings["BookStoreDBConnectionString"]?.ConnectionString
                         ?? "Data Source=.;Initial Catalog=BookStoreDB;Integrated Security=True";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGioHang();
            }
        }

        private void LoadGioHang()
        {
            DataTable dt = LayDuLieu("SELECT TOP 1 SoDH FROM DonDatHang WHERE MaKH = 2 AND Dagiao = 0 ORDER BY SoDH DESC");

            if (dt.Rows.Count > 0)
            {
                int currentSoDH = Convert.ToInt32(dt.Rows[0]["SoDH"]);
                ViewState["SoDH"] = currentSoDH; // Lưu lại để dùng cho Update/Delete

                // Query lấy chi tiết giỏ hàng
                string sql = @"SELECT CT.MaSach, S.TenSach, CT.Dongia, CT.Soluong, CT.Thanhtien, 
                               ISNULL(S.AnhBia, 'no-image.jpg') as HinhAnh
                               FROM CTDatHang CT INNER JOIN Sach S ON CT.MaSach = S.MaSach
                               WHERE CT.SoDH = @SoDH";

                SqlParameter[] p = { new SqlParameter("@SoDH", currentSoDH) };
                DataTable dtItems = LayDuLieu(sql, p);

                if (dtItems.Rows.Count > 0)
                {
                    pnlCartContent.Visible = true;
                    pnlEmptyCart.Visible = false;
                    rptCartItems.DataSource = dtItems;
                    rptCartItems.DataBind();

                    // Tính tổng tiền trực tiếp bằng Compute của DataTable để giảm truy vấn SQL
                    decimal tongTien = Convert.ToDecimal(dtItems.Compute("SUM(Thanhtien)", ""));
                    lblTongTien.Text = string.Format("{0:#,##0} VNĐ", tongTien);
                }
                else { HienGioTrong(); }
            }
            else { HienGioTrong(); }
        }

        private void HienGioTrong()
        {
            pnlCartContent.Visible = false;
            pnlEmptyCart.Visible = true;
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int maSach = Convert.ToInt32(e.CommandArgument);
            int soDH = ViewState["SoDH"] != null ? (int)ViewState["SoDH"] : 0;

            if (e.CommandName == "Update")
            {
                TextBox txtQty = (TextBox)e.Item.FindControl("txtQuantity");
                if (int.TryParse(txtQty.Text, out int qty) && qty > 0)
                {
                    ThucThiSQL("UPDATE CTDatHang SET Soluong=@qty, Thanhtien=@qty*Dongia WHERE MaSach=@ms AND SoDH=@sdh",
                        new SqlParameter("@qty", qty), new SqlParameter("@ms", maSach), new SqlParameter("@sdh", soDH));
                }
            }
            else if (e.CommandName == "Delete")
            {
                ThucThiSQL("DELETE FROM CTDatHang WHERE MaSach=@ms AND SoDH=@sdh",
                    new SqlParameter("@ms", maSach), new SqlParameter("@sdh", soDH));
            }
            LoadGioHang();
        }

        protected void btnClearAll_Click(object sender, EventArgs e)
        {
            int soDH = (int)(ViewState["SoDH"] ?? 0);
            ThucThiSQL("DELETE FROM CTDatHang WHERE SoDH=@sdh", new SqlParameter("@sdh", soDH));
            LoadGioHang();
        }

        protected void btnDatHang_Click(object sender, EventArgs e)
        {
            int soDH = (int)(ViewState["SoDH"] ?? 0);
            // Cập nhật trạng thái đơn hàng thành Đã giao (Hoàn tất)
            string sql = @"UPDATE DonDatHang SET Dagiao = 1, Ngaygiao = GETDATE(), 
                           Trigia = (SELECT SUM(Thanhtien) FROM CTDatHang WHERE SoDH = @sdh)
                           WHERE SoDH = @sdh";
            ThucThiSQL(sql, new SqlParameter("@sdh", soDH));

            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đặt hàng thành công!'); window.location='trangchu.aspx';", true);
        }
        private DataTable LayDuLieu(string sql, params SqlParameter[] p)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                if (p != null) cmd.Parameters.AddRange(p);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return dt;
        }

        private void ThucThiSQL(string sql, params SqlParameter[] p)
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddRange(p);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}