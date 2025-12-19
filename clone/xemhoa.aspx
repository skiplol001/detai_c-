<%@ Page Title="Xem Hoa" Language="C#" MasterPageFile="~/layoutmaster.Master" 
    AutoEventWireup="true" CodeBehind="xemhoa.aspx.cs" Inherits="clone.xemhoa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .xem-hoa-container { padding: 20px; text-align: center; max-width: 1200px; margin: 0 auto; font-family: 'Segoe UI', Arial, sans-serif; }
        
        h2 { color: #d81b60; margin-bottom: 20px; text-transform: uppercase; }

        .dropdown-container { margin-bottom: 30px; background: #fef0f4; padding: 15px; border-radius: 10px; display: inline-block; }
        .loai-hoa-dropdown { padding: 8px 15px; border: 1px solid #ff80ab; border-radius: 20px; outline: none; min-width: 200px; }

        .flowers-grid-container { 
            display: flex; flex-wrap: wrap; justify-content: center; gap: 25px; margin-top: 20px; 
        }

        .flower-item { 
            border: 1px solid #eee; border-radius: 12px; padding: 15px; 
            background-color: #fff; width: 260px; box-sizing: border-box;
            transition: all 0.3s ease; box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            display: flex; flex-direction: column; align-items: center;
        }
        .flower-item:hover { transform: translateY(-8px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); border-color: #ff80ab; }

        .flower-image { width: 100%; height: 200px; object-fit: cover; border-radius: 8px; margin-bottom: 12px; }

        .flower-name { font-weight: bold; color: #333; font-size: 1.1em; margin-bottom: 8px; height: 45px; overflow: hidden; display: flex; align-items: center; justify-content: center; }
        .flower-price { color: #e91e63; font-weight: bold; font-size: 1.05em; margin-bottom: 12px; }

        .btn-add-cart { 
            background: #ff4081; color: white; border: none; padding: 8px 20px; 
            border-radius: 25px; cursor: pointer; font-weight: 600; width: 100%; transition: 0.2s;
        }
        .btn-add-cart:hover { background: #c2185b; box-shadow: 0 3px 8px rgba(233, 30, 99, 0.4); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="xem-hoa-container">
        <h2>DANH MỤC HOA</h2>
        
        <div class="dropdown-container">
            <asp:DropDownList ID="ddlLoai" runat="server" 
                AutoPostBack="True" 
                CssClass="loai-hoa-dropdown"
                DataSourceID="SqlDataSourceLoai"
                DataTextField="TenLoai"
                DataValueField="MaLoai"
                AppendDataBoundItems="true">
                <asp:ListItem Text="-- Tất cả loại hoa --" Value=""></asp:ListItem>
            </asp:DropDownList>
        </div>
        
        <asp:DataList ID="dlHoa" runat="server" 
            RepeatColumns="4" 
            RepeatDirection="Horizontal" 
            DataSourceID="SqlDataSourceHoa" OnSelectedIndexChanged="dlHoa_SelectedIndexChanged">
            <ItemTemplate>
                <div class="flower-item">
                    <img src='<%# "Images/" + Eval("Hinh") %>' class="flower-image" alt='<%# Eval("TenHoa") %>' />
                    
                    <div class="flower-name">
                        <%# Eval("TenHoa") %>
                    </div>
                    
                    <div class="flower-price">
                        Giá bán: <%# Eval("Gia", "{0:#,##0} VNĐ") %>
                    </div>
                                    
                      <div class="flower-price">
<asp:Button ID="btnThemgiohang" runat="server" Text="Add to cart" CssClass="btn-search" />               

                      </div>
                   
                </div>
            </ItemTemplate>
        </asp:DataList>
        
        <asp:SqlDataSource ID="SqlDataSourceLoai" runat="server" 
            ConnectionString="<%$ ConnectionStrings:HoaTuoiDB %>" 
            SelectCommand="SELECT * FROM [Loai]">
        </asp:SqlDataSource>
        
       <asp:SqlDataSource ID="SqlDataSourceHoa" runat="server" 
    ConnectionString="<%$ ConnectionStrings:HoaTuoiDB %>" 
    SelectCommand="SELECT * FROM [Hoa] WHERE ([MaLoai] = @MaLoai OR @MaLoai = 0 OR @MaLoai IS NULL)">
    <SelectParameters>
        <asp:ControlParameter ControlID="ddlLoai" Name="MaLoai" PropertyName="SelectedValue" 
            Type="Int32" DefaultValue="0" ConvertEmptyStringToNull="true" />
    </SelectParameters>
</asp:SqlDataSource>
    </div>
</asp:Content>