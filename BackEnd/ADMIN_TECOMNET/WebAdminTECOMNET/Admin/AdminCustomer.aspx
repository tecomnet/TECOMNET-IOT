<%@ Page Title="Clientes" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminCustomer.aspx.vb" Inherits="WebAdminTECOMNET.AdminCustomer" %>

<%@ Register TagPrefix="uc" TagName="ucCustomer" Src="~/UserControls/CustomerControl.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../Css/bootstrap.min.css" />
    <script src="../Scripts/js/bootstrap.js"></script>
    <style>
        .RadGrid {
            border-radius: 30px;
            overflow: hidden;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager" runat="server" />
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel" runat="server"></telerik:RadAjaxLoadingPanel>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Administrar clientes</label>
    </div>
    <div class="container pt-2" style="max-width: 1045px">
        <telerik:RadToolBar ID="rtbMenu" runat="server" Width="100%">
            <Items>
                <telerik:RadToolBarButton Text="Agregar Cliente" CommandName="Add" ImageUrl="../Resources/Images/add.png"></telerik:RadToolBarButton>
            </Items>
        </telerik:RadToolBar>
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%" ShowFooter="true" PageSize="10" AllowPaging="true" AllowFilteringByColumn="True">
            <MasterTableView DataKeyNames="CustomerID" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridEditCommandColumn UniqueName="Edit" ButtonType="ImageButton" HeaderStyle-Width="5px">
                        <HeaderStyle Width="5px"></HeaderStyle>
                    </telerik:GridEditCommandColumn>
                    <telerik:GridBoundColumn HeaderText="Nombre" DataField="CustomerName" UniqueName="CustomerName"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Email" DataField="Email" UniqueName="Email"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Teléfono" DataField="Phonenumber" UniqueName="Phonenumber"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="RFC" DataField="RFC" UniqueName="RFC"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha de alta" DataField="CreationDate" UniqueName="CreationDate"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains" DataFormatString="{0:dd/MM/yyyy}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha de baja" DataField="LastDate" UniqueName="LastDate"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains" DataFormatString="{0:dd/MM/yyyy}">
                    </telerik:GridBoundColumn>
                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="¿Esta seguro de dar de baja el cliente?" UniqueName="Delete">
                    </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:Panel ID="pnlCustomer" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <uc:ucCustomer runat="server" ID="ucCustomer" />
            <div class="col-md-offset-2 col-md-12 text-center m-3">
                <asp:Button runat="server" Text="Cancelar" ID="btnCancelar" CssClass="btn btn-danger" />
                <asp:Button runat="server" Text="Guardar" ID="btnGuardar" CssClass="btn btn-primary" ValidationGroup="GuardarCustomer" />
            </div>
            <div>
                <asp:ValidationSummary ID="GuardarCustomer" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="GuardarCustomer" />
            </div>
        </asp:Panel>
        <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
    </div>
</asp:Content>
