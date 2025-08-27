Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI

Public Class AdminCar
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
    Private Property CarID As Integer
        Get
            Return Val(ViewState("CarID"))
        End Get
        Set(value As Integer)
            ViewState("CarID") = value
        End Set
    End Property
#End Region
#Region "Metodos y funciones"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objControllerCar As New ControllerCar
        rgDashboard.DataSource = objControllerCar.GetCars
    End Sub
    Private Sub ShowControls(ByVal isUpdate As Boolean)
        pnlCar.Visible = isUpdate
        rgDashboard.Visible = Not isUpdate
        rtbMenu.Visible = Not isUpdate
    End Sub
    Private Sub clearControls()
        ucCarUser.CarID = 0
        ucCarUser.ModelID = 0
        ucCarUser.VIN = String.Empty
        ucCarUser.YEAR = Now.Year
        ucCarUser.brand = String.Empty
        ucCarUser.Color = String.Empty
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
    Public Sub FillCar(ByVal CarID As Integer)
        Dim objControllerCar As New ControllerCar
        Dim objCar As New Car
        objCar = objControllerCar.GetCar(CarID)

        ucCarUser.CarID = objCar.CarID
        ucCarUser.ModelID = objCar.ModelID
        ucCarUser.VIN = objCar.VIN
        ucCarUser.YEAR = objCar.YEAR
        ucCarUser.brand = objCar.brand
        ucCarUser.Color = objCar.Color
    End Sub
#End Region
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub rtbMenu_ButtonClick(sender As Object, e As RadToolBarEventArgs) Handles rtbMenu.ButtonClick
        ShowControls(True)
        clearControls()
        CarID = 0
    End Sub
    Private Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        ShowControls(False)
        clearControls()
        CarID = 0
    End Sub
    Private Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Dim objController As New ControllerCar
        Dim objCar As New Car

        objCar.CarID = ucCarUser.CarID
        objCar.ModelID = ucCarUser.ModelID
        objCar.VIN = ucCarUser.VIN
        objCar.YEAR = ucCarUser.YEAR
        objCar.brand = ucCarUser.brand
        objCar.Color = ucCarUser.Color

        If Me.CarID > 0 Then
            If objController.UpdateCar(objCar) > 0 Then
                clearControls()
                ShowControls(False)
                rgDashboard.Rebind()
                DisplayMesage("El registro se actualizó correctamente", True)
            Else
                DisplayMesage("Error al actualizar el registro", False)
            End If
        Else
            If objController.AddCar(objCar) > 0 Then
                clearControls()
                ShowControls(False)
                rgDashboard.Rebind()
                DisplayMesage("El registro se guardo correctamente", True)
            Else
                DisplayMesage("El registro no se pudo guardar.", False)
            End If
        End If

    End Sub
    Private Sub rgDashboard_DeleteCommand(sender As Object, e As GridCommandEventArgs) Handles rgDashboard.DeleteCommand
        Dim id As Integer = Val(e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("CarID").ToString())

        Dim objController As New ControllerCar

        If objController.DeactivateCar(id) Then
            DisplayMesage("El registro se dio de baja correctamente.", True)
            clearControls()
            ShowControls(False)
            rgDashboard.Rebind()
        Else
            DisplayMesage("No se pudo dar de baja el registro", False)
        End If
    End Sub
    Private Sub rgDashboard_ItemCommand(sender As Object, e As GridCommandEventArgs) Handles rgDashboard.ItemCommand
        If e.CommandName = RadGrid.EditCommandName Then
            Dim dataItem As GridDataItem = e.Item
            Me.CarID = Val(dataItem.GetDataKeyValue("CarID"))
            ShowControls(True)
            FillCar(Me.CarID)
            e.Canceled = True
        End If
    End Sub
#End Region
End Class