Imports ModelsTECOMNET.TECOMNET


Public Class ControllerCompany
    Public Function GetCompanys() As List(Of Company)
        Dim controller As New Controller
        Dim lstCompany As New List(Of Company)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCompany(Of DataSet)(1, New Company)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstCompany
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstCompany.Add(ConvertObject.Company(dr))
                Next
            End If
        Catch ex As Exception
            Return lstCompany
        End Try
        Return lstCompany
    End Function
    Public Function GetCompany(ByVal CompanyID As Integer) As Company
        Dim controller As New Controller
        Dim objCompany As New Company
        objCompany.CompanyID = CompanyID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCompany(Of DataSet)(2, objCompany)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCompany = ConvertObject.Company(dr)
            Next
        Catch ex As Exception
            Return objCompany
        End Try
        Return objCompany
    End Function
    Public Function AddCompany(ByVal objCompany As Company) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCompany(Of Integer)(3, objCompany)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdateCompany(ByVal objCompany As Company) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCompany(Of Integer)(4, objCompany)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function DesactivateCompany(ByVal CompanyID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objCompany As New Company
        objCompany.CompanyID = CompanyID
        objCompany.LastDate = Now
        Try
            exito = controller.TransactionsCompany(Of Integer)(5, objCompany)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
