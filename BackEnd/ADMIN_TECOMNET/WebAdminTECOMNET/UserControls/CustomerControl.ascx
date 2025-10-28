<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CustomerControl.ascx.vb" Inherits="WebAdminTECOMNET.CustomerControl" %>
<h2>Registrar cliente</h2>
<asp:HiddenField ID="hfCustomerID" runat="server" />
<div class="row pb-1">
    <div class="col-md-1">
        <strong class="text-P">Género</strong>
    </div>
    <div class="col-md-5">
        <asp:DropDownList ID="ddlSex" runat="server" CssClass="form-control">
            <asp:ListItem Text="Femenino" Value="F" Selected="True" />
            <asp:ListItem Text="Masculino" Value="M" />
        </asp:DropDownList>
    </div>
    <div class="col-md-1">
        <strong class="text-P">RFC</strong>
    </div>
    <div class="col-md-5">
        <telerik:RadTextBox ID="rtbRFC" runat="server" Width="100%"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbRFC" ValidationGroup="GuardarCustomer"
            ErrorMessage="El RFC obligatorio." Display="None" />
    </div>
</div>
<div class="row pb-1">
    <div class="col-md-1">
        A. Paterno:
    </div>
    <div class="col-md-5">
        <telerik:RadTextBox ID="rtbPaternalSurname" runat="server" Width="100%" ClientEvents-OnValueChanged="NombreCompleto"></telerik:RadTextBox>
    </div>
    <div class="col-md-1">
        A. Materno:
    </div>
    <div class="col-md-5">
        <telerik:RadTextBox ID="rtbMaternalSurname" runat="server" Width="100%" ClientEvents-OnValueChanged="NombreCompleto"></telerik:RadTextBox>
    </div>
</div>
<div class="row pb-1">
    <div class="col-md-1">
        Nombre:
    </div>
    <div class="col-md-5">
        <telerik:RadTextBox ID="rtbName" runat="server" Width="100%" ClientEvents-OnValueChanged="NombreCompleto"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbName" ValidationGroup="GuardarCustomer"
            ErrorMessage="El nombre es obligatorio." Display="None" />
    </div>
    <div class="col-md-1">
        F. nacimiento:
    </div>
    <div class="col-md-5">
        <telerik:RadDatePicker ID="rdpDateBirth" runat="server" Width="100%"></telerik:RadDatePicker>
    </div>
</div>
<div class="row pb-1">
    <div class="col-md-1">
        N. Completo:
    </div>
    <div class="col-md-11">
        <telerik:RadTextBox ID="rtbCustomerName" runat="server" Width="100%"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbCustomerName" ValidationGroup="GuardarCustomer"
            ErrorMessage="El nombre completo es obligatorio." Display="None" />
    </div>
</div>
<div class="row pb-1">
    <div class="col-md-1">
        Email:
    </div>
    <div class="col-md-5">
        <asp:TextBox ID="tbEmail" runat="server" Width="100%" TextMode="Email" CssClass="form-control"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEmail" ValidationGroup="GuardarCustomer"
            ErrorMessage="El email es obligatorio." Display="None" />
    </div>
    <div class="col-md-1">
        Teléfono:
    </div>
    <div class="col-md-5">
        <asp:TextBox ID="tbPhoneNumber" runat="server" Width="100%" CssClass="form-control"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="tbPhoneNumber" ValidationGroup="GuardarCustomer"
            ErrorMessage="El teléfono es obligatorio." Display="None" />
    </div>
