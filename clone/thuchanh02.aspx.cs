using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace clone
{
    public partial class thuchanh02 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlLoai.Items.Add("Bánh Croissant bơ");
                ddlLoai.Items.Add("Bánh bò nướng");
                ddlLoai.Items.Add("Patés chauds");
                ddlLoai.Items.Add("Hamburger");
                ddlLoai.SelectedIndex = 0;
            }
        }

        protected void btnThem_Click(object sender, EventArgs e)
        {
            string tenBanh = ddlLoai.SelectedItem.Text;
            int soLuong;

            if (int.TryParse(txtSL.Text, out soLuong) && soLuong > 0)
            {
                string itemText = $"{tenBanh} ({soLuong} cái)";

                lbDS.Items.Add(itemText);

                txtSL.Text = "";
            }

        }

        protected void btnXoa_Click(object sender, EventArgs e)
        {
            if (lbDS.SelectedIndex >= 0)
            {
                lbDS.Items.RemoveAt(lbDS.SelectedIndex);
            }

        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            lblTenKH.Text = txtTenKH.Text;
            lblDiaChi.Text = txtDiachi.Text;
            lblMST.Text = txtMST.Text;


            lbDSBanh.Items.Clear();

            foreach (ListItem item in lbDS.Items)
            {
                lbDSBanh.Items.Add(new ListItem(item.Text, item.Value));
            }
            pnlHoaDon.Visible = true;

        }
    }
}