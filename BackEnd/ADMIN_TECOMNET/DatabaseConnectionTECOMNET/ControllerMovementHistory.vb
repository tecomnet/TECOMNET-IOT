Imports ModelsTECOMNET.TECOMNET

Public Class ControllerMovementHistory
    Public Function AddMovement(ByVal objMovementHistory As MovementHistory) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsMovementHistory(Of Integer)(1, objMovementHistory)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
