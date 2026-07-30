Imports ModelsTECOMNET.Enums.TECOMNET

Namespace TECOMNET
    <Serializable>
    Public Class User
        Public Property UserID As Integer
        Public Property UserName As String
        Public Property Name As String
        Public Property Email As String
        Public Property Password As String
        Public Property PhoneNumber As String
        Public Property UserType As UserType
        Public Property CreationDate As DateTime
        Public Property LastDate As DateTime?
        Public Sub New()
            Me.UserID = 0
            Me.UserName = String.Empty
            Me.Name = String.Empty
            Me.Email = String.Empty
            Me.Password = String.Empty
            Me.PhoneNumber = String.Empty
            Me.UserType = Enums.TECOMNET.UserType.AdministratorTECOMNET
            Me.CreationDate = Now
        End Sub
    End Class
End Namespace