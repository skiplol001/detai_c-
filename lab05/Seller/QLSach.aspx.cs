using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05.Seller
{
    public partial class QLSach : System.Web.UI.Page
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MaRole"] == null || Convert.ToInt32(Session["MaRole"]) != 2)
            {
                Response.Redirect("~/khach/dangnhap.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSach();
            }
        }

        private void LoadSach()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strCon))
                {
                    string sql = "SELECT * FROM Sach ORDER BY Ngaycapnhat DESC";
                    SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvSach.DataSource = dt;
                    gvSach.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Lỗi tải danh sách: " + ex.Message + "');</script>");
            }
        }

        protected void gvSach_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Lấy ID sách từ DataKeys
            int maSach = Convert.ToInt32(gvSach.DataKeys[e.RowIndex].Value);


            using (SqlConnection conn = new SqlConnection(strCon))
            {
                string sql = "DELETE FROM Sach WHERE MaSach = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", maSach);

                conn.Open();
                int result = cmd.ExecuteNonQuery();

                if (result > 0)
                {
                    LoadSach();
                    // Dùng ScriptManager để hiện thông báo thay vì Response.Write nếu dùng UpdatePanel sau này
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Xóa thành công!');", true);
                }
            }
        }

    }
}