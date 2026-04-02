Public Class ProductSIMChangeLog

    Public Property ICCID As String
    Public Property ProductID As Integer
    Public Property ReasonForChange As String
    Public Property Channel As String
    Public Property Action As String
    Public Property PerformedBy As String
    Public Property Applied As Boolean
    Public Property RequestGUID As String
    Public Sub New()
        Me.ICCID = String.Empty
        Me.ProductID = 0
        Me.ReasonForChange = String.Empty
        Me.Channel = String.Empty
        Me.Action = String.Empty
        Me.PerformedBy = String.Empty
        Me.Applied = 0
        Me.RequestGUID = String.Empty
    End Sub
End Class
