Imports System.Configuration
Imports System.Text.Json
Imports System.Net
Imports System.Net.Http
Imports System.Text
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Public Class ConectionAltanRedes
#Region "POST"
    Function PostAPIService(MSISDN As String, jsonData As String, Method As AltanApisMethod) As AltanResult
        Dim EndPoint As String = String.Empty
        Dim token As String = String.Empty
        Dim url As String = String.Empty

        If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
            url = ConfigurationManager.AppSettings("UrlBaseTest").ToString
        Else
            url = ConfigurationManager.AppSettings("UrlBaseProd").ToString
        End If

        Select Case Method
            Case AltanApisMethod.Resumen
                EndPoint = String.Format("{0}/v1/subscribers/{1}/resume", url, MSISDN)
            Case AltanApisMethod.Suspend
                EndPoint = String.Format("{0}/v1/subscribers/{1}/suspend", url, MSISDN)
            Case AltanApisMethod.ChangeOffer
                EndPoint = String.Format("{0}/v1/subscribers/{1}", url, MSISDN)
        End Select

        System.Diagnostics.Debug.WriteLine("ENDPOINT: " & EndPoint)

        Dim result As New AltanResult
        result.ErrorID = AltanErrors.Unknown
        result.JSON = String.Empty
        result.StatusCode = 0
        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()

                Dim content As New StringContent("")
                ' Configurar los encabezados (headers)                
                If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
                    token = "6c2NnSWNMRmxhNmZwWHVFVw=="
                Else
                    Dim objAltanResult As New AltanResult
                    objAltanResult = PostAPIAccessToken()
                    If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                        Dim objToken As New AccessToken
                        objToken = JsonSerializer.Deserialize(Of AccessToken)(objAltanResult.JSON)
                        token = objToken.accessToken
                    Else
                        result.ErrorID = AltanErrors.Mistake
                        result.JSON = objAltanResult.JSON
                        Return result
                    End If
                End If

                client.DefaultRequestHeaders.Add("Authorization", "Bearer " & token)

                If String.IsNullOrWhiteSpace(jsonData) Then
                    Throw New Exception("JSON vacío, no se puede enviar request a Altán")
                End If

                ' Convertir los datos a JSON
                content = New StringContent(jsonData, Encoding.UTF8, "application/json")

                Console.WriteLine("ENDPOINT: " & EndPoint)
                Console.WriteLine("BODY: " & jsonData)
                Console.WriteLine("TOKEN>>>>>>>>>>>>>>>>>>>>>>>>>>: " & token)
                ' Enviar la solicitud POST de forma síncrona

                Dim response As HttpResponseMessage


                Select Case Method
                    Case AltanApisMethod.Resumen
                        response = client.PostAsync(EndPoint, content).Result
                    Case AltanApisMethod.Suspend
                        response = client.PostAsync(EndPoint, content).Result
                    Case AltanApisMethod.ChangeOffer
                        Dim request As New HttpRequestMessage(New HttpMethod("PATCH"), EndPoint)
                        request.Content = content
                        response = client.SendAsync(request).Result
                End Select

                ' Verificar si la respuesta fue exitosa
                'If response.IsSuccessStatusCode Then
                '    result.ErrorID = AltanErrors.Susssuccessful
                '    result.JSON = response.Content.ReadAsStringAsync().Result
                '    Return result ' Devuelve la respuesta en formato JSON o texto
                'Else
                '    If response.StatusCode = HttpStatusCode.BadRequest Then
                '        result.ErrorID = AltanErrors.Mistake
                '        result.JSON = response.Content.ReadAsStringAsync().Result
                '        Return result
                '        ' Return ""
                '    ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                '        result.ErrorID = AltanErrors.Mistake
                '        result.JSON = response.Content.ReadAsStringAsync().Result
                '        Return result
                '    ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                '        result.ErrorID = AltanErrors.Mistake
                '        result.JSON = response.Content.ReadAsStringAsync().Result
                '        Return result
                '    End If
                'End If

                Dim responseBody As String = response.Content.ReadAsStringAsync().Result

                Console.WriteLine("STATUS: " & response.StatusCode)
                Console.WriteLine("BODY: " & responseBody)

                If response.IsSuccessStatusCode Then
                    result.ErrorID = AltanErrors.Susssuccessful

                Else
                    result.ErrorID = AltanErrors.Mistake
                End If

                result.StatusCode = response.StatusCode
                result.JSON = responseBody
                Return result

            End Using
        Catch ex As Exception
            'Retorna los errores
            result.ErrorID = AltanErrors.Mistake
            result.JSON = ex.ToString()
            Return result
        End Try
        Return result
    End Function
    Function PostAPIAccessToken() As AltanResult

        Dim result As New AltanResult
        result.ErrorID = AltanErrors.Unknown
        result.JSON = String.Empty

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()
                Dim UrlEndPoint As String
                Dim content As New StringContent("")
                ' Configurar los encabezados (headers)
                client.DefaultRequestHeaders.Add("Authorization", "Basic " & ConfigurationManager.AppSettings("ALConexion").ToString) '                

                If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
                    UrlEndPoint = ConfigurationManager.AppSettings("UrlTokenTest").ToString
                Else
                    UrlEndPoint = ConfigurationManager.AppSettings("UrlTokenProd").ToString
                End If

                ' Enviar la solicitud POST de forma síncrona
                Dim response As HttpResponseMessage = client.PostAsync(UrlEndPoint, content).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    result.ErrorID = AltanErrors.Susssuccessful
                    result.JSON = response.Content.ReadAsStringAsync().Result
                    Return result ' Devuelve la respuesta en formato JSON o texto
                Else
                    If response.StatusCode = HttpStatusCode.BadRequest Then
                        result.ErrorID = AltanErrors.Mistake
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                        ' Return ""
                    ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                        result.ErrorID = AltanErrors.Mistake
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                    ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                        result.ErrorID = AltanErrors.Mistake
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                    End If
                End If
            End Using
        Catch ex As Exception
            Return result
        End Try
        Return result
    End Function
