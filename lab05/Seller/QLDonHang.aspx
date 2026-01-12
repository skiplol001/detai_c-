<%@ Page Title="Thống kê" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="QLDonHang.aspx.cs" Inherits="lab05.Seller.QLDonHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .status-pending { background: #ffedd5; color: #9a3412; }
        .status-success { background: #dcfce7; color: #166534; }
        .btn-update { background: #6366f1; color: white; border: none; padding: 6px 12px; border-radius: 5px; cursor: pointer; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 style="margin-bottom: 20px;">Danh sách đơn đặt hàng</h2>

    <div style="background: white; padding: 20px; border-radius: 15px;">
        <asp:GridView ID="gvDonHang" runat="server" AutoGenerateColumns="False" Width="100%" 
            GridLines="None" DataKeyNames="SoDH" OnRowCommand="gvDonHang_RowCommand">
            <Columns>
                <asp:BoundField DataField="SoDH" HeaderText="Mã ĐH" />
                <asp:BoundField DataField="NgayDH" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="HoTenKH" HeaderText="Khách hàng" />
                <asp:BoundField DataField="Trigia" HeaderText="Tổng tiền" DataFormatString="{0:#,##0} đ" />
                <asp:TemplateField HeaderText="Trạng thái">
                    <ItemTemplate>
                        <span class='<%# (bool)Eval("Dagiao") ? "status-badge status-success" : "status-badge status-pending" %>'>
                            <%# (bool)Eval("Dagiao") ? "Đã giao hàng" : "Chờ xử lý" %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Xử lý">
                    <ItemTemplate>
                        <asp:Button ID="btnToggleStatus" runat="server" Text="Đổi trạng thái" 
                            CommandName="UpdateStatus" CommandArgument='<%# Eval("SoDH") %>' 
                            CssClass="btn-update" Visible='<%# !(bool)Eval("Dagiao") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>