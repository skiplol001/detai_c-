<%@ Page Title="ĐĂNG KÝ" Language="C#" MasterPageFile="~/default.Master" 
    AutoEventWireup="true" CodeBehind="dangky.aspx.cs" Inherits="lab05.dangky" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .login-container {
            max-width: 400px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        
        .login-title {
            color: #ff4081;
            text-align: center;
            font-size: 28px;
            margin-bottom: 30px;
        }
        
        .login-form {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        
        .btn-login {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #ff4081, #ff80ab);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .error-message {
            color: #f44336;
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            background: #ffebee;
            border-radius: 5px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        .auto-style2 { width: 600px; border-collapse: collapse; margin-top: 20px; border: 1px solid #ddd; background: #fafafa; }
        .text-input { width: 100%; padding: 6px; box-sizing: border-box; }
        .btn-add { background: #4CAF50; color: white; padding: 10px 30px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .auto-style6 {
            width: 323px;
        }
        .auto-style7 {
            font-size: large;
        }
        .auto-style8 {
            font-size: x-large;
            width: 742px;
            border-bottom: 1px solid #eee;
            padding: 10px;
        }
        .auto-style9 {
            font-size: x-large;
            width: 742px;
        }
        .auto-style10 {
            text-align: left;
        }
        .auto-style11 {
            font-size: x-large;
            text-align: left;
            width: 742px;
            height: 38px;
        }
        .auto-style13 {
            padding: 6px;
            box-sizing: border-box;
        }
        .auto-style14 {
            width: 742px;
        }
        .auto-style15 {
            text-align: left;
            height: 38px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container">
        <h2 class="login-title"> ĐĂNG NHẬP<table align="center" class="auto-style2">
            <tr>
                <td class="auto-style8">Họ Tên(*):</td>
                <td style="text-align: left" class="auto-style6">
                    <asp:TextBox ID="txtHoTen" runat="server" CssClass="text-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvTenHoa" runat="server"
                        ControlToValidate="txtTenHoa" ErrorMessage="Chưa nhập họ tên"
                        Display="Dynamic" ForeColor="Red" CssClass="auto-style7"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style8">Tên đăng nhập(*):</td>
                <td style="text-align: left" class="auto-style6">
                    <asp:TextBox ID="txtTendangnhap" runat="server" CssClass="text-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvtendangnhap" runat="server"
                        ControlToValidate="txtGia" ErrorMessage="Chưa nhập tên đăng nhập"
                        Display="Dynamic" ForeColor="Red" CssClass="auto-style7"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; padding: 20px;" class="auto-style9">
                    Mật khẩu(*):</td>
                <td style="padding: 20px;" class="auto-style10">
                    <asp:TextBox ID="txtmatkhau" runat="server" CssClass="auto-style13" TextMode="Password" Width="234px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvmk" runat="server"
                        ControlToValidate="txtGia" ErrorMessage="Chưa nhập mật khẩu"
                        Display="Dynamic" ForeColor="Red" CssClass="auto-style7"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td style="padding: 20px;" class="auto-style11">
                    Nhập lại mật khẩu:</td>
                <td style="padding: 20px;" class="auto-style15">
                    <asp:TextBox ID="txtcfmk" runat="server" CssClass="auto-style13" TextMode="Password" Width="234px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvcfmk" runat="server"
                        ControlToValidate="txtGia" ErrorMessage="Chưa nhập mật khẩu"
                        Display="Dynamic" ForeColor="Red" CssClass="auto-style7"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; padding: 20px;" class="auto-style14">
                    Ngày sinh:</td>
                <td style="text-align: center; padding: 20px;">
                    <asp:TextBox ID="txtNgay" runat="server" CssClass="text-input" TextMode="Date"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; padding: 20px;" class="auto-style14">
                    Email:</td>
                <td style="text-align: center; padding: 20px;">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="auto-style13" TextMode="Password" Width="234px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; padding: 20px;" class="auto-style14">
                    Địa chỉ:</td>
                <td style="text-align: center; padding: 20px;">
                    <asp:TextBox ID="txtDiachi" runat="server" CssClass="auto-style13" TextMode="Password" Width="234px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: center; padding: 20px;" class="auto-style14">
                    Điện thoại(*):</td>
                <td style="text-align: center; padding: 20px;">
                    <asp:TextBox ID="txtSDT" runat="server" CssClass="auto-style13" TextMode="Password" Width="234px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvsdt" runat="server"
                        ControlToValidate="txtGia" ErrorMessage="Chưa nhập số điện thoại"
                        Display="Dynamic" ForeColor="Red" CssClass="auto-style7"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center; padding: 20px;">
                    <asp:Button ID="btndangky" runat="server" Text="Đăng ký" CssClass="btn-add" OnClick="btnthem_Click" />
                    <br />
                    <asp:Label ID="lblThongBao" runat="server"></asp:Label>
                </td>
            </tr>
        </table>

        </h2>
        
    </div>
</asp:Content>