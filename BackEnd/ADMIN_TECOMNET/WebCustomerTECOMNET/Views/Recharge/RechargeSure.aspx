<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RechargeSure.aspx.vb" Inherits="WebCustomerTECOMNET.RechargeSure" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>TECOMNET - Recarga</title>
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }

        .recarga-box {
            border: 2px solid #198754;
            border-radius: 10px;
            background-color: #fff;
        }

        .recarga-header {
            font-size: 28px;
            font-weight: bold;
        }

        .promo-title {
            font-weight: 600;
            font-size: 14px;
            color: #6c757d;
        }

        .promo-value {
            font-size: 20px;
            font-weight: bold;
            color: #212529;
        }

        footer {
            background-color: #003575ff;
            color: white;
            padding: 15px 0;
            margin-top: 40px;
        }

        .containerTittle {
            background: #3f7dc0;
            font-size: 20px;
            color: white;
            padding-top: 20px;
            padding-bottom: 20px;
        }

        .containerWizzard {
            background-color: white;
            padding-bottom: 20px;
        }

        .btn-custom {
            background-color: #3f7dc0;
            border-color: #3f7dc0;
            font-weight: bold;
            color: white;
        }

            .btn-custom:hover {
                background-color: #233251;
                border-color: #233251;
                color: white;
            }

        .containerPay {
            text-align: center;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            margin-top: 3em;
            margin-left: auto;
            margin-right: auto;
        }

        .h1Successfull {
            color: #3f7dc0;
        }

        .pSuccessfull {
            color: #555;
        }

        .buttonSuccessfull {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #3f7dc0;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
        }

        .buttonSusscess:hover {
            background-color: #233251;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server"></telerik:RadAjaxManager>
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
        <div class="m-2">
            <img height="40" src="../../Resources/Logo.png" />
            <img height="40" src="../../Resources/BYD-Logo.png" />
            <img height="40" src="../../Resources/Logo-Altan.jpeg" />
        </div>
        <hr />

        <asp:UpdatePanel ID="upGeneral" runat="server">            
            <ContentTemplate>
                <asp:HiddenField ID="hfMSISDN" runat="server" />
                <div class="container mt-4 text-center">
                    <div>
                        <h2 class="pb-4">En <strong>TECOMNET</strong> siempre tenemos los mejores precios.</h2>
                    </div>
                    <div id="ErrorMessageDiv" runat="server" class="alert alert-danger alert-dismissible fade show text-center" visible="false">
                        <asp:Literal runat="server" ID="FailureText" />
                    </div>
                    <asp:Panel runat="server" ID="pnlNumero" DefaultButton="btnValidaPhoneNumber" CssClass="containerWizzard">
                        <div class="containerTittle fw-bold">
                            Ingresa tú número
                        </div>
                        <div class="mb-3 pt-3">
                            <label for="txtPhonenumber" class="form-label fw-bold">Número de teléfono</label>
                            <asp:TextBox ID="txtPhonenumber" runat="server" placeholder="Introduce tu número a 10 dígitos" TextMode="Number"
                                CssClass="form-control m-auto" MaxLength="10" Width="300px"></asp:TextBox>
                            <label for="txtConfirmPhonenumber" class="form-label fw-bold">Confirma número de teléfono</label>
                            <asp:TextBox ID="txtConfirmPhonenumber" runat="server" placeholder="Introduce tu número a 10 dígitos" TextMode="Number"
                                CssClass="form-control m-auto" MaxLength="10" Width="300px"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnValidaPhoneNumber" runat="server" CssClass="btn btn-custom" Text="Continuar" ValidationGroup="ValidationPhonenumber" />
                        <div class="mt-2">
                            <asp:ValidationSummary ID="Validation" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="ValidationPhonenumber" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhonenumber" ValidationGroup="ValidationPhonenumber" ErrorMessage="La número es obligatorio." Display="None"></asp:RequiredFieldValidator>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirmPhonenumber" ValidationGroup="ValidationPhonenumber" ErrorMessage="La confirmación del número es obligatoria." Display="None"></asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="CompareValidator1" runat="server"
                                ControlToValidate="txtPhonenumber" ControlToCompare="txtConfirmPhonenumber" ErrorMessage="Los números deben ser iguales"
                                Operator="Equal" Type="Integer" Display="None" ValidationGroup="ValidationPhonenumber">
                            </asp:CompareValidator>

                            <asp:RegularExpressionValidator ID="revPhonenumber" runat="server"
                                ControlToValidate="txtPhonenumber"
                                ValidationExpression="^\d{10}$"
                                ErrorMessage="Debe ingresar exactamente 10 dígitos numéricos"
                                Display="None" ValidationGroup="ValidationPhonenumber">
                            </asp:RegularExpressionValidator>
                            <asp:RegularExpressionValidator ID="revConfirmPhonenumber" runat="server"
                                ControlToValidate="txtConfirmPhonenumber"
                                ValidationExpression="^\d{10}$"
                                ErrorMessage="Debe ingresar exactamente 10 dígitos numéricos"
                                Display="None" ValidationGroup="ValidationPhonenumber">
                            </asp:RegularExpressionValidator>
                        </div>
                    </asp:Panel>
                    <asp:Panel runat="server" ID="pnlRecarga" CssClass="containerWizzard" Visible="false">
                        <div class="row">
                            <h5 class="pb-2" style="background-color: #f8f9fa; color: #3f7dc0">Costo de plataforma: 3.5%</h5>
                            <asp:ListView ID="lvOffer" runat="server" DataKeyNames="OfferID,MVNOId,Price, OfferName, TotalAmt">
                                <ItemTemplate>
                                    <div class="col-sm-6 pb-3">
                                        <div class="card shadow-sm recarga-box">
                                            <div class="card-header text-center text-light" style="background-color: #34857c">
                                                <label class="recarga-header"><%# Eval("OfferName")%></label>
                                            </div>
                                            <div class="card-body text-center">
                                                <div class="col-md-12">
                                                    <label class="promo-title">Incluye</label>
                                                    <label class="promo-value"><%# String.Format("{0} MB", Eval("TotalAmt"))%></label>
                                                </div>
                                                <div class="col-md-12">
                                                    <label class="promo-title">Costo</label>
                                                    <label class="promo-value"><%# String.Format("{0:C2} MXN", Eval("Price"))%></label>
                                                </div>                                                
                                                <div class="text-center">
                                                    <asp:Button ID="btnPay" runat="server" Text="Lo quiero" CssClass="btn btn-primary" CommandName="Pay" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:ListView>
                        </div>
                    </asp:Panel>
                    <asp:Panel ID="pnlValidate" runat="server" Visible="false" CssClass="containerPay">
                        <h1 runat="server" id="h1Tittle"></h1>
                        <p runat="server" id="pMessage"></p>
                        <asp:HyperLink NavigateUrl="~/Views/Recharge/RechargeSure.aspx" ID="hlButton" runat="server" Text="Volver a la página principal"></asp:HyperLink>
                    </asp:Panel>
                    <p class="mt-3 text-muted" style="font-size: 13px;">1 Gigabyte (GB) equivale a 1,024 Megabytes (MB)</p>
                    <div class="mt-4">
                        <p>Tarjetas participantes</p>
                        <img src="https://img.icons8.com/color/48/visa.png" alt="Visa" />
                        <img src="https://img.icons8.com/color/48/mastercard.png" alt="MasterCard" />
                        <img src="https://img.icons8.com/color/48/amex.png" alt="Amex" />
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <footer class="text-center">
            <div class="container">
                <small>
                    <p>(c) <%: Now.Year %> por  TECOMNET.</p>
                </small>
                <br>
                <a href="https://www.tecomnet.mx/avisodeprivacidad/" class="text-white me-3">Términos y condiciones</a>
                <a href="https://www.tecomnet.mx/tecomnet-s-a-p-i-de-c-v-aviso-de-privacidad/" class="text-white">Aviso de privacidad</a>
            </div>
        </footer>
    </form>
</body>
</html>
