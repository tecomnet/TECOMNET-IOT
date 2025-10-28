Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI

Public Class UserAdmin
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
    Private Property UserID As Integer
        Get
            Return Val(ViewState("UserID"))
        End Get
        Set(value As Integer)
            ViewState("UserID") = value
        End Set
    End Property
#End Region
#Region "Metodos y funciones"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerUser
        rgDashboard.DataSource = objController.GetUsers
    End Sub
    Private Sub ShowControls(ByVal isUpdate As Boolean)
        pnlUser.Visible = isUpdate
        rgDashboard.Visible = Not isUpdate
        rtbMenu.Visible = Not isUpdate
    End Sub
    Private Sub clearControls()
        rrblUserType.SelectedIndex = 0
        rtbUserName.Text = String.Empty
        rtbName.Text = String.Empty
        tbEmail.Text = String.Empty
        tbPhoneNumber.Text = String.Empty
        tbPassword.Text = String.Empty
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
    Public Sub FillUser(ByVal UserID As Integer)
        Dim objController As New ControllerUser
        Dim objUser As New User
        objUser = objController.GetUser(UserID)

        Me.UserID = objUser.UserID
        rrblUserType.SelectedValue = objUser.UserType
        rtbUserName.Text = objUser.UserName
        rtbName.Text = objUser.Name
        tbEmail.Text = objUser.Email
        tbPhoneNumber.Text = objUser.PhoneNumber
        tbPassword.Text = objUser.Password
    End Sub
#End Region
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub rtbMenu_ButtonClick(sender As Object, e As RadToolBarEventArgs) Handles rtbMenu.ButtonClick
        ShowControls(True)
        clearControls()
        UserID = 0
    End Sub
    Private Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        ShowControls(False)
        clearControls()
        UserID = 0
    End Sub
    Private Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Dim objController As New ControllerUser
        Dim objUser As New User

        objUser.UserID = Me.UserID
        objUser.UserName = rtbUserName.Text
        objUser.Name = rtbName.Text
        objUser.Email = tbEmail.Text
        objUser.Password = Securyty.Cifrar(tbPassword.Text)
        objUser.PhoneNumber = tbPhoneNumber.Text
        objUser.UserType = rrblUserType.SelectedValue

        If Me.UserID > 0 Then
            If objController.UpdateUser(objUser) > 0 Then
                clearControls()
                ShowControls(False)
                rgDashboard.Rebind()
                DisplayMesage("El registro se actualizó correctamente", True)
            Else
                DisplayMesage("Error al actualizar el registro", False)
            End If
        Else
            If objController.AddUser(objUser) > 0 Then
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
        Dim id As Integer = Val(e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("UserID").ToString())

        Dim objController As New ControllerUser

        If objController.DesactivateUser(id) Then
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
            Me.UserID = Val(dataItem.GetDataKeyValue("UserID"))
            ShowControls(True)
            FillUser(Me.UserID)
            e.Canceled = True
        End If
    End Sub
#End Region

End Class