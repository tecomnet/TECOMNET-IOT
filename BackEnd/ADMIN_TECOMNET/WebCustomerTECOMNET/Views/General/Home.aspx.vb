Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports System.Text.Json

Public Class Home
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
#Region "Events"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'AlexSD 09042026 - Inicia Correccion para eliminar la cookie de ID al cerrar sesión, se agrega validación para evitar que se pueda acceder a la página sin iniciar sesión
        'Evitar cache (para botón atrás)
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.Cache.SetNoStore()
        Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1))

        'Validar sesión
        If Session("Usuario") Is Nothing Then
            FormsAuthentication.RedirectToLoginPage()
            Return
        End If

        'Solo cargar datos la primera vez
        If Not Page.IsPostBack Then
            lblCustomerName.Text = String.Format("Hola, {0}", Customer.CustomerName)
            llenaDatos()
        End If

    End Sub

#End Region
#Region "Functions and metods"
    Public Sub llenaDatos()
        Dim objController As New ControllerSIM
        Dim ListSIMDetail As New List(Of SIMDetail)
        Dim objAltanResult As New AltanResult
        Dim objErrorAltan As New ErrorAltan
        Dim altan As New ConectionAltanRedes

        ListSIMDetail = objController.GetSIMsAssociateCustomer(Customer.CustomerID)

        For Each objSim As SIMDetail In ListSIMDetail
            objAltanResult = altan.GetAPIService(objSim.MSISDN, AltanApisMethod.Profile)
            If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
                Dim profile As New ResponseSubscriber
                profile = JsonSerializer.Deserialize(Of ResponseSubscriber)(objAltanResult.JSON)
                objSim.EstausAltan = profile.ResponseSubscriber.Status.SubStatus
                objSim.AvailableMB = (objSim.AssignedMB + objSim.AdditionalMB) - (profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.TotalAmt - profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.UnusedAmt)
            Else
                'objErrorAltan = JsonSerializer.Deserialize(Of ErrorAltan)(objAltanResult.JSON)
                'DisplayMesage(String.Format("No se puede consultar el perfil - {0} - {1} - {2}", objErrorAltan.errorCode, objErrorAltan.description, objErrorAltan.detail), False)
            End If
        Next

        lvSIMS.DataSource = ListSIMDetail
        lvSIMS.DataBind()
    End Sub
#End Region
End Class