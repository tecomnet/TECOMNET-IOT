<%@ Page Title="Historial de recargas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="ViewRecharge.aspx.vb" Inherits="WebCustomerTECOMNET.ViewRecharge" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        .RadGrid
        {
            border-radius: 30px;
            overflow: hidden;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Consulta tus recargas</label>
    </div>
    <div class="container pt-2" style="max-width:1045px">
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%">
            <MasterTableView DataKeyNames="PaymentID" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridBoundColumn HeaderText="Producto" DataField="ProductName" UniqueName="ProductName"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Auto" DataField="brand" UniqueName="brand"></telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Costo" DataField="PaymentAmount" UniqueName="PaymentAmount" DataFormatString="{0:C2}">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha" DataField="PurchaseDate" UniqueName="PurchaseDate">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Método de pago" DataField="MethodPayment" UniqueName="MethodPayment"></telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
    </div>
</asp:Content>
