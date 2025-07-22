<%@ Page Title="Reportes" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="Reports.aspx.vb" Inherits="WebAdminTECOMNET.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        .RadGrid {
            border-radius: 30px;
            overflow: hidden;
        }

        .containerGralAux {
            background: #f8f9fa;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-left: auto;
            margin-right: auto;
        }

        .containerTitleAux {
            background: #3f7dc0;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-left: auto;
            margin-right: auto;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager" runat="server" />
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel" runat="server"></telerik:RadAjaxLoadingPanel>
    <div class="container-fluid text-center pt-2 containerTitleAux" width="100%">
        <label class="h3 text-white">Reportes</label>
    </div>    
        <div class="container-fluid containerGralAux">
            <telerik:RadTabStrip ID="rtsReports" runat="server" Width="100%" MultiPageID="rmpReports">
                <Tabs>
                    <telerik:RadTab Text="Clientes" Value="1" Selected="True"></telerik:RadTab>
                    <telerik:RadTab Text="Vehículos" Value="2"></telerik:RadTab>
                    <telerik:RadTab Text="SIMS" Value="3"></telerik:RadTab>
                    <telerik:RadTab Text="Recargas" Value="4"></telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
            <telerik:RadMultiPage ID="rmpReports" runat="server" Width="100%">
                <telerik:RadPageView ID="rpvClientes" runat="server" Selected="true" Width="100%">
                    <telerik:RadRadioButtonList ID="rrblCustomer" runat="server">
                        <Items>
                            <telerik:ButtonListItem Text="Activos" Value="1" Selected="true" />
                            <telerik:ButtonListItem Text="No Activos" Value="2" />
                        </Items>
                    </telerik:RadRadioButtonList>
                </telerik:RadPageView>
                <telerik:RadPageView ID="rpvVehículos" runat="server" Width="100%">
                    <telerik:RadRadioButtonList ID="rrblVehiculos" runat="server">
                        <Items>
                            <telerik:ButtonListItem Text="Activos" Value="1" Selected="true" />
                            <telerik:ButtonListItem Text="No Activos" Value="2" />
                        </Items>
                    </telerik:RadRadioButtonList>
                </telerik:RadPageView>
                <telerik:RadPageView ID="rpvSIMS" runat="server" Width="100%">
                    <telerik:RadRadioButtonList ID="rrblSIMS" runat="server">
                        <Items>
                            <telerik:ButtonListItem Text="Activos" Value="1" Selected="true" />
                            <telerik:ButtonListItem Text="No Activos" Value="2" />
                        </Items>
                    </telerik:RadRadioButtonList>
                </telerik:RadPageView>
                <telerik:RadPageView ID="rpvPay" runat="server" Width="100%">
                    Desde:
                    <telerik:RadDatePicker ID="rdpStart" runat="server"></telerik:RadDatePicker>
                    Hasta:
                    <telerik:RadDatePicker ID="rdpEnd" runat="server"></telerik:RadDatePicker>
                </telerik:RadPageView>
            </telerik:RadMultiPage>
            <asp:Button ID="btnFind" runat="server" Width="100%" Text="Buscar" CssClass="w-100 btn btn-lg btn-primary mb-3" />
        </div>

        <telerik:RadGrid ID="rgResult" runat="server" Width="100%" Height="500px" AllowPaging="true"
            PageSize="50" AutoGenerateColumns="true">
            <MasterTableView CommandItemDisplay="Top" NoMasterRecordsText="No hay registros que mostrar">
                <CommandItemSettings ShowExportToExcelButton="true" ShowExportToPdfButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
            </MasterTableView>
            <ClientSettings>
                <Scrolling AllowScroll="true" />
            </ClientSettings>
        </telerik:RadGrid>
    
</asp:Content>
