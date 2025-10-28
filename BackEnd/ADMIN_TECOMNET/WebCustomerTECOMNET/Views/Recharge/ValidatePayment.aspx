<%@ Page Title="Pago" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="ValidatePayment.aspx.vb" Inherits="WebCustomerTECOMNET.ValidatePayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
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

        .h1Error {
            color: #f44336;
        }

        .pError {
            color: #555;
        }

        .buttonError {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #f44336;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
        }

            .buttonError:hover {
                background-color: #e53935;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="containerPay">
        <h1 runat="server" id="h1Tittle"></h1>
        <p runat="server" id="pMessage"></p>
        <asp:HyperLink NavigateUrl="../General/Home.aspx" ID="hlButton" runat="server" Text="Volver a la página principal"></asp:HyperLink>
    </div>

</asp:Content>