#End Region
#Region "GET"
    Function GetAPIService(MSISDN As String, Method As AltanApisMethod) As AltanResult
        Dim EndPoint As String = String.Empty
        Dim token As String = String.Empty
        Dim url As String = String.Empty

        If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
            url = ConfigurationManager.AppSettings("UrlBaseTest").ToString
        Else
            url = ConfigurationManager.AppSettings("UrlBaseProd").ToString
        End If

        Select Case Method
            Case AltanApisMethod.Profile
                EndPoint = String.Format("{0}/v1/subscribers/{1}/profile", url, MSISDN)
        End Select

        Dim result As New AltanResult
        result.ErrorID = AltanErrors.Unknown
        result.JSON = String.Empty

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()

                ' Configurar los encabezados (headers)                
                If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
                    token = "6c2NnSWNMRmxhNmZwWHVFVw=="
                Else
                    Dim objAltanResult As New AltanResult
                    objAltanResult = PostAPIAccessToken()
                    If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                        Dim objToken As New AccessToken
                        objToken = JsonSerializer.Deserialize(Of AccessToken)(objAltanResult.JSON)
                        token = objToken.accessToken
                    Else
                        result.ErrorID = AltanErrors.Mistake
                        result.JSON = objAltanResult.JSON
                        Return result
                    End If
                End If

                client.DefaultRequestHeaders.Add("Authorization", "Bearer " & token)

                ' Enviar la solicitud GET de forma síncrona
                Dim response As HttpResponseMessage = client.GetAsync(EndPoint).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    result.ErrorID = AltanErrors.Susssuccessful
                    result.JSON = response.Content.ReadAsStringAsync().Result
                    Return result ' Devuelve la respuesta en formato JSON o texto
                Else
                    If response.StatusCode = HttpStatusCode.BadRequest Then
                        result.ErrorID = AltanErrors.Mistake
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                        ' Return ""
                    ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                        result.ErrorID = AltanErrors.Mistake
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                    ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                        result.ErrorID = AltanErrors.Mistake
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                    End If
                End If
            End Using
        Catch ex As Exception
            Return result
        End Try
        Return result
    End Function
#End Region
End Class