Namespace TECOMNET.AltanRedes
    Public Class NotificationAltan
        Public Property EventType As String
        Public Property Callback As String
        Public Property [Event] As EventDetails
    End Class

    ' Detalles del evento principal
    Public Class EventDetails
        Public Property Id As String
        Public Property EffectiveDate As String
        Public Property Detail As EventDetail
    End Class

    ' Detalles específicos del evento
    Public Class EventDetail
        Public Property BE As String
        Public Property FreeUnitTypeName As String
        Public Property TotalAmount As String
        Public Property UnUsedAmount As String
        Public Property ExpiryDate As String
        Public Property ThresholdValue As String
        Public Property OfferingID As String
    End Class
End Namespace