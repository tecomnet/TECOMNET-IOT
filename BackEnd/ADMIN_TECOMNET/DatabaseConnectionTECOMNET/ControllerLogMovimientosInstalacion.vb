Imports ModelsTECOMNET
Imports ModelsTECOMNET.TECOMNET

Public Class ControllerLogMovimientosInstalacion
    Public Function AddLog(ByVal objLogMovimientosInstalacion As LogMovimientosInstalacion) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsLogMovimientosInstalacion(Of Integer)(1, objLogMovimientosInstalacion)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
