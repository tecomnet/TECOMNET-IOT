Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET

Public Class Profile
    Inherits System.Web.UI.Page

#Region "Property"
    Private Property Customer As Customer
        Get
            Return Session("Usuario")
        End Get
        Set(value As Customer)
            Session("Usuario") = value
        End Set
    End Property
#End Region
#Region "Event"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
        If Not Page.IsPostBack Then
            rtbPaternalSurname.Text = Customer.PaternalSurname
            rtbMaternalSurname.Text = Customer.MaternalSurname
            rtbName.Text = Customer.Name
            rdpDateBirth.SelectedDate = Customer.DateBirth
            rtbCustomerName.Text = Customer.CustomerName
            tbEmail.Text = Customer.Email
            tbPhoneNumber.Text = Customer.PhoneNumber
            rtbRFC.Text = Customer.RFC
            ddlSex.SelectedValue = Customer.Sex
            ddlCountry.SelectedValue = Customer.Country
            ddlState.SelectedValue = Customer.State
            rtbCologne.Text = Customer.Cologne
            rtbAddress.Text = Customer.Address
            rtbZipCode.Text = Customer.ZipCode
        End If
    End Sub

    Private Sub btnGuardar_Click(sender As Object, e As EventArgs) Handles btnGuardar.Click
        Dim objController As New ControllerCustomer
        Dim objCustomer As New Customer

        objCustomer.CustomerID = Customer.CustomerID
        objCustomer.PaternalSurname = rtbPaternalSurname.Text
        objCustomer.MaternalSurname = rtbMaternalSurname.Text
        objCustomer.Name = rtbName.Text
        objCustomer.CustomerName = rtbCustomerName.Text
        objCustomer.DateBirth = rdpDateBirth.SelectedDate
        objCustomer.Email = tbEmail.Text
        objCustomer.PhoneNumber = tbPhoneNumber.Text
        objCustomer.RFC = rtbRFC.Text
        objCustomer.Sex = ddlSex.SelectedValue
        objCustomer.Country = ddlCountry.SelectedValue
        objCustomer.State = ddlState.SelectedValue
        objCustomer.Cologne = rtbCologne.Text
        objCustomer.Address = rtbAddress.Text
        objCustomer.ZipCode = rtbZipCode.Text

        If objController.UpdateCustomer(objCustomer) > 0 Then
            DisplayMesage("El registro se actualizó correctamente", True)
            Customer = objCustomer
        Else
            DisplayMesage("El registro no se pudo actualizar.", False)
        End If
    End Sub
#End Region
#Region "Function"
    Private Sub DisplayMesage(message As String, success As Boolean)
        Dim literal As New LiteralControl(String.Format("<div class='{0}'>{1}</div>", IIf(success, "rounded mt-3 p-3 mb-2 bg-success text-white", "rounded mt-3 p-3 mb-2 bg-danger text-white"), message))
        MessagePanel.Controls.Add(literal)
    End Sub
#End Region




End Class