<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="WebCustomerTECOMNET.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Inicio de sesión</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link rel="shortcut icon" href="../../Resources/Logo.ico" type="image/x-icon" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
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
    <script type="text/javascript">
        function snniper() {
            document.getElementById("btnContinuarSnipper").style.display = "block";
            document.getElementById("<%=btnIngresar.ClientID%>").style.display = "none";
        }
        function cleanControls() {
            document.getElementById("btnContinuarSnipper").style.display = "none";
            document.getElementById("<%=btnIngresar.ClientID%>").style.display = "block";
            document.getElementById("Registro").style.display = "none";
            if (document.getElementById("ErrorMessageDiv") !== null) {
                document.getElementById("ErrorMessageDiv").style.display = "none";
            }
        }
    </script>
</head>
<body>
    <form id="form2" runat="server" class="login-container">
            <asp:Image class="mb-4" ID="imgLogo" CssClass="logo" runat="server" ImageUrl="~/Resources/Logo.png" />            
            <h2 class="h3 mb-3 fw-normal"><%: IIf(Now.Hour >= 0 And Now.Hour <= 12, "Buenos días,", "Buenas tardes,") %></h2>            
                <div class="mb-3">
                    <label for="txtCorreo" class="form-label">Correo Electrónico</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email"
                        placeholder="name@example.com" oninput="cleanControls()"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCorreo" ErrorMessage="El correo es requerido" Display="None"></asp:RequiredFieldValidator>
                </div>
                <div class="mb-3">
                    <label for="txtPassword" class="form-label">Contraseña</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Password"
                        oninput="cleanControls()" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword" ErrorMessage="La contraseña es requerida" Display="None"></asp:RequiredFieldValidator>
                </div>
                <div class="text-center mt-3">
                    <label>
                        <asp:CheckBox ID="cbRecordarme" runat="server" />
                        Recordar usuario     
                    </label>
                </div>
                <div class="d-grid mt-3">
                    <div id="ErrorMessageDiv" runat="server" class="alert alert-danger alert-dismissible fade show text-center" visible="false">
                        <asp:Literal runat="server" ID="FailureText" />
                    </div>
                    <asp:ValidationSummary ID="Registro" runat="server" CssClass="alert alert-danger alert-dismissible fade show" />
                    <asp:Button ID="btnIngresar" runat="server" CssClass="btn btn-custom btn-block" Text="Iniciar sesión" OnClientClick="snniper()" />
                    <button id="btnContinuarSnipper" class="w-100 btn btn-primary btn-lg" style="display: none" type="button" onclick="snniperStop()">
                        <span class="spinner-grow spinner-grow-sm" role="status" aria-hidden="true"></span>
                    </button>
                </div>
                <div class="text-center mt-3">
                    <%--<a href="ResetPassword.aspx">¿Olvidó su contraseña?</a>--%>
                    <a href="Registration.aspx" style="color:#76cbc4">Registrate aquí</a>
                    <%--<p class="mt-5 mb-3 text-muted">&copy; <%: Now.Year %> - por TECOMNET</p>--%>
                </div>
        
    </form>
</body>
</html>
