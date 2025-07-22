Namespace TECOMNET
    Public Class Company
        Public Property CompanyID As Integer
        Public Property Company As String
        Public Property CreationDate As DateTime
        Public Property LastDate As DateTime?
        Public Sub New()
            Me.Company = String.Empty
            Me.CreationDate = Now
        End Sub
    End Class
End Namespace