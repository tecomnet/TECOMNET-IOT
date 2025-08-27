Imports System.Text.Json
Imports System.Net
Imports System.Net.Http
Imports System.Text
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports System.IO
Imports ModelsTECOMNET

Public Class ConectionLinkX
    ''QA
    'Dim jsonDataKey As String = "{""email"":""mauricio.gomez@knesysplus.com"",""apiKey"":""api-73370894-ac9b-4355-83e3-7f5cc3fb651d-yurc9c""}"
    'Public Const urlGetToken As String = "https://devpddf.lklpay.com.mx:3000/api/auth/ecommerce/login"
    'Public Const urlGetResponse As String = "https://devtransactions.lklpay.com.mx:3004/api/link/m/ecommerce"
    ''Produccion TOKEN JTH
    'Dim jsonDataKey As String = "{""email"":""daniel.arzate@knesysplus.com"",""apiKey"":""api-d3e20c6a-103b-45d7-b9df-96c3ac28b4dd-6wp0xi""}"
    'Public Const urlGetToken As String = "https://lklapi.lklpay.com.mx/pef1d7972c8ro/auth/ecommerce/login"
    'Public Const urlGetResponse As String = "https://lklapi.lklpay.com.mx/f2c65bd1289pm/link/ecommerce"
    'Produccion TOKEN TECOMNET
    Dim jsonDataKey As String = "{""email"":""h.martinez@tecomnet.mx"",""apiKey"":""api-113f2717-c412-48d1-8da3-d3df93b2954c-29vpbp""}"
    Public Const urlGetToken As String = "https://lklapi.lklpay.com.mx/pef1d7972c8ro/auth/ecommerce/login"
    Public Const urlGetResponse As String = "https://lklapi.lklpay.com.mx/f2c65bd1289pm/link/ecommerce"

#Region "POST"
    Function Authorization() As LinkXResult
        Dim result As New LinkXResult
        result.ErrorID = LinkXErrors.Unknown
        result.JSON = String.Empty

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()
                Dim content = New StringContent(jsonDataKey, Encoding.UTF8, "application/json")
                client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                Try
                    ' Enviar la solicitud POST
                    Dim response As HttpResponseMessage = client.PostAsync(urlGetToken, content).Result

                    ' Verificar si la respuesta fue exitosa
                    If response.IsSuccessStatusCode Then
                        result.ErrorID = LinkXErrors.Susssuccessful
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result ' Devuelve la respuesta en formato JSON o texto
                    Else
                        If response.StatusCode = HttpStatusCode.BadRequest Then
                            result.ErrorID = LinkXErrors.Mistake
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                            ' Return ""
                        ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                            result.ErrorID = LinkXErrors.Mistake
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                        ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                            result.ErrorID = LinkXErrors.Mistake
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                        End If
                    End If
                Catch ex As Exception
                    Return result
                End Try
            End Using
        Catch ex As Exception
            Return result
        End Try
        Return result
    End Function
    Function PaymentRequest(token As String, body As String) As LinkXResult
        Dim result As New LinkXResult
        result.ErrorID = LinkXErrors.Unknown
        result.JSON = String.Empty

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()
                Dim content = New StringContent(body, Encoding.UTF8, "application/json")
                client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " & token)
                Try
                    ' Enviar la solicitud POST
                    Dim response As HttpResponseMessage = client.PostAsync(urlGetResponse, content).Result

                    ' Verificar si la respuesta fue exitosa
                    If response.IsSuccessStatusCode Then
                        result.ErrorID = LinkXErrors.Susssuccessful
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result ' Devuelve la respuesta en formato JSON o texto
                    Else
                        If response.StatusCode = HttpStatusCode.BadRequest Then
                            result.ErrorID = LinkXErrors.Mistake
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                            ' Return ""
                        ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                            result.ErrorID = LinkXErrors.Mistake
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                        ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                            result.ErrorID = LinkXErrors.Mistake
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                        End If
                    End If
                Catch ex As Exception
                    Return result
                End Try
            End Using
        Catch ex As Exception
            Return result
        End Try
        Return result
    End Function
#End Region
End Class