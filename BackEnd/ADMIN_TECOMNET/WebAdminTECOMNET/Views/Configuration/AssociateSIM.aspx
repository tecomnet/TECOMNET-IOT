<%@ Page Title="Asociar SIM" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AssociateSIM.aspx.vb" Inherits="WebAdminTECOMNET.AssociateSIM" %>

<%@ Register TagPrefix="uc" TagName="ucCarUser" Src="~/UserControls/CarUser.ascx" %>

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
        <label class="h3 text-white">Asociación de SIM a vehículo</label>
    </div>
    <div class="container pt-2" style="max-width: 1045px">
        <telerik:RadToolBar ID="rtbMenu" runat="server" Width="100%">
            <Items>
                <telerik:RadToolBarButton Text="Asociar SIM" CommandName="Add" ImageUrl="../../Resources/Images/add.png"></telerik:RadToolBarButton>
            </Items>
        </telerik:RadToolBar>
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%" ShowFooter="true" PageSize="10" AllowPaging="true" AllowFilteringByColumn="True">
            <MasterTableView DataKeyNames="SIMID,MSISDN" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridEditCommandColumn UniqueName="Edit" ButtonType="ImageButton" HeaderStyle-Width="5px">
                        <HeaderStyle Width="5px"></HeaderStyle>
                    </telerik:GridEditCommandColumn>
                    <telerik:GridBoundColumn HeaderText="ICCID" DataField="ICCID" UniqueName="ICCID"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="VIN" DataField="VIN" UniqueName="VIN"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Marca" DataField="Model" UniqueName="Model"
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
                    <%--<telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="¿Esta seguro de dar de baja el SIM?" UniqueName="Delete">
                    </telerik:GridButtonColumn>--%>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:Panel ID="pnlSIM" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <h2>Asignar SIM a vehículo</h2>
            <div class="row mb-2">
                <div class="col-md-1">
                    SIM:
                </div>
                <div class="col-md-4">
                    <telerik:RadComboBox ID="rcbSIM" runat="server" Width="100%" EnableLoadOnDemand="True"
                        MarkFirstMatch="True" ShowMoreResultsBox="True" Filter="Contains">
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rcbSIM" ValidationGroup="Guardar"
                        ErrorMessage="El SIM es obligatorio." Display="None" />
                </div>
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
                <div class="col-md-2">
                    <asp:LinkButton ID="lbAddCar" runat="server" Text="Nuevo Vehículo"></asp:LinkButton>
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
        <asp:Panel ID="pnlCar" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <uc:ucCarUser runat="server" ID="ucCarUser" />
            <div class="col-md-offset-2 col-md-12 text-center m-3">
                <asp:Button runat="server" Text="Cancelar" ID="btnCancelarCar" CssClass="btn btn-danger" />
                <asp:Button runat="server" Text="Guardar" ID="btnGuardarCar" CssClass="btn btn-primary" ValidationGroup="GuardarCar" />
            </div>
            <div>
                <asp:ValidationSummary ID="GuardarCar" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="GuardarCar" />
            </div>
        </asp:Panel>
        <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
    </div>
</asp:Content>
