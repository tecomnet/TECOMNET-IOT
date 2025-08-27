Public Class RechargeRequest
    Public Property MSISDN As String
    Public Property MVNOId As Integer
    Public Property OfferID As Integer
    Public Property TotalAmount As Decimal
    Public Property PaymentMethodID As Integer
    Public Sub New(MSISDN As String, MVNOId As Integer, OfferID As Integer, TotalAmount As Decimal, PaymentMethodID As Integer)
        Me.MSISDN = MSISDN
        Me.MVNOId = MVNOId
        Me.OfferID = OfferID
        Me.TotalAmount = TotalAmount
        Me.PaymentMethodID = PaymentMethodID
    End Sub
    Public Sub New()
    End Sub
End Class
