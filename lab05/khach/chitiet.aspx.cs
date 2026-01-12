using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class chitiet : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kiểm tra trạng thái đăng nhập để hiện form bình luận
                if (Session["MaKH"] == null)
                {
                    pnlCommentForm.Visible = false;
                    pnlLoginReq.Visible = true;
                }
                else
                {
                    pnlCommentForm.Visible = true;
                    pnlLoginReq.Visible = false;
                }
            }
        }

        // 1. Hàm vẽ sao đánh giá
        public string RenderStars(object stars)
        {
            int count = Convert.ToInt32(stars);
            string result = "";
            for (int i = 1; i <= 5; i++)
            {
                result += (i <= count) ? "★" : "☆";
            }
            return result;
        }

        // 2. Xử lý gửi Bình luận
        protected void btnGuiBL_Click(object sender, EventArgs e)
        {
            if (Session["MaKH"] == null) return;

            string maSach = Request.QueryString["MaSach"];
            string maKH = Session["MaKH"].ToString();
            string noiDung = txtNoiDungBL.Text.Trim();
            int danhGia = int.Parse(ddlStars.SelectedValue);

            if (string.IsNullOrEmpty(noiDung))
            {
                lblMsg.Text = "Bạn chưa nhập nội dung bình luận!";
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(strCon))
                {
                    string sql = "INSERT INTO Comment(MaSach, MaKH, NoiDung, DanhGia, NgayBL) " +
                                 "VALUES (@MaSach, @MaKH, @NoiDung, @DanhGia, GETDATE())";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@MaSach", maSach);
                    cmd.Parameters.AddWithValue("@MaKH", maKH);
                    cmd.Parameters.AddWithValue("@NoiDung", noiDung);
                    cmd.Parameters.AddWithValue("@DanhGia", danhGia);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // Reset form và load lại danh sách bình luận
                txtNoiDungBL.Text = "";
                lblMsg.Text = "Gửi bình luận thành công!";
                lblMsg.ForeColor = System.Drawing.Color.Green;
                rptComments.DataBind();
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Lỗi: " + ex.Message;
            }
        }

        // 3. Xử lý thêm vào Giỏ hàng (Session DataTable)
        protected void btnThemGioHang_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string maSach = btn.CommandArgument;

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
                DataTable dtCart = (Session["Cart"] == null) ? CreateCartTable() : (DataTable)Session["Cart"];

                bool exists = false;
                foreach (DataRow row in dtCart.Rows)
                {
                    if (row["MaSach"].ToString() == maSach)
                    {
                        row["Soluong"] = (int)row["Soluong"] + 1;
                        row["Thanhtien"] = (int)row["Soluong"] * (decimal)row["Dongia"];
                        exists = true; break;
                    }
                }

                if (!exists)
                {
                    DataRow dr = dtCart.NewRow();
                    dr["MaSach"] = r["MaSach"];
                    dr["TenSach"] = r["TenSach"];
                    dr["HinhAnh"] = r["AnhBia"];
                    dr["Dongia"] = r["Dongia"];
                    dr["Soluong"] = 1;
                    dr["Thanhtien"] = r["Dongia"];
                    dtCart.Rows.Add(dr);
                }

                Session["Cart"] = dtCart;
                Response.Write("<script>alert('Đã thêm vào giỏ hàng!');</script>");
            }
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

        protected void SqlDataSourceSachCungChuDe_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            pnlNoRelated.Visible = (e.AffectedRows == 0);
        }
    }
}