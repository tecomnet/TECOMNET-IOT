Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnectionTECOMNET

Namespace Controllers.BYD
    <Authorize>
    Public Class RechargeController
        Inherits ApiController
        <HttpGet>
        <Route("api/BYD/ObtenerRecargas/Desde/{desde:datetime}/Hasta/{hasta:datetime}")>
        Public Function GetRecharge(desde As Date, hasta As Date) As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String

                sqlQuery = "select bm.Model AS Modelo, p.ProductName AS Paquete, PurchaseDate AS DiaDeCompra, CASE WHEN p.MB = 1 THEN 'ILIMITADO' ELSE CAST(p.MB AS NVARCHAR(10)) END AS MEGAS, " &
                      " CASE WHEN MethodPayment = 1 Then 'TDC' ELSE 'TRANSFERENCIA' END AS FormaDePago FROM CustomerPayments AS cp " &
                      " INNER JOIN [Product] As p On cp.ProductID = p.ProductID INNER JOIN Car As c On cp.CarID = c.CarID" &
                      " INNER JOIN BYDModels AS bm ON c.ModelID = bm.ModelId "
                sqlQuery += String.Format("WHERE CAST(PurchaseDate AS DATE) BETWEEN '{0:yyyy/MM/dd}' AND '{1:yyyy/MM/dd}'", desde, hasta)

                dt = controller.TransactionsQuerys(sqlQuery).Tables(0)

                ' Verifica si hay datos
                If dt.Rows.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                End If

                Dim csvData As String = Functions.ConvertirDataTableACSV(dt)

                ' Agregar BOM (Byte Order Mark) al inicio para evitar problemas de codificación
                Dim bom As Byte() = Encoding.UTF8.GetPreamble()
                Dim csvBytes As Byte() = Encoding.UTF8.GetBytes(csvData)
                Dim finalBytes As Byte() = bom.Concat(csvBytes).ToArray()

                ' Crear respuesta HTTP con el archivo CSV
                Dim response As New HttpResponseMessage(HttpStatusCode.OK)
                response.Content = New ByteArrayContent(finalBytes)
                response.Content.Headers.ContentType = New System.Net.Http.Headers.MediaTypeHeaderValue("text/csv")
                response.Content.Headers.ContentDisposition = New System.Net.Http.Headers.ContentDispositionHeaderValue("attachment") With {
                    .FileName = "Recargas.csv"
                }


                Return response

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                Key .error = "Ocurrió un error al generar el CSV.",
                Key .detalle = ex.Message
            })
                Return errorResponse
            End Try


        End Function
    End Class
End Namespace