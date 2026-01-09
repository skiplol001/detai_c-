<%@ Page Title="THANH TOÁN" Language="C#" MasterPageFile="~/default.Master" AutoEventWireup="true" CodeBehind="thanhtoan.aspx.cs" Inherits="lab05.thanhtoan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .checkout-container { display: grid; grid-template-columns: 1fr 400px; gap: 30px; max-width: 1200px; margin: 30px auto; align-items: start; }
        .checkout-card { background: white; padding: 30px; border-radius: 20px; box-shadow: var(--shadow-soft); border: 1px solid #f1f5f9; }
        .checkout-title { font-size: 1.5rem; font-weight: 800; color: var(--text-main); margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        
        /* Form fields */
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 0.85rem; font-weight: 700; color: var(--text-muted); margin-bottom: 8px; text-transform: uppercase; }
        .form-control { width: 100%; padding: 12px 15px; border-radius: 10px; border: 1px solid #e2e8f0; font-family: inherit; transition: var(--transition); }
        .form-control:focus { border-color: var(--primary-color); outline: none; box-shadow: 0 0 0 4px rgba(255, 64, 129, 0.1); }

        /* Order Summary Table */
        .summary-item { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px dashed #e2e8f0; font-size: 0.9rem; }
        .summary-total { display: flex; justify-content: space-between; padding-top: 20px; margin-top: 10px; font-size: 1.2rem; font-weight: 800; color: var(--primary-color); }

        .btn-pay { width: 100%; padding: 15px; border-radius: 12px; background: var(--primary-color); color: white; border: none; font-weight: 800; font-size: 1rem; cursor: pointer; transition: var(--transition); margin-top: 20px; }
        .btn-pay:hover { background: var(--primary-dark); transform: translateY(-3px); box-shadow: 0 10px 20px rgba(255, 64, 129, 0.3); }
        
        @media (max-width: 992px) { .checkout-container { grid-template-columns: 1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="checkout-container">
        <div class="checkout-card">
            <div class="checkout-title"><i class="fa-solid fa-truck-fast"></i> THÔNG TIN GIAO HÀNG</div>
            
            <div class="form-group">
                <label class="form-label">Họ tên người nhận</label>
                <asp:TextBox ID="txtHoTen" runat="server" CssClass="form-control" placeholder="Nhập đầy đủ họ tên"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtHoTen" ErrorMessage="Vui lòng nhập họ tên" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Số điện thoại</label>
                <asp:TextBox ID="txtDienThoai" runat="server" CssClass="form-control" placeholder="Số điện thoại liên lạc"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Địa chỉ nhận hàng</label>
                <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Số nhà, tên đường, phường/xã..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Ngày giao dự kiến</label>
                <asp:TextBox ID="txtNgayGiao" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>
        </div>

        <div class="checkout-card">
            <div class="checkout-title"><i class="fa-solid fa-receipt"></i> ĐƠN HÀNG</div>
            
            <asp:Repeater ID="rptSummary" runat="server">
                <ItemTemplate>
                    <div class="summary-item">
                        <span><%# Eval("TenSach") %> <b>x<%# Eval("Soluong") %></b></span>
                        <span><%# string.Format("{0:#,##0} đ", Eval("Thanhtien")) %></span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="summary-total">
                <span>TỔNG TIỀN:</span>
                <asp:Label ID="lblTongTien" runat="server" Text="0 đ"></asp:Label>
            </div>

            <asp:Button ID="btnDatHang" runat="server" Text="XÁC NHẬN ĐẶT HÀNG" CssClass="btn-pay" OnClick="btnDatHang_Click" />
            <p style="text-align:center; margin-top:15px; font-size:0.8rem; color:var(--text-muted)">
                <a href="giohang.aspx" style="color:var(--text-muted)"><i class="fa-solid fa-arrow-left"></i> Quay lại giỏ hàng</a>
            </p>
        </div>
    </div>
</asp:Content>