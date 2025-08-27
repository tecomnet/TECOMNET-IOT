Imports System.Text.Json.Serialization
Namespace TECOMNET.AltanRedes
    Public Class OrderInfo
        <JsonPropertyName("msisdn")>
        Public Property Msisdn As String
        <JsonPropertyName("effectiveDate")>
        Public Property EffectiveDate As String
        <JsonPropertyName("order")>
        Public Property Order As OrderDetails
    End Class

    Public Class OrderDetails
        <JsonPropertyName("id")>
        Public Property Id As String
    End Class
End Namespace