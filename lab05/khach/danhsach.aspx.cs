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
        // Sử dụng chuỗi kết nối từ Web.config
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
            if (!string.IsNullOrEmpty(maCD))
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    string sql = "SELECT Tenchude FROM ChuDe WHERE MaCD = @ID";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@ID", maCD);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null) TenChuDeHienTai = result.ToString();
                }
            }
        }

        private void LoadBooks()
        {
            string maCD = Request.QueryString["MaCD"];
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

                // 3. Thực thi lấy dữ liệu (OFFSET FETCH yêu cầu SQL 2012+)
                string sqlData = $@"SELECT * FROM Sach {whereClause} ORDER BY {orderSql} 
                                   OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                SqlCommand cmdData = new SqlCommand(sqlData, conn);

                // Add Parameters cho cmdData
                if (!string.IsNullOrEmpty(maCD)) cmdData.Parameters.AddWithValue("@MaCD", maCD);
                if (!string.IsNullOrEmpty(search)) cmdData.Parameters.AddWithValue("@Search", "%" + search + "%");
                if (string.IsNullOrEmpty(price))
                {
                    if (!string.IsNullOrEmpty(min)) cmdData.Parameters.AddWithValue("@Min", min);
                    if (!string.IsNullOrEmpty(max)) cmdData.Parameters.AddWithValue("@Max", max);
                }
                cmdData.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * pageSize);
                cmdData.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmdData);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptSach.DataSource = dt;
                rptSach.DataBind();

                // 4. Lệnh đếm tổng để phân trang (Dùng SqlCommand riêng để tránh lỗi reuse Parameter)
                SqlCommand cmdCount = new SqlCommand($"SELECT COUNT(*) FROM Sach {whereClause}", conn);
                if (!string.IsNullOrEmpty(maCD)) cmdCount.Parameters.AddWithValue("@MaCD", maCD);
                if (!string.IsNullOrEmpty(search)) cmdCount.Parameters.AddWithValue("@Search", "%" + search + "%");
                if (string.IsNullOrEmpty(price))
                {
                    if (!string.IsNullOrEmpty(min)) cmdCount.Parameters.AddWithValue("@Min", min);
                    if (!string.IsNullOrEmpty(max)) cmdCount.Parameters.AddWithValue("@Max", max);
                }

                conn.Open();
                int totalRows = (int)cmdCount.ExecuteScalar();
                conn.Close();

                int totalPages = (int)Math.Ceiling((double)totalRows / pageSize);
                BindPagination(totalPages);
            }
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
            DataTable dtCart;
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
            if (Request.QueryString.AllKeys.Length > 0)
            {
                foreach (string key in Request.QueryString.AllKeys)
                {
                    if (key != null && key != "page")
                        url += key + "=" + Server.UrlEncode(Request.QueryString[key]) + "&";
                }
            }
            return url + "page=" + pageNum;
        }
    }
}