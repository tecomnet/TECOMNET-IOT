Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI

Public Class ViewRecharge
    Inherits System.Web.UI.Page
    Private Property Customer As Customer
        Get
            Return Session("Usuario")
        End Get
        Set(value As Customer)
            Session("Usuario") = value
        End Set
    End Property
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Private Sub rgDashboard_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgDashboard.NeedDataSource
        Dim objController As New ControllerCustomerPayments
        rgDashboard.DataSource = objController.GetCustomerPaymentsDetails(Customer.CustomerID)
    End Sub
End Class