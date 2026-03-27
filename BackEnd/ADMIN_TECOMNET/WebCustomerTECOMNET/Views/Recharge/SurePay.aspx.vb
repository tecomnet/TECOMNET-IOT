Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.LinkX
Imports System.Text.Json
Public Class SurePay
    Inherits System.Web.UI.Page
    Public Const Comision As Double = 0.035
#Region "Properties"
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
    Public Property ProductID As Integer
        Get
            Return Request.QueryString("pi")
        End Get
        Set(value As Integer)
            Request.QueryString("pi") = value
        End Set
    End Property
    Private Property objPaymentRequested As PaymentRequestTecomnet
        Get
            Return ViewState("PaymentRequested")
        End Get
        Set(value As PaymentRequestTecomnet)
            ViewState("PaymentRequested") = value
        End Set
    End Property
#End Region
#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If ProductID = 0 Or SIMID = 0 Then
                Response.Redirect("~/Views/Recharge/Recharge.aspx")
            End If
            GetProduct()
            CreatePayLinkX()
        End If
    End Sub
#End Region
#Region "Functions and metods"
    Public Sub GetProduct()
        Dim objController As New ControllerProduct
        Dim objProduct As New Product
        objProduct = objController.GetProduct(ProductID)
        lblProduct.Text = objProduct.ProductName
        lblMB.Text = String.Format("{0}", IIf(objProduct.MB = 1, "DATOS ILIMITADOS", objProduct.MB & " MB"))
        lblPrice.Text = String.Format("{0:C2}", objProduct.Price)
        lblUsoPlataforma.Text = String.Format("{0:C2}", GetAmount(objProduct.Price * Comision))
        lblTotal.Text = String.Format("{0:C2} ", objProduct.Price + GetAmount(objProduct.Price * Comision))
    End Sub
    Public Sub CreatePayLinkX()
        Dim objConection As New ConectionLinkX
        Dim objToken As New LinkXResult
        Dim objController As New ControllerProduct
        Dim objProduct As New Product
        Dim ObjControllerSIM As New ControllerSIM
        Dim objSIM As New SIM
        Dim objControllerPaymentRequest As New ControllerPaymentRequest
        Dim objPaymentRequest As New PaymentRequestTecomnet
        Dim nuevoGuid As Guid = Guid.NewGuid()
        Dim OrderID As String = String.Format("{0}|{1}", "BYD", nuevoGuid.ToString())

        objProduct = objController.GetProduct(ProductID)
        objSIM = ObjControllerSIM.GetSIM(Me.SIMID)
        objPaymentRequest.RequestID = 0
        objPaymentRequest.OrderID = OrderID
        objPaymentRequest.SIMID = Me.SIMID
        objPaymentRequest.ProductID = Me.ProductID
        objPaymentRequest.CarID = objSIM.CarID
        objPaymentRequest.CustomerID = Me.Customer.CustomerID
        objPaymentRequest.estatus_pago = "created"
        objPaymentRequest.id_transaction = ""
        objPaymentRequest.auth_number = ""
        objPaymentRequest.authCode = ""
        objPaymentRequest.reason = ""
        objPaymentRequest.CreationDate = Now


        objPaymentRequest.RequestID = objControllerPaymentRequest.AddPaymentRequest(objPaymentRequest)

        If objPaymentRequest.RequestID > 0 Then
            Me.objPaymentRequested = objPaymentRequest
            objToken = objConection.Authorization()
            If objToken.ErrorID = LinkXErrors.Susssuccessful Then
                Dim objLoginLink As New AccessTokenLinkX
                Dim objPayment As New PaymentRequest
                objLoginLink = JsonSerializer.Deserialize(Of AccessTokenLinkX)(objToken.JSON)

                objPayment.amount = objProduct.Price + GetAmount(objProduct.Price * Comision)
                objPayment.displayAmount = objProduct.Price + GetAmount(objProduct.Price * Comision)
                'objPayment.amount = 10
                'objPayment.displayAmount = 5
                objPayment.displayCurrency = "MXN"
                objPayment.language = "es"
                'objPayment.displayCurrency = "USD"
                'objPayment.language = "en"
                'QA
                'objPayment.email = "mauricio.gomez@knesysplus.com"
                'objPayment.commerceName = "Comercio"
                'objPayment.supportEmail = "soporte@iomexi.com"
                'Produccion
                objPayment.email = "daniel.arzate@knesysplus.com"
                objPayment.commerceName = "TECOMNET"
                objPayment.supportEmail = "recargas@tecomnet.mx"
                objPayment.description = String.Format("{0} - {1} MB", objProduct.ProductName, objProduct.MB)
                objPayment.response_url = "https://tecomnet.net/TECOMNET/webhook/ValidatePay/"
                objPayment.redirectUrl = "https://tecomnet.net/TECOMNET/WebClient/Views/General/Home.aspx"
                objPayment.order_id = objPaymentRequest.OrderID
                objPayment.imageUrl = "https://www.tecomnet.mx/wp-content/uploads/2024/11/888-removebg-preview.png"
                'objPayment.origin = "plugin"
                objPayment.origin = "ecommerce"
                Dim user As New PaymentRequest.UserDetail
                user.firstName = Customer.Name
                user.lastName = Customer.PaternalSurname
                user.phone = Customer.PhoneNumber
                user.email = Customer.Email
                'user.country = "MX"
                'user.state = "Jal"
                'user.locality = "Guadalajara"
                'user.address = "Av 123"
                'user.zipCode = "4510"
                user.country = ""
                user.state = ""
                user.locality = ""
                user.address = ""
                user.zipCode = ""
                objPayment.userData = user

                Dim objRequest As New LinkXResult
                objRequest = objConection.PaymentRequest(objLoginLink.response.token, JsonSerializer.Serialize(objPayment))

                If objRequest.ErrorID = LinkXErrors.Susssuccessful Then
                    Dim objPaymentResponse As New PaymentResponse
                    objPaymentResponse = JsonSerializer.Deserialize(Of PaymentResponse)(objRequest.JSON)
                    ViewState("Url") = objPaymentResponse.response.url
                Else
                    Response.Write("Existe un error al procesar el pago con tarjeta, intenta nuevamante.")
                End If
            Else
                Response.Write("Existe un error al procesar el pago con tarjeta, intenta nuevamante.")
            End If
        Else
            Response.Write("Existe un error al procesar el pago con tarjeta, intenta nuevamante.")
        End If

    End Sub

    Protected Sub btnContinuar_Click(sender As Object, e As EventArgs)
        Me.objPaymentRequested.estatus_pago = "wait"
        Dim objControllerPaymentRequest As New ControllerPaymentRequest
        If objControllerPaymentRequest.UpdatePaymentRequest(Me.objPaymentRequested) > 0 Then
            Response.Redirect(ViewState("Url").ToString)
        Else
            Response.Write("Existe un error al procesar el pago con tarjeta, intenta nuevamante.")
        End If
    End Sub
#End Region
    Public Function GetAmount(mount As Double) As Double
        Return Math.Ceiling(mount * 100) / 100
    End Function
End Class