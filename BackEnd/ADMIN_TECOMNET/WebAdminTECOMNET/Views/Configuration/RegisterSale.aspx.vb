Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Pdf.PdfName
Imports Telerik.Web.UI
Public Class RegisterSale
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
#Region "Function SIM"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerCar
        rgDashboard.DataSource = objController.GetCars
    End Sub
    Private Sub ShowControls(ByVal isUpdate As Boolean)
        pnlCar.Visible = isUpdate
        rgDashboard.Visible = Not isUpdate
        rtbMenu.Visible = Not isUpdate
        pnlCustomer.Visible = False
    End Sub
    Private Sub clearControls()
        rcbVIN.Enabled = True
        rcbVIN.ClearSelection()
        rcbVIN.Text = String.Empty
        rcbVIN.SelectedValue = 0
        rcbCustomerName.ClearSelection()
        rcbCustomerName.Text = String.Empty
        rcbCustomerName.SelectedValue = 0
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
    Public Function GetCar(ByVal CarID As Integer) As Car
        Dim objController As New ControllerCar
        Dim objCar As New Car
        objCar = objController.GetCar(CarID)
        Return objCar
    End Function
#End Region
#Region "FunctionCustomer"
    Private Sub ShowControlsCustomer(ByVal isUpdate As Boolean)
        pnlCustomer.Visible = isUpdate
        pnlCar.Visible = Not isUpdate
        btnCancelarCustomer.Text = "Cancelar"
    End Sub
    Private Sub clearControlsCustomer()
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
    Public Function GetCustomer(ByVal CustomerID As Integer) As Customer
        Dim objController As New ControllerCustomer
        Dim objCustomer As New Customer
        objCustomer = objController.GetCustomer(CustomerID)
        Return objCustomer
    End Function
#End Region
#End Region
#Region "Eventos"
#Region "EventCar"
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

        If Val(rcbVIN.SelectedValue) = 0 Or Val(rcbCustomerName.SelectedValue) = 0 Then
            DisplayMesage("Todos los campos son obligatorios.", True)
        Else
            objCar.CarID = IIf(Me.CarID = 0, Val(rcbVIN.SelectedValue), Me.CarID)
            objCar.CustomerID = Val(rcbCustomerName.SelectedValue)

            If objCar.CarID > 0 Then
                If objController.AssociateCarToCustomer(objCar) > 0 Then
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
        Dim id As Integer = Val(e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("CarID").ToString())

        Dim objController As New ControllerCar

        If objController.DeactivateCar(id) Then
            DisplayMesage("El registro se dio de baja correctamente.", True)
            ShowControls(False)
            clearControls()
            CarID = 0
            rgDashboard.Rebind()
        Else
            DisplayMesage("No se pudo dar de baja el registro", False)
        End If
    End Sub
    Private Sub rgDashboard_ItemCommand(sender As Object, e As GridCommandEventArgs) Handles rgDashboard.ItemCommand
        If e.CommandName = RadGrid.EditCommandName Then
            Dim dataItem As GridDataItem = e.Item
            clearControls()
            Me.CarID = Val(dataItem.GetDataKeyValue("CarID"))
            ShowControls(True)
            FillCar(Me.CarID)
            rcbVIN.Enabled = False
            e.Canceled = True
        End If
    End Sub
    Private Sub FillCar(ByVal carID As Integer)
        Dim objCar As Car = GetCar(carID)
        Dim objCustomer As Customer
        rcbVIN.SelectedValue = objCar.CarID
        rcbVIN.Text = objCar.VIN
        If Val(objCar.CustomerID) > 0 Then
            objCustomer = FillCustomer(Val(objCar.CustomerID))
            rcbCustomerName.SelectedValue = objCustomer.CustomerID
            rcbCustomerName.Text = objCustomer.CustomerName
        End If
    End Sub
    Private Function FillCustomer(ByVal CustomerID As Integer) As Customer
        Return GetCustomer(CustomerID)
    End Function
    Private Sub rcbVIN_ItemsRequested(sender As Object, e As RadComboBoxItemsRequestedEventArgs) Handles rcbVIN.ItemsRequested
        sender.Items.Clear()
        If e.Text.Length > 0 Then
            Try
                Dim objController As New ControllerCar
                Dim listCar As New List(Of Car)
                listCar = objController.GetAvailableCarCustomerByMatch(String.Format("%{0}%", e.Text))

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
#Region "EventCustomer"
    Private Sub lbAddCustomer_Click(sender As Object, e As EventArgs) Handles lbAddCustomer.Click
        clearControlsCustomer()
        ShowControlsCustomer(True)
    End Sub
    Private Sub btnCancelarCustomer_Click(sender As Object, e As EventArgs) Handles btnCancelarCustomer.Click
        clearControlsCustomer()
        ShowControlsCustomer(False)
    End Sub
    Private Sub btnGuardarCustomer_Click(sender As Object, e As EventArgs) Handles btnGuardarCustomer.Click
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

        If objController.AddCustomer(objCustomer) > 0 Then
            btnCancelarCustomer.Text = "Regresar"
            DisplayMesage("El registro se guardo correctamente", True)
        Else
            DisplayMesage("El registro no se pudo guardar.", False)
        End If
    End Sub
    Private Sub rcbCustomerName_ItemsRequested(sender As Object, e As RadComboBoxItemsRequestedEventArgs) Handles rcbCustomerName.ItemsRequested
        sender.Items.Clear()
        If e.Text.Length > 2 Then
            Try
                Dim objController As New ControllerCustomer
                Dim listCustomer As New List(Of Customer)
                listCustomer = objController.GetCustomerByMatch(String.Format("%{0}%", e.Text))

                Dim itemsPerRequest As Integer = 20
                Dim itemOffset As Integer = e.NumberOfItems
                Dim endOffset As Integer = itemOffset + itemsPerRequest
                If endOffset > listCustomer.Count Then
                    endOffset = listCustomer.Count
                End If

                With listCustomer
                    Dim i As Integer
                    For i = itemOffset To endOffset - 1
                        Dim item = New RadComboBoxItem
                        item.Text = listCustomer.Item(i).CustomerName
                        item.Value = listCustomer.Item(i).CustomerID
                        item.Attributes("RFC") = listCustomer.Item(i).RFC
                        item.Attributes("CustomerName") = listCustomer.Item(i).CustomerName
                        rcbCustomerName.Items.Add(item)
                        item.DataBind()
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