Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI
Public Class RegisterProduct
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
    Private Property ProductId As Integer
        Get
            Return Val(ViewState("ProductId"))
        End Get
        Set(value As Integer)
            ViewState("ProductId") = value
        End Set
    End Property
#End Region
#Region "Metodos y funciones"
    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerProduct
        rgDashboard.DataSource = objController.GetProducts()
    End Sub
    Private Sub ShowControls(ByVal isUpdate As Boolean)
        pnlProducts.Visible = isUpdate
        rgDashboard.Visible = Not isUpdate
        rtbMenu.Visible = Not isUpdate
        GetCompanys()
    End Sub
    Private Sub clearControls()
        rtbProductName.Text = String.Empty
        rntbPrice.Value = 1
        rntbMB.Value = 1
        rtbOffertID.Text = String.Empty
        GetCompanys()
    End Sub
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
    Public Sub FillProduct(ByVal ProducID As Integer)
        Dim objController As New ControllerProduct
        Dim objProduct As New Product
        objProduct = objController.GetProduct(ProducID)
        Me.ProductId = objProduct.ProductID
        rtbProductName.Text = objProduct.ProductName
        rntbPrice.Value = objProduct.Price
        rntbMB.Value = objProduct.MB
        rtbOffertID.Text = objProduct.OfferIdAltan
        ddlCompany.SelectedValue = objProduct.CompanyID
    End Sub
    Public Sub GetCompanys()
        Dim objController As New ControllerCompany
        ddlCompany.DataSource = objController.GetCompanys
        ddlCompany.DataTextField = "Company"
        ddlCompany.DataValueField = "CompanyID"
        ddlCompany.DataBind()
    End Sub
#End Region
#Region "Eventos"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
    End Sub
    Private Sub rtbMenu_ButtonClick(sender As Object, e As RadToolBarEventArgs) Handles rtbMenu.ButtonClick
        ShowControls(True)
        clearControls()
        ProductId = 0
    End Sub
    Private Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        ShowControls(False)
        clearControls()
        ProductId = 0
    End Sub
    Private Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Dim objController As New ControllerProduct
        Dim objProduct As New Product

        objProduct.ProductID = Me.ProductId
        objProduct.ProductName = rtbProductName.Text
        objProduct.Price = rntbPrice.Value
        objProduct.MB = rntbMB.Value
        objProduct.CompanyID = ddlCompany.SelectedValue
        objProduct.OfferIdAltan = rtbOffertID.Text

        If Me.ProductId > 0 Then
            If objController.UpdateProduct(objProduct) > 0 Then
                clearControls()
                ShowControls(False)
                rgDashboard.Rebind()
                DisplayMesage("El registro se actualizó correctamente", True)
            Else
                DisplayMesage("Error al actualizar el registro", False)
            End If
        Else
            If objController.AddProduct(objProduct) > 0 Then
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
        Dim id As Integer = Val(e.Item.OwnerTableView.DataKeyValues(e.Item.ItemIndex)("ProductId").ToString())

        Dim objController As New ControllerProduct

        If objController.DeactivateProduct(id) Then
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
            Me.ProductId = Val(dataItem.GetDataKeyValue("ProductId"))
            ShowControls(True)
            FillProduct(Me.ProductId)
            e.Canceled = True
        End If
    End Sub
#End Region
End Class