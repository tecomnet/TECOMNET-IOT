Namespace TECOMNET
    <Serializable>
    Public Class Customer
        Public Property CustomerID As Integer
        Public Property PaternalSurname As String
        Public Property MaternalSurname As String
        Public Property Name As String
        Public Property CustomerName As String
        Public Property DateBirth As Date?
        Public Property Email As String
        Public Property Password As String
        Public Property PhoneNumber As String
        Public Property RFC As String
        Public Property Sex As String
        Public Property Country As String
        Public Property State As String
        Public Property Cologne As String
        Public Property Address As String
        Public Property ZipCode As String
        Public Property CreationDate As DateTime
        Public Property RegistrationDate As DateTime?
        Public Property LastDate As DateTime?
        Public Sub New()
            Me.PaternalSurname = String.Empty
            Me.MaternalSurname = String.Empty
            Me.Name = String.Empty
            Me.CustomerName = String.Empty
            Me.Email = String.Empty
            Me.Password = String.Empty
            Me.PhoneNumber = String.Empty
            Me.RFC = String.Empty
            Me.Sex = String.Empty
            Me.Country = String.Empty
            Me.State = String.Empty
            Me.Cologne = String.Empty
            Me.Address = String.Empty
            Me.ZipCode = String.Empty
            Me.CreationDate = Now
        End Sub
    End Class
End Namespace