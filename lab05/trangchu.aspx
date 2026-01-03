<%@ Page Title="TRANG CHỦ" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="trangchu.aspx.cs" Inherits="lab05.trangchu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-title {
            color: var(--text-main);
            text-align: center;
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 30px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Thay thế auto-style1 bằng Grid hiện đại */
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .book-item {
            background: #fff;
            border-radius: 12px;
            padding: 15px;
            text-align: center;
            border: 1px solid #f1f5f9;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .book-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 20px -5px rgba(0,0,0,0.1);
            border-color: var(--primary-color);
        }

        /* Khung chứa ảnh để cố định kích thước bìa sách */
        .image-wrapper {
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 12px;
            background-color: #f8fafc;
            border-radius: 8px;
            overflow: hidden;
        }

        .book-image {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain; /* Giữ tỉ lệ ảnh, không bị méo */
        }

        .book-name {
            font-weight: 700;
            color: var(--text-main);
            font-size: 0.95rem;
            margin-bottom: 8px;
            height: 42px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .book-price {
            color: var(--primary-color);
            font-weight: 800;
            font-size: 1.1rem;
            margin-bottom: 5px;
        }

        .update-date {
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-bottom: 15px;
        }

        /* --- Buttons --- */
        .button-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }

        .btn-ui {
            padding: 8px 5px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.75rem;
            text-decoration: none;
            cursor: pointer;
            border: none;
            transition: all 0.3s;
        }

        /* Nút thêm giỏ hàng - Hiệu ứng Glow sáng lên */
        .btn-add-cart {
            background: var(--primary-color);
            color: white;
        }
        .btn-add-cart:hover {
            filter: brightness(1.2);
            box-shadow: 0 0 12px rgba(255, 64, 129, 0.5);
            transform: scale(1.03);
        }

        /* Nút chi tiết - Đổi sang màu xanh dương */
        .btn-detail {
            background: #f1f5f9;
            color: var(--text-main);
            text-align: center;
            line-height: 1.5; /* Căn giữa text cho thẻ a */
        }
        .btn-detail:hover {
            background: #2196F3;
            color: white !important;
            box-shadow: 0 4px 8px rgba(33, 150, 243, 0.3);
        }

        /* --- Toast Message --- */
        .message {
            position: fixed;
            top: 80px; /* Tránh đè lên sticky header */
            right: 20px;
            padding: 15px 25px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            z-index: 2000;
            display: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            animation: slideIn 0.3s ease-out;
        }
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .success { background-color: #10b981; }
    </style>

    <script>
        function showAddingMessage(bookName) {
            var msgBox = document.getElementById("messageBox");
            msgBox.innerHTML = "<i class='fa-solid fa-check-circle'></i> Đã thêm <b>" + bookName + "</b> vào giỏ hàng!";
            msgBox.className = "message success";
            msgBox.style.display = "block";
            
            setTimeout(function () {
                msgBox.style.display = "none";
            }, 3000);
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="messageBox" class="message"></div>
    
    <div class="sach-container">
        <h2 class="page-title">SÁCH MỚI NHẤT</h2>

        <div class="books-grid">
            <asp:Repeater ID="rptSach" runat="server" DataSourceID="SqlDataSourceSach" OnItemCommand="rptSach_ItemCommand">
                <ItemTemplate>
                    <div class="book-item">
                        <div class="image-wrapper">
                            <asp:Image ID="imgSach" runat="server"
                                ImageUrl='<%# "~/Images/" + (Eval("AnhBia") != DBNull.Value && !string.IsNullOrEmpty(Eval("AnhBia").ToString()) ? Eval("AnhBia") : "no-image.jpg") %>'
                                AlternateText='<%# Eval("TenSach") %>'
                                CssClass="book-image" />
                        </div>

                        <div class="book-info">
                            <div class="book-name" title='<%# Eval("TenSach") %>'>
                                <%# Eval("TenSach") %>
                            </div>

                            <div class="book-price">
                                <%# string.Format("{0:#,##0} VNĐ", Eval("Dongia")) %>
                            </div>

                            <div class="update-date">
                                <i class="fa-regular fa-calendar-check"></i> <%# Convert.ToDateTime(Eval("Ngaycapnhat")).ToString("dd/MM/yyyy") %>
                            </div>
                        </div>

                        <div class="button-container">
                            <asp:LinkButton ID="btnThemgiohang" runat="server"
                                Text="Thêm vào giỏ"
                                CssClass="btn-ui btn-add-cart"
                                CommandName="ThemGioHang"
                                CommandArgument='<%# Eval("MaSach") + "|" + Eval("Dongia") %>'
                                OnClientClick='<%# "showAddingMessage(\"" + Eval("TenSach").ToString().Replace("\"", "\\\"") + "\"); return true;" %>' />

                            <a href='<%# "chitiet.aspx?MaSach=" + Eval("MaSach") %>' class="btn-ui btn-detail">Chi tiết</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:SqlDataSource ID="SqlDataSourceSach" runat="server"
            ConnectionString="Data Source=.;Initial Catalog=BookStoreDB;Integrated Security=True"
            SelectCommand="SELECT TOP 6 Sach.*, ChuDe.Tenchude 
                          FROM Sach 
                          INNER JOIN ChuDe ON Sach.MaCD = ChuDe.MaCD 
                          ORDER BY Ngaycapnhat DESC"></asp:SqlDataSource>
    </div>
</asp:Content>