<%@ Page Title="Recarga" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="Recharge.aspx.vb" Inherits="WebCustomerTECOMNET.Recharge" %>

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
            margin-top: .3em;
            margin-left: auto;
            margin-right: auto;
        }
        .containerProduct {            
            background: #f8f9fa;            
            max-width: 1024px;            
            margin-left: auto;
            margin-right: auto;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Mas datos para tu BYD</label>
    </div>
    <asp:Panel ID="pnlAutos" runat="server" Visible="false">
        <div class="text-center pt-2">
            <h4 class="text-white">Selecciona un vehiculo</h4>
        </div>
        <asp:ListView ID="lvSIMS" runat="server" DataKeyNames="SIMID">
            <ItemTemplate>
                <div class="containerCar container">
                    <div class="row">
                        <div class="col-md-10">
                            <strong>
                                <label cssclass="font-weight-bold pr-1" class="text-P"><%# String.Format("{0} - {1}", Eval("Model"), Eval("VIN")) %></label>
                                <label cssclass="font-weight-bold" class="text-P"><%# String.Format(" - {0}", Eval("Producto")) %></label>
                            </strong>
                        </div>
                        <div class="text-center col-md-2">
                            <asp:HyperLink ID="hlMore" runat="server" Text="Seleccionar" CssClass="btn btn-primary" NavigateUrl='<%# String.Format("~/Views/Recharge/Recharge.aspx?sd={0}", Eval("SIMID")) %>'></asp:HyperLink>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </asp:Panel>
    <asp:ListView ID="lvProducts" runat="server" DataKeyNames="ProductID">
        <ItemTemplate>
            <div class="row pt-2">
                <div class="col">
                    <div class="card shadow-sm containerProduct">
                        <div class="card-header text-center text-light" style="background-color: #34857c">
                            <h5><%# Eval("ProductName")%></h5>
                        </div>
                        <div class="card-body text-center">
                            <p class="card-text">
                                <h4><strong><%# String.Format("{0}", IIf(Eval("MB") = 1, "DATOS ILIMITADOS", Eval("MB") & " MB"))%> </strong></h4>
                            </p>
                            <p class="card-text">
                                <strong><%# String.Format("Costo: {0:C2} MXN", Eval("Price"))%> </strong>
                            </p>
                            <p class="card-text">
                                <strong>Vigencia: Al corte de tu factuta </strong>
                            </p>
                            <div class="text-center">
                                <asp:HyperLink ID="hlPay" runat="server" Text="Lo quiero" CssClass="btn btn-primary" NavigateUrl='<%# String.Format("~/Views/Recharge/SurePay.aspx?sd={0}&pi={1}", Me.SIMID, Eval("ProductID"))%>' />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:ListView>
    <div class="pt-5">
        <label class="text-white-50">*Las tarifas publicadas incluyen el 16% de IVA</label><br />
        <label class="text-white-50">*1 Gigabyte(GB) equivale a 1,024 Megabytes (MB)</label>
    </div>
</asp:Content>
