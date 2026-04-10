Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.GatewayTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports System.Text.Json
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET.LinkX
Imports ModelsTECOMNET
Public Class RechargeSure
    Inherits System.Web.UI.Page
    Const Claves As String = "{""UserName"":""USER.TECOMNET.USER_API"",""Password"":""VnhmNDg5dm03OXAx""}"

#Region "Properties"
#End Region
#Region "Functions and metods"
    Public Sub CreatePayLinkX(OfferName As String, TotalAmt As String, GUID As String)
        Dim objConection As New ConectionLinkX
        Dim objToken As New LinkXResult
        Dim objController As New ControllerProduct
        Dim ObjControllerSIM As New ControllerSIM

        objToken = objConection.Authorization()
        If objToken.ErrorID = LinkXErrors.Susssuccessful Then
            Dim objLoginLink As New AccessTokenLinkX
            Dim objPayment As New PaymentRequest
            objLoginLink = JsonSerializer.Deserialize(Of AccessTokenLinkX)(objToken.JSON)

            objPayment.amount = TotalAmt
            objPayment.displayAmount = TotalAmt
            objPayment.displayCurrency = "MXN"
            objPayment.language = "es"

            objPayment.email = "daniel.arzate@knesysplus.com"
            objPayment.commerceName = "TECOMNET"
            objPayment.supportEmail = "recargas@tecomnet.mx"
            objPayment.description = String.Format("{0} - {1} MB", OfferName, TotalAmt)
            objPayment.response_url = "https://tecomnet.net/TECOMNET/webhook/ValidatePay/"
            objPayment.redirectUrl = String.Format("https://tecomnet.net/TECOMNET/WebClient/Views/Recharge/RechargeSure.aspx?opr={0}", Securyty.EncodeStrToBase64(GUID))
            objPayment.order_id = GUID
            objPayment.imageUrl = "https://www.tecomnet.mx/wp-content/uploads/2024/11/888-removebg-preview.png"
            objPayment.origin = "ecommerce"
            Dim user As New PaymentRequest.UserDetail
            user.firstName = ""
            user.lastName = ""
            user.phone = ""
            user.email = ""
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
                Response.Redirect(objPaymentResponse.response.url)
            Else
                ShowPanelError(True, "Existe un error al procesar el pago con tarjeta, intenta nuevamante.")
            End If
        Else
            ShowPanelError(True, "Existe un error al procesar el pago con tarjeta, intenta nuevamante.")
        End If

    End Sub
    Private Function GetProductos() As Boolean
        Try
            Dim objErrorGateway As New ErrorGateway
            Dim token As String = String.Empty
            Dim SIMProfile As New SimTecomnet
            Dim ltsOffer As New List(Of OfferTecomnet)

            Dim objController As New ConectionConcentratorTecomnet
            objErrorGateway = objController.PostGetToken(Claves)

            If objErrorGateway.CodeError = "0" Then
                token = objErrorGateway.Description.Replace("""", "")
                objErrorGateway = objController.GetProfile(txtPhonenumber.Text, token)
                If objErrorGateway.CodeError = "0" Then
                    SIMProfile = JsonSerializer.Deserialize(Of SimTecomnet)(objErrorGateway.Description)
                    hfMSISDN.Value = SIMProfile.MSISDN
                    objErrorGateway = objController.GetOffers(SIMProfile.MVNOId, token)
                    If objErrorGateway.CodeError = "0" Then
                        ltsOffer = JsonSerializer.Deserialize(Of List(Of OfferTecomnet))(objErrorGateway.Description)
                        lvOffer.DataSource = ltsOffer
                        lvOffer.DataBind()
                        Return True
                    Else
                        ShowPanelError(True, objErrorGateway.ErrorMessage)
                        Return False
                    End If
                Else
                    ShowPanelError(True, objErrorGateway.ErrorMessage)
                    Return False
                End If
            Else
                ShowPanelError(True, objErrorGateway.ErrorMessage)
                Return False
            End If
        Catch ex As Exception
            ShowPanelError(True, "Error al conectarse al servidor remoto.")
            Return False
        End Try
        Return False
    End Function
    Private Sub ValidatePay(opr As Integer)
        pnlNumero.Visible = False
        pnlRecarga.Visible = False
        pnlValidate.Visible = True
        ' El pago fue exitoso                
        hlButton.CssClass = "buttonSuccessfull"
        h1Tittle.InnerText = "¡Gracias por tu pago!"
        h1Tittle.Attributes.Add("class", "h1Successfull")
        pMessage.InnerText = "Tu pago con tarjeta ha sido exitoso. Apreciamos tu confianza y preferencia."
        pMessage.Attributes.Add("class", "pSuccessfull")
    End Sub
#End Region
#Region "Events"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None

        If Not Page.IsPostBack Then
            Dim opr As String = Request.QueryString("opr")
            If opr <> String.Empty Then
                If Val(Securyty.DecodeBase64ToString(opr)) > 0 Then
                    ValidatePay(Val(Securyty.DecodeBase64ToString(opr)))
                End If
            End If
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
    Private Sub btnValidaPhoneNumber_Click(sender As Object, e As EventArgs) Handles btnValidaPhoneNumber.Click
        If GetProductos() Then
            pnlNumero.Visible = False
            pnlRecarga.Visible = True
        End If
    End Sub
    Private Sub lvProducts_ItemCommand(sender As Object, e As ListViewCommandEventArgs) Handles lvOffer.ItemCommand
        Try
            Dim objErrorGateway As New ErrorGateway
            Dim token As String = String.Empty

            Dim dataItem As ListViewDataItem = CType(e.Item, ListViewDataItem)
            Dim IMSI As String = hfMSISDN.Value
            Dim MVNOId As Integer = Val(lvOffer.DataKeys(dataItem.DisplayIndex).Values("MVNOId").ToString())
            Dim OfferID As Integer = Val(lvOffer.DataKeys(dataItem.DisplayIndex).Values("OfferID").ToString())
            Dim TotalAmount As Decimal = Decimal.Parse(lvOffer.DataKeys(dataItem.DisplayIndex).Values("Price").ToString())
            Dim OfferName As String = lvOffer.DataKeys(dataItem.DisplayIndex).Values("OfferName").ToString()
            Dim TotalAmt As String = lvOffer.DataKeys(dataItem.DisplayIndex).Values("TotalAmt").ToString()
            Dim PaymentMethodID As Integer = 4
            Dim objRechargeRequest As New RechargeRequest(IMSI, MVNOId, OfferID, TotalAmount, PaymentMethodID)
            Dim objResponseRechargeGateway As New ResponseRechargeGateway

            Dim objController As New ConectionConcentratorTecomnet
            objErrorGateway = objController.PostGetToken(Claves)

            If objErrorGateway.CodeError = "0" Then
                token = objErrorGateway.Description.Replace("""", "")
                objErrorGateway = objController.PostRechargeRequest(objRechargeRequest, token)
                If objErrorGateway.CodeError = "0" Then
                    objResponseRechargeGateway = JsonSerializer.Deserialize(Of ResponseRechargeGateway)(objErrorGateway.Description)
                    If objResponseRechargeGateway.OrderID <> String.Empty And objResponseRechargeGateway.RechargeId > 0 And objResponseRechargeGateway.RequestID > 0 Then
                        Select Case e.CommandName.ToString
                            Case "Pay"
                                CreatePayLinkX(OfferName, TotalAmt, objResponseRechargeGateway.OrderID)
                        End Select
                    End If
                    ShowPanelError(True, "Error al conectar con el servidor remoto")
                Else
                    ShowPanelError(True, objErrorGateway.ErrorMessage)
                End If
            Else
                ShowPanelError(True, objErrorGateway.ErrorMessage)
            End If
        Catch ex As Exception
            ShowPanelError(True, "Error al conectarse al servidor remoto.")
        End Try

    End Sub
    Public Sub ShowPanelError(Iserror As Boolean, text As String)
        ErrorMessageDiv.Visible = Iserror
        FailureText.Text = text
    End Sub
#End Region
End Class