<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="UserAdmin.aspx.vb" Inherits="WebAdminTECOMNET.UserAdmin" %>

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
        <label class="h3 text-white">Registrar Usuarios</label>
    </div>
    <div class="container pt-2" style="max-width: 1045px">
        <telerik:RadToolBar ID="rtbMenu" runat="server" Width="100%">
            <Items>
                <telerik:RadToolBarButton Text="Registrar Usuario" CommandName="Add" ImageUrl="../Resources/Images/add.png"></telerik:RadToolBarButton>
            </Items>
        </telerik:RadToolBar>
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%">
            <MasterTableView DataKeyNames="UserID" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridEditCommandColumn UniqueName="Edit" ButtonType="ImageButton" HeaderStyle-Width="5px">
                        <HeaderStyle Width="5px"></HeaderStyle>
                    </telerik:GridEditCommandColumn>
                    <telerik:GridBoundColumn HeaderText="Usuario" DataField="Name" UniqueName="Name"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Email" DataField="Email" UniqueName="Email"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="User" DataField="UserType" UniqueName="UserType"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="CreationDate" DataField="CreationDate" UniqueName="CreationDate" DataFormatString="{0:yyyy/MM/dd}"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="LastDate" DataField="LastDate" UniqueName="LastDate" DataFormatString="{0:yyyy/MM/dd}"></telerik:GridBoundColumn>
                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ConfirmText="¿Esta seguro de dar de baja el producto?" UniqueName="Delete">
                    </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:Panel ID="pnlUser" runat="server" Width="100%" Visible="false" CssClass="container containerGral">
            <h2>Registro de usuarios</h2>
            <hr />
            <div class="row pb-2">
                <div class="col-md-12 text-center">
                    <telerik:RadRadioButtonList ID="rrblUserType" runat="server" Direction="Horizontal">
                        <Items>
                            <telerik:ButtonListItem Value="1" Text="Administrador" Selected="true" />
                            <telerik:ButtonListItem Value="2" Text="Instalador" />
                            <telerik:ButtonListItem Value="3" Text="Vendedor" />
                            <telerik:ButtonListItem Value="4" Text="Reportes BYD" />
                        </Items>
                    </telerik:RadRadioButtonList>
                </div>
            </div>
            <div class="row pb-2">
                <div class="col-md-2">
                    Usuario:
                </div>
                <div class="col-md-4">
                    <telerik:RadTextBox ID="rtbUserName" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbUserName" ValidationGroup="Guardar"
                        ErrorMessage="El usuario es obligatorio." Display="None" />
                </div>
                <div class="col-md-2">
                    Nombre:
                </div>
                <div class="col-md-4">
                    <telerik:RadTextBox ID="rtbName" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbName" ValidationGroup="Guardar"
                        ErrorMessage="El nombre es obligatorio." Display="None" />
                </div>
            </div>
            <div class="row pb-2">
                <div class="col-md-2">
                    Email:
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="tbEmail" runat="server" Width="100%" TextMode="Email" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEmail" ValidationGroup="Guardar"
                        ErrorMessage="El email es obligatorio." Display="None" />
                </div>
                <div class="col-md-2">
                    Teléfono:
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="tbPhoneNumber" runat="server" Width="100%" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="tbPhoneNumber" ValidationGroup="Guardar"
                        ErrorMessage="El teléfono es obligatorio." Display="None" />
                </div>
            </div>
            <div class="row pb-2">
                <div class="col-md-2">
                    Contraseña:
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="tbPassword" runat="server" Width="100%" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="tbPassword" ValidationGroup="Guardar"
                        ErrorMessage="La contraseña es obligatoria." Display="None" />
                </div>
                <div class="col-md-2">
                </div>
                <div class="col-md-4">
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
