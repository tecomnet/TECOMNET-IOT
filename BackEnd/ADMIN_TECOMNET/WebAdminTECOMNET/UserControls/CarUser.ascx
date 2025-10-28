<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CarUser.ascx.vb" Inherits="WebAdminTECOMNET.CarUser" %>
<h2>Registrar vehículo</h2>
<asp:HiddenField ID="hfCarID" runat="server" />
<div class="row mb-2">
    <div class="col-md-1">
        Modelo:
    </div>
    <div class="col-md-3">
        <telerik:RadComboBox ID="rcbModel" runat="server" Width="100%"></telerik:RadComboBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rcbModel" ValidationGroup="GuardarCar"
            ErrorMessage="El modelo obligatorio." Display="None" />
    </div>
    <div class="col-md-1">
        VIN:
    </div>
    <div class="col-md-3">
        <telerik:RadTextBox ID="rtbVIN" runat="server" Width="100%"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbVIN" ValidationGroup="GuardarCar"
            ErrorMessage="El VIN es obligatorio." Display="None" />
    </div>
    <div class="col-md-1">
        Año:
    </div>
    <div class="col-md-3">
        <telerik:RadNumericTextBox ID="rntbYear" runat="server" Width="100%" MinValue="2000">
            <NumberFormat DecimalDigits="0" GroupSeparator="" />
        </telerik:RadNumericTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rntbYear" ValidationGroup="GuardarCar"
            ErrorMessage="El año es obligatorio." Display="None" />
    </div>
</div>
<div class="row">
    <div class="col-md-1">
        Marca:
    </div>
    <div class="col-md-7">
        <telerik:RadTextBox ID="rtbMarca" runat="server" Width="100%"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbMarca" ValidationGroup="GuardarCar"
            ErrorMessage="La marca es obligatoria." Display="None" />
    </div>
    <div class="col-md-1">
        Color:
    </div>
    <div class="col-md-3">
        <telerik:RadTextBox ID="rtbColor" runat="server" Width="100%"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbColor" ValidationGroup="GuardarCar"
            ErrorMessage="El color es obligatorio." Display="None" />
    </div>
</div>