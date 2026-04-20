Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Public Class Recharge
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
    Public Property SIMID As Integer
        Get
            Return Request.QueryString("sd")
        End Get
        Set(value As Integer)
            Request.QueryString("sd") = value
        End Set
    End Property

#End Region
#Region "Event"
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

        If Not Page.IsPostBack Then
            GetProductos()
            llenaDatos()
            If Val(SIMID) = 0 Then
                pnlAutos.Visible = True
                lvProducts.Visible = False
            Else
                pnlAutos.Visible = False
                lvProducts.Visible = True
            End If
        End If
    End Sub

#End Region
#Region "Function"
    Private Sub GetProductos()
        Dim objController As New ControllerProduct
        lvProducts.DataSource = objController.GetAvailableProducts(3)
        lvProducts.DataBind()
    End Sub
    Public Sub llenaDatos()
        Dim objController As New ControllerSIM
        Dim objSIMDetail As New SIMDetail
        lvSIMS.DataSource = objController.GetSIMsAssociateCustomer(Customer.CustomerID)
        lvSIMS.DataBind()
    End Sub
#End Region
End Class