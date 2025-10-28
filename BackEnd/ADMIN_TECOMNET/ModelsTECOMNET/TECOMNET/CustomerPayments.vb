Imports ModelsTECOMNET.Enums.TECOMNET
Namespace TECOMNET
    Public Class CustomerPayments
        Public Property PaymentID As Integer
        Public Property ProductID As Integer
        Public Property SIMID As Integer
        Public Property CarID As Integer
        Public Property CustomerID As Integer
        Public Property PurchaseDate As DateTime
        Public Property PaymentAmount As Double
        Public Property MethodPayment As MethodPayment
        Public Property InvoiceRequired As Boolean
        Public Property OrderID As Integer?
        Public Property InvoiceID As Integer?
        Public Property DepositID As Integer?
        Public Sub New()
            Me.PaymentID = 0
            Me.ProductID = 0
            Me.SIMID = 0
            Me.CarID = 0
            Me.CustomerID = 0
            Me.PurchaseDate = Now
            Me.PaymentAmount = 0
            Me.OrderID = Nothing
            Me.MethodPayment = MethodPayment.Card
            Me.InvoiceRequired = True
        End Sub
    End Class
    Public Class CustomerPaymentsDetails
        Inherits CustomerPayments
        Public Property CustomerName As String
        Public Property ProductName As String
        Public Property ICCID As String
        Public Property brand As String
        Public Property Color As String
    End Class
End Namespace