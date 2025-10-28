Namespace TECOMNET.LinkX
    Public Class PaymentRequest
        Public Property amount As Decimal
        Public Property displayAmount As Decimal
        Public Property displayCurrency As String
        Public Property language As String
        Public Property email As String
        Public Property commerceName As String
        Public Property supportEmail As String
        Public Property description As String
        Public Property response_url As String
        Public Property redirectUrl As String
        Public Property order_id As String
        Public Property origin As String
        Public Property imageUrl As String
        Public Property userData As UserDetail
        Public Class UserDetail
            Public Property firstName As String
            Public Property lastName As String
            Public Property phone As String
            Public Property email As String
            Public Property country As String
            Public Property state As String
            Public Property locality As String
            Public Property address As String
            Public Property zipCode As String
        End Class
    End Class
End Namespace