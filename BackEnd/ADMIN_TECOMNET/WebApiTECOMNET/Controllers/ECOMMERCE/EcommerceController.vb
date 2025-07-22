Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports WebApiTECOMNET.API.Tecomnet
Imports System.IO
Imports System.Threading.Tasks

Namespace Controllers.BYD
    <Authorize>
    Public Class EcommerceController
        Inherits ApiController
        <HttpGet>
        <Route("api/BYD/Ecommerce/B2B/GetCustomers")>
        Public Function GetCustomers() As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String

                sqlQuery = "select Nombre AS [Name], Apellidos AS LastNames, Email, telefono AS Phone from catusuarios"

                'dt = controller.TransactionsQuerysEco(sqlQuery).Tables(0)

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
                    .FileName = "Customers.csv"
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
        <Route("api/BYD/Ecommerce/B2B/GetProducts")>
        Public Function GetProducts() As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String

                sqlQuery = "select Clave_SAE AS SAECode, Nombre_SAE AS [Name],Clasificacion AS [Classification], " &
                        " Sub_Clasificacion AS SubClassification, descripcion AS [Description], precio_unitario AS Price, " &
                        " existencias AS Stock, habilitado AS [Enabled] from [dbo].[catProductos]"

                'dt = controller.TransactionsQuerysEco(sqlQuery).Tables(0)

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
                    .FileName = "Products.csv"
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
        <Route("api/BYD/Ecommerce/B2B/GetSales")>
        Public Function GetSales() As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String

                sqlQuery = "select Clave_SAE AS SAECode, Nombre_SAE AS [Name],Clasificacion AS [Classification], " &
                        " Sub_Clasificacion AS SubClassification, descripcion AS [Description], precio_unitario AS Price, " &
                        " existencias AS Stock, habilitado AS [Enabled] from [dbo].[catProductos]"

                'dt = controller.TransactionsQuerysEco(sqlQuery).Tables(0)

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
                    .FileName = "Products.csv"
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