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
        .book-description { line-height: 1.6; color: #555; font-size: 14px; background: #f9f9f9; padding: 15px; border-radius: 8px; border-left: 4px solid #ff4081; margin-bottom: 20px; }
        .btn-add-cart-large { background: linear-gradient(135deg, #ff4081, #ff80ab); color: white !important; border: none; padding: 12px 30px; border-radius: 25px; font-weight: bold; text-decoration: none; display: inline-block; cursor: pointer; }

        /* Sách cùng chủ đề */
        .related-books-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 20px; }
        .related-book-item { background: white; border-radius: 8px; border: 1px solid #f0f0f0; padding: 10px; text-align: center; transition: 0.3s; }
        .related-book-item:hover { box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .related-book-image { width: 100%; height: 180px; object-fit: contain; margin-bottom: 10px; }
        .related-book-name { font-size: 13px; font-weight: bold; height: 38px; overflow: hidden; color: #333; }

        /* Bình luận & Đánh giá */
        .comment-section { background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 15px rgba(0,0,0,0.05); }
        .comment-form { margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px dashed #ddd; }
        .ddl-stars { padding: 8px; border-radius: 5px; border: 1px solid #ddd; margin: 10px 0; width: 200px; }
        .txt-comment { width: 100%; border: 1px solid #ddd; border-radius: 8px; padding: 12px; font-family: inherit; box-sizing: border-box; }
        .btn-gui-bl { background: #333; color: white; border: none; padding: 10px 25px; border-radius: 5px; cursor: pointer; margin-top: 10px; }
        .btn-gui-bl:hover { background: #ff4081; }
        
        .comment-item { padding: 15px 0; border-bottom: 1px solid #eee; }
        .user-name { font-weight: bold; color: #333; }
        .comment-date { font-size: 11px; color: #999; margin-left: 10px; }
        .comment-stars { color: #ffc107; font-size: 16px; margin: 5px 0; }
        .login-req { background: #fff3f8; padding: 15px; border-radius: 8px; text-align: center; color: #ff4081; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="chi-tiet-container">
        
        <%-- 1. THÔNG TIN CHI TIẾT SÁCH --%>
        <h2 class="section-title">Thông tin chi tiết</h2>
        <asp:FormView ID="FormViewChiTiet" runat="server" DataSourceID="SqlDataSourceChiTiet" Width="100%">
            <ItemTemplate>
                <div class="book-detail">
                    <asp:Image ID="imgSach" runat="server" ImageUrl='<%# "~/Images/" + Eval("AnhBia") %>' CssClass="book-image-large" />
                    <div class="book-info">
                        <div class="book-name"><%# Eval("TenSach") %></div>
                        <div style="margin: 10px 0; color: #666; font-size: 14px;">
                            <strong>Chủ đề:</strong> <%# Eval("Tenchude") %> | 
                            <strong>NXB:</strong> <%# Eval("TenNXB") %>
                        </div>
                        <div class="book-price-large"><%# Eval("Dongia", "{0:#,##0} VNĐ") %></div>
                        <div class="book-description"><%# Eval("Mota") %></div>
                        <asp:LinkButton ID="btnThemGioHang" runat="server" CssClass="btn-add-cart-large" 
                            CommandArgument='<%# Eval("MaSach") %>' OnClick="btnThemGioHang_Click">
                            <i class="fa fa-shopping-cart"></i> Thêm vào giỏ hàng
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:FormView>

        <%-- 2. SÁCH CÙNG CHỦ ĐỀ --%>
        <h2 class="section-title">Sách cùng chủ đề</h2>
        <div class="related-books-grid">
            <asp:Repeater ID="rptSachCungChuDe" runat="server" DataSourceID="SqlDataSourceSachCungChuDe">
                <ItemTemplate>
                    <div class="related-book-item">
                        <a href='<%# "chitiet.aspx?MaSach=" + Eval("MaSach") %>'>
                            <img src='<%# "/Images/" + Eval("AnhBia") %>' class="related-book-image" />
                        </a>
                        <div class="related-book-name"><%# Eval("TenSach") %></div>
                        <div style="color:#ff4081; font-weight:bold;"><%# Eval("Dongia", "{0:#,##0} đ") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:Panel ID="pnlNoRelated" runat="server" Visible="false" Style="padding:20px; text-align:center;">
            Không có sách liên quan cùng chủ đề.
        </asp:Panel>

        <%-- 3. BÌNH LUẬN VÀ ĐÁNH GIÁ --%>
        <h2 class="section-title">Đánh giá từ khách hàng</h2>
        <div class="comment-section">
            <asp:Panel ID="pnlCommentForm" runat="server" CssClass="comment-form">
                <div class="rating-input">
                    <label>Đánh giá của bạn:</label><br />
                    <asp:DropDownList ID="ddlStars" runat="server" CssClass="ddl-stars">
                        <asp:ListItem Value="5">★★★★★ (Tuyệt vời)</asp:ListItem>
                        <asp:ListItem Value="4">★★★★ (Rất tốt)</asp:ListItem>
                        <asp:ListItem Value="3">★★★ (Bình thường)</asp:ListItem>
                        <asp:ListItem Value="2">★★ (Tạm được)</asp:ListItem>
                        <asp:ListItem Value="1">★ (Kém)</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <asp:TextBox ID="txtNoiDungBL" runat="server" TextMode="MultiLine" Rows="3" 
                    placeholder="Viết nhận xét của bạn về sách..." CssClass="txt-comment"></asp:TextBox>
                <div style="text-align: right;">
                    <asp:Button ID="btnGuiBL" runat="server" Text="Gửi đánh giá" CssClass="btn-gui-bl" OnClick="btnGuiBL_Click" />
                </div>
                <asp:Label ID="lblMsg" runat="server" ForeColor="Red" font-size="12px"></asp:Label>
            </asp:Panel>

            <asp:Panel ID="pnlLoginReq" runat="server" Visible="false" CssClass="login-req">
                Bạn cần <a href="DangNhap.aspx">đăng nhập</a> để gửi bình luận.
            </asp:Panel>

            <div class="comment-list">
                <asp:Repeater ID="rptComments" runat="server" DataSourceID="SqlDataSourceComments">
                    <ItemTemplate>
                        <div class="comment-item">
                            <div class="user-name">
                                <%# Eval("HoTenKH") %> 
                                <span class="comment-date"><%# Eval("NgayBL", "{0:dd/MM/yyyy HH:mm}") %></span>
                            </div>
                            <div class="comment-stars"><%# RenderStars(Eval("DanhGia")) %></div>
                            <div class="comment-content"><%# Eval("NoiDung") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <%-- DATASOURCES --%>
        <asp:SqlDataSource ID="SqlDataSourceChiTiet" runat="server" ConnectionString="<%$ ConnectionStrings:BookStoreDB %>"
            SelectCommand="SELECT S.*, C.Tenchude, N.TenNXB FROM Sach S JOIN ChuDe C ON S.MaCD = C.MaCD JOIN NhaXuatBan N ON S.MaNXB = N.MaNXB WHERE S.MaSach = @MaSach">
            <SelectParameters><asp:QueryStringParameter Name="MaSach" QueryStringField="MaSach" Type="Int32" DefaultValue="1" /></SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSourceSachCungChuDe" runat="server" ConnectionString="<%$ ConnectionStrings:BookStoreDB %>" OnSelected="SqlDataSourceSachCungChuDe_Selected"
            SelectCommand="SELECT TOP 4 * FROM Sach WHERE MaCD = (SELECT MaCD FROM Sach WHERE MaSach = @MaSach) AND MaSach <> @MaSach">
            <SelectParameters><asp:QueryStringParameter Name="MaSach" QueryStringField="MaSach" Type="Int32" /></SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSourceComments" runat="server" ConnectionString="<%$ ConnectionStrings:BookStoreDB %>"
            SelectCommand="SELECT C.*, K.HoTenKH FROM Comment C JOIN KhachHang K ON C.MaKH = K.MaKH WHERE C.MaSach = @MaSach ORDER BY C.NgayBL DESC">
            <SelectParameters><asp:QueryStringParameter Name="MaSach" QueryStringField="MaSach" Type="Int32" /></SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>