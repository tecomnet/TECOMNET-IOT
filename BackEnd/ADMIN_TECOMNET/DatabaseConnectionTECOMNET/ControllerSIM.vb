Imports ModelsTECOMNET.TECOMNET

Public Class ControllerSIM
    Public Function GetSIMs() As List(Of SIMDetail)
        Dim controller As New Controller
        Dim lstSIM As New List(Of SIMDetail)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(1, New SIM)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstSIM
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstSIM.Add(ConvertObject.SIMDetail(dr))
                Next
            End If
        Catch ex As Exception
            Return lstSIM
        End Try
        Return lstSIM
    End Function
    Public Function GetSIM(ByVal SIMID As Integer) As SIM
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.SIMID = SIMID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(2, objSIM)

            For Each dr As DataRow In dt.Tables(0).Rows
                objSIM = ConvertObject.SIM(dr)
            Next
        Catch ex As Exception
            Return objSIM
        End Try
        Return objSIM
    End Function
    Public Function GetAvailableSIMsByMatch(ByVal TextSearch As String) As List(Of SIM)
        Dim controller As New Controller
        Dim lstSIM As New List(Of SIM)
        Try
            Dim dt As New DataSet
            Dim objSim As New SIM
            objSim.ICCID = TextSearch
            dt = controller.TransactionsSIM(Of DataSet)(3, objSim)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstSIM
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstSIM.Add(ConvertObject.SIM(dr))
                Next
            End If
        Catch ex As Exception
            Return lstSIM
        End Try
        Return lstSIM
    End Function
    Public Function DeactivateSIM(ByVal SIMID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.SIMID = SIMID
        objSIM.LastDate = Now
        Try
            exito = controller.TransactionsSIM(Of Integer)(4, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function AssociateSIMToCar(ByVal objSIM As SIM) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsSIM(Of Integer)(5, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function GetSIMsAssociateCustomer(ByVal CustomerID As Integer) As List(Of SIMDetail)
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.CarID = CustomerID
        Dim lstSIM As New List(Of SIMDetail)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(6, objSIM)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstSIM
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstSIM.Add(ConvertObject.SIMDetail(dr))
                Next
            End If
        Catch ex As Exception
            Return lstSIM
        End Try
        Return lstSIM
    End Function
    Public Function UpdateMB(ByVal SIMID As Integer, ByVal AdditionalMB As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.SIMID = SIMID
        objSIM.AdditionalMB = AdditionalMB
        Try
            exito = controller.TransactionsSIM(Of Integer)(7, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function ChangeActiveSIM(ByVal SIMID As Integer, ByVal Active As Boolean) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.SIMID = SIMID
        objSIM.Active = Active
        Try
            exito = controller.TransactionsSIM(Of Integer)(8, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function GetSIMByICCID(ByVal ICCID As String) As SIM
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.ICCID = ICCID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(9, objSIM)

            For Each dr As DataRow In dt.Tables(0).Rows
                objSIM = ConvertObject.SIM(dr)
            Next
        Catch ex As Exception
            Return objSIM
        End Try
        Return objSIM
    End Function
    Public Function BYDOfferChange(ByVal ICCID As String, ByVal ProductID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.ICCID = ICCID
        objSIM.CarID = ProductID
        Try
            exito = controller.TransactionsSIM(Of Integer)(10, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function RegisterSale(ByVal carID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.ICCID = 0
        objSIM.CarID = carID
        Try
            exito = controller.TransactionsSIM(Of Integer)(11, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
