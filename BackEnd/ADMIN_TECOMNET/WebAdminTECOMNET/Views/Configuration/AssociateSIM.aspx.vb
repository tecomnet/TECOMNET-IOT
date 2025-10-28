Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports System.Text.Json

Public Class AssociateSIM
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
#End Region
#Region "Metodos y funciones"
#Region "FunctionSIM"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerSIM
        rgDashboard.DataSource = objController.GetSIMs
    End Sub
    Private Sub ShowControls(ByVal isUpdate As Boolean)
        pnlSIM.Visible = isUpdate
        rgDashboard.Visible = Not isUpdate
        rtbMenu.Visible = Not isUpdate
        pnlCar.Visible = False
    End Sub
    Private Sub clearControls()
        rcbSIM.Enabled = True
        rcbSIM.ClearSelection()
        rcbSIM.Text = String.Empty
        rcbSIM.SelectedValue = 0
        rcbVIN.ClearSelection()
        rcbVIN.Text = String.Empty
        rcbVIN.SelectedValue = 0
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
    Public Function GetSIM(ByVal SIMID As Integer) As SIM
        Dim objController As New ControllerSIM
        Dim objSIM As New SIM
        objSIM = objController.GetSIM(SIMID)
        Return objSIM
    End Function
#End Region
#Region "FunctionCAR"
    Private Sub ShowControlsCar(ByVal isUpdate As Boolean)
        pnlCar.Visible = isUpdate
        pnlSIM.Visible = Not isUpdate
        btnCancelarCar.Text = "Cancelar"
    End Sub
    Private Sub clearControlsCar()
        ucCarUser.CarID = 0
        ucCarUser.ModelID = 0
        ucCarUser.VIN = String.Empty
        ucCarUser.YEAR = Now.Year
        ucCarUser.brand = String.Empty
        ucCarUser.Color = String.Empty
    End Sub
    Public Function GetCar(ByVal CarID As Integer) As Car
        Dim objController As New ControllerCar
        Dim objCar As New Car
        objCar = objController.GetCar(CarID)
        Return objCar
    End Function
#End Region
#End Region
#Region "Eventos"
#Region "EventSIM"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub rtbMenu_ButtonClick(sender As Object, e As RadToolBarEventArgs) Handles rtbMenu.ButtonClick
        ShowControls(True)
        clearControls()
        SIMID = 0
    End Sub
    Private Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        ShowControls(False)
        clearControls()
        SIMID = 0
    End Sub
    Private Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Dim objController As New ControllerSIM
        Dim objSIM As New SIM

        If Val(rcbSIM.SelectedValue) = 0 Or Val(rcbVIN.SelectedValue) = 0 Then
            DisplayMesage("Todos los campos son obligatorios.", True)
        Else
            objSIM.SIMID = IIf(Me.SIMID = 0, Val(rcbSIM.SelectedValue), Me.SIMID)
            objSIM.CarID = Val(rcbVIN.SelectedValue)

            If objSIM.SIMID > 0 Then
                If objController.AssociateSIMToCar(objSIM) > 0 Then
                    clearControls()
                    ShowControls(False)
                    rgDashboard.Rebind()
                    DisplayMesage("El registro se actualizó correctamente", True)
                Else
                    DisplayMesage("Error al actualizar el registro", False)
                End If
            End If
        End If
    End Sub
    Private Sub rgDashboard_DeleteCommand(sender As Object, e As GridCommandEventArgs) Handles rgDashboard.DeleteCommand
        Dim id As Integer = Val(e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("SIMID").ToString())
        Dim objSIM As New SIM
        Dim ObjControllerSIM As New ControllerSIM
        Dim objErrorAltan As New ErrorAltan
        Dim altan As New ConectionAltanRedes
        objSIM = ObjControllerSIM.GetSIM(id)

        'Suspendemos servicio en Altan
        Dim objAltanResult As New AltanResult
        objAltanResult = altan.PostAPIService(objSIM.MSISDN, "", AltanApisMethod.Suspend)
        If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
            ObjControllerSIM.DeactivateSIM(id)
            Dim objMovementHistory As New MovementHistory
            Dim ObjControllerMovementHistory As New ControllerMovementHistory

            'Registramos movimiento en tabla de historia de movimientos
            objMovementHistory.MovementDate = Now
            objMovementHistory.MovementType = MovementType.Desactivate
            objMovementHistory.SIMID = SIMID
            objMovementHistory.Description = ""
            ObjControllerMovementHistory.AddMovement(objMovementHistory)

            DisplayMesage("El registro se dio de baja correctamente.", True)
            ShowControls(False)
            clearControls()
            SIMID = 0
            rgDashboard.Rebind()
        Else
            objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
            DisplayMesage(String.Format("No se pudo dar de baja el registro - {0} - {1} - {2}", objErrorAltan.errorCode, objErrorAltan.description, objErrorAltan.detail), False)
        End If
    End Sub
    Private Sub rgDashboard_ItemCommand(sender As Object, e As GridCommandEventArgs) Handles rgDashboard.ItemCommand
        If e.CommandName = RadGrid.EditCommandName Then
            Dim dataItem As GridDataItem = e.Item
            clearControls()
            Me.SIMID = Val(dataItem.GetDataKeyValue("SIMID"))
            ShowControls(True)
            FillSIM(Me.SIMID)
            rcbSIM.Enabled = False
            e.Canceled = True
        End If
    End Sub
    Private Sub FillSIM(ByVal SIMID As Integer)
        Dim objSIM As SIM = GetSIM(SIMID)
        Dim objCar As Car
        rcbSIM.SelectedValue = objSIM.SIMID
        rcbSIM.Text = objSIM.ICCID
        If Val(objSIM.CarID) > 0 Then
            objCar = FillCar(Val(objSIM.CarID))
            rcbVIN.SelectedValue = objCar.CarID
            rcbVIN.Text = objCar.VIN
        End If
    End Sub
    Private Function FillCar(ByVal CarID As Integer) As Car
        Return GetCar(CarID)
    End Function
    Private Sub rcbSIM_ItemsRequested(sender As Object, e As RadComboBoxItemsRequestedEventArgs) Handles rcbSIM.ItemsRequested
        sender.Items.Clear()
        If e.Text.Length > 2 Then
            Try
                Dim objController As New ControllerSIM
                Dim listSIM As New List(Of SIM)
                listSIM = objController.GetAvailableSIMsByMatch(String.Format("%{0}%", e.Text))

                Dim itemsPerRequest As Integer = 20
                Dim itemOffset As Integer = e.NumberOfItems
                Dim endOffset As Integer = itemOffset + itemsPerRequest
                If endOffset > listSIM.Count Then
                    endOffset = listSIM.Count
                End If

                With listSIM
                    Dim i As Integer
                    For i = itemOffset To endOffset - 1
                        sender.Items.Add(New RadComboBoxItem(listSIM.Item(i).ICCID, listSIM.Item(i).SIMID))
                    Next i

                    If .Count > 0 Then
                        e.Message = [String].Format("<b>1</b>-<b>{0}</b> de <b>{1}</b> encontrados", endOffset.ToString(), .Count.ToString())
                    Else
                        e.Message = "Sin coincidencias"
                    End If
                End With
            Catch ex As Exception
                e.Message = "Sin coincidencias"
            End Try
        End If
    End Sub
