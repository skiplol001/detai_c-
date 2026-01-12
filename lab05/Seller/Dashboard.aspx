<%@ Page Title="Thống kê" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="lab05.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); display: flex; align-items: center; gap: 20px; }
        .stat-icon { width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; color: white; }
        .stat-info h3 { margin: 0; color: #64748b; font-size: 14px; text-transform: uppercase; }
        .stat-info p { margin: 5px 0 0; font-size: 24px; font-weight: 800; color: #1e293b; }
        
        .bg-blue { background: #3b82f6; }
        .bg-green { background: #10b981; }
        .bg-purple { background: #8b5cf6; }
        .bg-orange { background: #f59e0b; }

        .recent-table { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        .table-title { font-size: 18px; font-weight: 700; margin-bottom: 20px; color: #1e293b; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid #f1f5f9; color: #64748b; }
        td { padding: 12px; border-bottom: 1px solid #f1f5f9; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 style="margin-bottom: 25px;">Tổng quan kinh doanh</h2>
    
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon bg-blue"><i class="fa-solid fa-dollar-sign"></i></div>
            <div class="stat-info">
                <h3>Doanh thu</h3>
                <p><asp:Literal ID="litRevenue" runat="server" Text="0"></asp:Literal> đ</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-green"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            <div class="stat-info">
                <h3>Đơn hàng</h3>
                <p><asp:Literal ID="litOrders" runat="server" Text="0"></asp:Literal></p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon bg-purple"><i class="fa-solid fa-book"></i></div>
            <div class="stat-info">
                <h3>Sách đang bán</h3>
                <p><asp:Literal ID="litBooks" runat="server" Text="0"></asp:Literal></p>
            </div>
        </div>
    </div>

    <div class="recent-table">
        <div class="table-title">Đơn hàng mới nhất</div>
        <asp:GridView ID="gvRecentOrders" runat="server" AutoGenerateColumns="False" CssClass="table" GridLines="None">
            <Columns>
                <asp:BoundField DataField="SoDH" HeaderText="Mã ĐH" />
                <asp:BoundField DataField="NgayDH" HeaderText="Ngày đặt" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                <asp:BoundField DataField="HoTenKH" HeaderText="Khách hàng" />
                <asp:BoundField DataField="Trigia" HeaderText="Trị giá" DataFormatString="{0:#,##0} đ" />
                <asp:TemplateField HeaderText="Trạng thái">
                    <ItemTemplate>
                        <%# (bool)Eval("Dagiao") ? "<span style='color:green'>Đã giao</span>" : "<span style='color:orange'>Đang xử lý</span>" %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>