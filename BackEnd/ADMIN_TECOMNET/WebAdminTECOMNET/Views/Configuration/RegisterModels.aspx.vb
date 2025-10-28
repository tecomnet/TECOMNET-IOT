Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI

Public Class RegisterModels
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
    Private Property ModelID As Integer
        Get
            Return Val(ViewState("ModelID"))
        End Get
        Set(value As Integer)
            ViewState("ModelID") = value
        End Set
    End Property
#End Region
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub rtbMenu_ButtonClick(sender As Object, e As RadToolBarEventArgs) Handles rtbMenu.ButtonClick
        ShowControls(True)
        clearControls()
        ModelID = 0
    End Sub
    Private Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        ShowControls(False)
        clearControls()
        ModelID = 0
    End Sub
    Private Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Dim objController As New ControllerModelBYD
        Dim objBYDModels As New BYDModels

        objBYDModels.ModelID = Me.ModelID
        objBYDModels.Model = rtbModel.Text

        If Me.ModelID > 0 Then
            If objController.UpdateModelBYD(objBYDModels) > 0 Then
                clearControls()
                ShowControls(False)
                rgDashboard.Rebind()
                DisplayMesage("El registro se actualizó correctamente", True)
            Else
                DisplayMesage("Error al actualizar el registro", False)
            End If
        Else
            If objController.AddModelBYD(objBYDModels) > 0 Then
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
        Dim id As Integer = Val(e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("ModelID").ToString())

        Dim objController As New ControllerModelBYD

        If objController.DeactivateModelBYD(id) Then
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
            Me.ModelID = Val(dataItem.GetDataKeyValue("ModelID"))
            ShowControls(True)
            FillModel(Me.ModelID)
            e.Canceled = True
        End If
    End Sub
#End Region
#Region "Metodos y funciones"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerModelBYD
        rgDashboard.DataSource = objController.GetModelsBYD
    End Sub
    Private Sub ShowControls(ByVal isUpdate As Boolean)
        pnlModels.Visible = isUpdate
        rgDashboard.Visible = Not isUpdate
        rtbMenu.Visible = Not isUpdate
    End Sub
    Private Sub clearControls()
        rtbModel.Text = String.Empty
    End Sub

    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
    Public Sub FillModel(ByVal ModelID As Integer)
        Dim objController As New ControllerModelBYD
        Dim objBYDModel As New BYDModels
        objBYDModel = objController.GetModelBYD(ModelID)
        Me.ModelID = objBYDModel.ModelID
        rtbModel.Text = objBYDModel.Model
    End Sub
#End Region
End Class