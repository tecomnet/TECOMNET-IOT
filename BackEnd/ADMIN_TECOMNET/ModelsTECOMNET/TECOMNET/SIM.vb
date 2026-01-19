Namespace TECOMNET
    Public Class SIM
        Public Property SIMID As Integer
        Public Property BE_ID As String
        Public Property IMSI As String
        Public Property IMSI_rb1 As String
        Public Property IMSI_rb2 As String
        Public Property ICCID As String
        Public Property MSISDN As String
        Public Property PIN As String
        Public Property PUK As String
        Public Property Serie As String
        Public Property Producto As String
        Public Property CarID As Integer?
        Public Property ExpirationDate As DateTime?
        Public Property AssignedMB As Integer?
        Public Property UsedMB As Integer?
        Public Property AvailableMB As Integer?
        Public Property AdditionalMB As Integer?
        Public Property Active As Boolean
        Public Property CreationDate As DateTime
        Public Property InstallationDate As DateTime?
        Public Property ActivationDate As DateTime?
        Public Property ReactivationDate As DateTime?
        Public Property SuspensionDate As DateTime?
        Public Property BillingStartDate As DateTime?
        Public Property CustomerSaleDate As DateTime?
        Public Property Status As String
        Public Property LastDate As DateTime?

        Public Sub New()
            Me.CreationDate = Now
            Me.BE_ID = String.Empty
            Me.IMSI = String.Empty
            Me.IMSI_rb1 = String.Empty
            Me.IMSI_rb2 = String.Empty
            Me.ICCID = String.Empty
            Me.MSISDN = String.Empty
            Me.PIN = String.Empty
            Me.PUK = String.Empty
            Me.Serie = String.Empty
            Me.Producto = String.Empty
            Me.Active = True
        End Sub
    End Class
    Public Class SIMDetail
        Inherits SIM
        Public Property VIN As String
        Public Property Model As String
        Public Property CustomerName As String
        Public Property RFC As String
        Public Property EstausAltan As String
    End Class

    Public Class ProfileDetail
        Public Property MSISDN As String
        Public Property IMSI As String
        Public Property Status As String
        Public Property CardPackage As String
        Public Property APNStatus As String
        Public Property DataUsage As String
    End Class
End Namespace