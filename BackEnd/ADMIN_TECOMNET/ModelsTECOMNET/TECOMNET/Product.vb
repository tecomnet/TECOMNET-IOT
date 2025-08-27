Namespace TECOMNET
    Public Class Product
        Public Property ProductID As Integer
        Public Property ProductName As String
        Public Property Price As Double
        Public Property MB As Integer
        Public Property OfferIdAltan As String
        Public Property CompanyID As Integer
        Public Property CreationDate As DateTime
        Public Property LastDate As DateTime?
        Public Sub New()
            Me.ProductName = String.Empty
            Me.OfferIdAltan = String.Empty
            Me.Price = 0
            Me.MB = 0
            Me.CompanyID = 0
            Me.CreationDate = Now
        End Sub
    End Class
    Public Class ProductDetail
        Inherits Product
        Public Property Company As String
    End Class
End Namespace