Imports System.IO
Imports System.Runtime.Remoting.Messaging
Imports DatabaseConnectionTECOMNET
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
End Class
