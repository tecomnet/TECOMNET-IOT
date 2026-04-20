Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI

Public Class ViewRecharge
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'AlexSD 09042026 - Inicia Correccion para eliminar la cookie de ID al cerrar sesión, se agrega validación para evitar que se pueda acceder a la página sin iniciar sesión
        'Evitar cache (para botón atrás)
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.Cache.SetNoStore()
        Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1))

        'Validar sesión
        If Session("Usuario") Is Nothing Then
            FormsAuthentication.RedirectToLoginPage()
            Return
        End If
    End Sub
    Private Property Customer As Customer
        Get
            Return Session("Usuario")
        End Get
        Set(value As Customer)
            Session("Usuario") = value
        End Set
    End Property

    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerCustomerPayments
        rgDashboard.DataSource = objController.GetCustomerPaymentsDetails(Customer.CustomerID)
    End Sub
End Class