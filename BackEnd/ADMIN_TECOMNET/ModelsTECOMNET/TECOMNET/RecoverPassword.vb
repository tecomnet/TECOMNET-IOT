Namespace TECOMNET
    Public Class RecoverPassword
        Public Property Type As Integer
        Public Property userID As Integer
        Public Property email As String
        Public Property RequestDate As DateTime
        Public Property ResetPasswordToken As String
        Public Property ResetPasswordTokenExpiration As DateTime
        Public Property Satisfactory As Boolean
    End Class
End Namespace