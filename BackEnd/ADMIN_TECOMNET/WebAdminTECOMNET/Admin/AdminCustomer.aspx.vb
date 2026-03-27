Imports System.Net
Imports System.Reflection.Emit
Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI

Public Class AdminCustomer
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
    Private Property CustomerID As Integer
        Get
            Return Val(ViewState("CustomerID"))
        End Get
        Set(value As Integer)
            ViewState("CustomerID") = value
        End Set
    End Property
#End Region
#Region "Metodos y funciones"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objControllerCustomer As New ControllerCustomer
        rgDashboard.DataSource = objControllerCustomer.GetCustomer
    End Sub
    Private Sub ShowControls(ByVal isUpdate As Boolean)
        pnlCustomer.Visible = isUpdate
        rgDashboard.Visible = Not isUpdate
        rtbMenu.Visible = Not isUpdate
    End Sub
    Private Sub clearControls()
        ucCustomer.CustomerID = 0
        ucCustomer.PaternalSurname = String.Empty
        ucCustomer.MaternalSurname = String.Empty
        ucCustomer.Name = String.Empty
        ucCustomer.CustomerName = String.Empty
        ucCustomer.DateBirth = Nothing
        ucCustomer.Email = String.Empty
        ucCustomer.PhoneNumber = String.Empty
        ucCustomer.RFC = String.Empty
        ucCustomer.CURP = String.Empty
        ucCustomer.Sex = "F"
        ucCustomer.Country = "Mexico"
        ucCustomer.State = "Ciudad de México"
        ucCustomer.Cologne = String.Empty
        ucCustomer.Address = String.Empty
        ucCustomer.ZipCode = String.Empty
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
    Public Sub FillCustomer(ByVal CustomerID As Integer)
        Dim objControllerCustomer As New ControllerCustomer
        Dim objCustomer As New Customer
        objCustomer = objControllerCustomer.GetCustomer(CustomerID)

        ucCustomer.CustomerID = objCustomer.CustomerID
        ucCustomer.PaternalSurname = objCustomer.PaternalSurname
        ucCustomer.MaternalSurname = objCustomer.MaternalSurname
        ucCustomer.Name = objCustomer.Name
        ucCustomer.CustomerName = objCustomer.CustomerName
        ucCustomer.DateBirth = objCustomer.DateBirth
        ucCustomer.Email = objCustomer.Email
        ucCustomer.PhoneNumber = objCustomer.PhoneNumber
        ucCustomer.RFC = objCustomer.RFC
        ucCustomer.CURP = objCustomer.CURP
        ucCustomer.Sex = objCustomer.Sex
        ucCustomer.Country = objCustomer.Country
        ucCustomer.State = objCustomer.State
        ucCustomer.Cologne = objCustomer.Cologne
        ucCustomer.Address = objCustomer.Address
        ucCustomer.ZipCode = objCustomer.ZipCode

    End Sub
#End Region
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub rtbMenu_ButtonClick(sender As Object, e As RadToolBarEventArgs) Handles rtbMenu.ButtonClick
        ShowControls(True)
        clearControls()
        CustomerID = 0
    End Sub
    Private Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        ShowControls(False)
        clearControls()
        CustomerID = 0
    End Sub
    Private Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Dim objController As New ControllerCustomer
        Dim objCustomer As New Customer

        objCustomer.CustomerID = ucCustomer.CustomerID
        objCustomer.PaternalSurname = ucCustomer.PaternalSurname
        objCustomer.MaternalSurname = ucCustomer.MaternalSurname
        objCustomer.Name = ucCustomer.Name
        objCustomer.CustomerName = ucCustomer.CustomerName
        objCustomer.DateBirth = ucCustomer.DateBirth
        objCustomer.Email = ucCustomer.Email
        objCustomer.PhoneNumber = ucCustomer.PhoneNumber
        objCustomer.RFC = ucCustomer.RFC
        objCustomer.CURP = ucCustomer.CURP
        objCustomer.Sex = ucCustomer.Sex
        objCustomer.Country = ucCustomer.Country
        objCustomer.State = ucCustomer.State
        objCustomer.Cologne = ucCustomer.Cologne
        objCustomer.Address = ucCustomer.Address
        objCustomer.ZipCode = ucCustomer.ZipCode

        If Me.CustomerID > 0 Then
            If objController.UpdateCustomer(objCustomer) > 0 Then
                clearControls()
                ShowControls(False)
                rgDashboard.Rebind()
                DisplayMesage("El registro se actualizó correctamente", True)
            Else
                DisplayMesage("Error al actualizar el registro", False)
            End If
        Else
            If objController.AddCustomer(objCustomer) > 0 Then
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
        Dim id As Integer = Val(e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("CustomerID").ToString())

        Dim objController As New ControllerCustomer

        If objController.DesactivateCustomer(id) Then
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
            Me.CustomerID = Val(dataItem.GetDataKeyValue("CustomerID"))
            ShowControls(True)
            FillCustomer(Me.CustomerID)
            e.Canceled = True
        End If
    End Sub
#End Region


End Class