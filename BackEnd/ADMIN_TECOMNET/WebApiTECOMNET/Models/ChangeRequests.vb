Imports System.ComponentModel.DataAnnotations

Namespace API.Tecomnet
    Public Class OfferChange
        <Required>
        Public Property ICC As String
        <Required>
        Public Property ProductID As Integer
        <Required>
        Public Property ReasonForChange As String
    End Class
    Public Class ChangeStatus
        <Required>
        Public Property ICC As String
        <Required>
        Public Property Operation As String
        <Required>
        Public Property ReasonForChange As String
    End Class
    Public Class APNStatusChange
        <Required>
        Public Property APN As String
        <Required>
        Public Property Operation As String
        <Required>
        Public Property ReasonForChange As String
    End Class
    Public Class RestrictService
        <Required>
        Public Property URL As String
        <Required>
        Public Property Operation As String
        <Required>
        Public Property ReasonForChange As String
    End Class
    Public Class ChangeRequestResponse
        Public Property Status As String
        Public Property GUID As String
    End Class
    Public Class GetRequestResponse
        Public Property Status As String
        Public Property Reference As String
        Public Property Description As String
        Public Property StatusDate As DateTime
        Public Sub New()
        End Sub
        Public Sub New(Status As String, Reference As String, Description As String, StatusDate As DateTime)
            Me.Status = Status
            Me.Reference = Reference
            Me.Description = Description
            Me.StatusDate = StatusDate
        End Sub
    End Class
End Namespace