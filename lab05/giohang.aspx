<%@ Page Title="GIỎ HÀNG" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="giohang.aspx.cs" Inherits="lab05.giohang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .cart-container { max-width: 1000px; margin: 0 auto; padding: 20px; }
        .cart-table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .cart-table th { background: #ff4081; color: white; padding: 12px; }
        .cart-table td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; }
        .product-img { width: 60px; height: 80px; object-fit: cover; }
        .quantity-input { width: 50px; text-align: center; padding: 5px; }
        .cart-summary { text-align: right; margin-top: 20px; padding: 20px; background: #f9f9f9; border-left: 5px solid #ff4081; }
        .btn-update { background: #4CAF50; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; }
        .btn-delete { background: #f44336; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; }
        .cart-actions { margin-top: 20px; text-align: center; }
        .btn-order { background: #ff4081; color: white; padding: 10px 30px; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; text-decoration: none; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="cart-container">
        <h1 style="color:#ff4081; text-align:center">GIỎ HÀNG CỦA BẠN</h1>

        <asp:Panel ID="pnlEmptyCart" runat="server">
            <div style="text-align:center; padding:50px">
                <h3>Giỏ hàng đang trống</h3>
                <a href="trangchu.aspx" style="color:#ff4081">Tiếp tục mua sắm</a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlCartContent" runat="server" Visible="false">
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Ảnh</th>
                        <th>Tên sách</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td><img src='<%# "Images/" + Eval("HinhAnh") %>' class="product-img" /></td>
                                <td style="text-align:left"><%# Eval("TenSach") %></td>
                                <td><asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Soluong") %>' CssClass="quantity-input" TextMode="Number" min="1" /></td>
                                <td><%# Eval("Dongia", "{0:#,##0}") %></td>
                                <td style="color:#ff4081; font-weight:bold"><%# Eval("Thanhtien", "{0:#,##0}") %></td>
                                <td>
                                    <asp:Button ID="btnUpdate" runat="server" Text="Lưu" CommandName="Update" CommandArgument='<%# Eval("MaSach") %>' CssClass="btn-update" />
                                    <asp:Button ID="btnDelete" runat="server" Text="Xóa" CommandName="Delete" CommandArgument='<%# Eval("MaSach") %>' CssClass="btn-delete" />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <div class="cart-summary">
                <span style="font-size:18px; font-weight:bold">TỔNG CỘNG: </span>
                <asp:Label ID="lblTongTien" runat="server" Style="font-size:24px; color:#ff4081; font-weight:bold" />
            </div>

            <div class="cart-actions">
                <asp:Button ID="btnClear" runat="server" Text="Xóa hết" OnClick="btnClear_Click" Style="padding:10px" />
                <asp:LinkButton ID="btnOrder" runat="server" CssClass="btn-order" OnClick="btnOrder_Click">ĐẶT HÀNG NGAY</asp:LinkButton>
            </div>
        </asp:Panel>
    </div>
</asp:Content>