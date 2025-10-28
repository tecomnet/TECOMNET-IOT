Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnectionTECOMNET

Namespace Controllers.BYD
    <Authorize>
    Public Class CustomerController
        Inherits ApiController
        <HttpGet>
        <Route("api/BYD/ObtenerClientes/Activos")>
        Public Function GetActiveCustomer() As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String

                sqlQuery = "SELECT CustomerName AS Nombre,FORMAT(DateBirth, 'dd/MM/yyyy') AS FechaDeCumpleaños,FORMAT(CreationDate, 'dd/MM/yyyy') AS FechaDeAlta,Country AS PAIS,State AS Estado FROM Customer"
                sqlQuery += " WHERE LastDate IS NULL"

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
                    .FileName = "ClientesActivos.csv"
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
        <HttpGet>
        <Route("api/BYD/ObtenerClientes/Inactivos")>
        Public Function GetNotActiveCustomer() As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String

                sqlQuery = "SELECT m.Model AS Modelo,VIN, Year,FORMAT(c.CreationDate, 'dd/MM/yyyy') AS FechaDeAlta,FORMAT(c.LastDate, 'dd/MM/yyyy') AS FechaDeBaja FROM Car as c inner join BYDModels AS m on c.ModelID = m.modelid"
                sqlQuery += " WHERE c.LastDate IS NOT NULL"

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
                    .FileName = "ClientesInactivos.csv"
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