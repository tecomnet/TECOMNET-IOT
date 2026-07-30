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
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server"></telerik:RadAjaxLoadingPanel>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="btnFind">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="rgResult" LoadingPanelID="RadAjaxLoadingPanel1" />
                    <telerik:AjaxUpdatedControl ControlID="rgInstallation" LoadingPanelID="RadAjaxLoadingPanel1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="rgResult">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="rgResult" LoadingPanelID="RadAjaxLoadingPanel1" />                    
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
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
                <telerik:RadTab Text="Instalación" Value="5"></telerik:RadTab>
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
            <telerik:RadPageView ID="rpvInstallation" runat="server" Width="100%">
                Desde:
                    <telerik:RadDatePicker ID="rdpStartInstallation" runat="server"></telerik:RadDatePicker>
                Hasta:
                    <telerik:RadDatePicker ID="rdpEndInstallation" runat="server"></telerik:RadDatePicker>
            </telerik:RadPageView>
        </telerik:RadMultiPage>
        <asp:Button ID="btnFind" runat="server" Width="100%" Text="Buscar" CssClass="w-100 btn btn-lg btn-primary mb-3" />
    </div>

    <telerik:RadGrid ID="rgResult" runat="server" Width="100%" Height="500px" AllowPaging="true"
        PageSize="50" AutoGenerateColumns="true">
        <MasterTableView CommandItemDisplay="Top" NoMasterRecordsText="No hay registros que mostrar" AllowFilteringByColumn="true">
            <CommandItemSettings ShowExportToExcelButton="true" ShowExportToPdfButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
        </MasterTableView>
        <ClientSettings>
            <Scrolling AllowScroll="true" />
        </ClientSettings>
    </telerik:RadGrid>
    <telerik:RadGrid ID="rgInstallation" runat="server" Width="100%" Height="500px" AllowPaging="true"
        PageSize="50" AutoGenerateColumns="false">
        <MasterTableView CommandItemDisplay="Top" NoMasterRecordsText="No hay registros que mostrar">
            <CommandItemSettings ShowExportToExcelButton="true" ShowExportToPdfButton="false" ShowAddNewRecordButton="false" ShowRefreshButton="false" />
            <Columns>
                <telerik:GridBoundColumn HeaderText="VIN" UniqueName="VIN" DataField="VIN"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderText="ICCID" UniqueName="ICCID" DataField="ICCID"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderText="FechaInstalacion" UniqueName="FechaInstalacion" DataField="FechaInstalacion"></telerik:GridBoundColumn>
                <telerik:GridBoundColumn HeaderText="Estado" UniqueName="Estado" DataField="Estado"></telerik:GridBoundColumn>
                <telerik:GridTemplateColumn HeaderText="VersionAnterior" UniqueName="VersionAnterior">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlVersionAnterior" runat="server" Text='<%# Eval("VersionAnterior")%>'
                            NavigateUrl='<%# "javascript:openImageModal(1,""" + Eval("VIN") + """)" %>'>
                        </asp:HyperLink>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridTemplateColumn HeaderText="VersionActual" UniqueName="VersionActual">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlVersionActual" runat="server" Text='<%# Eval("VersionActual")%>'
                            NavigateUrl='<%# "javascript:openImageModal(2,""" + Eval("VIN") + """)" %>'>
                        </asp:HyperLink>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridTemplateColumn HeaderText="SIMAnterior" UniqueName="SIM_Anterior">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlSIM_Anterior" runat="server" Text='<%# Eval("SIM_Anterior")%>'
                            NavigateUrl='<%# "javascript:openImageModal(3,""" + Eval("VIN") + """)" %>'>
                        </asp:HyperLink>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>
                <telerik:GridTemplateColumn HeaderText="Conectividad" UniqueName="Conectividad">
                    <ItemTemplate>
                        <asp:HyperLink ID="Conectividad" runat="server" Text='<%# Eval("Conectividad")%>'
                            NavigateUrl='<%# "javascript:openImageModal(4,""" + Eval("VIN") + """)" %>'>
                        </asp:HyperLink>
                    </ItemTemplate>
                </telerik:GridTemplateColumn>                
            </Columns>
        </MasterTableView>
        <ClientSettings>
            <Scrolling AllowScroll="true" />
        </ClientSettings>
    </telerik:RadGrid>
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server" ClientIDMode="Static" Behaviors="Close" ShowContentDuringLoad="false" VisibleStatusbar="false"
        ReloadOnShow="true" EnableShadow="true">
    </telerik:RadWindowManager>
    <script type="text/javascript">
        function openImageModal(tipo, VIN) {
            VIN
            var manager = $find("RadWindowManager1");
            var wnd = manager.open("ViewEvidence.aspx?tipo=" + tipo + "&VIN=" + VIN, "ImageWindow");
            wnd.setSize(500, 500);
            wnd.center();
            return false;
        }
    </script>
</asp:Content>
