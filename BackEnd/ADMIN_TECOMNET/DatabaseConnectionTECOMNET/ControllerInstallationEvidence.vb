Imports ModelsTECOMNET
Imports ModelsTECOMNET.TECOMNET

Public Class ControllerInstallationEvidence
    Public Function GetInstallationEvidence(ByVal VIN As String) As InstallationEvidence
        Dim controller As New Controller
        Dim objInstallationEvidence As New InstallationEvidence
        objInstallationEvidence.VIN = VIN
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsInstallationEvidence(Of DataSet)(1, objInstallationEvidence)

            For Each dr As DataRow In dt.Tables(0).Rows
                objInstallationEvidence = ConvertObject.InstallationEvidence(dr)
            Next
        Catch ex As Exception
            Return objInstallationEvidence
        End Try
        Return objInstallationEvidence
    End Function
    Public Function AddInstallationEvidence(ByVal objInstallationEvidence As InstallationEvidence) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsInstallationEvidence(Of Integer)(2, objInstallationEvidence)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdateInstallationEvidence(ByVal objInstallationEvidence As InstallationEvidence) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsInstallationEvidence(Of Integer)(3, objInstallationEvidence)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
