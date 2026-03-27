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
    Public Function GetInstallationEvidenceByDate(ByVal InstallationDate As Date) As List(Of SearchInstallationStatus)
        Dim controller As New Controller
        Dim lstSearchInstallationStatus As New List(Of SearchInstallationStatus)
        Dim objLogMovimientosInstalacion As New LogMovimientosInstalacion

        objLogMovimientosInstalacion.Fecha = InstallationDate

        Try
        Dim dt As New DataSet
            dt = controller.TransactionsLogMovimientosInstalacion(Of DataSet)(2, objLogMovimientosInstalacion)

            For Each dr As DataRow In dt.Tables(0).Rows
                Dim objSearchInstallationStatus As New SearchInstallationStatus
                objSearchInstallationStatus = ConvertObject.SearchInstallationStatus(dr)
                lstSearchInstallationStatus.Add(objSearchInstallationStatus)
            Next
        Catch ex As Exception
            Return lstSearchInstallationStatus
        End Try
        Return lstSearchInstallationStatus
    End Function
End Class
