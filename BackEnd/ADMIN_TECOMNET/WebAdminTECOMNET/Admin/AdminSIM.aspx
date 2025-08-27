<%@ Page Title="Administración de SIMS" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminSIM.aspx.vb" Inherits="WebAdminTECOMNET.AdminSIM" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../Css/bootstrap.min.css" />
    <script src="../Scripts/js/bootstrap.js"></script>
    <style>
        .RadGrid {
            border-radius: 30px;
            overflow: hidden;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager" runat="server" />    
    <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel" runat="server"></telerik:RadAjaxLoadingPanel>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Administración de SIM´s</label>
    </div>    
    <div class="container pt-2" style="max-width: 1045px">        
        <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
        <telerik:RadGrid ID="rgDashboard" runat="server" Width="100%" ShowFooter="true" PageSize="10" AllowPaging="true" AllowFilteringByColumn="True">
            <MasterTableView DataKeyNames="SIMID,MSISDN" NoMasterRecordsText="No hay registros que mostrar"
                CommandItemSettings-ShowRefreshButton="false" Width="100%" AutoGenerateColumns="false">
                <Columns>
                    <telerik:GridButtonColumn ButtonType="ImageButton" ImageUrl="~/Resources/images/cog.png" CommandName="Profile" 
                        HeaderTooltip="Ver detalles"></telerik:GridButtonColumn>
                    <telerik:GridButtonColumn ButtonType="ImageButton" ImageUrl="~/Resources/images/connect.png" CommandName="Resume"
                        HeaderTooltip="Activar servicio Altan"></telerik:GridButtonColumn>
                    <telerik:GridButtonColumn ButtonType="ImageButton" ImageUrl="~/Resources/images/disconnect.png" CommandName="Suspend"
                        HeaderTooltip="Desactivar servicio con Altan"></telerik:GridButtonColumn>                    
                    <telerik:GridButtonColumn ButtonType="ImageButton" CommandName="Delete" ImageUrl="~/Resources/images/cancel.png"
                        ConfirmText="¿Esta seguro de dar de baja el SIM?" UniqueName="Delete">
                    </telerik:GridButtonColumn>
                    <telerik:GridBoundColumn HeaderText="MSISDN" DataField="MSISDN" UniqueName="MSISDN"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="VIN" DataField="VIN" UniqueName="VIN"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Marca" DataField="Model" UniqueName="Model"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Cliente" DataField="CustomerName" UniqueName="CustomerName"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Activo" DataField="Active" UniqueName="Active"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="MB Usados" DataField="UsedMB" UniqueName="UsedMB"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains" 
                        DataFormatString="{0:N0}" ItemStyle-HorizontalAlign="Right">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="MB Disponibles" DataField="AvailableMB" UniqueName="AvailableMB"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains"  
                        DataFormatString="{0:N0}"  ItemStyle-HorizontalAlign="Right">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha de alta" DataField="CreationDate" UniqueName="CreationDate"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains" DataFormatString="{0:yyyy/MM/dd}"
                        ItemStyle-HorizontalAlign="Center">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Fecha de baja" DataField="LastDate" UniqueName="LastDate"
                        FilterDelay="1000" ShowFilterIcon="false" CurrentFilterFunction="Contains">
                    </telerik:GridBoundColumn>                    
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>                        
    </div>
</asp:Content>
