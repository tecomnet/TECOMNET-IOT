<%@ Page Title="Cambiar Contraseña" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="ChangePassword.aspx.vb" Inherits="WebCustomerTECOMNET.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Cambio de contraseña</label>
    </div>
    <div class="container containerGral">
        <div class="container-xxl pt-3">
            <div class="row">
                <div class="col-md-3">
                    <strong class="text-P">Contraseña actual:
                    </strong>
                </div>
                <div class="col-md-9">
                    <asp:TextBox runat="server" ID="txtContrasenaActual" TextMode="Password" CssClass="form-control" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtContrasenaActual" ErrorMessage="El campo de contraseña actual es obligatorio." Display="None" ValidationGroup="Cambio"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row pt-1">
                <div class="col-md-3">
                    <strong class="text-P">Nueva contraseña:
                    </strong>
                </div>
                <div class="col-md-9">
                    <asp:TextBox runat="server" ID="txtNuevaContrasena" TextMode="Password" CssClass="form-control" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNuevaContrasena" ErrorMessage="El campo nueva contraseña es obligatorio." Display="None" ValidationGroup="Cambio"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="row pt-1">
                <div class="col-md-3">
                    <strong class="text-P">Confirmar la nueva contraseña
                    </strong>
                </div>
                <div class="col-md-9">
                    <asp:TextBox runat="server" ID="txtConfirmarNuevaContrasena" TextMode="Password" CssClass="form-control" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirmarNuevaContrasena" ErrorMessage="El campo confirmar nueva contraseña es obligatorio." Display="None" ValidationGroup="Cambio"></asp:RequiredFieldValidator>
                    <asp:CompareValidator runat="server" ControlToValidate="txtConfirmarNuevaContrasena" ControlToCompare="txtNuevaContrasena" ErrorMessage="La contraseña actual no coincide" Display="None" ValidationGroup="Cambio"></asp:CompareValidator>
                </div>
            </div>
            <div class="row">
                <div class="col-12 text-center pt-3">
                    <asp:Button runat="server" Text="Cambiar contraseña" OnClick="ChangePassword_Click" CssClass="btn btn-primary" ValidationGroup="Cambio" />
                </div>
            </div>
            <div class="row">
                <div class="col-12 text-center pt-3">
                    <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
                    <asp:ValidationSummary ID="Registro" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="Cambio" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
