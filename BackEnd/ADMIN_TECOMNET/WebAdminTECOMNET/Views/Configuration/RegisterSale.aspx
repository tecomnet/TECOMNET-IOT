<%@ Page Title="Registro de venta" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="RegisterSale.aspx.vb" Inherits="WebAdminTECOMNET.RegisterSale" %>

<%@ Register TagPrefix="uc" TagName="ucCustomer" Src="~/UserControls/CustomerControl.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
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
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel" runat="server"></telerik:RadAjaxLoadingPanel>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Registrar Venta</label>
    </div>
    <div class="container pt-2" style="max-width: 1045px">
        <telerik:RadToolBar ID="rtbMenu" runat="server" Width="100%">
            <Items>
                <telerik:RadToolBarButton Text="Registrar Venta" CommandName="Add" ImageUrl="../../Resources/Images/add.png"></telerik:RadToolBarButton>
            </Items>
        </telerik:RadToolBar>
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%" ShowFooter="true" PageSize="10" AllowPaging="true" AllowFilteringByColumn="True">
            <MasterTableView DataKeyNames="CarID" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridEditCommandColumn UniqueName="Edit" ButtonType="ImageButton" HeaderStyle-Width="5px">
                        <HeaderStyle Width="5px"></HeaderStyle>
                    </telerik:GridEditCommandColumn>
                    <telerik:GridBoundColumn HeaderText="VIN" DataField="VIN" UniqueName="VIN"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Modelo" DataField="Model" UniqueName="Model"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Cliente" DataField="CustomerName" UniqueName="CustomerName"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="RFC" DataField="RFC" UniqueName="RFC"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha de alta" DataField="CreationDate" UniqueName="CreationDate"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha de baja" DataField="LastDate" UniqueName="LastDate"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="¿Esta seguro de dar de baja el vehículo?" UniqueName="Delete">
                    </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:Panel ID="pnlCar" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <h2>Registrar Venta</h2>
            <div class="row mb-2">
                <div class="col-md-1">
                    VIN Vehículo:
                </div>
                <div class="col-md-4">
                    <telerik:RadComboBox ID="rcbVIN" runat="server" Width="100%" EnableLoadOnDemand="True"
                        MarkFirstMatch="True" ShowMoreResultsBox="True" Filter="Contains">
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rcbVIN" ValidationGroup="Guardar"
                        ErrorMessage="El VIM es obligatorio." Display="None" />
                </div>
                <div class="col-md-1">
                    RFC:
                </div>
                <div class="col-md-4">
                    <telerik:RadComboBox ID="rcbCustomerName" runat="server" Width="100%" EnableLoadOnDemand="True"
                        ShowMoreResultsBox="True" Filter="Contains">
                        <ItemTemplate>
                            <table style="width: 100%; height: 12px; text-align: left">
                                <tr>
                                    <td style="width: 35%">
                                        <%#DataBinder.Eval(Container, "Attributes['RFC']")%>
                                    </td>
                                    <td style="width: 65%">
                                        <%#DataBinder.Eval(Container, "Attributes['CustomerName']")%>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <HeaderTemplate>
                            <table style="width: 100%; text-align: left">
                                <tr>
                                    <td style="width: 35%;">RFC </td>
                                    <td style="width: 65%;">Nombre</td>
                                </tr>
                            </table>
                        </HeaderTemplate>
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rcbCustomerName" ValidationGroup="Guardar"
                        ErrorMessage="El cliente es obligatorio." Display="None" />
                </div>
                <div class="col-md-2">
                    <asp:LinkButton ID="lbAddCustomer" runat="server" Text="Nuevo Cliente"></asp:LinkButton>
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
        <asp:Panel ID="pnlCustomer" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <uc:ucCustomer runat="server" ID="ucCustomer" />
            <div class="col-md-offset-2 col-md-12 text-center m-3">
                <asp:Button runat="server" Text="Cancelar" ID="btnCancelarCustomer" CssClass="btn btn-danger" />
                <asp:Button runat="server" Text="Guardar" ID="btnGuardarCustomer" CssClass="btn btn-primary" ValidationGroup="GuardarCustomer" />
            </div>
            <div>
                <asp:ValidationSummary ID="GuardarCustomer" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="GuardarCustomer" />
            </div>
        </asp:Panel>
        <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
    </div>
</asp:Content>
