Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Renci.SshNet
Imports System.IO

Module Module1

    Sub Main()
        Dim host As String = "cdrs.altanredes.com"
        Dim port As Integer = 22
        Dim username As String = "MBX374"
        Dim password As String = "TTpL0fn5WFWqGZ0"
        Dim objControllerCDR As New ControllerCDR
        Dim objControllerCDR1 As New ControllerCDR
        Dim DateFtp As Date = Date.Now.AddDays(-1)
        Dim remotePath As String = String.Format("/374/cdrs/bss-cbs/{0}{1}{2}/", DateFtp.Year, String.Format("{0:00}", DateFtp.Month), String.Format("{0:00}", DateFtp.Day))
        'Dim remotePath As String = String.Format("/374/cdrs/bss-cbs/20250325/", Now.Year, Now.Month, Now.Day)        

        'If Not EventLog.SourceExists("TECOMNET") Then
        '    EventLog.CreateEventSource("TECOMNET", "Services")
        'End If

        ' Write an informational entry.
        'EventLog.WriteEntry("TECOMNET", "El servicio ha iniciado.", EventLogEntryType.Information)
        Console.WriteLine("************************")
        Console.WriteLine("El servicio ha iniciado.")
        Try
            ' Conectar al servidor SFTP
            Using client As New SftpClient(host, port, username, password)
                client.Connect()
                ' Listar archivos
                Console.WriteLine("Lectura de CDRS en " & remotePath & ":")
                For Each file In client.ListDirectory(remotePath)

                    Try
                        If Not file.IsDirectory AndAlso Not file.IsSymbolicLink Then
                            Using stream As New MemoryStream()
                                client.DownloadFile(remotePath & file.Name, stream)
                                stream.Position = 0  ' Reiniciar posición del stream
                                Using reader As New StreamReader(stream)
                                    Dim contenido As String = reader.ReadToEnd()
                                    Dim fileContent() As String = contenido.Split("|"c)
                                    'Console.WriteLine("TotalFlux " + fileContent(363) + " | CREATE_Date " + fileContent(10) + " | IMEI " + fileContent(367) + " | IMSI " + fileContent(354) + " | MainOfferingID " + fileContent(380) + " | LastEffectOffering " + fileContent(380))                                
                                    If objControllerCDR.AddCDRAux(New CDR(ConvertStringToDateTime(fileContent(10)), "Datos", (fileContent(363) / 1000000), fileContent(367), fileContent(354), fileContent(380), fileContent(380))) = 0 Then
                                        Console.WriteLine("************************")
                                        Console.WriteLine("Error al agregar el CDR")
                                    End If
                                End Using
                            End Using
                        End If
                    Catch ex As Exception
                        Console.WriteLine("************************")
                        Console.WriteLine("Error al agregar el CDR")
                    End Try
                Next
                client.Disconnect()
            End Using

            objControllerCDR1.CDRDataStructure()
            Console.WriteLine("************************")
            Console.WriteLine("Proceso terminado")
        Catch ex As Exception
            Console.WriteLine("************************")
            Console.WriteLine("Ocurrió un error en " & ex.Message)
            'EventLog.WriteEntry("TECOMNET", "Ocurrió un error en " & ex.Message, EventLogEntryType.Error)
        End Try
    End Sub
    Function ReadTextFile(filePath As String) As String
        Dim fileContent As String = ""
        Try
            fileContent = System.IO.File.ReadAllText(filePath)
        Catch ex As Exception
            Console.WriteLine("************************")
            Console.WriteLine("Ocurrió un error al leer el texto " & ex.Message)
            'EventLog.WriteEntry("TECOMNET", "Ocurrió un error al leer el texto " & ex.Message, EventLogEntryType.Error)
        End Try
        Return fileContent
    End Function
    Public Function ConvertStringToDateTime(dateString As String) As DateTime
        ' Check if the input string is in the correct format (YYYYMMDDHHMMSS)
        If dateString.Length <> 14 Or Not IsNumeric(dateString) Then
            Throw New ArgumentException("Invalid date string format. Expected YYYYMMDDHHMMSS.")
        End If

        Dim year As Integer = Integer.Parse(dateString.Substring(0, 4))
        Dim month As Integer = Integer.Parse(dateString.Substring(4, 2))
        Dim day As Integer = Integer.Parse(dateString.Substring(6, 2))
        Dim hour As Integer = Integer.Parse(dateString.Substring(8, 2))
        Dim minute As Integer = Integer.Parse(dateString.Substring(10, 2))
        Dim second As Integer = Integer.Parse(dateString.Substring(12, 2))

        Return New DateTime(year, month, day, hour, minute, second)

    End Function
End Module
