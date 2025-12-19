using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace clone
{
    public partial class tracuu : System.Web.UI.Page
    {
        protected void btnthem_Click(object sender, EventArgs e)
        {
            try
            {
                if (fuhinh.HasFile)
                {
                    // 1. Lưu file ảnh vật lý
                    string tenFile = fuhinh.FileName;
                    string path = Server.MapPath("~/Images/") + tenFile;
                    fuhinh.SaveAs(path);

                    // 2. Gán tên file cho tham số @Hinh trong SqlDataSource
                    SqlDataSource2.InsertParameters["Hinh"].DefaultValue = tenFile;

                    // 3. Thực thi Insert
                    SqlDataSource2.Insert();

                    lblThongBao.Text = "Thêm hoa thành công!";
                    lblThongBao.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblThongBao.Text = "Bạn chưa chọn ảnh!";
                    lblThongBao.ForeColor = System.Drawing.Color.Red;
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi: " + ex.Message;
                lblThongBao.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}