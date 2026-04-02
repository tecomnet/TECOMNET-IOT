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
Imports System.Web.WebSockets
Imports System.Drawing
Imports ModelsTECOMNET
Imports System.Collections.Specialized.BitVector32
Imports System.Web.Helpers

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
        '<HttpPost>
        '<Route("api/BYD/CambioOferta")>
        'Public Function CambioOferta(OfferChange As OfferChange) As HttpResponseMessage
        '    Try
        '        If ModelState.IsValid Then
        '            Dim objController As New ControllerSIM
        '            If objController.BYDOfferChange(OfferChange.ICC, OfferChange.ProductID) > 0 Then
        '                Dim nuevoGuid As Guid = Guid.NewGuid()
        '                Dim objChangeRequestResponse As New ChangeRequestResponse
        '                objChangeRequestResponse.Status = "Aproved"
        '                objChangeRequestResponse.GUID = nuevoGuid.ToString()
        '                Return Request.CreateResponse(HttpStatusCode.OK, objChangeRequestResponse)
        '            End If
        '        Else
        '            Return Request.CreateResponse(HttpStatusCode.BadRequest, New With {
        '                Key .mensaje = "Objeto recibido no válido."
        '                })
        '        End If
        '    Catch ex As Exception

        '        ' Manejo de errores: devuelve un mensaje JSON con el error

        '        Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '        Key .error = "Ocurrió un error al generar la solicitud.",
        '        Key .detalle = ex.Message
        '    })
        '        Return errorResponse
        '    End Try
        '    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '        Key .error = "Ocurrió un error al generar la solicitud.",
        '        Key .detalle = ""
        '    })
        'End Function

        '5.9.1	Solicitud_Cambio_Oferta alex

        <AllowAnonymous>
        <HttpPost>
        <Route("api/BYD/CambioOferta")>
        Public Function CambioOferta(<FromBody> OfferChange As OfferChange) As HttpResponseMessage
            Dim Success As Boolean = False
            Dim resultLog As Boolean = True
            Dim nuevoGuid As Guid = Guid.NewGuid()
            Try
                If Not ModelState.IsValid Then
                    Return Request.CreateResponse(HttpStatusCode.BadRequest, ModelState)
                End If

                If ModelState.IsValid Then
                    Dim resutado
                    Dim controller As New Controller
                    Dim resultAltan As New AltanResult
                    resultAltan.ErrorID = AltanErrors.Mistake

                    Dim altan As New ConectionAltanRedes()
                    Dim ObjControllerSIM As New ControllerSIM
                    Dim objBuscaLog As New ProductSIMChangeLog

                    '>>>>>>>>> INICIA - Valida si ya existe un cambio de oferta <<<<<<<<<
                    objBuscaLog.ICCID = OfferChange.ICC
                    objBuscaLog.ProductID = 0
                    objBuscaLog.ReasonForChange = ""
                    objBuscaLog.Channel = ""
                    objBuscaLog.Action = ""
                    objBuscaLog.PerformedBy = ""
                    objBuscaLog.Applied = False
                    objBuscaLog.RequestGUID = ""
                    'objBuscaLog.ProductID = OfferChange.ProductID

                    'Si ya encuentra un registro en el log > 0 cambia Success a False para no mandar ninguna solicitud
                    Dim result = controller.TransactionsProductSIMChangeLog(Of Integer)(2, objBuscaLog)

                    If result > 0 Then
                        resultLog = False
                    End If
                    '>>>>>>>>> TERMINA - Valida si ya existe un cambio de oferta <<<<<<<<<

                    '>>>>>>>>> Comienza el cambio de oferta con Altan <<<<<<<<<<
                    'resultLog Debe ser TRUE para que mande la solicitud con Altan

                    If resultLog Then

                        Dim json = JsonSerializer.Serialize(New With {
                            .primaryOffering = New With {
                                .offeringId = "1003901000",
                                .address = String.Empty,
                                .scheduleDate = String.Empty,
                                .startEffectiveDate = String.Empty,
                                .expireEffectiveDate = String.Empty,
                                .allowChangeOfferInSuspendBarring = String.Empty
                            }
                        })

                        Dim objSIM = ObjControllerSIM.GetSIMByICCID(OfferChange.ICC)

                        resultAltan = altan.PostAPIService(
                            objSIM.MSISDN, json,
                            AltanApisMethod.ChangeOffer
                        )

                        If resultAltan.ErrorID <> AltanErrors.Susssuccessful Then
                            resutado = Request.CreateResponse(HttpStatusCode.BadRequest, New With {
                                Key .mensaje = "Error en Altán",
                                Key .detalle = resultAltan.JSON,
                                Key .status = resultAltan.StatusCode
                            })
                        End If
                    End If
                    '>>>>>>>>> Termina el cambio de oferta con Altan <<<<<<<<<<

                    Dim objController As New ControllerSIM
                    'Si Altan responde exitosamente, se procede a cambiar la oferta en el sistema local
                    If resultAltan.ErrorID = AltanErrors.Susssuccessful Then
                        If objController.BYDOfferChange(OfferChange.ICC, OfferChange.ProductID) > 0 Then
                            Success = True
                        End If
                    End If

                    '>>>>>>> Comienza a insertar en el log <<<<<<<<
                    Dim objLog As New ProductSIMChangeLog
                    objLog.ICCID = OfferChange.ICC
                    objLog.ProductID = OfferChange.ProductID
                    objLog.ReasonForChange = "Cambio de oferta solicitado desde API Codigo Altan:" + resultAltan.StatusCode.ToString()
                    objLog.Channel = "API"
                    objLog.Action = If(Success, "Cambio OK", "Error Cambio")
                    objLog.PerformedBy = "Sistema"
                    objLog.Applied = Success
                    objLog.RequestGUID = nuevoGuid.ToString()
                    controller.TransactionsProductSIMChangeLog(Of Integer)(1, objLog)
                    '>>>>>>> Termina de insertar en el log <<<<<<<<

                    If resutado IsNot Nothing Then
                        Return resutado
                    End If

                    If (Success) Then
                        Dim objChangeRequestResponse As New ChangeRequestResponse
                        objChangeRequestResponse.Status = "Aproved"
                        objChangeRequestResponse.GUID = nuevoGuid.ToString()
                        Return Request.CreateResponse(HttpStatusCode.OK, objChangeRequestResponse)
                    Else
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .mensaje = "No se pudo aplicar el cambio"
                        })
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

        '5.11	Solicitud_Cambio_De_Estatus
        <HttpPost>
        <Route("api/BYD/SolicitudCambioEstatus")>
        Public Function CambioEstatus(ChangeStatus As ChangeStatus) As HttpResponseMessage
            Try
                If ChangeStatus Is Nothing Then
                    Return Request.CreateResponse(HttpStatusCode.BadRequest, New With {
                            Key .mensaje = "Objeto recibido no válido."
                            })
                Else
                    If ModelState.IsValid Then
                        If ChangeStatus.Operation <> "Suspend" AndAlso ChangeStatus.Operation <> "Resume" Then
                            Return Request.CreateResponse(HttpStatusCode.BadRequest, New With {
                                Key .mensaje = "Error en la operación, las operaciones validas son Suspend y Resume"
                                })
                        Else
                            Dim objChangeRequestResponse As New ChangeRequestResponse
                            Dim objTicket As New Ticket
                            Dim nuevoGuid As Guid = Guid.NewGuid()
                            Dim objConttroller As New ControllerTicket

                            objTicket.TicketID = 0
                            objTicket.UserID = 1
                            objTicket.GUID = nuevoGuid.ToString
                            objTicket.RegistrationDate = Now
                            objTicket.StartDate = Nothing
                            objTicket.EndDate = Nothing
                            Select Case ChangeStatus.Operation
                                Case "Suspend"
                                    objTicket.Type = TypeTicket.Suspend
                                Case "Resume"
                                    objTicket.Type = TypeTicket.Resume
                            End Select

                            objTicket.Stage = StageTicket.Received
                            objTicket.Status = StatusTicket.Open
                            objTicket.Subject = "Solicitud de cambio de estatus de SIM"
                            objTicket.Reference = ChangeStatus.ICC
                            objTicket.Description = ChangeStatus.ReasonForChange
                            objTicket.Comments = String.Empty

                            objTicket.TicketID = objConttroller.AddTicket(objTicket)

                            If objTicket.TicketID > 0 Then
                                objChangeRequestResponse.Status = "Registered"
                                objChangeRequestResponse.GUID = nuevoGuid.ToString()
                                Return Request.CreateResponse(HttpStatusCode.OK, objChangeRequestResponse)
                            Else
                                Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                                    Key .error = "Ocurrió un error al generar la solicitud.",
                                    Key .detalle = "No se registro la solicitud, intenta nuevamente."
                                })
                            End If
                        End If
                    Else
                        Return Request.CreateResponse(HttpStatusCode.BadRequest, New With {
                            Key .mensaje = "Objeto recibido no válido."
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
        '5.12	Batch_Cambio_De_Estatus
        <HttpPost>
        <Route("api/BYD/BatchSolicitudCambioEstatus")>
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

                Dim dt As New DataTable
                dt = Functions.SolicitudCambioEstatus(savedFilePath, "|", NewGuidString)

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
        '5.13	Consultar_Solicitud
        <HttpGet>
        <Route("api/BYD/ConsultarSolicitud/{GUID}")>
        Public Function ConsultarSolicitud(GUID As String) As HttpResponseMessage
            Try
                Dim lstTickets As New List(Of Ticket)
                Dim objController As New ControllerTicket
                Dim lstRequestResponse As New List(Of GetRequestResponse)
                Dim Status As String = String.Empty
                Dim RegistrationDate As New DateTime

                lstTickets = objController.GetTickestPorGUID(GUID)

                If lstTickets.Count > 0 Then
                    For Each objTicket As Ticket In lstTickets
                        Select Case objTicket.Status
                            Case StatusTicket.Authorized
                                Status = "Authorized"
                                RegistrationDate = objTicket.EndDate
                            Case StatusTicket.Authorized
                                Status = "Authorized"
                                RegistrationDate = objTicket.EndDate
                            Case StatusTicket.Open
                                Status = "Open"
                                RegistrationDate = objTicket.RegistrationDate
                        End Select
                        lstRequestResponse.Add(New GetRequestResponse(Status, objTicket.Reference, objTicket.Comments, RegistrationDate))
                    Next
                    Return Request.CreateResponse(HttpStatusCode.OK, lstRequestResponse)
                Else
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No existe el GUID enviado."
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
        '5.14	Solicitud_Cambio_Estatus_APN
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
        '5.15	Batch_Cambio_Estatus_APN
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
        '5.16	Restringir_Servicio
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
        '6.1	Registrar Vehículo y asociación a SIM.- No documentado
        <HttpPost>
        <Route("api/BYD/RegistrarVehiculo/VIN/{VIN}/ICCID/{ICCID}/UserID/{UserID}")>
        Public Function RegistrarVehículo(VIN As String, ICCID As String, UserID As Integer) As HttpResponseMessage
            Try
                Dim objcar As New Car
                Dim objSIM As New SIM
                Dim objControllerCar As New ControllerCar
                Dim objControllerSIM As New ControllerSIM
                objcar = objControllerCar.GetCarByVIN(VIN)
                objSIM = objControllerSIM.GetSIMByICCID(ICCID)

                If objcar.CarID > 0 Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .error = "El VIN ya se encuentra registrado en el sistema.",
                        Key .detalle = ""
                    })
                ElseIf objSIM.SIMID = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .error = "El ICCID no esta registrado en nuestro sistema.",
                            Key .detalle = ""
                        })
                ElseIf Not IsNothing(objSIM.CarID) Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .error = "El ICCID se encuntra asociado a otro vehículo.",
                            Key .detalle = ""
                        })
                Else
                    objcar.CarID = 0
                    objcar.ModelID = 1
                    objcar.YEAR = 2000
                    objcar.VIN = VIN
                    objcar.CarID = objControllerCar.AddCar(objcar)

                    If objcar.CarID = 0 Then
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .error = "No se pudo registrar el vehículo.",
                            Key .detalle = ""
                        })
                    Else
                        objSIM.CarID = objcar.CarID
                        objSIM.InstallationDate = Now
                        objSIM.ActivationDate = Now
                        objSIM.BillingStartDate = Now
                        objSIM.Active = True
                        objSIM.Status = "Active"

                        If (objControllerSIM.AssociateSIMToCar(objSIM) > 0) Then
                            Dim ControllerInstallationEvidence As New ControllerInstallationEvidence
                            Dim objInstallationEvidence As New InstallationEvidence
                            Dim objControllerLogMovimientosInstalacion As New ControllerLogMovimientosInstalacion
                            Dim objLogMovimientosInstalacion As New LogMovimientosInstalacion

                            objInstallationEvidence.VIN = objcar.VIN
                            ControllerInstallationEvidence.AddInstallationEvidence(objInstallationEvidence)

                            objLogMovimientosInstalacion.LogID = 0
                            objLogMovimientosInstalacion.UsuarioID = UserID
                            objLogMovimientosInstalacion.Fecha = Now
                            objLogMovimientosInstalacion.ICCID = ICCID
                            objLogMovimientosInstalacion.VIN = VIN
                            objLogMovimientosInstalacion.Operacion = "Instalacion de SIM"
                            objControllerLogMovimientosInstalacion.AddLog(objLogMovimientosInstalacion)

                            Return Request.CreateResponse(HttpStatusCode.OK, New With {
                            Key .Detalle = "El vehículo se registro correctamente"
                            })
                        Else
                            Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                                Key .error = "Error al Asociar el vehículo al SIM.",
                                Key .detalle = "Vehiculo registrado correctamente, SIM existente sin asociar a un vehículo,error al asociar, reportar al area de sistemas."
                                })
                        End If
                    End If
                End If
            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                    Key .error = "Ocurrió un error al generar la solicitud.",
                    Key .detalle = ex.Message
                })
            End Try
        End Function
        '6.2	ObtenerEstadoInstalacion VIN .- No documentado
        <HttpGet>
        <Route("api/BYD/ObtenerEstadoInstalacion/VIN/{VIN}")>
        Public Function ObtenerEstadoInstalacion(VIN As String) As HttpResponseMessage
            Try
                Dim objControllerCar As New ControllerCar
                Dim objInstallationStatus As New InstallationStatus

                objInstallationStatus = objControllerCar.GetInstallationStatusByVIN(VIN)

                If objInstallationStatus.VIN = "" Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                Else
                    If objInstallationStatus.CurrentVersion <> "" And objInstallationStatus.PreviousVersion <> "" And objInstallationStatus.PreviousSIM <> "" And objInstallationStatus.Connectivity <> "" Then
                        objInstallationStatus.State = "Terminado"
                    Else
                        objInstallationStatus.State = "Pendiente"
                    End If
                    Return Request.CreateResponse(HttpStatusCode.OK, objInstallationStatus)
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
        '6.3	AsociarEvidenciaInstalacion VIN .- No documentado
        <HttpPut>
        <Route("api/BYD/AsociarEvidenciaInstalacion")>
        Public Function AsociarEvidenciaInstalacion(objInstallationEvidence As InstallationEvidence) As HttpResponseMessage
            Try

                If Not ModelState.IsValid Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "Estructura enviada incorrectamente."
                        })
                End If

                If objInstallationEvidence.VIN = "" Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "El número VIN es obligatorio."
                        })
                Else
                    Dim objControllerCar As New ControllerCar
                    Dim objInstallationStatus As New InstallationStatus

                    objInstallationStatus = objControllerCar.GetInstallationStatusByVIN(objInstallationEvidence.VIN)

                    If objInstallationStatus.VIN = "" Then
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "El VIN asociado no se encuentra registrado."
                        })
                    Else
                        Dim objControllerInstallationEvidence As New ControllerInstallationEvidence
                        Dim ruta As String = "C:\TecomentFiles\EvidenciasInstalacion\" & objInstallationStatus.VIN

                        If objInstallationEvidence.CurrentVersion <> "" Then
                            If Functions.GuardarImagenDesdeBase64(objInstallationEvidence.CurrentVersion, ruta, "CurrentVersion.jpg") Then
                                objInstallationEvidence.CurrentVersion = "CurrentVersion.jpg"
                            Else
                                objInstallationEvidence.CurrentVersion = ""
                            End If
                        End If

                        If objInstallationEvidence.PreviousVersion <> "" Then
                            If Functions.GuardarImagenDesdeBase64(objInstallationEvidence.PreviousVersion, ruta, "PreviousVersion.jpg") Then
                                objInstallationEvidence.PreviousVersion = "PreviousVersion.jpg"
                            Else
                                objInstallationEvidence.PreviousVersion = ""
                            End If
                        End If

                        If objInstallationEvidence.PreviousSIM <> "" Then
                            If Functions.GuardarImagenDesdeBase64(objInstallationEvidence.PreviousSIM, ruta, "PreviousSIM.jpg") Then
                                objInstallationEvidence.PreviousSIM = "PreviousSIM.jpg"
                            Else
                                objInstallationEvidence.PreviousSIM = ""
                            End If
                        End If

                        If objInstallationEvidence.Connectivity <> "" Then
                            If Functions.GuardarImagenDesdeBase64(objInstallationEvidence.Connectivity, ruta, "Connectivity.jpg") Then
                                objInstallationEvidence.Connectivity = "Connectivity.jpg"
                            Else
                                objInstallationEvidence.Connectivity = ""
                            End If
                        End If

                        objControllerInstallationEvidence.UpdateInstallationEvidence(objInstallationEvidence)
                        objInstallationStatus = objControllerCar.GetInstallationStatusByVIN(objInstallationEvidence.VIN)

                        If objInstallationStatus.CurrentVersion <> "" And objInstallationStatus.PreviousVersion <> "" And objInstallationStatus.PreviousSIM <> "" And objInstallationStatus.Connectivity <> "" Then
                            objInstallationStatus.State = "Terminado"
                        Else
                            objInstallationStatus.State = "Pendiente"
                        End If
                        Return Request.CreateResponse(HttpStatusCode.OK, objInstallationStatus)
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
        '6.4	ObtenerEstadoInstalacion VIN .- No documentado
        <HttpGet>
        <Route("api/BYD/ObtenerEvidencias/{fecha:datetime}")>
        Public Function ObtenerEvidencias(fecha As Date) As HttpResponseMessage
            Try
                Dim objControllerLogMovimientosInstalacion As New ControllerLogMovimientosInstalacion
                Dim lstSearchInstallationStatus As New List(Of SearchInstallationStatus)

                lstSearchInstallationStatus = objControllerLogMovimientosInstalacion.GetInstallationEvidenceByDate(fecha)

                If lstSearchInstallationStatus.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, lstSearchInstallationStatus)
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
        '6.5	Obtener Modelos de coches
        <HttpGet>
        <Route("api/BYD/Models")>
        Public Function ObtenerModelos() As HttpResponseMessage
            Try
                Dim objControllerModelBYD As New ControllerModelBYD
                Dim lstBYDModels As New List(Of BYDModels)

                lstBYDModels = objControllerModelBYD.GetAvailableModelsBYD

                If lstBYDModels.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, lstBYDModels)
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
        '6.6	Obtener Marcas de coches
        <HttpGet>
        <Route("api/BYD/Brands")>
        Public Function ObtenerMarcas() As HttpResponseMessage
            Try

                Dim lstBYDBrands As New List(Of String)
                lstBYDBrands.Add("ATTO")
                lstBYDBrands.Add("DOLPHIN")
                lstBYDBrands.Add("DOLPHIN MINI")
                lstBYDBrands.Add("DOLPHIN PLUS")
                lstBYDBrands.Add("HAN")
                lstBYDBrands.Add("KING")
                lstBYDBrands.Add("M9")
                lstBYDBrands.Add("SEAL")
                lstBYDBrands.Add("SEALION")
                lstBYDBrands.Add("SHARK")
                lstBYDBrands.Add("SONG PLUS")
                lstBYDBrands.Add("SONG PRO")
                lstBYDBrands.Add("TAN")
                lstBYDBrands.Add("YUAN PLUS")
                lstBYDBrands.Add("YUAN PRO")

                If lstBYDBrands.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No hay datos disponibles."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, lstBYDBrands)
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
        '6.7	Registra Venta
        <HttpPost>
        <Route("api/BYD/Sale")>
        Public Function RegistrarVenta(objCustomer As Customer, objCar As Car, UserID As Integer) As HttpResponseMessage
            Try
                If objCustomer.CustomerName = String.Empty Or objCustomer.Email = String.Empty Or objCustomer.PhoneNumber = String.Empty Or objCustomer.CURP Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .error = "El nombre, email, teléefono y curp son obligatorios.",
                        Key .detalle = ""
                    })
                ElseIf objCustomer.Sex <> "M" And objCustomer.Sex <> "F" Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .error = "El sexo debe ser M para hombres y F para mujeres.",
                            Key .detalle = ""
                        })
                ElseIf objCar.ModelID = 0 Or objCar.YEAR < 2017 Or objCar.VIN = String.Empty Or objCar.brand = String.Empty Or objCar.Color = String.Empty Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .error = "Los datos del vehículo deben estar completos.",
                            Key .detalle = ""
                        })
                Else
                    Dim objControllerCar As New ControllerCar
                    objCar = objControllerCar.GetCarByVIN(objCar.VIN)
                    If objCar.CarID <= 0 Then
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .error = "El VIN no se encuentra registrado en el sistema.",
                            Key .detalle = ""
                        })
                    Else
                        objCustomer.CreationDate = Now
                        objCustomer.RegistrationDate = Now
                        objCustomer.LastDate = Nothing
                        Dim objControllerCustomer As New ControllerCustomer
                        objCustomer.CustomerID = objControllerCustomer.AddCustomer(objCustomer)
                        If objCustomer.CustomerID > 0 Then
                            objCar.CustomerID = objCustomer.CustomerID
                            If objControllerCar.UpdateCar(objCar) > 0 Then
                                Return Request.CreateResponse(HttpStatusCode.OK, objCar)
                            Else
                                Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                                Key .error = "Error al asociar el vehículo.",
                                Key .detalle = ""
                        })
                            End If
                        Else
                            Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                            Key .error = "Error al agregar al cliente.",
                            Key .detalle = ""
                        })
                        End If
                    End If
                End If
            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                    Key .error = "Ocurrió un error al generar la solicitud.",
                    Key .detalle = ex.Message
                })
            End Try
        End Function

        '6.7	Registra Venta
        '<HttpGet>
        '<Route("api/BYD/Sale")>
        'Public Function RegistrarVenta(objCustomer As Customer, objCar As Car, ICCID As String, UserID As Integer) As HttpResponseMessage
        '    Try
        '        Dim objSIM As New SIM
        '        Dim objControllerCar As New ControllerCar
        '        Dim objControllerSIM As New ControllerSIM
        '        objCar = objControllerCar.GetCarByVIN(objCar.VIN)
        '        objSIM = objControllerSIM.GetSIMByICCID(ICCID)

        '        If objCar.CarID > 0 Then
        '            Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '                Key .error = "El VIN ya se encuentra registrado en el sistema.",
        '                Key .detalle = ""
        '            })
        '        ElseIf objSIM.SIMID = 0 Then
        '            Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '                    Key .error = "El ICCID no esta registrado en nuestro sistema.",
        '                    Key .detalle = ""
        '                })
        '        ElseIf Not IsNothing(objSIM.CarID) Then
        '            Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '                    Key .error = "El ICCID se encuntra asociado a otro vehículo.",
        '                    Key .detalle = ""
        '                })
        '        Else

        '            If objCar.ModelID = 0 Or objCar.YEAR = 0 Or objCar.VIN = String.Empty Then
        '                Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '                    Key .error = "Los datos del vehículo deben estar completos.",
        '                    Key .detalle = ""
        '                })
        '            Else
        '                objCar.CarID = objControllerCar.AddCar(objCar)
        '                If objCar.CarID = 0 Then
        '                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '                        Key .error = "No se pudo registrar el vehículo.",
        '                        Key .detalle = ""
        '                    })
        '                Else



        '                    'Dim objControllerCustomer As New ControllerCustomer
        '                    'objControllerCustomer.AddCustomer(objCustomer)
        '                    'objControllerCar.AssociateCarToCustomer(objCar)
        '                    'objSIM.CarID = objCar.CarID
        '                    'objSIM.InstallationDate = Now
        '                    'objSIM.ActivationDate = Now
        '                    'objSIM.BillingStartDate = Now
        '                    'objSIM.CustomerSaleDate = Now
        '                    'objSIM.Active = True
        '                    'objSIM.Status = "Active"


        '                    If (objControllerSIM.AssociateSIMToCar(objSIM) > 0) Then
        '                        Dim objControllerLogMovimientosInstalacion As New ControllerLogMovimientosInstalacion
        '                        Dim objLogMovimientosInstalacion As New LogMovimientosInstalacion

        '                        objLogMovimientosInstalacion.LogID = 0
        '                        objLogMovimientosInstalacion.UsuarioID = UserID
        '                        objLogMovimientosInstalacion.Fecha = Now
        '                        objLogMovimientosInstalacion.ICCID = ICCID
        '                        objLogMovimientosInstalacion.VIN = objCar.VIN
        '                        objLogMovimientosInstalacion.Operacion = "Instalacion de SIM"
        '                        objControllerLogMovimientosInstalacion.AddLog(objLogMovimientosInstalacion)

        '                        Return Request.CreateResponse(HttpStatusCode.OK, New With {
        '                        Key .Detalle = "El vehículo se registro correctamente"
        '                        })
        '                    Else
        '                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '                            Key .error = "Error al Asociar el vehículo al SIM.",
        '                            Key .detalle = "Vehiculo registrado correctamente, SIM existente sin asociar a un vehículo,error al asociar, reportar al area de sistemas."
        '                            })
        '                    End If
        '                End If
        '            End If
        '        End If
        '    Catch ex As Exception
        '        ' Manejo de errores: devuelve un mensaje JSON con el error
        '        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
        '            Key .error = "Ocurrió un error al generar la solicitud.",
        '            Key .detalle = ex.Message
        '        })
        '    End Try
        'End Function
    End Class
End Namespace