using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class danhsach : System.Web.UI.Page
    {
        string strCon = "Data Source=.;Initial Catalog=BookStoreDB;Integrated Security=True";
        int pageSize = 6;

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
                LoadBooks();
            }
        }

        private void LoadBooks()
        {
            string maCD = Request.QueryString["MaCD"];
            string search = Request.QueryString["search"];

            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string whereClause = " WHERE 1=1";
                if (!string.IsNullOrEmpty(maCD)) whereClause += " AND MaCD = @MaCD";
                if (!string.IsNullOrEmpty(search)) whereClause += " AND TenSach LIKE @Search";

                // Lấy dữ liệu với OFFSET FETCH (SQL 2012+)
                string sqlData = $@"
                    SELECT * FROM Sach {whereClause}
                    ORDER BY TenSach 
                    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

                string sqlCount = $"SELECT COUNT(*) FROM Sach {whereClause}";

                SqlCommand cmdData = new SqlCommand(sqlData, conn);
                SqlCommand cmdCount = new SqlCommand(sqlCount, conn);

                if (!string.IsNullOrEmpty(maCD))
                {
                    cmdData.Parameters.AddWithValue("@MaCD", maCD);
                    cmdCount.Parameters.AddWithValue("@MaCD", maCD);
                }
                if (!string.IsNullOrEmpty(search))
                {
                    cmdData.Parameters.AddWithValue("@Search", "%" + search + "%");
                    cmdCount.Parameters.AddWithValue("@Search", "%" + search + "%");
                    hTitle.InnerText = "Kết quả tìm kiếm cho: " + search;
                }

                cmdData.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * pageSize);
                cmdData.Parameters.AddWithValue("@PageSize", pageSize);

                SqlDataAdapter da = new SqlDataAdapter(cmdData);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptSach.DataSource = dt;
                rptSach.DataBind();

                conn.Open();
                int totalRows = (int)cmdCount.ExecuteScalar();
                int totalPages = (int)Math.Ceiling((double)totalRows / pageSize);
                conn.Close();

                BindPagination(totalPages);
            }
        }

        private void BindPagination(int totalPages)
        {
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
            if (!string.IsNullOrEmpty(Request.QueryString["MaCD"]))
                url += "MaCD=" + Request.QueryString["MaCD"] + "&";
            if (!string.IsNullOrEmpty(Request.QueryString["search"]))
                url += "search=" + Request.QueryString["search"] + "&";

            return url + "page=" + pageNum.ToString();
        }
    }
}