Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports System.Text.Json
Public Class AdminSIM
    Inherits System.Web.UI.Page
#Region "Propiedades"
    Private Property objUser As User
        Get
            Return Session("Usuario")
        End Get
        Set(value As User)
            Session("Usuario") = value
        End Set
    End Property
    Private Property SIMID As Integer
        Get
            Return Val(ViewState("SIMID"))
        End Get
        Set(value As Integer)
            ViewState("SIMID") = value
        End Set
    End Property
    Private Property MSISDN As String
        Get
            Return Val(ViewState("MSISDN"))
        End Get
        Set(value As String)
            ViewState("MSISDN") = value
        End Set
    End Property
#End Region
#Region "Metodos y funciones"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerSIM
        rgDashboard.DataSource = objController.GetSIMs
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
#End Region
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub rgDashboard_ItemCommand(sender As Object, e As GridCommandEventArgs) Handles rgDashboard.ItemCommand

        If TypeOf e.Item Is GridDataItem Then
            Dim dataItem As GridDataItem = e.Item
            Dim objAltanResult As New AltanResult
            Dim objErrorAltan As New ErrorAltan
            Dim altan As New ConectionAltanRedes
            Me.SIMID = Val(dataItem.GetDataKeyValue("SIMID"))
            Me.MSISDN = Val(dataItem.GetDataKeyValue("MSISDN"))
            Select Case e.CommandName
                Case "Resume"
                    objAltanResult = altan.PostAPIService(Me.MSISDN, "", AltanApisMethod.Resumen)
                    If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                        Dim objOrderInfo As New OrderInfo
                        objOrderInfo = JsonSerializer.Deserialize(Of OrderInfo)(objAltanResult.JSON)
                        MovementRegister(MovementType.ResumeService)
                        ChangeActiveSIM(Me.SIMID, True)
                        DisplayMesage(String.Format("El servicio se activo para el MSISDN {0}", objOrderInfo.Msisdn), True)
                    Else
                        objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
                        DisplayMesage(String.Format("No se puede activar el servicio - {0} - {1} - {2}", objErrorAltan.errorCode, objErrorAltan.description, objErrorAltan.detail), False)
                    End If
                Case "Suspend"
                    objAltanResult = altan.PostAPIService(Me.MSISDN, "", AltanApisMethod.Suspend)
                    If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                        Dim objOrderInfo As New OrderInfo
                        objOrderInfo = JsonSerializer.Deserialize(Of OrderInfo)(objAltanResult.JSON)
                        MovementRegister(MovementType.Suspend)
                        ChangeActiveSIM(Me.SIMID, False)
                        DisplayMesage(String.Format("El servicio se desactivo para el MSISDN {0}", objOrderInfo.Msisdn), True)
                    Else
                        objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
                        DisplayMesage(String.Format("No se puede suspender el servicio - {0} - {1} - {2}", objErrorAltan.errorCode, objErrorAltan.description, objErrorAltan.detail), False)
                    End If
                Case "Profile"
                    objAltanResult = altan.GetAPIService(Me.MSISDN, AltanApisMethod.Profile)
                    If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                        Dim profile As New ResponseSubscriber
                        profile = JsonSerializer.Deserialize(Of ResponseSubscriber)(objAltanResult.JSON)
                        MovementRegister(MovementType.ResumeService)
                        DisplayMesage(String.Format("El servicio se encutra {0}, megas disponibles: {1}", profile.ResponseSubscriber.Status.SubStatus, profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.UnusedAmt), True)
                    Else
                        objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
                        DisplayMesage(String.Format("No se puede consultar el perfil - {0} - {1} - {2}", objErrorAltan.errorCode, objErrorAltan.description, objErrorAltan.detail), False)
                    End If
                Case "Delete"
                    'Suspendemos servicio en Altan                    
                    objAltanResult = altan.PostAPIService(Me.MSISDN, "", AltanApisMethod.Suspend)
                    If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                        Dim objOrderInfo As New OrderInfo
                        objOrderInfo = JsonSerializer.Deserialize(Of OrderInfo)(objAltanResult.JSON)
                        MovementRegister(MovementType.Desactivate)
                        DeactivateSIM(Me.SIMID)
                        DisplayMesage(String.Format("El servicio se desactivo para el MSISDN {0}", objOrderInfo.Msisdn), True)
                    Else
                        objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
                        DisplayMesage(String.Format("No se puede suspender el servicio - {0} - {1} - {2}", objErrorAltan.errorCode, objErrorAltan.description, objErrorAltan.detail), False)
                    End If
            End Select
            e.Canceled = True
            rgDashboard.Rebind()
        End If
    End Sub
    Public Sub MovementRegister(ByVal Movement As MovementType)
        'Registramos movimiento en tabla de historia de movimientos
        Dim objMovementHistory As New MovementHistory
        Dim ObjControllerMovementHistory As New ControllerMovementHistory
        objMovementHistory.MovementDate = Now
        objMovementHistory.MovementType = Movement
        objMovementHistory.SIMID = SIMID
        objMovementHistory.Description = ""
        ObjControllerMovementHistory.AddMovement(objMovementHistory)
    End Sub
    Public Sub ChangeActiveSIM(ByVal SIMID As Integer, ByVal Active As Boolean)
        Dim ObjControllerSIM As New ControllerSIM
        ObjControllerSIM.ChangeActiveSIM(SIMID, Active)
    End Sub
    Public Sub DeactivateSIM(ByVal SIMID As Integer)
        Dim ObjControllerSIM As New ControllerSIM
        ObjControllerSIM.DeactivateSIM(SIMID)
    End Sub
#End Region
End Class