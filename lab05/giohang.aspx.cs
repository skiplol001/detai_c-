using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class giohang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCart();
            }
        }

        private void LoadCart()
        {
            DataTable dt = (DataTable)Session["Cart"];
            if (dt != null && dt.Rows.Count > 0)
            {
                pnlCartContent.Visible = true;
                pnlEmptyCart.Visible = false;
                rptCartItems.DataSource = dt;
                rptCartItems.DataBind();

                decimal total = 0;
                foreach (DataRow r in dt.Rows) total += (decimal)r["Thanhtien"];
                lblTongTien.Text = string.Format("{0:#,##0} VNĐ", total);
            }
            else
            {
                pnlCartContent.Visible = false;
                pnlEmptyCart.Visible = true;
            }
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            DataTable dt = (DataTable)Session["Cart"];
            string maSach = e.CommandArgument.ToString();

            if (e.CommandName == "Update")
            {
                TextBox txt = (TextBox)e.Item.FindControl("txtQuantity");
                int slMoi = int.Parse(txt.Text);

                foreach (DataRow r in dt.Rows)
                {
                    if (r["MaSach"].ToString() == maSach)
                    {
                        r["Soluong"] = slMoi;
                        r["Thanhtien"] = slMoi * (decimal)r["Dongia"];
                        break;
                    }
                }
            }
            else if (e.CommandName == "Delete")
            {
                for (int i = dt.Rows.Count - 1; i >= 0; i--)
                {
                    if (dt.Rows[i]["MaSach"].ToString() == maSach) dt.Rows.RemoveAt(i);
                }
            }

            Session["Cart"] = dt;
            LoadCart();
        }

        // Xử lý nút Xóa hết (Hàm btnClear_Click khớp với OnClick trong ASPX)
        protected void btnClear_Click(object sender, EventArgs e)
        {
            Session["Cart"] = null;
            LoadCart();
        }

        // Xử lý nút Đặt hàng
        protected void btnOrder_Click(object sender, EventArgs e)
        {
            if (Session["Cart"] != null)
            {
                // Chuyển hướng sang trang thanh toán hoặc lưu DB
                Response.Redirect("thanhtoan.aspx");
            }
        }
    }
}