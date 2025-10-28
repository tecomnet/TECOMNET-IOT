Imports ModelsTECOMNET.TECOMNET

Public Class ControllerTicket
    Public Function GetTickets() As List(Of Ticket)
        Dim controller As New Controller
        Dim lstTicketS As New List(Of Ticket)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsTickets(Of DataSet)(1, New Ticket)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstTicketS
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstTicketS.Add(ConvertObject.Ticket(dr))
                Next
            End If
        Catch ex As Exception
            Return lstTicketS
        End Try
        Return lstTicketS
    End Function
    Public Function GetTicketPorID(ByVal TicketID As Integer) As Ticket
        Dim controller As New Controller
        Dim objTicket As New Ticket
        objTicket.TicketID = TicketID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsTickets(Of DataSet)(2, objTicket)

            For Each dr As DataRow In dt.Tables(0).Rows
                objTicket = ConvertObject.Ticket(dr)
            Next
        Catch ex As Exception
            Return objTicket
        End Try
        Return objTicket
    End Function
    Public Function GetTickestPorGUID(ByVal GUID As String) As List(Of Ticket)
        Dim controller As New Controller
        Dim objTicket As New Ticket
        Dim LstTicket As New List(Of Ticket)
        objTicket.GUID = GUID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsTickets(Of DataSet)(3, objTicket)

            For Each dr As DataRow In dt.Tables(0).Rows
                objTicket = ConvertObject.Ticket(dr)
                LstTicket.Add(objTicket)
            Next
        Catch ex As Exception
            Return LstTicket
        End Try
        Return LstTicket
    End Function
    Public Function AddTicket(ByVal objTicket As Ticket) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsTickets(Of Integer)(4, objTicket)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
