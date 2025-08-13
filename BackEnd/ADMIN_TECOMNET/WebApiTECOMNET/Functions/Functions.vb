Imports System.IO
Imports System.Net
Imports System.Runtime.Remoting.Messaging
Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports WebApiTECOMNET.API.Tecomnet

Public Class Functions
    ' Método para convertir DataTable a CSV en memoria
    Public Shared Function ConvertirDataTableACSV(ByVal dt As DataTable) As String
        Dim sb As New StringBuilder()

        ' Encabezados
        sb.AppendLine(String.Join("|", dt.Columns.Cast(Of DataColumn).Select(Function(col) col.ColumnName)))

        ' Filas
        For Each row As DataRow In dt.Rows
            Dim valores As String = String.Join("|", row.ItemArray.Select(Function(field) $"""{field.ToString().Replace("""", """""")}"""))
            sb.AppendLine(valores)
        Next

        Return sb.ToString()
    End Function
    Public Shared Function AplicarCambioOferta(filePath As String, delimiter As String) As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add("ICC", GetType(String))
        dt.Columns.Add("ProductID", GetType(Integer))

        ' Leer todas las líneas del archivo
        Dim lines As String() = File.ReadAllLines(filePath)

        ' Leer cada línea del archivo y agregar las filas al DataTable
        For i As Integer = 1 To lines.Length - 1
            Dim values As String() = lines(i).Split(delimiter)

            Dim objController As New ControllerSIM
            If objController.BYDOfferChange(values(0), values(1)) = 0 Then
                dt.Rows.Add(values(0), values(1))
            End If
        Next

        Return dt
    End Function
    Public Shared Function SolicitudCambioEstatus(filePath As String, delimiter As String, GUID As String) As DataTable
        Dim dt As New DataTable()
        dt.Columns.Add("ICC", GetType(String))
        dt.Columns.Add("Operation", GetType(String))
        dt.Columns.Add("ReasonForChange", GetType(String))
        ' Leer todas las líneas del archivo
        Dim lines As String() = File.ReadAllLines(filePath)

        ' Leer cada línea del archivo y agregar las filas al DataTable
        For i As Integer = 1 To lines.Length - 1
            Dim values As String() = lines(i).Split(delimiter)

            Dim objController As New ControllerSIM


            If values(1) <> "Suspend" AndAlso values(1) <> "Resume" Then
                dt.Rows.Add(values(0), values(1), "Error en la operación, las operaciones validas son Suspend y Resume")
            Else

                Dim objChangeRequestResponse As New ChangeRequestResponse
                Dim objTicket As New Ticket
                Dim objConttroller As New ControllerTicket

                objTicket.TicketID = 0
                objTicket.UserID = 1
                objTicket.GUID = GUID
                objTicket.RegistrationDate = Now
                objTicket.StartDate = Nothing
                objTicket.EndDate = Nothing
                Select Case values(1)
                    Case "Suspend"
                        objTicket.Type = TypeTicket.Suspend
                    Case "Resume"
                        objTicket.Type = TypeTicket.Resume
                End Select

                objTicket.Stage = StageTicket.Received
                objTicket.Status = StatusTicket.Open
                objTicket.Subject = "Solicitud de cambio de estatus de SIM"
                objTicket.Reference = values(0)
                objTicket.Description = values(2)
                objTicket.Comments = String.Empty

                objTicket.TicketID = objConttroller.AddTicket(objTicket)

                If objTicket.TicketID = 0 Then
                    dt.Rows.Add(values(0), values(1), values(2))
                End If
            End If
        Next

        Return dt
    End Function
End Class
