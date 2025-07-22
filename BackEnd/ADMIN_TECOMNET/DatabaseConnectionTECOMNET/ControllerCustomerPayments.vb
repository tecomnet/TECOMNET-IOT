Imports ModelsTECOMNET.TECOMNET

Public Class ControllerCustomerPayments
    Public Function GetCustomerPaymentsDetails(ByVal CustomerID As Integer) As List(Of CustomerPaymentsDetails)
        Dim controller As New Controller
        Dim lstCustomerPaymentsDetails As New List(Of CustomerPaymentsDetails)
        Try
            Dim dt As New DataSet
            Dim objCustomerPayments As New CustomerPayments
            objCustomerPayments.CustomerID = CustomerID

            dt = controller.TransactionsCustomerPayments(Of DataSet)(1, objCustomerPayments)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstCustomerPaymentsDetails
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstCustomerPaymentsDetails.Add(ConvertObject.CustomerPaymentsDetails(dr))
                Next
            End If
        Catch ex As Exception
            Return lstCustomerPaymentsDetails
        End Try
        Return lstCustomerPaymentsDetails
    End Function
    Public Function RegisterSale(ByVal objCustomerPayments As CustomerPayments) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCustomerPayments(Of Integer)(3, objCustomerPayments)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
