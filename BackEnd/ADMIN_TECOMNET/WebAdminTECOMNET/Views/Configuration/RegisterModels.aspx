<%@ Page Title="Registrar Modelos" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="RegisterModels.aspx.vb" Inherits="WebAdminTECOMNET.RegisterModels" %>

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
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" />
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel" runat="server"></telerik:RadAjaxLoadingPanel>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Registro de Modelos</label>
    </div>
    <div class="container pt-2" style="max-width: 1045px">
        <telerik:RadToolBar ID="rtbMenu" runat="server" Width="100%">
            <Items>
                <telerik:RadToolBarButton Text="Registrar Modelo" CommandName="Add" ImageUrl="../../Resources/Images/add.png"></telerik:RadToolBarButton>
            </Items>
        </telerik:RadToolBar>
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%">
            <MasterTableView DataKeyNames="ModelID" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridEditCommandColumn UniqueName="Edit" ButtonType="ImageButton" HeaderStyle-Width="5px">
                        <HeaderStyle Width="5px"></HeaderStyle>
                    </telerik:GridEditCommandColumn>
                    <telerik:GridBoundColumn HeaderText="Modelo" UniqueName="Model" DataField="Model"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha de alta" UniqueName="CreationDate" DataField="CreationDate" DataFormatString="{0:yyyy/MM/dd}"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha de baja" UniqueName="LastDate" DataField="LastDate" DataFormatString="{0:yyyy/MM/dd}"></telerik:GridBoundColumn>
                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="¿Esta seguro de cancelar el modelo?" UniqueName="Delete">
                    </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:Panel ID="pnlModels" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <h2>Registro de modelos</h2>
            <hr />
            <div class="row">
                <div class="col-md-2">
                    Modelo:
                </div>
                <div class="col-md-10">
                    <telerik:RadTextBox ID="rtbModel" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbModel" ValidationGroup="Guardar"
                        ErrorMessage="El modelo es obligatorio." Display="None" />
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
