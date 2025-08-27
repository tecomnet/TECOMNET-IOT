Imports ModelsTECOMNET.Enums.TECOMNET

Namespace TECOMNET
    Public Class Ticket
        Public Property TicketID As Integer
        Public Property UserID As Integer
        Public Property GUID As String
        Public Property RegistrationDate As DateTime
        Public Property StartDate As DateTime?
        Public Property EndDate As DateTime?
        Public Property Type As TypeTicket
        Public Property Stage As StageTicket
        Public Property Status As StatusTicket
        Public Property Subject As String
        Public Property Reference As String
        Public Property Description As String
        Public Property Comments As String
        Public Sub New()
            Me.TicketID = 0
            Me.UserID = 0
            Me.GUID = String.Empty
            Me.RegistrationDate = Now
            Me.Type = TypeTicket.Suspend
            Me.Stage = StageTicket.Received
            Me.Status = StatusTicket.Open
            Me.Subject = String.Empty
            Me.Reference = String.Empty
            Me.Description = String.Empty
            Me.Comments = String.Empty
        End Sub
    End Class
End Namespace