Imports ModelsTECOMNET.TECOMNET

Public Class ControllerCDR
    Public Function AddCDRAux(ByVal objCDR As CDR) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCDR(Of Integer)(1, objCDR)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function CDRDataStructure() As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCDR(Of Integer)(2, New CDR)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
