Namespace TECOMNET.LinkX
    Public Class PaymentResponse
        Public Property message As String
        Public Property response As ResponseObject
        Public Class ResponseObject
            Public Property amount As Decimal
            Public Property description As String
            Public Property url As String
            Public Property authCode As String
            Public Property required3DS As Boolean
        End Class
    End Class
End Namespace