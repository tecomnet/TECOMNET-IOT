Imports ModelsTECOMNET.TECOMNET

Public Class ControllerUser
    Public Function GetUsers() As List(Of User)
        Dim controller As New Controller
        Dim lstUser As New List(Of User)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsUser(Of DataSet)(1, New User)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstUser
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstUser.Add(ConvertObject.Users(dr))
                Next
            End If
        Catch ex As Exception
            Return lstUser
        End Try
        Return lstUser
    End Function
    Public Function GetUser(ByVal UserID As Integer) As User
        Dim controller As New Controller
        Dim objUser As New User
        objUser.UserID = UserID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsUser(Of DataSet)(2, objUser)

            For Each dr As DataRow In dt.Tables(0).Rows
                objUser = ConvertObject.Users(dr)
            Next
        Catch ex As Exception
            Return objUser
        End Try
        Return objUser
    End Function
    Public Function AddUser(ByVal objUser As User) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsUser(Of Integer)(3, objUser)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdateUser(ByVal objUser As User) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsUser(Of Integer)(4, objUser)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function DesactivateUser(ByVal UserID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objUser As New User
        objUser.UserID = UserID
        objUser.LastDate = Now
        Try
            exito = controller.TransactionsUser(Of Integer)(5, objUser)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function LoginUser(ByVal email As String, ByVal password As String) As User
        Dim controller As New Controller
        Dim objUser As New User
        objUser.Email = email
        objUser.Password = password
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsUser(Of DataSet)(6, objUser)

            For Each dr As DataRow In dt.Tables(0).Rows
                objUser = ConvertObject.Users(dr)
            Next
        Catch ex As Exception
            Return objUser
        End Try
        Return objUser
    End Function
End Class
