Namespace TECOMNET
    Public Class AuditCategories
        Public Property CategoryID As Short
        Public Property CategoryName As String
        Public Property CategoryDescription As String
        Public Property Active As Boolean
        Public Sub New()
            Me.Active = True
        End Sub
    End Class
End Namespace