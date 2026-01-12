using System;

namespace lab05.Admin // Kiểm tra namespace này phải khớp với Inherits trong file .Master
{
    public partial class Seller : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["HoTen"] != null)
                {
                    litSellerName.Text = Session["HoTen"].ToString();
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            // Quay về trang đăng nhập nằm trong folder khach
            Response.Redirect("~/khach/dangnhap.aspx");
        }
    }
}