Namespace TECOMNET
    Public Class BYDModels
        Public Property ModelID As Integer
        Public Property Model As String
        Public Property CreationDate As DateTime
        Public Property LastDate As DateTime?
        Public Sub New()
            Me.Model = String.Empty
            Me.CreationDate = Now
        End Sub
    End Class
End Namespace