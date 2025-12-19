<%@ Page Title="Tra Cứu Hoa" Language="C#" MasterPageFile="~/layoutmaster.Master" 
    AutoEventWireup="true" CodeBehind="tracuu.aspx.cs" Inherits="clone.tracuu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .tra-cuu-container { padding: 30px; text-align: center; font-family: Arial, sans-serif; }
        .search-box { 
            margin: 20px auto; max-width: 600px; background: #fff5f8; 
            padding: 20px; border-radius: 12px; border: 1px solid #ffc1d6;
        }
        .search-row { display: flex; align-items: center; justify-content: center; gap: 10px; flex-wrap: wrap; }
        .search-label { font-weight: bold; color: #d81b60; }
        .price-box { padding: 8px; border: 1px solid #ff80ab; border-radius: 5px; width: 120px; outline: none; }
        .btn-search { 
            background: #ff4081; color: white; border: none; padding: 8px 20px; 
            border-radius: 5px; font-weight: bold; cursor: pointer; transition: 0.3s;
        }
        .btn-search:hover { background: #e91e63; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        
        .flowers-grid { margin: 30px auto; max-width: 1100px; }
        .flower-card { 
            border: 1px solid #eee; border-radius: 8px; padding: 15px; 
            text-align: center; background: #fff; width: 230px;
            transition: transform 0.2s; box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .flower-card:hover { transform: translateY(-5px); }
        .flower-img { width: 100%; height: 200px; object-fit: cover; border-radius: 5px; margin-bottom: 10px; }
        .flower-name { font-weight: bold; color: #333; font-size: 16px; margin: 10px 0; height: 40px; overflow: hidden; }
        .flower-price { color: #e91e63; font-weight: bold; font-size: 15px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="tra-cuu-container">
        
        <div class="search-box">
            <div class="search-row">
                <span class="search-label">Giá từ:</span>
                <asp:TextBox ID="txtGiaTu" runat="server" TextMode="Number" CssClass="price-box"></asp:TextBox>
                
                <span class="search-label">đến:</span>
                <asp:TextBox ID="txtGiaDen" runat="server" TextMode="Number" CssClass="price-box"></asp:TextBox>
                
                <asp:Button ID="btnTimKiem" runat="server" Text="Tìm kiếm" CssClass="btn-search" />
            </div>
        </div>
        
        <asp:DataList ID="dlHoa" runat="server" 
            RepeatColumns="4" 
            RepeatDirection="Horizontal" 
            DataSourceID="SqlDataSourceHoa" 
            CellPadding="15">
            <ItemTemplate>
                <div class="flower-card">
                    <img src='<%# "Images/" + Eval("Hinh") %>' class="flower-img" />
                    
                    <div class="flower-name">
                        <%# Eval("TenHoa") %>
                    </div>
                    
                    <div class="flower-price">
                        <%# Eval("Gia", "{0:#,##0} VNĐ") %>
                    </div>
                     <div class="flower-price">
<asp:Button ID="btnThemgiohang" runat="server" Text="Add to cart" CssClass="btn-search" />               

                      </div>
                </div>
            </ItemTemplate>
        </asp:DataList>
        
        <asp:SqlDataSource ID="SqlDataSourceHoa" runat="server" 
            ConnectionString="<%$ ConnectionStrings:HoaTuoiDB %>" 
            SelectCommand="SELECT * FROM Hoa WHERE (Gia >= @GiaTu OR @GiaTu IS NULL) AND (Gia <= @GiaDen OR @GiaDen IS NULL)">
            <SelectParameters>
                <asp:ControlParameter ControlID="txtGiaTu" Name="GiaTu" PropertyName="Text" Type="Double" ConvertEmptyStringToNull="true" />
                <asp:ControlParameter ControlID="txtGiaDen" Name="GiaDen" PropertyName="Text" Type="Double" ConvertEmptyStringToNull="true" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>