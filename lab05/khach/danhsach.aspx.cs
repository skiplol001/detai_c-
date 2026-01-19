using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class danhsach : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;
        int pageSize = 6;
        protected string TenChuDeHienTai = "";

        public int CurrentPage
        {
            get
            {
                int p;
                return (int.TryParse(Request.QueryString["page"], out p)) ? p : 1;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTenChuDe();
                LoadBooks();
            }
        }

        private void LoadTenChuDe()
        {
            string maCD = Request.QueryString["MaCD"];
            string maLoai = Request.QueryString["MaLoai"];

            using (SqlConnection con = new SqlConnection(strCon))
            {
                con.Open();
                if (!string.IsNullOrEmpty(maCD))
                {
                    string sql = "SELECT Tenchude FROM ChuDe WHERE MaCD = @ID";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@ID", maCD);
                    TenChuDeHienTai = cmd.ExecuteScalar()?.ToString();
                }
                else if (!string.IsNullOrEmpty(maLoai))
                {
                    string sql = "SELECT TenLoai FROM PhanLoai WHERE MaLoai = @ID";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@ID", maLoai);
                    TenChuDeHienTai = "THỂ LOẠI: " + cmd.ExecuteScalar()?.ToString();
                }
            }
        }

        private void LoadBooks()
        {
            string maCD = Request.QueryString["MaCD"];
            string maLoai = Request.QueryString["MaLoai"];
            string search = Request.QueryString["search"];
            string sort = Request.QueryString["sort"];
            string price = Request.QueryString["price"];
            string min = Request.QueryString["min"];
            string max = Request.QueryString["max"];

            // Thiết lập tiêu đề hiển thị
            if (!string.IsNullOrEmpty(search)) hTitle.InnerText = "KẾT QUẢ: " + search.ToUpper();
            else if (!string.IsNullOrEmpty(TenChuDeHienTai)) hTitle.InnerText = TenChuDeHienTai.ToUpper();
            else hTitle.InnerText = "TẤT CẢ SÁCH";

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                // 1. Xây dựng WHERE clause động
                string whereClause = " WHERE 1=1";
                if (!string.IsNullOrEmpty(maCD)) whereClause += " AND MaCD = @MaCD";

                // FIX: Lọc theo MaLoai (Lấy tất cả MaCD thuộc MaLoai này)
                if (!string.IsNullOrEmpty(maLoai))
                    whereClause += " AND MaCD IN (SELECT MaCD FROM ChuDe WHERE MaLoai = @MaLoai)";

                if (!string.IsNullOrEmpty(search)) whereClause += " AND TenSach LIKE @Search";

                if (!string.IsNullOrEmpty(price))
                {
                    if (price == "0-50") whereClause += " AND Dongia < 50000";
                    else if (price == "50-200") whereClause += " AND Dongia BETWEEN 50000 AND 200000";
                    else if (price == "200-above") whereClause += " AND Dongia > 200000";
                }
                else
                {
                    if (!string.IsNullOrEmpty(min)) whereClause += " AND Dongia >= @Min";
                    if (!string.IsNullOrEmpty(max)) whereClause += " AND Dongia <= @Max";
                }

                // 2. Sắp xếp
                string orderSql = "TenSach ASC";
                if (sort == "date_desc") orderSql = "Ngaycapnhat DESC";
                else if (sort == "price_asc") orderSql = "Dongia ASC";

                // 3. Lấy dữ liệu phân trang
                string sqlData = $@"SELECT * FROM Sach {whereClause} ORDER BY {orderSql} 
                                   OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                SqlCommand cmdData = new SqlCommand(sqlData, conn);
                AddParameters(cmdData, maCD, maLoai, search, min, max);
                cmdData.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * pageSize);
                cmdData.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmdData);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // 4. Đếm tổng số dòng (để hiện Panel Empty và Phân trang)
                SqlCommand cmdCount = new SqlCommand($"SELECT COUNT(*) FROM Sach {whereClause}", conn);
                AddParameters(cmdCount, maCD, maLoai, search, min, max);

                conn.Open();
                int totalRows = (int)cmdCount.ExecuteScalar();
                conn.Close();

                // Xử lý hiển thị
                if (totalRows == 0)
                {
                    rptSach.Visible = false;
                    pnlEmpty.Visible = true;
                }
                else
                {
                    rptSach.Visible = true;
                    pnlEmpty.Visible = false;
                    rptSach.DataSource = dt;
                    rptSach.DataBind();
                }

                int totalPages = (int)Math.Ceiling((double)totalRows / pageSize);
                BindPagination(totalPages);
            }
        }

        // Hàm phụ để tránh lặp code khi thêm tham số SQL
        private void AddParameters(SqlCommand cmd, string maCD, string maLoai, string search, string min, string max)
        {
            if (!string.IsNullOrEmpty(maCD)) cmd.Parameters.AddWithValue("@MaCD", maCD);
            if (!string.IsNullOrEmpty(maLoai)) cmd.Parameters.AddWithValue("@MaLoai", maLoai);
            if (!string.IsNullOrEmpty(search)) cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
            if (!string.IsNullOrEmpty(min)) cmd.Parameters.AddWithValue("@Min", min);
            if (!string.IsNullOrEmpty(max)) cmd.Parameters.AddWithValue("@Max", max);
        }

        protected void rptSach_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ThemGioHang")
            {
                int maSach = Convert.ToInt32(e.CommandArgument);
                ThemSachVaoSession(maSach);
            }
        }

        private void ThemSachVaoSession(int maSach)
        {
            DataTable dtCart = (Session["Cart"] == null) ? CreateCartTable() : (DataTable)Session["Cart"];

            bool exists = false;
            foreach (DataRow row in dtCart.Rows)
            {
                if (Convert.ToInt32(row["MaSach"]) == maSach)
                {
                    row["Soluong"] = (int)row["Soluong"] + 1;
                    row["Thanhtien"] = (int)row["Soluong"] * (decimal)row["Dongia"];
                    exists = true; break;
                }
            }

            if (!exists)
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    SqlCommand cmd = new SqlCommand("SELECT MaSach, TenSach, AnhBia, Dongia FROM Sach WHERE MaSach=@ID", conn);
                    cmd.Parameters.AddWithValue("@ID", maSach);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            DataRow nr = dtCart.NewRow();
                            nr["MaSach"] = dr["MaSach"];
                            nr["TenSach"] = dr["TenSach"];
                            nr["HinhAnh"] = dr["AnhBia"];
                            nr["Dongia"] = dr["Dongia"];
                            nr["Soluong"] = 1;
                            nr["Thanhtien"] = dr["Dongia"];
                            dtCart.Rows.Add(nr);
                        }
                    }
                }
            }
            Session["Cart"] = dtCart;
        }

        private DataTable CreateCartTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("MaSach", typeof(int));
            dt.Columns.Add("TenSach", typeof(string));
            dt.Columns.Add("HinhAnh", typeof(string));
            dt.Columns.Add("Dongia", typeof(decimal));
            dt.Columns.Add("Soluong", typeof(int));
            dt.Columns.Add("Thanhtien", typeof(decimal));
            return dt;
        }

        private void BindPagination(int totalPages)
        {
            if (totalPages <= 0) totalPages = 1;
            List<int> pages = new List<int>();
            for (int i = 1; i <= totalPages; i++) pages.Add(i);
            rptPagination.DataSource = pages;
            rptPagination.DataBind();

            lnkPrev.NavigateUrl = GetPageUrl(CurrentPage - 1);
            lnkPrev.CssClass = (CurrentPage <= 1) ? "page-node disabled" : "page-node";
            lnkNext.NavigateUrl = GetPageUrl(CurrentPage + 1);
            lnkNext.CssClass = (CurrentPage >= totalPages) ? "page-node disabled" : "page-node";
        }

        protected string GetPageUrl(object pageNum)
        {
            string url = Request.Path + "?";
            foreach (string key in Request.QueryString.AllKeys)
            {
                if (key != null && key != "page")
                    url += key + "=" + Server.UrlEncode(Request.QueryString[key]) + "&";
            }
            return url + "page=" + pageNum;
        }
    }
}