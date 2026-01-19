using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lab05
{
    public partial class Default : System.Web.UI.MasterPage
    {
        string strCon = ConfigurationManager.ConnectionStrings["BookStoreDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string activePage = Request.Url.AbsolutePath.ToLower();
            if (activePage.Contains("dangnhap.aspx") || activePage.Contains("dangky.aspx"))
            {
                sideBar.Visible = false;
            }

            if (!IsPostBack)
            {
                KiemTraDangNhap();
            }
        }  
        protected void NavTheLoai_Click(object sender, EventArgs e)
        {
            string maLoai = ((LinkButton)sender).CommandArgument;
            Response.Redirect("~/khach/danhsach.aspx?MaLoai=" + maLoai);
        }

        protected void NavChuDe_Click(object sender, EventArgs e)
        {
            string maCD = ((LinkButton)sender).CommandArgument;
            Response.Redirect("~/khach/danhsach.aspx?MaCD=" + maCD);
        }

        protected void Sort_Click(object sender, EventArgs e)
        {
            string sort = ((LinkButton)sender).CommandArgument;
            Response.Redirect(GetMasterFilterUrl("sort", sort));
        }

        protected void PriceRange_Click(object sender, EventArgs e)
        {
            string price = ((LinkButton)sender).CommandArgument;
            Response.Redirect(GetMasterFilterUrl("price", price));
        }

        protected void ClearFilter_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/khach/danhsach.aspx");
        }

        // --- CÁC HÀM CŨ ---
        private void KiemTraDangNhap()
        {
            if (Session["HoTen"] != null)
            {
                phAnonymous.Visible = false; phUser.Visible = true;
                litUserName.Text = Session["HoTen"].ToString();
                if (Session["MaRole"] != null && Session["MaRole"].ToString() == "2") lnkDashboard.Visible = true;
            }
            else { phAnonymous.Visible = true; phUser.Visible = false; lnkDashboard.Visible = false; }
        }

       
        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/khach/danhsach.aspx?search=" + Server.UrlEncode(txtSearch.Text.Trim()));
        }

        protected void BtnApplyPrice_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/khach/danhsach.aspx?min=" + txtMinPrice.Text.Trim() + "&max=" + txtMaxPrice.Text.Trim());
        }

        public string GetMasterFilterUrl(string paramName, string value)
        {
            string url = "/khach/danhsach.aspx?";
            var query = Request.QueryString;
            foreach (string key in query.AllKeys)
            {
                if (key != null && key != paramName && key != "page")
                    url += key + "=" + Server.UrlEncode(query[key]) + "&";
            }
            return url + paramName + "=" + value;
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon(); Response.Redirect("~/khach/trangchu.aspx");
        }
    }
}