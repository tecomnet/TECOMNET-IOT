<%@ Page Title="Registro de Productos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="RegisterProduct.aspx.vb" Inherits="WebAdminTECOMNET.RegisterProduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        .RadGrid {
            border-radius: 30px;
            overflow: hidden;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager" runat="server" />
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" />
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel" runat="server"></telerik:RadAjaxLoadingPanel>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Registro de Productos</label>
    </div>
    <div class="container pt-2" style="max-width: 1045px">
        <telerik:RadToolBar ID="rtbMenu" runat="server" Width="100%">
            <Items>
                <telerik:RadToolBarButton Text="Registrar Producto" CommandName="Add" ImageUrl="../../Resources/Images/add.png"></telerik:RadToolBarButton>
            </Items>
        </telerik:RadToolBar>
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%">
            <MasterTableView DataKeyNames="ProductId" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridEditCommandColumn UniqueName="Edit" ButtonType="ImageButton" HeaderStyle-Width="5px">
                        <HeaderStyle Width="5px"></HeaderStyle>
                    </telerik:GridEditCommandColumn>
                    <telerik:GridBoundColumn HeaderText="Producto" DataField="ProductName" UniqueName="ProductName"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Costo" DataField="Price" UniqueName="Price" DataFormatString="{0:C2}"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="MB" DataField="MB" UniqueName="MB"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Empresa" DataField="Company" UniqueName="Company"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="CreationDate" DataField="CreationDate" UniqueName="CreationDate" DataFormatString="{0:yyyy/MM/dd}"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="LastDate" DataField="LastDate" UniqueName="LastDate" DataFormatString="{0:yyyy/MM/dd}"></telerik:GridBoundColumn>
                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="¿Esta seguro de dar de baja el producto?" UniqueName="Delete">
                    </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:Panel ID="pnlProducts" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <h2>Registro de productos</h2>
            <hr />
            <div class="row pb-2">
                <div class="col-md-1">
                    Producto:
                </div>
                <div class="col-md-3">
                    <telerik:RadTextBox ID="rtbProductName" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbProductName" ValidationGroup="Guardar"
                        ErrorMessage="El nombre del producto es obligatorio." Display="None" />
                </div>
                <div class="col-md-1">
                    Costo:
                </div>
                <div class="col-md-3">
                    <telerik:RadNumericTextBox ID="rntbPrice" runat="server" Width="100%" MinValue="1"></telerik:RadNumericTextBox>
                    <asp:RangeValidator runat="server" ControlToValidate="rntbPrice" Type="Double" MinimumValue="1" MaximumValue="10000"
                        ValidationGroup="Guardar" ErrorMessage="Por favor ingresa un costo entre 1 y 10,000" Display="None" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbProductName" ValidationGroup="Guardar"
                        ErrorMessage="El costo del producto es obligatorio." Display="None" />
                </div>
                <div class="col-md-1">
                    MB:
                </div>
                <div class="col-md-3">
                    <telerik:RadNumericTextBox ID="rntbMB" runat="server" Width="100%" MinValue="0"></telerik:RadNumericTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rntbMB" ValidationGroup="Guardar"
                        ErrorMessage="Los MB son obligatorios." Display="None" />
                </div>
            </div>
            <div class="row pb-2">
                <div class="col-md-1">
                    Empresa:
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlCompany" runat="server" Width="100%" CssClass="form-select">
                    </asp:DropDownList>                    
                </div>
                <div class="col-md-1">
                    Oferta ID:
                </div>
                <div class="col-md-3">
                    <telerik:RadTextBox ID="rtbOffertID" runat="server" Width="100%"></telerik:RadTextBox>                    
                </div>                
            </div>
            <div class="col-md-offset-2 col-md-12 text-center m-3">
                <asp:Button runat="server" Text="Cancelar" ID="btnCancelar" CssClass="btn btn-danger" />
                <asp:Button runat="server" Text="Guardar" ID="btnGuardar" CssClass="btn btn-primary" ValidationGroup="Guardar" />
            </div>
            <div>
                <asp:ValidationSummary ID="Guardar" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="Guardar" />
            </div>
        </asp:Panel>
        <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
    </div>
</asp:Content>