</div>
<div class="row pb-1">
    <div class="col-md-1">
        <strong class="text-P">País</strong>
    </div>
    <div class="col-md-5">
        <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control">
            <asp:ListItem Text="Mexico" Value="Mexico" Selected="True" />
        </asp:DropDownList>
    </div>
    <div class="col-md-1">
        <strong class="text-P">Estado</strong>
    </div>
    <div class="col-md-5">
        <asp:DropDownList ID="ddlState" runat="server" CssClass="form-control">
            <asp:ListItem Text="Aguascalientes" Value="Aguascalientes"></asp:ListItem>
            <asp:ListItem Text="Baja California" Value="Baja California"></asp:ListItem>
            <asp:ListItem Text="Baja California Sur" Value="Baja California Sur"></asp:ListItem>
            <asp:ListItem Text="Campeche" Value="Campeche"></asp:ListItem>
            <asp:ListItem Text="Chiapas" Value="Chiapas"></asp:ListItem>
            <asp:ListItem Text="Chihuahua" Value="Chihuahua"></asp:ListItem>
            <asp:ListItem Text="Coahuila de Zaragoza" Value="Coahuila de Zaragoza"></asp:ListItem>
            <asp:ListItem Text="Colima" Value="Colima"></asp:ListItem>
            <asp:ListItem Text="Ciudad de México" Value="Ciudad de México" Selected="True"></asp:ListItem>
            <asp:ListItem Text="Durango" Value="Durango"></asp:ListItem>
            <asp:ListItem Text="Guanajuato" Value="Guanajuato"></asp:ListItem>
            <asp:ListItem Text="Guerrero" Value="Guerrero"></asp:ListItem>
            <asp:ListItem Text="Hidalgo" Value="Hidalgo"></asp:ListItem>
            <asp:ListItem Text="Jalisco" Value="Jalisco"></asp:ListItem>
            <asp:ListItem Text="México" Value="México"></asp:ListItem>
            <asp:ListItem Text="Michoacán de Ocampo" Value="Michoacán de Ocampo"></asp:ListItem>
            <asp:ListItem Text="Morelos" Value="Morelos"></asp:ListItem>
            <asp:ListItem Text="Nayarit" Value="Nayarit"></asp:ListItem>
            <asp:ListItem Text="Nuevo León" Value="Nuevo León"></asp:ListItem>
            <asp:ListItem Text="Oaxaca" Value="Oaxaca"></asp:ListItem>
            <asp:ListItem Text="Puebla" Value="Puebla"></asp:ListItem>
            <asp:ListItem Text="Querétaro" Value="Querétaro"></asp:ListItem>
            <asp:ListItem Text="Quintana Roo" Value="Quintana Roo"></asp:ListItem>
            <asp:ListItem Text="San Luis Potosí" Value="San Luis Potosí"></asp:ListItem>
            <asp:ListItem Text="Sinaloa" Value="Sinaloa"></asp:ListItem>
            <asp:ListItem Text="Sonora" Value="Sonora"></asp:ListItem>
            <asp:ListItem Text="Tabasco" Value="Tabasco"></asp:ListItem>
            <asp:ListItem Text="Tamaulipas" Value="Tamaulipas"></asp:ListItem>
            <asp:ListItem Text="Tlaxcala" Value="Tlaxcala"></asp:ListItem>
            <asp:ListItem Text="Veracruz de Ignacio de la Llave" Value="Veracruz de Ignacio de la Llave"></asp:ListItem>
            <asp:ListItem Text="Yucatán" Value="Yucatán"></asp:ListItem>
            <asp:ListItem Text="Zacatecas" Value="Zacatecas"></asp:ListItem>
        </asp:DropDownList>
    </div>
</div>
<div class="row pt-1">
    <div class="col-md-1">
        <strong class="text-P">Colonia</strong>
    </div>
    <div class="col-md-5">
        <telerik:RadTextBox ID="rtbCologne" runat="server" Width="100%"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbCologne" ValidationGroup="GuardarCustomer"
            ErrorMessage="La colonia obligatoria." Display="None" />
    </div>
    <div class="col-md-1">
        <strong class="text-P">CP</strong>
    </div>
    <div class="col-md-5">
        <telerik:RadTextBox ID="rtbZipCode" runat="server" Width="100%"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbZipCode" ValidationGroup="GuardarCustomer"
            ErrorMessage="El CP es obligatorio." Display="None" />
    </div>
</div>
<div class="row pt-1">
    <div class="col-md-1">
        <strong class="text-P">Dirección</strong>
    </div>
    <div class="col-md-11">
        <telerik:RadTextBox ID="rtbAddress" runat="server" Width="100%"></telerik:RadTextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbAddress" ValidationGroup="GuardarCustomer"
            ErrorMessage="La dirección es obligatoria." Display="None" />
    </div>
</div>



<telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
    <script type="text/javascript">
        function NombreCompleto() {
            var paterno = trim($find("<%= rtbPaternalSurname.ClientID %>").get_value());
            var materno = trim($find("<%= rtbMaternalSurname.ClientID %>").get_value());
            var nombres = trim($find("<%= rtbName.ClientID %>").get_value());
            $find("<%= rtbPaternalSurname.ClientID %>").set_value(paterno);
            $find("<%= rtbMaternalSurname.ClientID %>").set_value(materno);
            $find("<%= rtbName.ClientID %>").set_value(nombres);

            $find("<%= rtbCustomerName.ClientID %>").set_value(trim(((paterno == "") ? "" : paterno) + ((materno == "") ? "" : ' ' + materno) + ((nombres == "") ? "" : ' ' + nombres)));            
        }
        function trim(stringToTrim) {
            return stringToTrim.replace(/^\s+|\s+$/g, "");
        }
    </script>
</telerik:RadScriptBlock>