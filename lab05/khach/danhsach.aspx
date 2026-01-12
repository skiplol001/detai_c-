<%@ Page Title="Danh mục sách" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="danhsach.aspx.cs" Inherits="lab05.danhsach" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-title { color: var(--text-main); font-size: 28px; font-weight: 800; margin-bottom: 30px; text-transform: uppercase; letter-spacing: 1px; position: relative; padding-bottom: 15px; }
        .page-title::after { content: ''; position: absolute; bottom: 0; left: 0; width: 60px; height: 4px; background: var(--primary-color); border-radius: 2px; }

        .books-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 25px; margin-top: 20px; }

        .book-item { background: #fff; border-radius: 16px; padding: 20px; text-align: center; border: 1px solid #f1f5f9; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); display: flex; flex-direction: column; position: relative; }
        .book-item:hover { transform: translateY(-10px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); border-color: var(--primary-light); }

        .image-wrapper { height: 200px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px; background-color: #f8fafc; border-radius: 12px; padding: 10px; }
        .book-image { max-width: 100%; max-height: 100%; object-fit: contain; transition: transform 0.5s ease; }
        .book-item:hover .book-image { transform: scale(1.05); }

        .book-name { font-weight: 700; color: var(--text-main); font-size: 0.95rem; margin-bottom: 10px; height: 42px; line-height: 1.4; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .book-price { color: var(--primary-color); font-weight: 800; font-size: 1.1rem; margin-bottom: 15px; }

        .button-container { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: auto; }
        .btn-ui { padding: 10px 5px; border-radius: 10px; font-weight: 700; font-size: 0.75rem; text-decoration: none; cursor: pointer; border: none; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 5px; }
        
        .btn-add-cart { background: var(--primary-color); color: white; }
        .btn-add-cart:hover { background: var(--primary-dark); transform: scale(1.02); }
        .btn-detail { background: #f1f5f9; color: var(--text-main); }
        .btn-detail:hover { background: #2196F3; color: white !important; }

        /* Phân trang */
        .pagination { display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 50px; }
        .page-node { text-decoration: none; padding: 10px 16px; border-radius: 10px; background: #fff; color: var(--text-main); border: 1px solid #e2e8f0; font-size: 0.9rem; font-weight: 600; transition: all 0.2s; }
        .page-node:hover { border-color: var(--primary-color); color: var(--primary-color); background: #fff0f6; }
        .page-node.active { background: var(--primary-color); color: white; border-color: var(--primary-color); box-shadow: 0 4px 10px rgba(255, 64, 129, 0.3); }
        .page-node.disabled { opacity: 0.5; pointer-events: none; background: #f8fafc; }

        /* Toast thông báo */
        .message { position: fixed; top: 100px; right: 25px; padding: 15px 25px; border-radius: 12px; color: white; font-weight: 600; z-index: 9999; display: none; box-shadow: 0 10px 20px rgba(0,0,0,0.1); background-color: #10b981; animation: slideIn 0.3s ease; }
        @keyframes slideIn { from { transform: translateX(100%); } to { transform: translateX(0); } }
    </style>

    <script>
        function showAddingMessage(bookName) {
            var msgBox = document.getElementById("messageBox");
            msgBox.innerHTML = "<i class='fa-solid fa-check-circle'></i> Đã thêm <b>" + bookName + "</b> vào giỏ!";
            msgBox.style.display = "block";
            setTimeout(function () { msgBox.style.display = "none"; }, 2500);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="messageBox" class="message"></div>
    
    <div class="sach-container">
        <h2 id="hTitle" runat="server" class="page-title">DANH MỤC SÁCH</h2>

        <div class="books-grid">
            <asp:Repeater ID="rptSach" runat="server" OnItemCommand="rptSach_ItemCommand">
                <ItemTemplate>
                    <div class="book-item">
                        <div class="image-wrapper">
                            <img src='<%# "../Images/" + (Eval("AnhBia") != DBNull.Value ? Eval("AnhBia") : "no-image.jpg") %>' class="book-image" />
                        </div>
                        <div class="book-info">
                            <div class="book-name" title='<%# Eval("TenSach") %>'><%# Eval("TenSach") %></div>
                            <div class="book-price"><%# string.Format("{0:#,##0} đ", Eval("Dongia")) %></div>
                        </div>
                        <div class="button-container">
                            <asp:LinkButton ID="btnThem" runat="server" CommandName="ThemGioHang" CommandArgument='<%# Eval("MaSach") %>'
                                CssClass="btn-ui btn-add-cart" OnClientClick='<%# "showAddingMessage(\"" + Eval("TenSach").ToString().Replace("\"", "\\\"") + "\");" %>'>
                                <i class="fa-solid fa-cart-plus"></i> Thêm
                            </asp:LinkButton>
                            <a href='<%# "chitiet.aspx?MaSach=" + Eval("MaSach") %>' class="btn-ui btn-detail">Chi tiết</a>
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