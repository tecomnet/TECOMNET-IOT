Public Class LogMovimientosInstalacion
    Public Property LogID As Integer
    Public Property UsuarioID As Integer
    Public Property Operacion As String
    Public Property VIN As String
    Public Property ICCID As String
    Public Property Fecha As DateTime

    Public Sub New()
        Me.LogID = 0
        Me.UsuarioID = 0
        Me.Operacion = String.Empty
        Me.VIN = String.Empty
        Me.ICCID = String.Empty
        Me.Fecha = Now
    End Sub
End Class
