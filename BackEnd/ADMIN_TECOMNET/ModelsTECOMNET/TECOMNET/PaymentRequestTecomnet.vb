Namespace TECOMNET
    <Serializable>
    Public Class PaymentRequestTecomnet
        Public Property RequestID As Integer
        Public Property OrderID As String
        Public Property SIMID As Integer
        Public Property ProductID As Integer
        Public Property CarID As Integer
        Public Property CustomerID As Integer
        Public Property estatus_pago As String
        Public Property id_transaction As String
        Public Property auth_number As String
        Public Property authCode As String
        Public Property reason As String
        Public Property CreationDate As DateTime
        Public Sub New()
            Me.OrderID = String.Empty
            Me.CreationDate = Now
            Me.estatus_pago = String.Empty
            Me.id_transaction = String.Empty
            Me.auth_number = String.Empty
            Me.authCode = String.Empty
            Me.reason = String.Empty
        End Sub
    End Class
End Namespace