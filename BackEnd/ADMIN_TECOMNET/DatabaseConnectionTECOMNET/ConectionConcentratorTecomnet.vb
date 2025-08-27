Imports System.Net.Http
Imports System.Text
Imports ModelsTECOMNET
Imports ModelsTECOMNET.GatewayTECOMNET
Imports System.Text.Json

Public Class ConectionConcentratorTecomnet
    Public Const url As String = "http://localhost/ConcentratorTecomnet/WebAPIConcentratorTecomnet/Api"
    Dim EndPoint As String = String.Empty
    Dim result As String = String.Empty
    Dim objError As New ErrorGateway

    Function PostGetToken(jsonData As String) As ErrorGateway
        EndPoint = String.Format("{0}/Account", url, jsonData)

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()

                Dim content As New StringContent("")

                ' Convertir los datos a JSON
                If jsonData <> String.Empty Then
                    content = New StringContent(jsonData, Encoding.UTF8, "application/json")
                End If

                ' Enviar la solicitud POST de forma síncrona
                Dim response As HttpResponseMessage = client.PostAsync(EndPoint, content).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    objError.CodeError = "0"
                    objError.ErrorMessage = ""
                    objError.Description = response.Content.ReadAsStringAsync().Result ' Devuelve la respuesta en formato JSON o texto
                    Return objError
                Else
                    objError.CodeError = "1"
                    objError.ErrorMessage = "Server Error"
                    objError.Description = response.Content.ReadAsStringAsync().Result ' Devuelve la respuesta en formato JSON o texto
                    Return objError
                End If
            End Using
        Catch ex As Exception
            objError.CodeError = "2"
            objError.ErrorMessage = "Server Error"
            objError.Description = ex.Message
            Return objError
        End Try
    End Function
    Function GetOffers(MVNOId As String, token As String) As ErrorGateway
        EndPoint = String.Format("{0}/Altan/GetOffers/{1}", url, MVNOId)

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()

                client.DefaultRequestHeaders.Add("Authorization", token)

                ' Enviar la solicitud GET de forma síncrona
                Dim response As HttpResponseMessage = client.GetAsync(EndPoint).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    objError.CodeError = "0"
                    objError.ErrorMessage = ""
                    objError.Description = response.Content.ReadAsStringAsync().Result ' Devuelve la respuesta en formato JSON o texto
                    Return objError
                Else
                    objError.CodeError = "1"
                    objError.ErrorMessage = "Server Error"
                    objError.Description = response.Content.ReadAsStringAsync().Result ' Devuelve la respuesta en formato JSON o texto
                    Return objError
                End If
            End Using
        Catch ex As Exception
            objError.CodeError = "2"
            objError.ErrorMessage = "Error interno"
            objError.Description = ex.Message
            Return objError
        End Try
    End Function
    Function GetProfile(MSISDN As String, token As String) As ErrorGateway
        Dim EndPoint As String = String.Empty
        Dim result As String = String.Empty
        EndPoint = String.Format("{0}/Altan/GetProfile/{1}", url, MSISDN)

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()

                client.DefaultRequestHeaders.Add("Authorization", token)

                ' Enviar la solicitud GET de forma síncrona
                Dim response As HttpResponseMessage = client.GetAsync(EndPoint).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    objError.CodeError = "0"
                    objError.ErrorMessage = ""
                    objError.Description = response.Content.ReadAsStringAsync().Result ' Devuelve la respuesta en formato JSON o texto
                    Return objError
                Else
                    objError.CodeError = "1"
                    objError.ErrorMessage = "Server Error"
                    objError.Description = response.Content.ReadAsStringAsync().Result ' Devuelve la respuesta en formato JSON o texto
                    Return objError
                End If
            End Using
        Catch ex As Exception
            objError.CodeError = "2"
            objError.ErrorMessage = "Error interno"
            objError.Description = ex.Message
            Return objError
        End Try
    End Function
    Function PostRechargeRequest(objRechargeRequest As RechargeRequest, token As String) As ErrorGateway
        EndPoint = String.Format("{0}/Altan/RechargeRequest", url)

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()
                client.DefaultRequestHeaders.Add("Authorization", token)
                'Dim content As New StringContent("")

                ' Convertir los datos a JSON                
                Dim sadds As String = JsonSerializer.Serialize(objRechargeRequest)
                Dim content = New StringContent(JsonSerializer.Serialize(objRechargeRequest), Encoding.UTF8, "application/json")


                ' Enviar la solicitud POST de forma síncrona
                Dim response As HttpResponseMessage = client.PostAsync(EndPoint, content).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    objError.CodeError = "0"
                    objError.ErrorMessage = ""
                    objError.Description = response.Content.ReadAsStringAsync().Result ' Devuelve la respuesta en formato JSON o texto
                    Return objError
                Else
                    objError.CodeError = "1"
                    objError.ErrorMessage = "Server Error"
                    objError.Description = response.Content.ReadAsStringAsync().Result ' Devuelve la respuesta en formato JSON o texto
                    Return objError
                End If
            End Using
        Catch ex As Exception
            objError.CodeError = "2"
            objError.ErrorMessage = "Server Error"
            objError.Description = ex.Message
            Return objError
        End Try
    End Function
End Class
