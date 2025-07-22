Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.LinkX

Public Class ControllerPaymentRequest
    'Public Function GetModelsBYD() As List(Of BYDModels)
    '    Dim controller As New Controller
    '    Dim lstBYDModels As New List(Of BYDModels)
    '    Try
    '        Dim dt As New DataSet
    '        dt = controller.TransactionsBYDModels(Of DataSet)(1, New BYDModels)

    '        If dt.Tables(0).Rows.Count = 0 Then
    '            Return lstBYDModels
    '        Else
    '            For Each dr As DataRow In dt.Tables(0).Rows
    '                lstBYDModels.Add(ConvertObject.BYDModels(dr))
    '            Next
    '        End If
    '    Catch ex As Exception
    '        Return lstBYDModels
    '    End Try
    '    Return lstBYDModels
    'End Function
    Public Function GetPaymentRequest(ByVal OrderID As Integer) As PaymentRequestTecomnet
        Dim controller As New Controller
        Dim objPaymentRequest As New PaymentRequestTecomnet
        objPaymentRequest.OrderID = OrderID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsPaymentRequest(Of DataSet)(2, objPaymentRequest)

            For Each dr As DataRow In dt.Tables(0).Rows
                objPaymentRequest = ConvertObject.PaymentRequestTecomnet(dr)
            Next
        Catch ex As Exception
            Return objPaymentRequest
        End Try
        Return objPaymentRequest
    End Function
    Public Function AddPaymentRequest(ByVal objPaymentRequest As PaymentRequestTecomnet) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsPaymentRequest(Of Integer)(3, objPaymentRequest)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdatePaymentRequest(ByVal objPaymentRequest As PaymentRequestTecomnet) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsPaymentRequest(Of Integer)(4, objPaymentRequest)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdatePaymentRequested(ByVal objPaymentRequest As PaymentRequestTecomnet) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsPaymentRequest(Of Integer)(5, objPaymentRequest)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    'Public Function DeactivateModelBYD(ByVal ModelID As Integer) As Integer
    '    Dim exito As Integer
    '    Dim controller As New Controller
    '    Dim objModel As New BYDModels
    '    objModel.ModelID = ModelID
    '    objModel.LastDate = Now
    '    Try
    '        exito = controller.TransactionsBYDModels(Of Integer)(5, objModel)
    '    Catch ex As Exception
    '        Return exito
    '    End Try
    '    Return exito
    'End Function
    'Public Function GetAvailableModelsBYD() As List(Of BYDModels)
    '    Dim controller As New Controller
    '    Dim lstBYDModels As New List(Of BYDModels)
    '    Try
    '        Dim dt As New DataSet
    '        dt = controller.TransactionsBYDModels(Of DataSet)(6, New BYDModels)

    '        If dt.Tables(0).Rows.Count = 0 Then
    '            Return lstBYDModels
    '        Else
    '            For Each dr As DataRow In dt.Tables(0).Rows
    '                lstBYDModels.Add(ConvertObject.BYDModels(dr))
    '            Next
    '        End If
    '    Catch ex As Exception
    '        Return lstBYDModels
    '    End Try
    '    Return lstBYDModels
    'End Function
End Class
