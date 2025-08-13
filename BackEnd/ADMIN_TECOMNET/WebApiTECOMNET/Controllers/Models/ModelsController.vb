Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports ModelsTECOMNET.Enums.TECOMNET
Imports WebApiTECOMNET.API.Tecomnet
Imports System.IO
Imports System.Threading.Tasks
Imports System.Text.Json

Namespace Controllers.Models
    <Authorize>
    Public Class ModelsController
        Inherits ApiController
        <HttpGet>
        <Route("api/ObtenModelos")>
        Public Function ObtenModelos() As HttpResponseMessage
            Try
                Dim objController As New ControllerModelBYD
                Dim listModelsBYD As New List(Of BYDModels)
                listModelsBYD = objController.GetModelsBYD()

                If listModelsBYD.Count > 0 Then
                    Return Request.CreateResponse(HttpStatusCode.OK, listModelsBYD)
                Else
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No existe modelos disponibles."
                        })
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                Key .error = "Ocurrió un error al generar la solicitud.",
                Key .detalle = ex.Message
            })
                Return errorResponse
            End Try
        End Function
    End Class
End Namespace