#End Region
#Region "EventCar"
    Private Sub lbAddCar_Click(sender As Object, e As EventArgs) Handles lbAddCar.Click
        clearControlsCar()
        ShowControlsCar(True)
    End Sub
    Private Sub btnCancelarCar_Click(sender As Object, e As EventArgs) Handles btnCancelarCar.Click
        clearControlsCar()
        ShowControlsCar(False)
    End Sub
    Private Sub btnGuardarCar_Click(sender As Object, e As EventArgs) Handles btnGuardarCar.Click
        Dim objController As New ControllerCar
        Dim objCar As New Car

        objCar.CarID = ucCarUser.CarID
        objCar.ModelID = ucCarUser.ModelID
        objCar.VIN = ucCarUser.VIN
        objCar.YEAR = ucCarUser.YEAR
        objCar.brand = ucCarUser.brand
        objCar.Color = ucCarUser.Color

        If objController.AddCar(objCar) > 0 Then
            btnCancelarCar.Text = "Regresar"
            DisplayMesage("El registro se guardo correctamente", True)
        Else
            DisplayMesage("El registro no se pudo guardar.", False)
        End If
    End Sub
    Private Sub rcbVIN_ItemsRequested(sender As Object, e As RadComboBoxItemsRequestedEventArgs) Handles rcbVIN.ItemsRequested
        sender.Items.Clear()
        If e.Text.Length > 2 Then
            Try
                Dim objController As New ControllerCar
                Dim listCar As New List(Of Car)
                listCar = objController.GetAvailableCarByMatch(String.Format("%{0}%", e.Text))

                Dim itemsPerRequest As Integer = 20
                Dim itemOffset As Integer = e.NumberOfItems
                Dim endOffset As Integer = itemOffset + itemsPerRequest
                If endOffset > listCar.Count Then
                    endOffset = listCar.Count
                End If

                With listCar
                    Dim i As Integer
                    For i = itemOffset To endOffset - 1
                        sender.Items.Add(New RadComboBoxItem(listCar.Item(i).VIN, listCar.Item(i).CarID))
                    Next i

                    If .Count > 0 Then
                        e.Message = [String].Format("<b>1</b>-<b>{0}</b> de <b>{1}</b> encontrados", endOffset.ToString(), .Count.ToString())
                    Else
                        e.Message = "Sin coincidencias"
                    End If
                End With
            Catch ex As Exception
                e.Message = "Sin coincidencias"
            End Try
        End If
    End Sub
#End Region
#End Region
End Class