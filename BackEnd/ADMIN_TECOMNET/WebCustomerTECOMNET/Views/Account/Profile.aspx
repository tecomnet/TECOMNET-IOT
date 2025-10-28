<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="Profile.aspx.vb" Inherits="WebCustomerTECOMNET.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server"></telerik:RadScriptManager>
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Mis datos personales</label>
    </div>
    <div class="container containerGral">
        <div class="container-xxl">
            <div class="row pt-3">
                <div class="col-md-2">
                    <strong class="text-P">Género</strong>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlSex" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Femenino" Value="F" Selected="True" />
                        <asp:ListItem Text="Masculino" Value="M" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <strong class="text-P">RFC</strong>
                </div>
                <div class="col-md-4">
                    <telerik:RadTextBox ID="rtbRFC" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbRFC" ValidationGroup="Guardar"
                        ErrorMessage="El RFC obligatorio." Display="None" />
                </div>
            </div>
            <div class="row pt-1">
                <div class="col-md-2">
                    <strong class="text-PP">Apellido Paterno</strong>
                </div>
                <div class="col-md-4">
                    <telerik:RadTextBox ID="rtbPaternalSurname" runat="server" Width="100%"></telerik:RadTextBox>
                </div>
                <div class="col-md-2">
                    <strong class="text-P">Apellido Materno</strong>
                </div>
                <div class="col-md-4">
                    <telerik:RadTextBox ID="rtbMaternalSurname" runat="server" Width="100%"></telerik:RadTextBox>
                </div>
            </div>
            <div class="row pt-1">
                <div class="col-md-2">
                    <strong class="text-P">Nombre</strong>
                </div>
                <div class="col-md-4">
                    <telerik:RadTextBox ID="rtbName" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbName" ValidationGroup="Guardar"
                        ErrorMessage="El nombre es obligatorio." Display="None" />
                </div>
                <div class="col-md-2">
                    <strong class="text-P">Fecha de nacimiento:</strong>
                </div>
                <div class="col-md-4">
                    <telerik:RadDatePicker ID="rdpDateBirth" runat="server" Width="100%"></telerik:RadDatePicker>
                </div>
            </div>
            <div class="row pt-1">
                <div class="col-md-2">
                    <strong class="text-P">Nombre Completo:</strong>
                </div>
                <div class="col-md-10">
                    <telerik:RadTextBox ID="rtbCustomerName" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbCustomerName" ValidationGroup="Guardar"
                        ErrorMessage="El nombre completo es obligatorio." Display="None" />
                </div>
            </div>
            <div class="row pt-1">
                <div class="col-md-2">
                    <strong class="text-P">Email:</strong>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="tbEmail" runat="server" Width="100%" TextMode="Email" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="tbEmail" ValidationGroup="Guardar"
                        ErrorMessage="El email es obligatorio." Display="None" />
                </div>
                <div class="col-md-2">
                    <strong class="text-P">Teléfono:</strong>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="tbPhoneNumber" runat="server" Width="100%" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="tbPhoneNumber" ValidationGroup="Guardar"
                        ErrorMessage="El teléfono es obligatorio." Display="None" />
                </div>
            </div>
            <div class="row pt-1">
                <div class="col-md-2">
                    <strong class="text-P">País</strong>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Mexico" Value="Mexico" Selected="True" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <strong class="text-P">Estado</strong>
                </div>
                <div class="col-md-4">
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
                <div class="col-md-2">
                    <strong class="text-P">Colonia</strong>
                </div>
                <div class="col-md-4">
                    <telerik:RadTextBox ID="rtbCologne" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbCologne" ValidationGroup="Guardar"
                        ErrorMessage="La colonia obligatoria." Display="None" />
                </div>
                <div class="col-md-2">
                    <strong class="text-P">CP</strong>
                </div>
                <div class="col-md-4">
                    <telerik:RadTextBox ID="rtbZipCode" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbZipCode" ValidationGroup="Guardar"
                        ErrorMessage="El CP es obligatorio." Display="None" />
                </div>
            </div>
            <div class="row pt-1">
                <div class="col-md-2">
                    <strong class="text-P">Dirección</strong>
                </div>
                <div class="col-md-10">
                    <telerik:RadTextBox ID="rtbAddress" runat="server" Width="100%"></telerik:RadTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="rtbAddress" ValidationGroup="Guardar"
                        ErrorMessage="La dirección es obligatoria." Display="None" />
                </div>
            </div>
            <div class="row">
                <div class="col-12 text-Pcenter pt-3">
                    <asp:Button runat="server" ID="btnGuardar" Text="Guardar" CssClass="btn btn-primary" ValidationGroup="Guardar" Visible="false" />
                </div>
            </div>
            <div class="row mt-4">
                <h6 class="text-P">Para realizar cambios en su perfil, favor de enviar un correo a: <a href="mailto:comercial@tecomnet.mx">comercial@tecomnet.mx</a></h6>
            </div>
            <div class="row">
                <div class="col-12 text-Pcenter pt-3">
                    <asp:PlaceHolder ID="MessagePanel" runat="server"></asp:PlaceHolder>
                    <asp:ValidationSummary ID="Registro" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="Guardar" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
