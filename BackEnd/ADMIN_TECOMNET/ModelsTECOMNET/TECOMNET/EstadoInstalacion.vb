
Namespace TECOMNET
    Public Class InstallationStatus
        Public Property VIN As String
        Public Property ICCID As String
        Public Property PreviousVersion As String
        Public Property CurrentVersion As String
        Public Property PreviousSIM As String
        Public Property Connectivity As String
        Public Property SIMStatus As String
        Public Property State As String
        Public Sub New()
            Me.VIN = String.Empty
            Me.ICCID = String.Empty
            Me.PreviousVersion = String.Empty
            Me.CurrentVersion = String.Empty
            Me.PreviousSIM = String.Empty
            Me.Connectivity = String.Empty
            Me.SIMStatus = String.Empty
            Me.State = "Pendiente"
        End Sub
    End Class
End Namespace