<%@ Page Title="Inicio" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="Home.aspx.vb" Inherits="WebCustomerTECOMNET.Home" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        .containerCar {
            text-align: center;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 1024px;
            margin-top: .5em;
            margin-left: auto;
            margin-right: auto;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid text-center pt-2 containerTitle">
        <asp:Label ID="lblCustomerName" runat="server" CssClass="h3 text-white"></asp:Label>
    </div>
    <asp:ListView ID="lvSIMS" runat="server" DataKeyNames="SIMID">
        <ItemTemplate>
            <div class="containerCar">
                <div class="col-12 text-center">
                    <strong>
                        <asp:Label ID="Label1" runat="server" CssClass="h3 font-weight-bold" Style="color: #3f7dc0"><%# String.Format("{0} - {1}", Eval("Model"), Eval("VIN")) %></asp:Label>
                    </strong>
                </div>
                <div class="col-12 text-center">
                    <strong>
                        <asp:Label ID="lblPlan" runat="server" CssClass="h3 font-weight-bold" Style="color: #3f7dc0"><%# Eval("Producto") %></asp:Label>
                    </strong>
                </div>
                <div class="text-center pt-2">
                    <strong>
                        <label>Datos incluidos:</label><asp:Label CssClass="text-success" ID="lblAssignedMG" runat="server"><%# IIf(Eval("AdditionalMB") = 1, "DATOS ILIMITADOS", String.Format(" {0} MB", Eval("AssignedMB"))) %></asp:Label></strong>
                </div>
                <div class="text-center">
                    <strong>
                        <label>Datos adicionales:</label><asp:Label CssClass="text-success" ID="Label2" runat="server"><%# IIf(Eval("AdditionalMB") = 1, "---", String.Format(" {0} MB", Eval("AdditionalMB"))) %></asp:Label></strong>
                </div>
                <div class="text-center">
                    <strong>
                        <label>Datos disponibles:</label><asp:Label CssClass="text-success" ID="lblAvailableMG" runat="server"><%# IIf(Eval("AdditionalMB") = 1, "---", String.Format(" {0} MB", Eval("AvailableMB"))) %></asp:Label></strong>
                </div>
                <div class="text-center">
                    <strong>
                        <label>Vigencia:</label><asp:Label CssClass="text-success" ID="lblExpirationDate" runat="server"><%# String.Format(" {0:dd/MM/yyyy}", Eval("ExpirationDate")) %></asp:Label></strong>
                </div>
                <div class="text-center">
                    <strong>
                        <label>Estatus de conectividad: </label>
                        <asp:Label CssClass="text-success" ID="lblEstatus" runat="server"><%#IIf(Eval("EstausAltan") = "", "No Activo", Eval("EstausAltan")) %></asp:Label></strong>
                </div>
                <div class="text-center pt-3">
                    <asp:HyperLink ID="hlMore" runat="server" Text="Quiero más datos" CssClass="btn btn-primary" NavigateUrl='<%# String.Format("~/Views/Recharge/Recharge.aspx?sd={0}", Eval("SIMID")) %>'></asp:HyperLink>
                </div>
            </div>
        </ItemTemplate>
    </asp:ListView>
</asp:Content>
