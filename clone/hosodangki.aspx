<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="hosodangki.aspx.cs"
    Inherits="clone.hosodangki" ClientIDMode="Static" EnableEventValidation="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đăng ký khách hàng</title>
    <style type="text/css">
        .auto-style1 {
            width: 62%;
            height: 450px;
            border-collapse: collapse;
        }

        .auto-style3 {
            text-align: center;
        }

        .auto-style4 {
            width: 335px;
        }

        .auto-style5 {
            width: 251px;
        }

        .auto-style6 {
            width: 251px;
            height: 31px;
        }

        .auto-style7 {
            width: 335px;
            height: 31px;
        }

        .customer-info-container {
            border: 2px solid #4CAF50;
            border-radius: 5px;
            padding: 10px;
            margin-top: 10px;
            min-height: 350px;
            max-height: 380px;
            overflow-y: auto;
            background-color: #f9f9f9;
        }

        .info-list {
            list-style-type: none;
            padding: 0;
            margin: 10px 0;
        }

            .info-list li {
                padding: 8px 5px;
                border-bottom: 1px dashed #ddd;
                font-size: 14px;
            }

                .info-list li:last-child {
                    border-bottom: none;
                }

        .info-label {
            font-weight: bold;
            color: #333;
            display: inline-block;
            min-width: 120px;
        }

        .info-value {
            color: #555;
        }

        .error-list {
            list-style-type: none;
            padding: 0;
            margin: 10px 0;
            color: red;
        }

            .error-list li {
                padding: 5px;
                border-bottom: 1px dashed #ff9999;
            }

        table td {
            padding: 8px;
            vertical-align: top;
        }

        h3 {
            margin: 5px 0;
            color: #2c3e50;
        }

        input[type="text"],
        input[type="password"],
        textarea,
        select {
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 3px;
            width: 250px;
        }

        .btn-dangky {
            padding: 8px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

            .btn-dangky:hover {
                background-color: #45a049;
            }

        .separator {
            border-left: 2px solid #4CAF50;
            height: 100%;
        }

        .required {
            color: red;
        }

        .error-title {
            color: red;
            font-weight: bold;
            margin-bottom: 10px;
            text-align: center;
        }

        .success-title {
            color: green;
            font-weight: bold;
            margin-bottom: 10px;
            text-align: center;
        }

        select {
            width: 80px;
            margin-right: 5px;
        }

        .error-message {
            color: red;
            font-size: 12px;
            margin-top: 3px;
            display: block;
        }

        .error-summary {
            color: red;
            font-size: 13px;
            margin-top: 10px;
            padding: 10px;
            border: 1px solid red;
            background-color: #ffe6e6;
            border-radius: 5px;
        }
        .auto-style8 {
            height: 46px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table align="center" class="auto-style1">
                <tr>
                    <td colspan="2" class="auto-style8">
                        <h3 class="auto-style3">Thông tin đăng nhập</h3>
                    </td>
                    <td rowspan="13" class="separator">
                        <div style="text-align: center;">
                            <h3 class="auto-style3">Hồ sơ khách hàng</h3>
                        </div>
                        <div class="customer-info-container">
                            <asp:Literal ID="ltCustomerInfo" runat="server"></asp:Literal>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style5">Tên đăng nhập<span class="required">*</span></td>
                    <td class="auto-style4">
                        <asp:TextBox ID="txttaikhoan" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                            ControlToValidate="txttaikhoan" ErrorMessage="(*)"
                            Display="Dynamic" CssClass="error-message"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revUsername" runat="server"
                            ControlToValidate="txttaikhoan" ErrorMessage="(*)"
                            ValidationExpression="^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':\\|,.<>\/?]{8,16}$"
                            Display="Dynamic" CssClass="error-message"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style5">Mật khẩu<span class="required">*</span></td>
                    <td class="auto-style4">
                        <asp:TextBox ID="txtmk" runat="server" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                            ControlToValidate="txtmk" ErrorMessage="(*)"
                            Display="Dynamic" CssClass="error-message"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revPassword" runat="server"
                            ControlToValidate="txtmk" ErrorMessage="(*)"
                            ValidationExpression="^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':\\|,.<>\/?]{8,16}$"
                            Display="Dynamic" CssClass="error-message"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style5">Nhập lại mật khẩu<span class="required">*</span></td>
                    <td class="auto-style4">
                        <asp:TextBox ID="txtcfmk" runat="server" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                            ControlToValidate="txtcfmk" ErrorMessage="(*)"
                            Display="Dynamic" CssClass="error-message"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="cvPassword" runat="server"
                            ControlToValidate="txtcfmk" ControlToCompare="txtmk"
                            ErrorMessage="(*)" Display="Dynamic"
                            CssClass="error-message"></asp:CompareValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <h3 class="auto-style3">Thông tin cá nhân</h3>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style5">Họ tên khách hàng<span class="required">*</span></td>
                    <td class="auto-style4">
                        <asp:TextBox ID="txttenkh" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFullname" runat="server"
                            ControlToValidate="txttenkh" ErrorMessage="(*)"
                            Display="Dynamic" CssClass="error-message"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style6">Ngày sinh</td>
                    <td class="auto-style7">
                        <asp:DropDownList ID="ddlngay" runat="server"></asp:DropDownList>
                        <asp:DropDownList ID="ddlthang" runat="server"></asp:DropDownList>
                        <asp:DropDownList ID="ddlnam" runat="server"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style5">Email</td>
                    <td class="auto-style4">
                        <asp:TextBox ID="txtemail" runat="server"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server"
                            ControlToValidate="txtemail" ErrorMessage="(*)"
                            ValidationExpression="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                            Display="Dynamic" CssClass="error-message"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style5">Thu nhập (VND)</td>
                    <td class="auto-style4">
                        <asp:TextBox ID="txtluong" runat="server"></asp:TextBox>
                        <asp:RangeValidator ID="rvIncome" runat="server"
                            ControlToValidate="txtluong" ErrorMessage="(*)"
                            MinimumValue="1000000" MaximumValue="50000000" Type="Integer"
                            Display="Dynamic" CssClass="error-message"></asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style6">Giới tính</td>
                    <td class="auto-style7">
                        <asp:RadioButton ID="rdnam" runat="server" Text="Nam" GroupName="gender" Checked="true" />
                    </td>
                </tr>
                <tr>
                    <td class="auto-style5">Địa chỉ</td>
                    <td class="auto-style4">
                        <asp:TextBox ID="txtdiachi" runat="server" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style5">Điện thoại</td>
                    <td class="auto-style4">
                        <asp:TextBox ID="txtsdt" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style3" colspan="2">
                        <asp:Button ID="btndangki" runat="server" Text="Đăng ký"
                            OnClick="btndangki_Click" CssClass="btn-dangky"
                            CausesValidation="false" />
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
