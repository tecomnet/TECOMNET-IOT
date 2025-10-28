Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI

Public Class AdminCompany
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
    Private Property CompanyId As Integer
        Get
            Return Val(ViewState("CompanyId"))
        End Get
        Set(value As Integer)
            ViewState("CompanyId") = value
        End Set
    End Property
#End Region
#Region "Metodos y funciones"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerCompany
        rgDashboard.DataSource = objController.GetCompanys
    End Sub
    Private Sub ShowControls(ByVal isUpdate As Boolean)
        pnlEmpresa.Visible = isUpdate
        rgDashboard.Visible = Not isUpdate
        rtbMenu.Visible = Not isUpdate
    End Sub
    Private Sub clearControls()
        rtbCompany.Text = String.Empty
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
    Public Sub FillCompany(ByVal CompanyID As Integer)
        Dim objController As New ControllerCompany
        Dim objCompany As New Company
        objCompany = objController.GetCompany(CompanyID)
        Me.CompanyId = objCompany.CompanyID
        rtbCompany.Text = objCompany.Company
    End Sub
#End Region
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub rtbMenu_ButtonClick(sender As Object, e As RadToolBarEventArgs) Handles rtbMenu.ButtonClick
        ShowControls(True)
        clearControls()
        CompanyId = 0
    End Sub
    Private Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        ShowControls(False)
        clearControls()
        CompanyId = 0
    End Sub
    Private Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Dim objController As New ControllerCompany
        Dim objCompany As New Company

        objCompany.CompanyID = Me.CompanyId
        objCompany.Company = rtbCompany.Text
        objCompany.CreationDate = Now

        If Me.CompanyId > 0 Then
            If objController.UpdateCompany(objCompany) > 0 Then
                clearControls()
                ShowControls(False)
                rgDashboard.Rebind()
                DisplayMesage("El registro se actualizó correctamente", True)
            Else
                DisplayMesage("Error al actualizar el registro", False)
            End If
        Else
            If objController.AddCompany(objCompany) > 0 Then
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
        Dim id As Integer = Val(e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("CompanyId").ToString())

        Dim objController As New ControllerCompany

        If objController.DesactivateCompany(id) Then
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
            Me.CompanyId = Val(dataItem.GetDataKeyValue("CompanyId"))
            ShowControls(True)
            FillCompany(Me.CompanyId)
            e.Canceled = True
        End If
    End Sub
#End Region

End Class