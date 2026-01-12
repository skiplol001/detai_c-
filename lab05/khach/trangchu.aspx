<%@ Page Title="TRANG CHỦ" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="trangchu.aspx.cs" Inherits="lab05.trangchu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-title { color: var(--text-main); text-align: center; font-size: 32px; font-weight: 800; margin: 40px 0; text-transform: uppercase; letter-spacing: 1px; position: relative; padding-bottom: 15px; }
        .page-title::after { content: ''; position: absolute; bottom: 0; left: 50%; transform: translateX(-50%); width: 80px; height: 4px; background: var(--primary-color); border-radius: 2px; }
        
        .books-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 30px; max-width: 1300px; margin: 0 auto 50px auto; padding: 0 15px; }
        
        .book-item { background: #fff; border-radius: 16px; padding: 20px; text-align: center; border: 1px solid #f1f5f9; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); display: flex; flex-direction: column; position: relative; }
        .book-item:hover { transform: translateY(-12px); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); border-color: var(--primary-light); }
        
        .new-badge { position: absolute; top: 15px; left: 15px; background: var(--primary-color); color: white; padding: 4px 12px; border-radius: 50px; font-size: 10px; font-weight: 800; z-index: 10; text-transform: uppercase; }
        
        .image-wrapper { height: 240px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px; background-color: #f8fafc; border-radius: 12px; padding: 10px; }
        .book-image { max-width: 100%; max-height: 100%; object-fit: contain; transition: transform 0.5s ease; }
        .book-item:hover .book-image { transform: scale(1.08); }

        .book-name { font-weight: 700; color: var(--text-main); font-size: 1rem; margin-bottom: 10px; height: 48px; line-height: 1.4; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .book-price { color: var(--primary-color); font-weight: 800; font-size: 1.2rem; margin-bottom: 8px; }
        .update-date { font-size: 0.8rem; color: var(--text-muted); margin-bottom: 20px; }

        .button-container { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: auto; }
        .btn-ui { padding: 10px 5px; border-radius: 10px; font-weight: 700; font-size: 0.8rem; text-decoration: none; cursor: pointer; border: none; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 5px; }
        .btn-add-cart { background: var(--primary-color); color: white; }
        .btn-detail { background: #f1f5f9; color: var(--text-main); }
        
        .message { position: fixed; top: 100px; right: 25px; padding: 18px 30px; border-radius: 12px; color: white; font-weight: 600; z-index: 9999; display: none; box-shadow: 0 15px 30px rgba(0,0,0,0.15); background-color: #10b981; }
  .button-container { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: auto; }
        .btn-ui { padding: 10px 5px; border-radius: 10px; font-weight: 700; font-size: 0.75rem; text-decoration: none; cursor: pointer; border: none; transition: all 0.3s ease; display: flex; align-items: center; justify-content: center; gap: 5px; }
        
        .btn-add-cart { background: var(--primary-color); color: white; }
        .btn-add-cart:hover { background: var(--primary-dark); transform: scale(1.02); }
        .btn-detail { background: #f1f5f9; color: var(--text-main); }
        .btn-detail:hover { background: #2196F3; color: white !important; }
    </style>

    <script>
        function showAddingMessage(bookName) {
            var msgBox = document.getElementById("messageBox");
            msgBox.innerHTML = "<i class='fa-solid fa-circle-check'></i> Đã thêm <b>" + bookName + "</b> vào giỏ!";
            msgBox.style.display = "block";
            setTimeout(function () { msgBox.style.display = "none"; }, 2500);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="messageBox" class="message"></div>
    <div class="sach-container">
        <h2 class="page-title">Sách Mới Nhất</h2>
        <div class="books-grid">
            <asp:Repeater ID="rptSach" runat="server" DataSourceID="SqlDataSourceSach" OnItemCommand="rptSach_ItemCommand">
                <ItemTemplate>
                    <div class="book-item">
                        <div class="new-badge">Mới</div>
                        <div class="image-wrapper">
                            <img src='<%# "../Images/" + (Eval("AnhBia") != DBNull.Value ? Eval("AnhBia") : "no-image.jpg") %>' class="book-image" />
                        </div>
                        <div class="book-info">
                            <div class="book-name"><%# Eval("TenSach") %></div>
                            <div class="book-price"><%# string.Format("{0:#,##0} đ", Eval("Dongia")) %></div>
                            <div class="update-date"><i class="fa-regular fa-calendar"></i> <%# Eval("Ngaycapnhat", "{0:dd/MM/yyyy}") %></div>
                        </div>
                        <div class="button-container">
                            <asp:LinkButton ID="btnThemgiohang" runat="server" CssClass="btn-ui btn-add-cart"
                                CommandName="ThemGioHang" CommandArgument='<%# Eval("MaSach") %>'
                                OnClientClick='<%# "showAddingMessage(\"" + Eval("TenSach").ToString().Replace("\"", "\\\"") + "\");" %>'>
                                <i class="fa-solid fa-cart-plus"></i> Thêm
                            </asp:LinkButton>
                            <a href='<%# "chitiet.aspx?MaSach=" + Eval("MaSach") %>' class="btn-ui btn-detail">Xem</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <asp:SqlDataSource ID="SqlDataSourceSach" runat="server" ConnectionString="<%$ ConnectionStrings:BookStoreDB %>"
            SelectCommand="SELECT TOP 8 * FROM Sach ORDER BY Ngaycapnhat DESC"></asp:SqlDataSource>
    </div>
</asp:Content>