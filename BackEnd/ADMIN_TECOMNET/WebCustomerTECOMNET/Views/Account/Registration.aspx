<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Registration.aspx.vb" Inherits="WebCustomerTECOMNET.Registration" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Registro</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link rel="shortcut icon" href="../../Resources/Logo.ico" type="image/x-icon" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(to bottom, #000000, #003575ff);
            color: white;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Arial', sans-serif;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.4);
            max-width: 400px;
            width: 100%;
        }

            .login-container h2 {
                text-align: center;
                margin-bottom: 20px;
                font-size: 1.8rem;
                font-weight: bold;
            }

        .btn-custom {
            background-color: #3f7dc0;
            border-color: #3f7dc0;
            font-weight: bold;
            color:white;
        }

            .btn-custom:hover {
                background-color: #233251;
                border-color: #233251;
            }

        .form-control:focus {
            box-shadow: 0 0 5px rgba(255, 87, 34, 0.8);
            border-color: #76cbc4;
        }

        .logo {
            display: block;
            margin: 0 auto 20px;
            max-width: 180px;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <form id="form2" runat="server" class="login-container">
        <telerik:RadScriptManager runat="server" ID="RadScriptManager"></telerik:RadScriptManager>
        <asp:Image class="mb-4" ID="imgLogo" runat="server" ImageUrl="~/Resources/Logo.png" CssClass="logo"/>
        <h2 class="h3 mb-3 fw-normal">Registro</h2>
        <asp:Panel runat="server" ID="pnlGeneral" DefaultButton="btnValidaDatos">
            <h5 class="text-center">
                <span class="align-bottom">Datos generales</span>
            </h5>
            <hr />
            <div class="form-group row">
                <label class="col-sm-5 col-form-label" for="rtbPoliza">VIN del vehículo</label>
                <div class="col-sm-7">
                    <telerik:RadTextBox ID="rtbVIN" runat="server" AutoCompleteType="Disabled" Width="100%">
                    </telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbVIN" ErrorMessage="El VIN es obligatorio." Display="None"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-5 col-form-label" for="rtbRFC">RFC</label>
                <div class="col-sm-7">
                    <telerik:RadTextBox ID="rtbRFC" runat="server" AutoCompleteType="Disabled" Width="100%">
                    </telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbRFC" ErrorMessage="El RFC es obligatorio." Display="None"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-5 col-form-label" for="rtbCorreo">Correo</label>
                <div class="col-sm-7">
                    <asp:TextBox ID="tbCorreo" runat="server" AutoCompleteType="Disabled" Width="100%" TextMode="Email" CssClass="form-control">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="tbCorreo" ErrorMessage="El correo es obligatorio" Display="None"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="form-group row mt-3">
                <asp:Button ID="btnValidaDatos" runat="server" CssClass="btn btn-custom btn-block" Text="Continuar" />
            </div>
            <div>
                <asp:ValidationSummary ID="Validation" runat="server" CssClass="alert alert-danger alert-dismissible fade show" />
            </div>
        </asp:Panel>
        <asp:Panel runat="server" ID="pnlSeguridad" DefaultButton="btnGuardarRegistro" Visible="false">
            <h5 class="text-center">
                <span class="align-bottom">Datos de acceso</span>
            </h5>
            <hr />
            <div class="form-group row pt-3">
                <label class="col-sm-5 col-form-label" for="rtbContrasena">Contraseña</label>
                <div class="col-sm-7">
                    <telerik:RadTextBox ID="rtbContrasena" runat="server" TextMode="Password" AutoCompleteType="Disabled" Width="100%">
                    </telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbContrasena" ValidationGroup="SeguridadSummary" ErrorMessage="La contraseña es obligatoria." Display="None"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-5 col-form-label" for="rtbConfirmarcontrasena">Confirmar contraseña:</label>
                <div class="col-sm-7">
                    <telerik:RadTextBox ID="rtbConfirmarcontrasena" runat="server" TextMode="Password" AutoCompleteType="Disabled" Width="100%">
                    </telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbConfirmarcontrasena" ValidationGroup="SeguridadSummary" ErrorMessage="El confirmación de contraseña es obligatoria" Display="None"></asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="form-group mt-3">
                <asp:Button ID="btnRegresarDatos" runat="server" CssClass="btn btn-success" Text="Regresar" Width="48%" />
                <asp:Button ID="btnGuardarRegistro" runat="server" CssClass="btn btn-custom btn-block" Text="Guardar" Width="48%" ValidationGroup="SeguridadSummary" />
            </div>
            <div>
                <asp:CompareValidator ID="CompareValidator1" runat="Server" ControlToValidate="rtbConfirmarcontrasena"
                    ControlToCompare="rtbContrasena" Operator="Equal" Type="string" ValidationGroup="SeguridadSummary"
                    ErrorMessage="No coinciden las contraseñas." Display="None" />
                <asp:ValidationSummary ID="SeguridadSummary" runat="server" ValidationGroup="SeguridadSummary" CssClass="alert alert-danger alert-dismissible fade show" />
            </div>
        </asp:Panel>
        <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
        <div class="text-center mt-3">
        <%--<a href="ResetPassword.aspx">¿Olvidó su contraseña?</a>--%>
        <asp:HyperLink ID="hlLogin" runat="server" NavigateUrl="~/Views/Account/Login.aspx" style="color:#76cbc4" Text="Iniciar sesión" Visible="false"></asp:HyperLink>
        <%--<p class="mt-5 mb-3 text-muted">&copy; <%: Now.Year %> - por TECOMNET</p>--%>
        </div>
    </form>
</body>
</html>
