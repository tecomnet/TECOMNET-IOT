Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports System.Text.Json
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports Stripe
Imports Stripe.Checkout
Public Class ValidatePayment
    Inherits System.Web.UI.Page
#Region "Properties"
    Private Property Customer As ModelsTECOMNET.TECOMNET.Customer
        Get
            Return Session("Usuario")
        End Get
        Set(value As ModelsTECOMNET.TECOMNET.Customer)
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
    Public Property ProductID As Integer
        Get
            Return Request.QueryString("pi")
        End Get
        Set(value As Integer)
            Request.QueryString("pi") = value
        End Set
    End Property
#End Region
#Region "Events"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' Configura Stripe con tu clave secreta
        Stripe.StripeConfiguration.ApiKey = "sk_test_51LnMvwKiq6K7O7gkb1ImNEZqWKaklqYFbAKGCh0AsUfhDnwO9R0Ye1dTqLd6KrlgfJcP8FCAhrUJXJyE97L2ybUB00TtNJBg8t"

        ' Recupera el ID de la sesión desde la URL
        Dim sessionId As String = Request.QueryString("session_id")

        If Not String.IsNullOrEmpty(sessionId) Then
            Dim service As New SessionService()
            Dim session As Session = service.Get(sessionId)

            If session.PaymentStatus = "paid" Then
                ' El pago fue exitoso                
                hlButton.CssClass = "buttonSuccessfull"
                h1Tittle.InnerText = "¡Gracias por tu pago!"
                h1Tittle.Attributes.Add("class", "h1Successfull")
                pMessage.InnerText = "Tu pago con tarjeta ha sido exitoso. Apreciamos tu confianza y preferencia."
                pMessage.Attributes.Add("class", "pSuccessfull")
                ActulizaMovimientosTecomnet()
            Else
                ' Algo salió mal                
                hlButton.CssClass = "buttonError"
                h1Tittle.InnerText = "¡El pago no se completó.!"
                h1Tittle.Attributes.Add("class", "h1Error")
                pMessage.InnerText = "Tu pago con tarjeta no ha sido exitoso. Por favor intentalo nuevamente."
                pMessage.Attributes.Add("class", "pError")
            End If
        Else
            hlButton.CssClass = "buttonError"
            h1Tittle.InnerText = "¡El pago no se completó.!"
            h1Tittle.Attributes.Add("class", "h1Error")
            pMessage.InnerText = "No se encontró información de la sesión."
            pMessage.Attributes.Add("class", "pError")
        End If

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
#End Region
#Region "Function and metods"
    Private Sub ActulizaMovimientosTecomnet()
        Dim objProducto As New ModelsTECOMNET.TECOMNET.Product
        Dim objSIM As New SIM
        Dim objCustomerPayments As New CustomerPayments
        Dim objMovementHistory As New MovementHistory

        Dim ObjControllerProduct As New ControllerProduct
        Dim ObjControllerSIM As New ControllerSIM
        Dim ObjControllerCustomerPayments As New ControllerCustomerPayments
        Dim ObjControllerMovementHistory As New ControllerMovementHistory

        objProducto = ObjControllerProduct.GetProduct(ProductID)
        objSIM = ObjControllerSIM.GetSIM(SIMID)
        'Actualiza Saldo en la base de datos
        ObjControllerSIM.UpdateMB(SIMID, objProducto.MB)

        'Registramos compra de megas
        objCustomerPayments.ProductID = ProductID
        objCustomerPayments.SIMID = SIMID
        objCustomerPayments.CarID = objSIM.CarID
        objCustomerPayments.CustomerID = Customer.CustomerID
        objCustomerPayments.PurchaseDate = Now
        objCustomerPayments.PaymentAmount = objProducto.Price
        objCustomerPayments.MethodPayment = MethodPayment.Card
        objCustomerPayments.InvoiceRequired = False
        ObjControllerCustomerPayments.RegisterSale(objCustomerPayments)

        'Aperturamos servicio en Altan
        Dim objAltanResult As New AltanResult
        Dim objErrorAltan As New ErrorAltan
        Dim altan As New ConectionAltanRedes
        objAltanResult = altan.PostAPIService(objSIM.MSISDN, "", AltanApisMethod.Resumen)
        If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
            Dim objOrderInfo As New OrderInfo
        Else
            objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
        End If

        'Registramos movimiento en tabla de historia de movimientos
        objMovementHistory.MovementDate = Now
        objMovementHistory.MovementType = MovementType.ResumeService
        objMovementHistory.SIMID = SIMID
        objMovementHistory.Description = ""
        ObjControllerMovementHistory.AddMovement(objMovementHistory)


    End Sub
#End Region
End Class

