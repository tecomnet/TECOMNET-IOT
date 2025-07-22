Imports ModelsTECOMNET.TECOMNET

Public Class ControllerCustomer
    Public Function GetCustomer() As List(Of Customer)
        Dim controller As New Controller
        Dim lstCustomers As New List(Of Customer)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCustomer(Of DataSet)(1, New Customer)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstCustomers
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstCustomers.Add(ConvertObject.Customers(dr))
                Next
            End If
        Catch ex As Exception
            Return lstCustomers
        End Try
        Return lstCustomers
    End Function
    Public Function GetCustomer(ByVal CustomerID As Integer) As Customer
        Dim controller As New Controller
        Dim objCustomer As New Customer
        objCustomer.CustomerID = CustomerID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCustomer(Of DataSet)(2, objCustomer)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCustomer = ConvertObject.Customers(dr)
            Next
        Catch ex As Exception
            Return objCustomer
        End Try
        Return objCustomer
    End Function
    Public Function AddCustomer(ByVal objCustomer As Customer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCustomer(Of Integer)(3, objCustomer)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdateCustomer(ByVal objCustomer As Customer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCustomer(Of Integer)(4, objCustomer)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function DesactivateCustomer(ByVal CustomerID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objCustomer As New Customer
        objCustomer.CustomerID = CustomerID
        objCustomer.LastDate = Now
        Try
            exito = controller.TransactionsCustomer(Of Integer)(5, objCustomer)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function GetCustomerByMatch(ByVal TextSearch As String) As List(Of Customer)
        Dim controller As New Controller
        Dim lstCustomer As New List(Of Customer)
        Try
            Dim dt As New DataSet
            Dim objCustomer As New Customer
            objCustomer.CustomerName = TextSearch
            dt = controller.TransactionsCustomer(Of DataSet)(6, objCustomer)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstCustomer
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstCustomer.Add(ConvertObject.Customers(dr))
                Next
            End If
        Catch ex As Exception
            Return lstCustomer
        End Try
        Return lstCustomer
    End Function
    Public Function ValidateCustomerRegistration(ByVal VIN As String, ByVal RFC As String, ByVal email As String) As Customer
        Dim controller As New Controller
        Dim objCustomer As New Customer
        objCustomer.CustomerName = VIN
        objCustomer.RFC = RFC
        objCustomer.Email = email
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCustomer(Of DataSet)(7, objCustomer)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCustomer = ConvertObject.Customers(dr)
            Next
        Catch ex As Exception
            Return objCustomer
        End Try
        Return objCustomer
    End Function
    Public Function RegistrationCustomer(ByVal objCustomer As Customer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCustomer(Of Integer)(8, objCustomer)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function LoginCustomer(ByVal email As String, ByVal password As String) As Customer
        Dim controller As New Controller
        Dim objCustomer As New Customer
        objCustomer.Email = email
        objCustomer.Password = password
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCustomer(Of DataSet)(9, objCustomer)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCustomer = ConvertObject.Customers(dr)
            Next
        Catch ex As Exception
            Return objCustomer
        End Try
        Return objCustomer
    End Function
    Public Function ChangePassword(ByVal CustomerID As Integer, ByVal InitialPassword As String, ByVal NewPassword As String) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objCustomer As New Customer
        objCustomer.CustomerID = CustomerID
        objCustomer.CustomerName = InitialPassword
        objCustomer.Password = NewPassword

        Try
            exito = controller.TransactionsCustomer(Of Integer)(10, objCustomer)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
