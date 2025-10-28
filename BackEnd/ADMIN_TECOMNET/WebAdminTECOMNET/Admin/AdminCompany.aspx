<%@ Page Title="Administra Compañias" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminCompany.aspx.vb" Inherits="WebAdminTECOMNET.AdminCompany" %>
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
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" />
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel" runat="server"></telerik:RadAjaxLoadingPanel>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Administración de Empresas</label>
    </div>
    <div class="container pt-2" style="max-width: 1045px">
        <telerik:RadToolBar ID="rtbMenu" runat="server" Width="100%">
            <Items>
                <telerik:RadToolBarButton Text="Registrar empresa" CommandName="Add" ImageUrl="../Resources/Images/add.png"></telerik:RadToolBarButton>
            </Items>
        </telerik:RadToolBar>
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%">
            <MasterTableView DataKeyNames="CompanyId" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridEditCommandColumn UniqueName="Edit" ButtonType="ImageButton" HeaderStyle-Width="5px">
                        <HeaderStyle Width="5px"></HeaderStyle>
                    </telerik:GridEditCommandColumn>
                    <telerik:GridBoundColumn HeaderText="Empresa" DataField="Company" UniqueName="Company"></telerik:GridBoundColumn>                    
                    <telerik:GridBoundColumn HeaderText="CreationDate" DataField="CreationDate" UniqueName="CreationDate" DataFormatString="{0:yyyy/MM/dd}"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="LastDate" DataField="LastDate" UniqueName="LastDate" DataFormatString="{0:yyyy/MM/dd}"></telerik:GridBoundColumn>
                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="¿Esta seguro de dar de baja la empresa?" UniqueName="Delete">
                    </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>        
        <asp:Panel ID="pnlEmpresa" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <h2>Registro de empresa</h2>
            <hr />
            <div class="row pb-2">
                <div class="col-md-2">
                    Empresa:
                </div>
                <div class="col-md-10">
                    <telerik:RadTextBox ID="rtbCompany" runat="server" Width="100%" MaxLength="150"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbCompany" ValidationGroup="Guardar"
                        ErrorMessage="El nombre de la empresa es obligatorio." Display="None" />
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