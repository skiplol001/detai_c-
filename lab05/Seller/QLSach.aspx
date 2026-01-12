<%@ Page Title="Quản lý Sách" Language="C#" MasterPageFile="Seller.Master" AutoEventWireup="true" CodeBehind="QLSach.aspx.cs" Inherits="lab05.Seller.QLSach" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .action-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .btn-add { background: #10b981; color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 600; }
        .grid-container { background: white; padding: 20px; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .img-thumb { width: 50px; height: 70px; object-fit: cover; border-radius: 4px; }
        .btn-edit { color: #3b82f6; margin-right: 10px; }
        .btn-delete { color: #ef4444; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="action-bar">
        <h2>Quản lý kho sách</h2>
        <asp:HyperLink ID="lnkAdd" runat="server" NavigateUrl="~/Seller/ThemSach.aspx" CssClass="btn-add">
            <i class="fa-solid fa-plus"></i> Thêm sách mới
        </asp:HyperLink>
    </div>

    <div class="grid-container">
        <asp:GridView ID="gvSach" runat="server" AutoGenerateColumns="False" CssClass="table" 
            DataKeyNames="MaSach" OnRowDeleting="gvSach_RowDeleting" GridLines="None" Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="Ảnh">
                    <ItemTemplate>
                        <img src='<%# Page.ResolveUrl("~/Images/" + Eval("AnhBia")) %>' class="img-thumb" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="TenSach" HeaderText="Tên sách" />
                <asp:BoundField DataField="Dongia" HeaderText="Giá bán" DataFormatString="{0:#,##0} đ" />
                <asp:BoundField DataField="Ngaycapnhat" HeaderText="Ngày đăng" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:TemplateField HeaderText="Thao tác">
                    <ItemTemplate>
                        <asp:HyperLink ID="lnkEdit" runat="server" NavigateUrl='<%# "SuaSach.aspx?id=" + Eval("MaSach") %>' CssClass="btn-edit">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </asp:HyperLink>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="btn-delete" 
                            OnClientClick="return confirm('Bạn có chắc chắn muốn xóa sách này?');">
                            <i class="fa-solid fa-trash"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>