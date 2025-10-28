Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports Telerik.Web.UI
Public Class CarUser
    Inherits System.Web.UI.UserControl
#Region "Properties"
    Public Property CarID As Integer
        Get
            Return Val(hfCarID.Value)
        End Get
        Set(value As Integer)
            hfCarID.Value = value
        End Set
    End Property
    Public Property ModelID As Integer
        Get
            Return Val(rcbModel.SelectedValue)
        End Get
        Set(value As Integer)
            rcbModel.SelectedValue = value
        End Set
    End Property
    Public Property VIN As String
        Get
            Return rtbVIN.Text
        End Get
        Set(value As String)
            rtbVIN.Text = value
        End Set
    End Property
    Public Property YEAR As Integer
        Get
            Return Val(rntbYear.Value)
        End Get
        Set(value As Integer)
            rntbYear.Value = value
        End Set
    End Property
    Public Property brand As String
        Get
            Return rtbMarca.Text
        End Get
        Set(value As String)
            rtbMarca.Text = value
        End Set
    End Property
    Public Property Color As String
        Get
            Return rtbColor.Text
        End Get
        Set(value As String)
            rtbColor.Text = value
        End Set
    End Property
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            GetModels()
        End If
    End Sub

    Public Sub GetModels()
        Dim objController As New ControllerModelBYD
        If Me.CarID = 0 Then
            rcbModel.DataSource = objController.GetModelsBYD()
        Else
            rcbModel.DataSource = objController.GetAvailableModelsBYD()
        End If
        rcbModel.DataTextField = "Model"
        rcbModel.DataValueField = "ModelID"
        rcbModel.DataBind()
    End Sub
End Class