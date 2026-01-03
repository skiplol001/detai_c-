<%@ Page Title="Danh mục sách" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="danhsach.aspx.cs" Inherits="lab05.danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <style>
    /* --- Layout chung --- */
    .books-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 20px;
        margin-top: 20px;
    }

    .book-item {
        background: #fff;
        border-radius: 12px;
        padding: 15px;
        text-align: center;
        border: 1px solid #f1f5f9;
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .book-item:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
        border-color: var(--primary-color);
    }

    /* --- Image --- */
    .book-image {
        width: auto;
        max-width: 100%;
        height: 150px;
        object-fit: contain;
        margin: 0 auto 12px auto;
        display: block;
        border-radius: 4px;
    }

    .book-name {
        font-weight: 700;
        color: var(--text-main);
        height: 40px;
        overflow: hidden;
        margin-bottom: 10px;
        font-size: 0.9rem;
        line-height: 1.2;
    }

    .book-price {
        color: var(--primary-color);
        font-weight: 800;
        font-size: 1rem;
        margin-bottom: 15px;
    }

    /* --- Nút bấm (Buttons) --- */
    .button-container {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 8px;
    }

    .btn-ui {
        padding: 8px;
        border-radius: 6px;
        font-weight: 600;
        text-decoration: none;
        font-size: 0.75rem;
        border: 1px solid transparent;
        cursor: pointer;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); /* Hiệu ứng chuyển động mượt */
    }

    /* NÚT THÊM GIỎ HÀNG (Màu hồng) */
    .btn-add { 
        background: var(--primary-color); 
        color: white; 
    }

    .btn-add:hover { 
        filter: brightness(1.2); /* Làm màu sáng lên 20% */
        box-shadow: 0 0 12px rgba(255, 64, 129, 0.5); /* Hiệu ứng Glow (phát sáng) */
        transform: scale(1.02); /* Phóng to nhẹ một chút */
    }

    /* NÚT CHI TIẾT (Màu xám chuyển sang xanh) */
    .btn-view { 
        background: #f1f5f9; 
        color: var(--text-main); 
        text-align: center;
        border: 1px solid #e2e8f0;
    }

    .btn-view:hover { 
        background: #2196F3; /* Màu xanh dương hiện đại (Material Blue) */
        color: white; /* Đổi màu chữ sang trắng */
        border-color: #1e88e5;
        box-shadow: 0 4px 6px rgba(33, 150, 243, 0.3);
    }

    /* Phân trang */
    .pagination { display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 50px; }
    .page-node { text-decoration: none; padding: 6px 12px; border-radius: 6px; background: #fff; color: var(--text-main); border: 1px solid #e2e8f0; font-size: 0.85rem; transition: all 0.2s; }
    .page-node:hover { border-color: var(--primary-color); color: var(--primary-color); }
    .page-node.active { background: var(--primary-color); color: white; border-color: var(--primary-color); }
    .page-node.disabled { opacity: 0.5; pointer-events: none; }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="sach-container">
        <h2 id="hTitle" runat="server" style="color: var(--text-main); font-weight: 800; margin-bottom: 30px; text-align:center;">DANH MỤC SÁCH</h2>

        <div class="books-grid">
            <asp:Repeater ID="rptSach" runat="server">
                <ItemTemplate>
                    <div class="book-item">
                        <div style="height: 150px; display: flex; align-items: center; justify-content: center;">
                            <img src='<%# "Images/" + (Eval("AnhBia") != DBNull.Value ? Eval("AnhBia") : "no-image.jpg") %>' class="book-image" />
                        </div>
                        <div>
                            <div class="book-name" title='<%# Eval("TenSach") %>'><%# Eval("TenSach") %></div>
                            <div class="book-price"><%# string.Format("{0:#,##0} đ", Eval("Dongia")) %></div>
                        </div>
                        <div class="button-container">
                            <asp:Button ID="btnThemgiohang" runat="server" Text="Mua" CssClass="btn-ui btn-add" />
                            <a href='<%# "chitiet.aspx?MaSach=" + Eval("MaSach") %>' class="btn-ui btn-view">Chi tiết</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="pagination">
            <asp:HyperLink ID="lnkPrev" runat="server" CssClass="page-node">Trước</asp:HyperLink>
            <asp:Repeater ID="rptPagination" runat="server">
                <ItemTemplate>
                    <asp:HyperLink ID="lnkPageNum" runat="server" 
                        Text='<%# Container.DataItem %>' 
                        NavigateUrl='<%# GetPageUrl(Container.DataItem) %>'
                        CssClass='<%# Convert.ToInt32(Container.DataItem) == CurrentPage ? "page-node active" : "page-node" %>'>
                    </asp:HyperLink>
                </ItemTemplate>
            </asp:Repeater>
            <asp:HyperLink ID="lnkNext" runat="server" CssClass="page-node">Sau</asp:HyperLink>
        </div>
    </div>
</asp:Content>