Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET

Public Class Registration
    Inherits System.Web.UI.Page
#Region "Property"
    Private Property Customer As Customer
        Get
            Return ViewState("Customer")
        End Get
        Set(value As Customer)
            ViewState("Customer") = value
        End Set
    End Property
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub btnRegresarDatos_Click(sender As Object, e As EventArgs) Handles btnRegresarDatos.Click
        cambiaPanel(1, 0)
    End Sub
    Private Sub btnGuardarRegistro_Click(sender As Object, e As EventArgs) Handles btnGuardarRegistro.Click
        Dim objController As New ControllerCustomer
        Dim objCustomer As Customer = Me.Customer

        objCustomer.Password = Securyty.Cifrar(rtbContrasena.Text)
        objCustomer.RegistrationDate = Now

        If objController.RegistrationCustomer(objCustomer) = 0 Then
            DisplayMesage("No se pudo dar de alta el usuario.", False)
        Else
            DisplayMesage("El usuario se registro correctamente.", True)
            pnlSeguridad.Visible = False
            hlLogin.Visible = True
        End If

    End Sub
    Private Sub btnValidaDatos_Click(sender As Object, e As EventArgs) Handles btnValidaDatos.Click
        Dim objCustomer As New Customer
        objCustomer = GetCustomer()
        If objCustomer.CustomerID > 0 Then
            Me.Customer = objCustomer
            cambiaPanel(0, 1)
        Else
            DisplayMesage("No coinciden los datos con los guardados en nuestra base de datos. ", False)
        End If
    End Sub
#End Region
#Region "Sub and Function"
    Public Sub cambiaPanel(ByVal General As Boolean, ByVal Securyty As Boolean)
        pnlGeneral.Visible = General
        pnlSeguridad.Visible = Securyty
    End Sub
    Public Function GetCustomer() As Customer
        Dim objController As New ControllerCustomer
        Dim objCustomer As New Customer
        objCustomer = objController.ValidateCustomerRegistration(rtbVIN.Text, rtbRFC.Text, tbCorreo.Text)
        Return objCustomer
    End Function
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='alert alert-{0} alert-dismissible fade show text-center'>{1}</div>", IIf(success, "success", "danger"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
#End Region
End Class