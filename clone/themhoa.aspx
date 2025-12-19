<%@ Page Title="Thêm Hoa Mới" Language="C#" MasterPageFile="~/layoutmaster.Master" 
    AutoEventWireup="true" CodeBehind="tracuu.aspx.cs" Inherits="clone.tracuu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style2 { width: 600px; border-collapse: collapse; margin-top: 20px; border: 1px solid #ddd; background: #fafafa; }
        .auto-style2 td { padding: 10px; border-bottom: 1px solid #eee; }
        .auto-style4 { width: 150px; font-weight: bold; text-align: right; }
        .text-input { width: 100%; padding: 6px; box-sizing: border-box; }
        .btn-add { background: #4CAF50; color: white; padding: 10px 30px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .btn-add:hover { background: #45a049; }
        .msg-success { color: green; font-weight: bold; margin-top: 10px; }
        .msg-error { color: red; font-weight: bold; margin-top: 10px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="padding: 30px; text-align: center;">
        <h2 style="color: #333;">THÊM HOA MỚI</h2>
        
        <table align="center" class="auto-style2">
            <tr>
                <td class="auto-style4">Danh mục:</td>
                <td style="text-align: left">
                    <asp:DropDownList ID="ddlLoai" runat="server" CssClass="text-input"
                        DataSourceID="SqlDataSource1" DataTextField="TenLoai" DataValueField="MaLoai">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="auto-style4">Tên Hoa<span style="color:red">*</span>:</td>
                <td style="text-align: left">
                    <%-- Sửa ID thành txtTenHoa cho khớp --%>
                    <asp:TextBox ID="txtTenHoa" runat="server" CssClass="text-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTenHoa" runat="server"
                        ControlToValidate="txtTenHoa" ErrorMessage="Chưa nhập tên hoa"
                        Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style4">Giá bán<span style="color:red">*</span>:</td>
                <td style="text-align: left">
                    <%-- Sửa ID thành txtGia cho khớp --%>
                    <asp:TextBox ID="txtGia" runat="server" CssClass="text-input" TextMode="Number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvGia" runat="server"
                        ControlToValidate="txtGia" ErrorMessage="Chưa nhập giá"
                        Display="Dynamic" ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style4">Ngày cập nhật:</td>
                <td style="text-align: left">
                    <asp:TextBox ID="txtNgay" runat="server" CssClass="text-input" TextMode="Date"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="auto-style4">Hình ảnh:</td>
                <td style="text-align: left">
                    <asp:FileUpload ID="fuhinh" runat="server" />
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; padding: 20px;">
                    <asp:Button ID="btnthem" runat="server" Text="Thêm hoa" CssClass="btn-add" OnClick="btnthem_Click" />
                    <br />
                    <asp:Label ID="lblThongBao" runat="server" Text=""></asp:Label>
                </td>
            </tr>
        </table>

        <%-- DataSource lấy danh mục --%>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:HoaTuoiDB %>" 
            SelectCommand="SELECT * FROM [Loai]">
        </asp:SqlDataSource>

        <%-- DataSource thực hiện Insert (Đảm bảo ControlID khớp với TextBox ở trên) --%>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
            ConnectionString="<%$ ConnectionStrings:HoaTuoiDB %>" 
            InsertCommand="INSERT INTO [Hoa] ([TenHoa], [Gia], [Hinh], [MaLoai], [NgayDang], [SoLuotXem]) VALUES (@TenHoa, @Gia, @Hinh, @MaLoai, @NgayDang, @SoLuotXem)">
            <InsertParameters>
                <asp:ControlParameter ControlID="txtTenHoa" Name="TenHoa" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtGia" Name="Gia" PropertyName="Text" Type="Double" />
                <asp:Parameter Name="Hinh" Type="String" />
                <asp:ControlParameter ControlID="ddlLoai" Name="MaLoai" PropertyName="SelectedValue" Type="Int32" />
                <asp:ControlParameter ControlID="txtNgay" Name="NgayDang" PropertyName="Text" Type="DateTime" />
                <asp:Parameter Name="SoLuotXem" Type="Int32" DefaultValue="0" />
            </InsertParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>