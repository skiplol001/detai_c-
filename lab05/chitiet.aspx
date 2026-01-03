<%@ Page Title="CHI TIẾT SÁCH" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="chitiet.aspx.cs" Inherits="lab05.chitiet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <style>
    .chi-tiet-container { max-width: 1100px; margin: 0 auto; padding: 20px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
    .section-title { color: #ff4081; font-size: 18px; margin: 25px 0 15px 0; padding-bottom: 8px; border-bottom: 2px solid #ff4081; text-transform: uppercase; }
    
    /* Detail chính */
    .book-detail { display: flex; gap: 30px; margin-bottom: 40px; background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
    .book-image-large { width: 220px; height: 310px; object-fit: cover; border-radius: 8px; }
    .book-info { flex: 1; }
    .book-name { color: #333; font-size: 26px; font-weight: bold; }
    .book-price-large { color: #ff4081; font-size: 24px; font-weight: bold; margin: 15px 0; }
    .book-description { line-height: 1.6; color: #555; font-size: 14px; background: #f9f9f9; padding: 15px; border-radius: 8px; border-left: 4px solid #ff4081; }
    .btn-add-cart-large { background: linear-gradient(135deg, #ff4081, #ff80ab); color: white !important; border: none; padding: 12px 30px; border-radius: 25px; font-weight: bold; text-decoration: none; display: inline-block; }

    /* --- PHẦN SÁCH CÙNG CHỦ ĐỀ */
    .related-books-grid { 
        display: grid; 
        grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); 
        gap: 15px; 
    }
    .related-book-item { 
        background: white; 
        border-radius: 8px; 
        border: 1px solid #f0f0f0;
        padding: 5px; /* Tạo khoảng cách cho khung chứa */
        text-align: center;
    }
    .related-book-image { 
        width: 80%;          
        height: 150px;        /* Chiều cao vừa vặn */
        margin: 10px auto;    /* Căn giữa */
        object-fit: contain;  /* Hiện rõ toàn bộ bìa sách */
        display: block;
        transition: 0.3s;
    }
    .related-book-item:hover .related-book-image {
        transform: scale(1.05); /* Hiệu ứng phóng nhẹ ảnh khi di chuột */
    }
    .related-book-name { 
        font-size: 12px; 
        font-weight: bold; 
        color: #333; 
        height: 32px; 
        overflow: hidden; 
        display: -webkit-box; 
        -webkit-line-clamp: 2; 
        -webkit-box-orient: vertical; 
        margin: 5px 0;
        padding: 0 5px;
    }
    .related-book-price { 
        color: #ff4081; 
        font-weight: bold; 
        font-size: 12px; 
        padding-bottom: 5px;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="chi-tiet-container">
        <h2 class="section-title">Thông tin chi tiết</h2>
        <asp:FormView ID="FormViewChiTiet" runat="server" DataSourceID="SqlDataSourceChiTiet" Width="100%">
            <ItemTemplate>
                <div class="book-detail">
                    <div class="book-image-container">
                        <asp:Image ID="imgSach" runat="server" ImageUrl='<%# "~/Images/" + Eval("AnhBia") %>' CssClass="book-image-large" />
                    </div>
                    <div class="book-info">
                        <div class="book-name"><%# Eval("TenSach") %></div>
                        <div class="book-meta" style="font-size: 14px; color: #666;">
                            <div><strong>Chủ đề:</strong> <%# Eval("Tenchude") %></div>
                            <div><strong>Nhà xuất bản:</strong> <%# Eval("TenNXB") %></div>
                        </div>
                        <div class="book-price-large"><%# Eval("Dongia", "{0:#,##0} VNĐ") %></div>
                        <div class="book-description"><%# Eval("Mota") %></div>
                        <asp:LinkButton ID="btnThemGioHang" runat="server" CssClass="btn-add-cart-large" 
                            CommandArgument='<%# Eval("MaSach") %>' OnClick="btnThemGioHang_Click">
                            Thêm vào giỏ hàng
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:FormView>

        <h2 class="section-title">Sách cùng chủ đề</h2>
        <div class="related-books-grid">
            <asp:Repeater ID="rptSachCungChuDe" runat="server" DataSourceID="SqlDataSourceSachCungChuDe">
                <ItemTemplate>
                    <div class="related-book-item">
                        <a href='<%# "chitiet.aspx?MaSach=" + Eval("MaSach") %>'>
                            <img src='<%# "Images/" + Eval("AnhBia") %>' class="related-book-image" />
                        </a>
                        <div class="related-book-info">
                            <div class="related-book-name"><%# Eval("TenSach") %></div>
                            <div class="related-book-price"><%# Eval("Dongia", "{0:#,##0} VNĐ") %></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:Panel ID="pnlNoRelated" runat="server" Visible="false" Style="padding:20px; text-align:center; color:#888;">Không có sách liên quan.</asp:Panel>

        <%-- DataSources --%>
        <asp:SqlDataSource ID="SqlDataSourceChiTiet" runat="server" ConnectionString="<%$ ConnectionStrings:BookStoreDB %>"
            SelectCommand="SELECT S.*, C.Tenchude, N.TenNXB FROM Sach S JOIN ChuDe C ON S.MaCD = C.MaCD JOIN NhaXuatBan N ON S.MaNXB = N.MaNXB WHERE S.MaSach = @MaSach">
            <SelectParameters><asp:QueryStringParameter Name="MaSach" QueryStringField="MaSach" Type="Int32" DefaultValue="1" /></SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSourceSachCungChuDe" runat="server" ConnectionString="<%$ ConnectionStrings:BookStoreDB %>" OnSelected="SqlDataSourceSachCungChuDe_Selected"
            SelectCommand="SELECT TOP 4 * FROM Sach WHERE MaCD = (SELECT MaCD FROM Sach WHERE MaSach = @MaSach) AND MaSach <> @MaSach">
            <SelectParameters><asp:QueryStringParameter Name="MaSach" QueryStringField="MaSach" Type="Int32" /></SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>