Namespace TECOMNET
    Public Class CDR
        Public Property CreateDate As DateTime
        Public Property Service As String
        Public Property Total As Double
        Public Property IMEI As String
        Public Property IMSI As String
        Public Property MainOfferingID As String
        Public Property LastEffectOffering As String
        Public Sub New(ByVal CreateDate As DateTime, ByVal Service As String, ByVal Total As Double, ByVal IMEI As String,
                       ByVal IMSI As String, ByVal MainOfferingID As String, ByVal LastEffectOffering As String)
            Me.CreateDate = CreateDate
            Me.Service = Service
            Me.Total = Total
            Me.IMEI = IMEI
            Me.IMSI = IMSI
            Me.MainOfferingID = MainOfferingID
            Me.LastEffectOffering = LastEffectOffering
        End Sub
        Public Sub New()
            Me.CreateDate = Now
            Me.Service = String.Empty
            Me.Total = 0
            Me.IMEI = String.Empty
            Me.IMSI = String.Empty
            Me.MainOfferingID = String.Empty
            Me.LastEffectOffering = String.Empty
        End Sub
    End Class
End Namespace
