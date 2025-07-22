Namespace TECOMNET
    Public Class Car
        Public Property CarID As Integer
        Public Property ModelID As Integer
        Public Property VIN As String
        Public Property YEAR As Integer
        Public Property brand As String
        Public Property CustomerID As Integer?
        Public Property Color As String
        Public Property CreationDate As DateTime
        Public Property LastDate As DateTime?
        Public Sub New()
            Me.VIN = String.Empty
            Me.brand = String.Empty
            Me.CreationDate = Now
            Me.Color = String.Empty
        End Sub
    End Class
    Public Class CarDetail
        Inherits Car
        Public Property Model As String
        Public Property CustomerName As String
        Public Property RFC As String
    End Class

End Namespace