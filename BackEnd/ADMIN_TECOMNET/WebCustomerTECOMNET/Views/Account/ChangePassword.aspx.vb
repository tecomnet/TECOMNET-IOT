Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET

Public Class ChangePassword
    Inherits System.Web.UI.Page
#Region "Property"
    Private Property Customer As Customer
        Get
            Return Session("Usuario")
        End Get
        Set(value As Customer)
            Session("Usuario") = value
        End Set
    End Property
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Protected Sub ChangePassword_Click(sender As Object, e As EventArgs)
        Dim objController As New ControllerCustomer

        If objController.ChangePassword(Customer.CustomerID, Securyty.Cifrar(txtContrasenaActual.Text), Securyty.Cifrar(txtNuevaContrasena.Text)) > 0 Then
            DisplayMesage("La contraseña se cambio correctamente", True)
        Else
            DisplayMesage("No se puedo realizar el cambio, intente nuevamente por favor.", False)
        End If
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub

End Class