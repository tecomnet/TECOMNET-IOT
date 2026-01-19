Namespace TECOMNET
    Public Class InstallationEvidence
        Public Property VIN As String
        Public Property PreviousVersion As String
        Public Property CurrentVersion As String
        Public Property PreviousSIM As String
        Public Property Connectivity As String
        Public Sub New()
            Me.VIN = String.Empty
            Me.PreviousVersion = String.Empty
            Me.CurrentVersion = String.Empty
            Me.PreviousSIM = String.Empty
            Me.Connectivity = String.Empty
        End Sub
    End Class
End Namespace