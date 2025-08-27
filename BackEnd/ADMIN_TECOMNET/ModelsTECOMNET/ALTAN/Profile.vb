Imports System.Text.Json.Serialization

Namespace TECOMNET.AltanRedes
    Public Class ResponseSubscriber
        <JsonPropertyName("responseSubscriber")>
        Public Property ResponseSubscriber As Subscriber
    End Class

    Public Class Subscriber
        <JsonPropertyName("information")>
        Public Property Information As Information
        <JsonPropertyName("status")>
        Public Property Status As Status
        <JsonPropertyName("primaryOffering")>
        Public Property PrimaryOffering As PrimaryOffering
        <JsonPropertyName("freeUnits")>
        Public Property FreeUnits As List(Of FreeUnit)
    End Class

    Public Class Information
        <JsonPropertyName("idSubscriber")>
        Public Property IdSubscriber As String
        <JsonPropertyName("IMSI")>
        Public Property IMSI As String
        <JsonPropertyName("ICCID")>
        Public Property ICCID As String
        <JsonPropertyName("IMEI")>
        Public Property IMEI As String
        <JsonPropertyName("coordinates")>
        Public Property Coordinates As String
    End Class

    Public Class Status
        <JsonPropertyName("subStatus")>
        Public Property SubStatus As String
    End Class

    Public Class PrimaryOffering
        <JsonPropertyName("offeringId")>
        Public Property OfferingId As String
        <JsonPropertyName("excessiveProductSpeed")>
        Public Property ExcessiveProductSpeed As String
    End Class

    Public Class FreeUnit
        <JsonPropertyName("name")>
        Public Property Name As String
        <JsonPropertyName("freeUnit")>
        Public Property FreeUnitDetails As FreeUnitDetails
        <JsonPropertyName("detailOfferings")>
        Public Property DetailOfferings As List(Of DetailOffering)
    End Class

    Public Class FreeUnitDetails
        <JsonPropertyName("totalAmt")>
        Public Property TotalAmt As String
        <JsonPropertyName("unusedAmt")>
        Public Property UnusedAmt As String
    End Class

    Public Class DetailOffering
        <JsonPropertyName("offeringId")>
        Public Property OfferingId As String
        <JsonPropertyName("purchaseSecuence")>
        Public Property PurchaseSecuence As String
        <JsonPropertyName("initialAmt")>
        Public Property InitialAmt As String
        <JsonPropertyName("unusedAmt")>
        Public Property UnusedAmt As String
        <JsonPropertyName("effectiveDate")>
        Public Property EffectiveDate As String
        <JsonPropertyName("expireDate")>
        Public Property ExpireDate As String
    End Class

End Namespace