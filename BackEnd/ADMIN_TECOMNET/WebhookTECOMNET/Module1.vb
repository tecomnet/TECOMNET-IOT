Imports System.Net
Imports System.Text
Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports ModelsTECOMNET.TECOMNET.LinkX
Imports Newtonsoft.Json
Imports System.Threading.Tasks
Imports System.IO
Imports System.Runtime.InteropServices.WindowsRuntime

Module Module1
    Dim listener As New HttpListener
    Dim whiteListedIPs As List(Of String) = New List(Of String) From {
        "35.190.175.10",
        "32.245.215.98",
        "35.196.235.221",
        "34.228.25.112",
        "54.152.205.27",
        "52.5.233.163",
        "54.152.205.27",
        "127.0.0.1",
        "200.68.170.110"
    }
    Sub Main()
        ' Configura el prefijo para el servicio (puerto 8080 en este caso)
        'QA
        'listener.Prefixes.Add("http://localhost:80/TECOMNET/webhook/notificadorConsumo/")
        'listener.Prefixes.Add("http://localhost:80/TECOMNET/webhook/notificadorPrimerUso/")
        'listener.Prefixes.Add("http://localhost:80/TECOMNET/webhook/ValidatePay/")        

        'Produccion
        listener.Prefixes.Add("https://tecomnet.net/TECOMNET/webhook/notificadorConsumo/")
        listener.Prefixes.Add("https://tecomnet.net/TECOMNET/webhook/notificadorPrimerUso/")
        listener.Prefixes.Add("https://tecomnet.net/TECOMNET/webhook/ValidatePay/")

        listener.Start()

        Console.WriteLine("Esperando conexiones https")

        Task.Run(AddressOf HandleRequests)

        Console.WriteLine("Presiona ENTER para salir...")
        Console.ReadLine()
        listener.Stop()

    End Sub

    Async Function HandleRequests() As Task
        While listener.IsListening
            Try
                Dim context As HttpListenerContext = Await listener.GetContextAsync()
                Await ProcessRequest(context)
            Catch ex As Exception
                Console.WriteLine($"Error en la escucha: {ex.Message}")
            End Try
        End While
    End Function

    Async Function ProcessRequest(context As HttpListenerContext) As Task
        Dim request As HttpListenerRequest = context.Request
        Dim response As HttpListenerResponse = context.Response

        Try

            Dim requestPath As String = request.Url.AbsolutePath

            ' Procesar según la ruta
            Select Case requestPath
                Case "/TECOMNET/webhook/notificadorConsumo/"
                    Dim resultado As Boolean = Await ProcesarNotificacionAltan(context, request, response)
                Case "/TECOMNET/webhook/ValidatePay/"
                    Await ProcesarNotificacionEpayment(request, response)
                Case "/TECOMNET/webhook/notificadorPrimerUso/"
                    Await notificadorPrimerUso(request, response)
                Case Else
                    Console.WriteLine($"Ruta no reconocida: {requestPath}")
                    response.StatusCode = 404 ' Not Found
            End Select
        Catch ex As Exception
            response.StatusCode = 403
            response.Close()
        End Try
        response.Close()
    End Function
    Public Async Function ProcesarNotificacionAltan(context As HttpListenerContext, request As HttpListenerRequest, response As HttpListenerResponse) As Task(Of Boolean)
        ' Código asíncrono aquí
        Try
            ' Obtén la IP del cliente
            Dim clientIP As String = context.Request.RemoteEndPoint.Address.ToString()

            If whiteListedIPs.Contains(clientIP) Then
                Console.WriteLine(String.Format("----{0}----", Now.ToString))
                Console.WriteLine($"Conexión permitida desde {clientIP}")

                ' Procesa la notificación recibida (puedes adaptarlo a tus necesidades)
                Dim requestBody As String
                Using reader As New IO.StreamReader(request.InputStream, request.ContentEncoding)
                    requestBody = reader.ReadToEnd()
                End Using

                Console.WriteLine("Datos recibidos:")
                'Console.WriteLine(requestBody)

                Dim notification As NotificationAltan = JsonConvert.DeserializeObject(Of NotificationAltan)(requestBody)

                ' Acceso a las propiedades
                Console.WriteLine($"EventType: {notification.EventType}")
                Console.WriteLine($"Callback: {notification.Callback}")
                Console.WriteLine($"Event ID: {notification.Event.Id}")
                Console.WriteLine($"Total Amount: {notification.Event.Detail.TotalAmount}")

                ' Responde con 200 OK
                Dim responseString As String = "OK"
                Dim buffer() As Byte = Encoding.UTF8.GetBytes(responseString)
                response.ContentLength64 = buffer.Length
                response.OutputStream.Write(buffer, 0, buffer.Length)
            Else
                Console.WriteLine($"Conexión rechazada desde {clientIP}")
                ' Responde con 403 Forbidden
                response.StatusCode = 403
            End If
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            Return False
        End Try
        Return True
    End Function
    Public Async Function ProcesarNotificacionEpayment(request As HttpListenerRequest, response As HttpListenerResponse) As Task(Of Boolean)
        Try
            Console.WriteLine(String.Format("----{0}----", Now.ToString))
            Console.WriteLine(String.Format("----{0}----", "Payment TecomnetIOT"))

            ' Procesa la notificación recibida (puedes adaptarlo a tus necesidades)
            Dim requestBody As String
            Using reader As New IO.StreamReader(request.InputStream, request.ContentEncoding)
                requestBody = reader.ReadToEnd()
            End Using

            Console.WriteLine("Datos recibidos:")
            Console.WriteLine(requestBody)

            Dim order As PaymentOrder = JsonConvert.DeserializeObject(Of PaymentOrder)(requestBody)

            If order.estatus_pago = "approved" Then
                ' El pago fue exitoso                            
                Await ActulizaMovimientosTecomnet(order)
            End If

            ' Responde con 200 OK
            Dim responseString As String = "OK"
            Dim buffer() As Byte = Encoding.UTF8.GetBytes(responseString)
            response.ContentLength64 = buffer.Length
            response.OutputStream.Write(buffer, 0, buffer.Length)
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            Return False
        End Try
        Return True
    End Function
    Public Async Function ActulizaMovimientosTecomnet(ByVal objOrder As PaymentOrder) As Task(Of Boolean)
        Try
            Dim objProducto As New ModelsTECOMNET.TECOMNET.Product
            Dim objSIM As New SIM
            Dim objCustomerPayments As New CustomerPayments
            Dim objMovementHistory As New MovementHistory
            Dim objPaymentRequestTecomnet As New PaymentRequestTecomnet
            Dim objCustomer As New Customer

            Dim ObjControllerProduct As New ControllerProduct
            Dim ObjControllerPaymentRequest As New ControllerPaymentRequest
            Dim ObjControllerSIM As New ControllerSIM
            Dim ObjControllerCustomerPayments As New ControllerCustomerPayments
            Dim ObjControllerMovementHistory As New ControllerMovementHistory
            Dim ObjControllerCustomer As New ControllerCustomer

            objPaymentRequestTecomnet = ObjControllerPaymentRequest.GetPaymentRequest(objOrder.order_id)

            objProducto = ObjControllerProduct.GetProduct(objPaymentRequestTecomnet.ProductID)
            objSIM = ObjControllerSIM.GetSIM(objPaymentRequestTecomnet.SIMID)
            'Actualiza Saldo en la base de datos
            ObjControllerSIM.UpdateMB(objPaymentRequestTecomnet.SIMID, objProducto.MB)

            'Registramos compra de megas
            objCustomerPayments.ProductID = objPaymentRequestTecomnet.ProductID
            objCustomerPayments.SIMID = objPaymentRequestTecomnet.SIMID
            objCustomerPayments.CarID = objSIM.CarID
            objCustomerPayments.CustomerID = objPaymentRequestTecomnet.CustomerID
            objCustomerPayments.PurchaseDate = Now
            objCustomerPayments.PaymentAmount = objProducto.Price
            objCustomerPayments.MethodPayment = MethodPayment.Card
            objCustomerPayments.InvoiceRequired = False
            ObjControllerCustomerPayments.RegisterSale(objCustomerPayments)

            'Actualizamos orden de compra
            objPaymentRequestTecomnet.estatus_pago = objOrder.estatus_pago
            objPaymentRequestTecomnet.id_transaction = objOrder.id_transaction
            objPaymentRequestTecomnet.auth_number = objOrder.auth_number
            objPaymentRequestTecomnet.authCode = objOrder.authCode
            objPaymentRequestTecomnet.reason = objOrder.reason
            ObjControllerPaymentRequest.UpdatePaymentRequested(objPaymentRequestTecomnet)

            'Aperturamos servicio en Altan
            Dim objAltanResult As New AltanResult
            Dim objErrorAltan As New ErrorAltan
            Dim altan As New ConectionAltanRedes
            objAltanResult = altan.PostAPIService(objSIM.MSISDN, "", AltanApisMethod.Resumen)
            If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                Dim objOrderInfo As New OrderInfo
            Else
                objErrorAltan = JsonConvert.DeserializeObject(Of ErrorAltan)(objAltanResult.JSON)
            End If

            'Registramos movimiento en tabla de historia de movimientos
            objMovementHistory.MovementDate = Now
            objMovementHistory.MovementType = MovementType.ResumeService
            objMovementHistory.SIMID = objPaymentRequestTecomnet.SIMID
            objMovementHistory.Description = ""
            ObjControllerMovementHistory.AddMovement(objMovementHistory)

            'Notificamos por correo electronico la compra
            objCustomer = ObjControllerCustomer.GetCustomer(objPaymentRequestTecomnet.CustomerID)

            EmailSender.RechargeNotification(objCustomer.CustomerName, objProducto.ProductName, objCustomer.Email, TypeMessageMail.Recharge)

        Catch ex As Exception
            Console.Write(ex.Message)
            Return False
        End Try
        Return True
    End Function
    Public Async Function notificadorPrimerUso(request As HttpListenerRequest, response As HttpListenerResponse) As Task(Of Boolean)
        Try
            Console.WriteLine(String.Format("----{0}----", Now.ToString))
            Console.WriteLine(String.Format("----{0}----", "Primer Uso TecomnetIOT"))

            ' Procesa la notificación recibida (puedes adaptarlo a tus necesidades)
            Dim requestBody As String
            Using reader As New IO.StreamReader(request.InputStream, request.ContentEncoding)
                requestBody = reader.ReadToEnd()
            End Using

            Console.WriteLine("Datos recibidos:")
            Console.WriteLine(requestBody)

            'Dim order As PaymentOrder = JsonConvert.DeserializeObject(Of PaymentOrder)(requestBody)

            'If order.estatus_pago = "approved" Then
            '    ' El pago fue exitoso                            
            '    Await ActulizaMovimientosTecomnet(order)
            'End If

            ' Responde con 200 OK
            Dim responseString As String = "OK"
            Dim buffer() As Byte = Encoding.UTF8.GetBytes(responseString)
            response.ContentLength64 = buffer.Length
            response.OutputStream.Write(buffer, 0, buffer.Length)
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            Return False
        End Try
        Return True
    End Function
End Module
