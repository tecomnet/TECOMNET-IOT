<%@ Page Title="Recargas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="RegisterPayment.aspx.vb" Inherits="WebAdminTECOMNET.RegisterPayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager" runat="server" />
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel" runat="server"></telerik:RadAjaxLoadingPanel>
    <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%">
        <MasterTableView DataKeyNames="ProductId" NoMasterRecordsText="No hay registros que mostrar"
            ClientDataKeyNames="ProductID" CommandItemDisplay="Top"
            CommandItemSettings-ShowRefreshButton="false" Width="100%" CommandItemSettings-AddNewRecordText="Registrar producto">
            <CommandItemSettings AddNewRecordText="Registrar producto" ExportToPdfText="Export to PDF"
                ShowRefreshButton="False"></CommandItemSettings>
            <Columns>
                <telerik:GridEditCommandColumn UniqueName="Edit" ButtonType="ImageButton" HeaderStyle-Width="5px">
                    <HeaderStyle Width="5px"></HeaderStyle>
                </telerik:GridEditCommandColumn>
                <telerik:GridBoundColumn HeaderText="ProductName"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderText="Price"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderText="CreationDate"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderText="LastDate"></telerik:GridBoundColumn>
                <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="¿Esta seguro de dar de baja el producto?" ImageUrl="../Resources/Images/led-icons/disconnect.png"
                    UniqueName="Delete">
                </telerik:GridButtonColumn>
            </Columns>
        </MasterTableView>
    </telerik:RadGrid>
    <asp:Panel ID="pnlPayments" runat="server" Width="100%">
        <div class="row pb-2">
            <div class="col-md-2">
                Producto
            </div>
            <div class="col-md-10">
                <telerik:RadComboBox ID="rcbProduct" runat="server" Width="100%"></telerik:RadComboBox>
            </div>
        </div>
        <div class="row pb-2">
            <div class="col-md-2">
                Cliente:
            </div>
            <div class="col-md-10">
                <telerik:RadComboBox ID="rcbCustomer" runat="server" Width="100%"></telerik:RadComboBox>
            </div>
        </div>
        <div class="row pb-2">
            <div class="col-md-2">
                Auto:
            </div>
            <div class="col-md-10">
                <telerik:RadComboBox ID="rcbCar" runat="server" Width="100%"></telerik:RadComboBox>                
            </div>
        </div>
        <div class="row pb-2">
            <div class="col-md-2">
                SIM
            </div>
            <div class="col-md-10">
                <telerik:RadComboBox ID="rcbSIM" runat="server" Width="100%"></telerik:RadComboBox>                
            </div>
        </div>
        <div class="row pb-2">
            <div class="col-md-2">
                Fecha de compra:
            </div>
            <div class="col-md-10">
                <telerik:RadDatePicker ID="rdpPurchaseDate" runat="server" Width="100%"></telerik:RadDatePicker>                                
            </div>
        </div>
        <div class="row pb-2">
            <div class="col-md-2">
                Monto:                
            </div>
            <div class="col-md-10">
                <telerik:RadNumericTextBox ID="rntbPaymentAmount" runat="server" Width="100%"></telerik:RadNumericTextBox>                               
            </div>
        </div>
        <div class="row pb-2">
            <div class="col-md-2">
                Metodo de pago:
            </div>
            <div class="col-md-10">
                <telerik:RadComboBox ID="rdpMethodPayment" runat="server" Width="100%"></telerik:RadComboBox>
            </div>
        </div>
        <div class="row pb-2">
            <div class="col-md-2">
                Requiere Factura:
            </div>
            <div class="col-md-10">
                <telerik:RadCheckBox ID="rcbInvoiceRequired" runat="server"></telerik:RadCheckBox>                
            </div>
        </div>                
        <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
        <div class="col-md-offset-2 col-md-12 text-center m-3">
            <asp:Button runat="server" Text="Cancelar" ID="btnCancelar" CssClass="btn btn-danger" />
            <asp:Button runat="server" Text="Guardar" ID="btnGuardar" CssClass="btn btn-primary" ValidationGroup="Guardar" />
        </div>
        <div>
            <asp:ValidationSummary ID="Guardar" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="Guardar" />
        </div>
    </asp:Panel>
</asp:Content>
