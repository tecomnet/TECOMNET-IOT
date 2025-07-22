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

Namespace Controllers.BYD
    <Authorize>
    Public Class SIMController
        Inherits ApiController

        '5.1	Consulta_de_perfil
        <HttpGet>
        <Route("api/BYD/ObtenerPerfil/{ICC}")>
        Public Function ObtenerPerfil(ICC As String) As HttpResponseMessage
            Try

                Dim objController As New ControllerSIM
                Dim objSIM As New SIM
                objSIM = objController.GetSIMByICCID(ICC)

                If Val(objSIM.SIMID) = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                Else
                    Dim objAltanResult As New AltanResult
                    Dim altan As New ConectionAltanRedes
                    Dim objErrorAltan As New ErrorAltan

                    objAltanResult = altan.GetAPIService(objSIM.MSISDN, AltanApisMethod.Profile)
                    If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                        Dim objProfile As New API.Tecomnet.Profile
                        Dim ObjControllerSIM As New ControllerSIM

                        Dim profile As New ResponseSubscriber
                        profile = JsonSerializer.Deserialize(Of ResponseSubscriber)(objAltanResult.JSON)

                        objProfile.MSISDN = objSIM.MSISDN
                        objProfile.IMSI = objSIM.IMSI
                        objProfile.Status = profile.ResponseSubscriber.Status.SubStatus
                        objProfile.CardPackage = objSIM.Producto
                        objProfile.APNStatus = "Active"

                        If profile.ResponseSubscriber.FreeUnits.Count > 0 Then
                            objProfile.DataUsage = (profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.TotalAmt - profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.UnusedAmt)
                        Else
                            objProfile.DataUsage = 0
                        End If

                        objProfile.TotalMB = (objSIM.AssignedMB + objSIM.AdditionalMB)
                        objProfile.ExpirationDate = objSIM.ExpirationDate

                        Return Request.CreateResponse(HttpStatusCode.OK, objProfile)
                    Else
                        objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .mensaje = "No hay datos disponibles."
                            })
                    End If
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
        '5.2	5.2	Batch_Consulta_Perfiles
        <HttpGet>
        <Route("api/BYD/ObtenerPerfiles/{Estatus}")>
        Public Function ObtenerPerfiles(Estatus As String) As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String

                Select Case Estatus
                    Case "Activo"
                        sqlQuery = "SELECT MSISDN, IMSI, CASE WHEN Active=1 THEN 'Active' ELSE 'NOT ACTIVE' END AS [Status], Producto AS CardPackage, 
                                    'Active' AS APNStatus, UsedMB AS DataUsage, AssignedMB + AdditionalMB AS TotalMB, CAST(ExpirationDate AS DATE) AS ExpirationDate 
                                    FROM SIM INNER JOIN [Product] AS p on SIM.ProductID = P.ProductID WHERE CompanyID=3 AND Active=1 --AND CarID IS NOT NULL"
                    Case "Inactivo"
                        sqlQuery = "SELECT MSISDN, IMSI, CASE WHEN Active=1 THEN 'Active' ELSE 'NOT ACTIVE' END AS [Status], Producto AS CardPackage, 
                                    'Active' AS APNStatus, UsedMB AS DataUsage, AssignedMB + AdditionalMB AS TotalMB, CAST(ExpirationDate AS DATE) AS ExpirationDate 
                                    FROM SIM INNER JOIN [Product] AS p on SIM.ProductID = P.ProductID WHERE CompanyID=3 AND Active=0 --AND CarID IS NOT NULL"
                    Case "All"
                        sqlQuery = "SELECT MSISDN, IMSI, CASE WHEN Active=1 THEN 'Active' ELSE 'NOT ACTIVE' END AS [Status], Producto AS CardPackage, 
                                    'Active' AS APNStatus, UsedMB AS DataUsage, AssignedMB + AdditionalMB AS TotalMB, CAST(ExpirationDate AS DATE) AS ExpirationDate 
                                    FROM SIM INNER JOIN [Product] AS p on SIM.ProductID = P.ProductID WHERE CompanyID=3 --AND Active=0 AND CarID IS NOT NULL"
                    Case Else
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                       Key .mensaje = "Selecciones una opción valida."
                       })
                End Select

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
                    .FileName = "Perfiles.csv"
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
        '5.3	Obtener_Consumo
        <HttpGet>
        <Route("api/BYD/ObtenerConsumo/{ICC}")>
        Public Function ObtenerConsumo(ICC As String) As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String

                sqlQuery = String.Format("SELECT SIM.ICCID, CreateDate AS TimeSpan, SUM(Total) AS DataUsage FROM CDRS INNER JOIN SIM ON CDRS.IMSI = SIM.IMSI 
										INNER JOIN [Product] AS P ON SIM.ProductID=P.ProductID
                                        WHERE SIM.ICCID = '{0}' AND CompanyID=3 --AND CarID IS NOT NULL
                                        GROUP BY SIM.ICCID,CreateDate ORDER BY CreateDate", ICC)
                dt = controller.TransactionsQuerys(sqlQuery).Tables(0)

                If dt.Rows.Count > 0 Then

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
                    .FileName = "Consumos.csv"
                }

                    Return response
                Else
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                Key .error = "Ocurrió un error al generar el CSV.",
                Key .detalle = ex.Message
            })
                Return errorResponse
            End Try
        End Function
        '5.4	Obtener_Recargas
        <HttpGet>
        <Route("api/BYD/ObtenerRecarga/{ICC}")>
        Public Function ObtenerRecarga(ICC As String) As HttpResponseMessage
            Try
                Dim dt As New DataTable
                Dim controller As New Controller
                Dim sqlQuery As String


                sqlQuery = String.Format("SELECT MSISDN,IMSI,P.ProductName AS CommercialOffer, CP.PurchaseDate AS TimeSpan, 
							CP.PaymentAmount AS Amount, 'Approved' AS [Status]
							FROM [dbo].[CustomerPayments] AS CP INNER JOIN SIM ON CP.SIMID=SIM.SIMID INNER JOIN [Product] AS P
							ON CP.ProductID = P.ProductID WHERE --SIM.Active=1 AND SIM.CarID IS NOT NULL AND
							SIM.ICCID='{0}' and CompanyID=3 ORDER BY CP.PurchaseDate", ICC)

                dt = controller.TransactionsQuerys(sqlQuery).Tables(0)

                If dt.Rows.Count > 0 Then
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
                Else
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                Key .error = "Ocurrió un error al generar el CSV.",
                Key .detalle = ex.Message
            })
                Return errorResponse
            End Try
        End Function
        '5.5	Batch_Obtener_Consumos
        <HttpGet>
        <Route("api/BYD/ObtenerConsumos/{Periodo}")>
        Public Function ObtenerConsumos(Periodo As String) As HttpResponseMessage
            Try
                Select Case Periodo
                    Case "Mes"
                        Dim dt As New DataTable
                        Dim controller As New Controller
                        Dim sqlQuery As String

                        sqlQuery = "SELECT SIM.ICCID, Cast(year(CreateDate) AS nvarchar(4)) + '-' + Cast(month(CreateDate) AS nvarchar(2)) AS TimeSpan, 
                                    SUM(Total) AS DataUsage
							        FROM CDRS INNER JOIN SIM ON CDRS.IMSI = SIM.IMSI 
									INNER JOIN [Product] AS P ON SIM.ProductID=P.ProductID
									WHERE YEAR(CreateDate) = YEAR(GETDATE()) AND CompanyID=3 -- AND SIM.Active=1 AND CarID IS NOT NULL
                                    GROUP BY Cast(year(CreateDate) AS nvarchar(4)) + '-' + Cast(month(CreateDate) AS nvarchar(2)),
									SIM.ICCID"

                        dt = controller.TransactionsQuerys(sqlQuery).Tables(0)

                        If dt.Rows.Count > 0 Then
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
                                .FileName = "Consumos.csv"
                            }

                            Return response

                        Else
                            Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                        End If

                    Case "Dia"
                        Dim dt As New DataTable
                        Dim controller As New Controller
                        Dim sqlQuery As String

                        sqlQuery = "SELECT SIM.ICCID, CreateDate AS TimeSpan, SUM(Total) AS DataUsage
							        FROM CDRS INNER JOIN SIM ON CDRS.IMSI = SIM.IMSI 
									INNER JOIN [Product] AS P ON SIM.ProductID=P.ProductID
                                    WHERE CompanyID=3 AND 
									YEAR(CDRS.CreateDate) = YEAR(GETDATE()) AND
									MONTH(CDRS.CreateDate) = MONTH(GETDATE()) -- SIM.Active=1 AND CarID IS NOT NULL 
                                    GROUP BY CDRS.CreateDate, SIM.ICCID"

                        dt = controller.TransactionsQuerys(sqlQuery).Tables(0)
                        If dt.Rows.Count > 0 Then

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
                                    .FileName = "Consumos.csv"
                                }

                            Return response

                        Else
                            Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                        End If
                    Case Else
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "Selecciona una opción valida."
                        })
                End Select
            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                Key .error = "Ocurrió un error al generar el CSV.",
                Key .detalle = ex.Message
            })
                Return errorResponse
            End Try
        End Function
        '5.6	Consulta_De_Uso_De_Datos
        <HttpGet>
        <Route("api/BYD/ObtenerUsoDatos/{ICC}")>
        Public Function ObtenerUsoDatos(ICC As String) As HttpResponseMessage
            Try

                Dim objController As New ControllerSIM
                Dim objSIM As New SIM
                objSIM = objController.GetSIMByICCID(ICC)

                If Val(objSIM.SIMID) = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                Else
                    Dim objAltanResult As New AltanResult
                    Dim altan As New ConectionAltanRedes
                    Dim objErrorAltan As New ErrorAltan

                    objAltanResult = altan.GetAPIService(objSIM.MSISDN, AltanApisMethod.Profile)
                    If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                        Dim objProfile As New API.Tecomnet.Profile
                        Dim ObjControllerSIM As New ControllerSIM

                        Dim profile As New ResponseSubscriber
                        profile = JsonSerializer.Deserialize(Of ResponseSubscriber)(objAltanResult.JSON)

                        objProfile.MSISDN = objSIM.MSISDN
                        objProfile.IMSI = objSIM.IMSI
                        objProfile.Status = profile.ResponseSubscriber.Status.SubStatus
                        objProfile.CardPackage = objSIM.Producto
                        objProfile.APNStatus = "Active"

                        If profile.ResponseSubscriber.FreeUnits.Count > 0 Then
                            objProfile.DataUsage = (profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.TotalAmt - profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.UnusedAmt)
                        Else
                            objProfile.DataUsage = 0
                        End If

                        objProfile.TotalMB = (objSIM.AssignedMB + objSIM.AdditionalMB)
                        objProfile.ExpirationDate = objSIM.ExpirationDate

                        Return Request.CreateResponse(HttpStatusCode.OK, objProfile)
                    Else
                        objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .mensaje = "No hay datos disponibles."
                            })
                    End If
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
        '5.7	Consulta_Estado_APN
        <HttpGet>
        <Route("api/BYD/EstatusAPN")>
        Public Function ObtenerEstatusAPN() As HttpResponseMessage
            Try
                Dim objAltanResult As New AltanResult
                Dim altan As New ConectionAltanRedes
                Dim objErrorAltan As New ErrorAltan

                Dim objAPN As New API.Tecomnet.APN

                objAPN.APN = "mifi.m2m.tecomnetbyd.com"
                objAPN.Status = "Active"

                Return Request.CreateResponse(HttpStatusCode.OK, objAPN)

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                Key .error = "Ocurrió un error al generar la solicitud.",
                Key .detalle = ex.Message
            })
                Return errorResponse
            End Try
        End Function
        '5.8	Solicitud_Obtener_Productos
        <HttpGet>
        <Route("api/BYD/ObtenerProductos")>
        Public Function ObtenerProductos() As HttpResponseMessage
            Try

                Dim objController As New ControllerProduct
                Dim lstProduct As New List(Of Product)
                'ID 3 =	BYD IOT
                lstProduct = objController.GetAvailableProducts(3)

                For Each product As Product In lstProduct
                    product.OfferIdAltan = Nothing
                    product.CompanyID = Nothing
                Next

                If lstProduct.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, lstProduct)
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
        '5.9	Solicitud_Cambio_Oferta
        <HttpPost>
        <Route("api/BYD/CambioOferta")>
        Public Function CambioOferta(OfferChange As OfferChange) As HttpResponseMessage
            Try
                If ModelState.IsValid Then
                    Dim objController As New ControllerSIM
                    If objController.BYDOfferChange(OfferChange.ICC, OfferChange.ProductID) > 0 Then
                        Dim nuevoGuid As Guid = Guid.NewGuid()
                        Dim objChangeRequestResponse As New ChangeRequestResponse
                        objChangeRequestResponse.Status = "Aproved"
                        objChangeRequestResponse.GUID = nuevoGuid.ToString()
                        Return Request.CreateResponse(HttpStatusCode.OK, objChangeRequestResponse)
                    End If
                Else
                    Return Request.CreateResponse(HttpStatusCode.BadRequest, New With {
                        Key .mensaje = "Objeto recibido no válido."
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
            Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                Key .error = "Ocurrió un error al generar la solicitud.",
                Key .detalle = ""
            })
        End Function
        '5.10	Batch_Cambio_Oferta
        <HttpPost>
        <Route("api/BYD/BatchCambioOferta")>
        Public Async Function BatchCambioOferta() As Task(Of HttpResponseMessage)
            Dim request = Me.Request

            ' Verifica si la solicitud contiene un archivo adjunto
            If Not request.Content.IsMimeMultipartContent() Then
                Return request.CreateResponse(HttpStatusCode.UnsupportedMediaType, New With {.message = "Formato no soportado. Usa multipart/form-data"})
            End If

            ' Ruta donde se guardarán los archivos
            Dim root As String = ConfigurationManager.AppSettings("PathCambioOferta")
            If Not Directory.Exists(root) Then
                Directory.CreateDirectory(root) ' Crea la carpeta si no existe
            End If

            Dim provider As New MultipartFormDataStreamProvider(root)

            Try
                'Usar Await para evitar bloqueo del hilo
                Await request.Content.ReadAsMultipartAsync(provider)

                ' Verificar si se subió algún archivo
                If provider.FileData.Count = 0 Then
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "No se adjuntó ningún archivo"})
                ElseIf provider.FileData.Count > 1 Then
                    For Each csv As MultipartFileData In provider.FileData
                        IO.File.Delete(csv.LocalFileName)
                    Next
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "Solo se puede subir un archivo a la vez"})
                End If

                ' Obtener la información del archivo subido
                Dim file = provider.FileData(0)
                Dim tempFilePath = file.LocalFileName ' Nombre temporal generado por el sistema

                ' Obtener el nombre original del archivo (quitando las comillas dobles)
                Dim originalFileName As String = file.Headers.ContentDisposition.FileName.Trim(""""c)

                If Path.GetExtension(originalFileName) <> ".csv" Then
                    IO.File.Delete(tempFilePath)
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "El archivo enviado debe tener extensión .csv"})
                End If

                Dim NewGuid As Guid = Guid.NewGuid()
                Dim NewGuidString As String = NewGuid.ToString()

                ' Ruta final donde se guardará el archivo con su nombre correcto
                'Dim savedFilePath = Path.Combine(root, originalFileName)
                Dim savedFilePath = Path.Combine(root, String.Format("{0}.csv", NewGuid))

                ' Mover y renombrar el archivo desde su ubicación temporal
                If IO.File.Exists(savedFilePath) Then
                    IO.File.Delete(savedFilePath) ' Elimina el archivo si ya existe
                End If
                IO.File.Move(tempFilePath, savedFilePath)

                Dim dt As New DataTable
                dt = Functions.AplicarCambioOferta(savedFilePath, "|")

                If dt.Rows.Count > 0 Then

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
                                    .FileName = String.Format("{0}.csv", NewGuidString)
                                }
                    response.Headers.Add("GUID", NewGuidString)

                    Return response
                End If

                ' Responder con JSON
                Return request.CreateResponse(HttpStatusCode.OK, New With {
                .Status = "Processed",
                .GUID = NewGuidString
            })
            Catch ex As Exception
                Return request.CreateResponse(HttpStatusCode.InternalServerError, New With {.message = "Error al procesar el archivo", .error = ex.Message})
            End Try
        End Function
        '5.10	Solicitud_Cambio_De_Estatus
        <HttpPost>
        <Route("api/BYD/CambioEstatus")>
        Public Function CambioEstatus(ChangeStatus As ChangeStatus) As HttpResponseMessage
            Try
                If ModelState.IsValid Then
                    Dim objChangeRequestResponse As New ChangeRequestResponse
                    objChangeRequestResponse.Status = "Registered"
                    objChangeRequestResponse.GUID = "dsfds-sdfsdf-sdfsdf"
                    Return Request.CreateResponse(HttpStatusCode.OK, objChangeRequestResponse)
                Else
                    Return Request.CreateResponse(HttpStatusCode.BadRequest, New With {
                        Key .mensaje = "Objeto recibido no válido."
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
        '5.11	Batch_Cambio_De_Estatus
        <HttpPost>
        <Route("api/BYD/BatchCambioEstatus")>
        Public Async Function BatchCambioEstatus() As Task(Of HttpResponseMessage)
            Dim request = Me.Request

            ' Verifica si la solicitud contiene un archivo adjunto
            If Not request.Content.IsMimeMultipartContent() Then
                Return request.CreateResponse(HttpStatusCode.UnsupportedMediaType, New With {.message = "Formato no soportado. Usa multipart/form-data"})
            End If

            ' Ruta donde se guardarán los archivos
            Dim root As String = ConfigurationManager.AppSettings("Path")
            If Not Directory.Exists(root) Then
                Directory.CreateDirectory(root) ' Crea la carpeta si no existe
            End If

            Dim provider As New MultipartFormDataStreamProvider(root)

            Try
                'Usar Await para evitar bloqueo del hilo
                Await request.Content.ReadAsMultipartAsync(provider)

                ' Verificar si se subió algún archivo
                If provider.FileData.Count = 0 Then
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "No se adjuntó ningún archivo"})
                ElseIf provider.FileData.Count > 1 Then
                    For Each csv As MultipartFileData In provider.FileData
                        IO.File.Delete(csv.LocalFileName)
                    Next
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "Solo se puede subir un archivo a la vez"})
                End If

                ' Obtener la información del archivo subido
                Dim file = provider.FileData(0)
                Dim tempFilePath = file.LocalFileName ' Nombre temporal generado por el sistema

                ' Obtener el nombre original del archivo (quitando las comillas dobles)
                Dim originalFileName As String = file.Headers.ContentDisposition.FileName.Trim(""""c)

                If Path.GetExtension(originalFileName) <> ".csv" Then
                    IO.File.Delete(tempFilePath)
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "El archivo enviado debe tener extensión .csv"})
                End If

                Dim NewGuid As Guid = Guid.NewGuid()
                Dim NewGuidString As String = NewGuid.ToString()

                ' Ruta final donde se guardará el archivo con su nombre correcto
                'Dim savedFilePath = Path.Combine(root, originalFileName)
                Dim savedFilePath = Path.Combine(root, String.Format("{0}.csv", NewGuid))

                ' Mover y renombrar el archivo desde su ubicación temporal
                If IO.File.Exists(savedFilePath) Then
                    IO.File.Delete(savedFilePath) ' Elimina el archivo si ya existe
                End If
                IO.File.Move(tempFilePath, savedFilePath)

                ' Responder con JSON
                Return request.CreateResponse(HttpStatusCode.OK, New With {
                .Status = "Registered",
                .GUID = NewGuidString
            })
            Catch ex As Exception
                Return request.CreateResponse(HttpStatusCode.InternalServerError, New With {.message = "Error al guardar el archivo", .error = ex.Message})
            End Try
        End Function
        '5.12	Solicitud_Cambio_Estatus_APN
        <HttpPost>
        <Route("api/BYD/CambioEstatusAPN")>
        Public Function CambioEstatusAPN(APNStatusChange As APNStatusChange) As HttpResponseMessage
            Try
                If ModelState.IsValid Then
                    Dim objChangeRequestResponse As New ChangeRequestResponse
                    objChangeRequestResponse.Status = "Registered"
                    objChangeRequestResponse.GUID = "dsfds-sdfsdf-sdfsdf"
                    Return Request.CreateResponse(HttpStatusCode.OK, objChangeRequestResponse)
                Else
                    Return Request.CreateResponse(HttpStatusCode.BadRequest, New With {
                        Key .mensaje = "Objeto recibido no válido."
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
        '5.13	Batch_Cambio_Estatus_APN
        <HttpPost>
        <Route("api/BYD/BatchCambioEstatusAPN")>
        Public Async Function BatchCambioEstatusAPN() As Task(Of HttpResponseMessage)
            Dim request = Me.Request

            ' Verifica si la solicitud contiene un archivo adjunto
            If Not request.Content.IsMimeMultipartContent() Then
                Return request.CreateResponse(HttpStatusCode.UnsupportedMediaType, New With {.message = "Formato no soportado. Usa multipart/form-data"})
            End If

            ' Ruta donde se guardarán los archivos
            Dim root As String = ConfigurationManager.AppSettings("Path")
            If Not Directory.Exists(root) Then
                Directory.CreateDirectory(root) ' Crea la carpeta si no existe
            End If

            Dim provider As New MultipartFormDataStreamProvider(root)

            Try
                'Usar Await para evitar bloqueo del hilo
                Await request.Content.ReadAsMultipartAsync(provider)

                ' Verificar si se subió algún archivo
                If provider.FileData.Count = 0 Then
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "No se adjuntó ningún archivo"})
                ElseIf provider.FileData.Count > 1 Then
                    For Each csv As MultipartFileData In provider.FileData
                        IO.File.Delete(csv.LocalFileName)
                    Next
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "Solo se puede subir un archivo a la vez"})
                End If

                ' Obtener la información del archivo subido
                Dim file = provider.FileData(0)
                Dim tempFilePath = file.LocalFileName ' Nombre temporal generado por el sistema

                ' Obtener el nombre original del archivo (quitando las comillas dobles)
                Dim originalFileName As String = file.Headers.ContentDisposition.FileName.Trim(""""c)

                If Path.GetExtension(originalFileName) <> ".csv" Then
                    IO.File.Delete(tempFilePath)
                    Return request.CreateResponse(HttpStatusCode.BadRequest, New With {.message = "El archivo enviado debe tener extensión .csv"})
                End If

                Dim NewGuid As Guid = Guid.NewGuid()
                Dim NewGuidString As String = NewGuid.ToString()

                ' Ruta final donde se guardará el archivo con su nombre correcto
                'Dim savedFilePath = Path.Combine(root, originalFileName)
                Dim savedFilePath = Path.Combine(root, String.Format("{0}.csv", NewGuid))

                ' Mover y renombrar el archivo desde su ubicación temporal
                If IO.File.Exists(savedFilePath) Then
                    IO.File.Delete(savedFilePath) ' Elimina el archivo si ya existe
                End If
                IO.File.Move(tempFilePath, savedFilePath)

                ' Responder con JSON
                Return request.CreateResponse(HttpStatusCode.OK, New With {
                .Status = "Registered",
                .GUID = NewGuidString
            })
            Catch ex As Exception
                Return request.CreateResponse(HttpStatusCode.InternalServerError, New With {.message = "Error al guardar el archivo", .error = ex.Message})
            End Try
        End Function
        '5.14	Restringir_Servicio
        <HttpPost>
        <Route("api/BYD/RestringirServicio")>
        Public Function RestringirServicio(RestrictService As RestrictService) As HttpResponseMessage
            Try
                If ModelState.IsValid Then
                    Dim objChangeRequestResponse As New ChangeRequestResponse
                    objChangeRequestResponse.Status = "Registered"
                    objChangeRequestResponse.GUID = "dsfds-sdfsdf-sdfsdf"
                    Return Request.CreateResponse(HttpStatusCode.OK, objChangeRequestResponse)
                Else
                    Return Request.CreateResponse(HttpStatusCode.BadRequest, New With {
                        Key .mensaje = "Objeto recibido no válido."
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
        '5.15	Consultar_Solicitud
        <HttpGet>
        <Route("api/BYD/ConsultarSolicitud/{GUID}")>
        Public Function ConsultarSolicitud(GUID As String) As HttpResponseMessage
            Try
                Dim objAltanResult As New AltanResult
                Dim altan As New ConectionAltanRedes
                Dim objErrorAltan As New ErrorAltan

                If GUID = "89014103211118510720" Then
                    Dim objGetRequestResponse As New GetRequestResponse
                    objGetRequestResponse.Status = ""
                    objGetRequestResponse.Description = ""
                    objGetRequestResponse.StatusDate = ""
                    Return Request.CreateResponse(HttpStatusCode.OK, objGetRequestResponse)
                Else
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No existe el GUID enviado."
                        })
                End If

                ''Reacomodar
                'objAltanResult = altan.GetAPIService(MSISDN, AltanApisMethod.Profile)
                'If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                '    Dim objProfile As New API.Tecomnet.Profile
                '    Dim ObjControllerSIM As New ControllerSIM
                '    Dim objSIM As New SIM

                '    Dim profile As New ResponseSubscriber
                '    profile = JsonSerializer.Deserialize(Of ResponseSubscriber)(objAltanResult.JSON)

                '    objSIM = ObjControllerSIM.GetSIMByMSISDN(MSISDN)

                '    objProfile.IMSI = profile.ResponseSubscriber.Information.IMSI
                '    objProfile.ICCID = profile.ResponseSubscriber.Information.ICCID
                '    objProfile.IMEI = profile.ResponseSubscriber.Information.IMEI
                '    objProfile.SubStatus = profile.ResponseSubscriber.Status.SubStatus
                '    objProfile.TotalAmt = IIf(objSIM.AdditionalMB = 1, 0, (objSIM.AssignedMB + objSIM.AdditionalMB))
                '    objProfile.UnusedAmt = IIf(objSIM.AdditionalMB = 1, 0, (objSIM.AssignedMB + objSIM.AdditionalMB) - (profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.TotalAmt - profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.UnusedAmt))
                '    objProfile.ExpireDate = objSIM.ExpirationDate

                '    Return Request.CreateResponse(HttpStatusCode.OK, objProfile)
                'Else
                '    objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
                '    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                '        Key .mensaje = "No hay datos disponibles."
                '        })
                'End If
                ''Reacomodar

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