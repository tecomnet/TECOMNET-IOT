Imports ModelsTECOMNET.TECOMNET
Public Class ControllerModelBYD
    Public Function GetModelsBYD() As List(Of BYDModels)
        Dim controller As New Controller
        Dim lstBYDModels As New List(Of BYDModels)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsBYDModels(Of DataSet)(1, New BYDModels)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstBYDModels
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstBYDModels.Add(ConvertObject.BYDModels(dr))
                Next
            End If
        Catch ex As Exception
            Return lstBYDModels
        End Try
        Return lstBYDModels
    End Function
    Public Function GetModelBYD(ByVal ModelID As Integer) As BYDModels
        Dim controller As New Controller
        Dim objModel As New BYDModels
        objModel.ModelID = ModelID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsBYDModels(Of DataSet)(2, objModel)

            For Each dr As DataRow In dt.Tables(0).Rows
                objModel = ConvertObject.BYDModels(dr)
            Next
        Catch ex As Exception
            Return objModel
        End Try
        Return objModel
    End Function
    Public Function AddModelBYD(ByVal objBYDModels As BYDModels) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsBYDModels(Of Integer)(3, objBYDModels)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdateModelBYD(ByVal objModel As BYDModels) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsBYDModels(Of Integer)(4, objModel)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function DeactivateModelBYD(ByVal ModelID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objModel As New BYDModels
        objModel.ModelID = ModelID
        objModel.LastDate = Now
        Try
            exito = controller.TransactionsBYDModels(Of Integer)(5, objModel)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function GetAvailableModelsBYD() As List(Of BYDModels)
        Dim controller As New Controller
        Dim lstBYDModels As New List(Of BYDModels)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsBYDModels(Of DataSet)(6, New BYDModels)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstBYDModels
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstBYDModels.Add(ConvertObject.BYDModels(dr))
                Next
            End If
        Catch ex As Exception
            Return lstBYDModels
        End Try
        Return lstBYDModels
    End Function
End Class

