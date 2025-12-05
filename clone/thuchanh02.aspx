<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="thuchanh02.aspx.cs" Inherits="clone.thuchanh02" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 50%;
        }
        .auto-style2 {
            height: 20px;
            text-align: center;
        }
        .auto-style3 {
            width: 303px;
        }
        .auto-style4 {
            width: 303px;
            height: 23px;
        }
        .auto-style5 {
            height: 23px;
        }
        .auto-style6 {
            width: 303px;
            text-align: center;
        }
        .auto-style7 {
            width: 303px;
            height: 23px;
            text-align: center;
        }
        .auto-style8 {
            width: 303px;
            height: 26px;
        }
        .auto-style9 {
            height: 26px;
        }
        .auto-style10 {
            text-align: center;
        }
        .auto-style11 {
            text-align: right;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table align="center" cellpadding="2" cellspacing="0" class="auto-style1">
                <tr>
                    <td class="auto-style2" colspan="4">
                        <h1>ĐƠN ĐẶT HÀNG&nbsp;</h1>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style3" colspan="3">Khách hàng</td>
                    <td>
                        <asp:TextBox ID="txtTenKH" runat="server" Width="416px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4" colspan="3">Địa chỉ</td>
                    <td class="auto-style5">
                        <asp:TextBox ID="txtDiachi" runat="server" Width="416px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style8" colspan="3">Mã số thuế</td>
                    <td class="auto-style9">
                        <asp:TextBox ID="txtMST" runat="server" Width="416px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style3" colspan="3">Chọn các loại bánh sau:</td>
                    <td class="auto-style10">Danh sách bánh được đặt:</td>
                </tr>
                <tr>
                    <td class="auto-style6" colspan="3">
                        <asp:DropDownList ID="ddlLoai" runat="server" Height="16px" Width="289px">
                        </asp:DropDownList>
                    </td>
                    <td class="auto-style10" rowspan="2">
                        <asp:ListBox ID="lbDS" runat="server"></asp:ListBox>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style4">Số lượng</td>
                    <td class="auto-style7">
                        <asp:TextBox ID="txtSL" runat="server" Width="116px"></asp:TextBox>
                    </td>
                    <td class="auto-style4">cái</td>
                </tr>
                <tr>
                    <td class="auto-style6" colspan="3">
                        <asp:Button ID="btnThem" runat="server" OnClick="btnThem_Click" Text="Thêm" />
                    </td>
                    <td class="auto-style11">
                        <asp:Button ID="btnXoa" runat="server" OnClick="btnXoa_Click" style="width: 35px" Text="Xoá" />
                    </td>
                </tr>
                <tr>
                    <td class="auto-style10" colspan="4">
                        <asp:Button ID="btnLuu" runat="server" OnClick="btnLuu_Click" Text="In đơn đặt hàng" />
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlHoaDon" runat="server" Visible="false" Width="50%" CssClass="hoa-don-container" Style="margin: 20px auto;">
    <div class="hoa-don-header">
        <h1>HÓA ĐƠN ĐẶT HÀNG</h1>
    </div>

    <div class="hoa-don-info">
        <p><strong>Khách hàng: </strong><asp:Label ID="lblTenKH" runat="server"></asp:Label></p>
        <p><strong>Địa chỉ: </strong><asp:Label ID="lblDiaChi" runat="server"></asp:Label></p>
        <p><strong>Mã số thuế: </strong><asp:Label ID="lblMST" runat="server"></asp:Label></p>
    </div>

    <%--<div class="hoa-don-detail">--%>
        <p><strong>Đặt các loại bánh sau:</strong></p>
        
        <asp:ListBox ID="lbDSBanh" runat="server" Width="100%" Height="150px" Enabled="false"></asp:ListBox>
        
        </div>

</asp:Panel>
    </form>
</body>
</html>
