using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Configuration;

namespace lab05
{
    public partial class trangchu : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e) { }

        protected void rptSach_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ThemGioHang")
            {
                int maSach = Convert.ToInt32(e.CommandArgument);
                ThemSachVaoSession(maSach);

                // Cập nhật số lượng trên Header của Master Page
                var masterPage = this.Master as Default;
                if (masterPage != null) masterPage.CapNhatSoLuongGioHang();
            }
        }

        private void ThemSachVaoSession(int maSach)
        {
            DataTable dtCart;
            // 1. Lấy hoặc khởi tạo giỏ hàng từ Session
            if (Session["Cart"] == null)
            {
                dtCart = new DataTable();
                dtCart.Columns.Add("MaSach", typeof(int));
                dtCart.Columns.Add("TenSach", typeof(string));
                dtCart.Columns.Add("HinhAnh", typeof(string));
                dtCart.Columns.Add("Dongia", typeof(decimal));
                dtCart.Columns.Add("Soluong", typeof(int));
                dtCart.Columns.Add("Thanhtien", typeof(decimal));
            }
            else { dtCart = (DataTable)Session["Cart"]; }

            // 2. Kiểm tra sách đã có trong giỏ chưa
            bool exists = false;
            foreach (DataRow row in dtCart.Rows)
            {
                if ((int)row["MaSach"] == maSach)
                {
                    row["Soluong"] = (int)row["Soluong"] + 1;
                    row["Thanhtien"] = (int)row["Soluong"] * (decimal)row["Dongia"];
                    exists = true; break;
                }
            }

            // 3. Nếu chưa có, lấy thông tin từ DB và thêm mới
            if (!exists)
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    string sql = "SELECT MaSach, TenSach, AnhBia, Dongia FROM Sach WHERE MaSach = @ID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ID", maSach);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        DataRow newRow = dtCart.NewRow();
                        newRow["MaSach"] = dr["MaSach"];
                        newRow["TenSach"] = dr["TenSach"];
                        newRow["HinhAnh"] = dr["AnhBia"];
                        newRow["Dongia"] = dr["Dongia"];
                        newRow["Soluong"] = 1;
                        newRow["Thanhtien"] = dr["Dongia"];
                        dtCart.Rows.Add(newRow);
                    }
                }
            }
            Session["Cart"] = dtCart;
        }
    }
}