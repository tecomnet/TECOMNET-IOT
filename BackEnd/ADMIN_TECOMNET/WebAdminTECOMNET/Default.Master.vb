Imports System.IO
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Public Class _Default
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim page As String = Path.GetFileNameWithoutExtension(Request.AppRelativeCurrentExecutionFilePath)

            Select Case page
                Case "Home"
                    ChangeEstatusNav(hlHome)
                Case "AssociateSIM"
                    ChangeEstatusNav(hlAssociateSIM)
                Case "RegisterSale"
                    ChangeEstatusNav(hlRegisterCarCustomer)
                Case "UserAdmin"
                    ChangeEstatusNav(hlRegisterUser)
                Case "ChangePassword"
                    ChangeEstatusNav(hlCambiarContrasena)
                Case "RegisterModels"
                    ChangeEstatusNav(hlResgisterModel)
                Case "RegisterProduct"
                    ChangeEstatusNav(hlProducts)
                Case "AdminCar"
                    ChangeEstatusNav(hlAdminCars)
                Case "AdminCustomer"
                    ChangeEstatusNav(hlAdminCustomers)
                Case "AdminSIM"
                    ChangeEstatusNav(hlAdminSIMS)
                Case "Reports"
                    ChangeEstatusNav(hlReports)
                Case "AdminCompany"
                    ChangeEstatusNav(hlCompany)
            End Select

            Select Case DirectCast(Session("Usuario"), User).UserType
                Case UserType.AdministratorTECOMNET
                    hlAssociateSIM.Visible = True
                    hlRegisterCarCustomer.Visible = True
                    hlRegisterUser.Visible = True
                    hlCambiarContrasena.Visible = True
                    hlResgisterModel.Visible = True
                    hlProducts.Visible = True
                    hlAdminCustomers.Visible = True
                    hlAdminCars.Visible = True
                    hlAdminSIMS.Visible = True
                    hlReports.Visible = True
                    hlCompany.Visible = True
                Case UserType.Installer
                    hlAssociateSIM.Visible = True
                    hlRegisterCarCustomer.Visible = False
                    hlRegisterUser.Visible = False
                    hlCambiarContrasena.Visible = True
                    hlResgisterModel.Visible = False
                    hlProducts.Visible = False
                    hlAdminCustomers.Visible = False
                    hlAdminCars.Visible = False
                    hlAdminSIMS.Visible = False
                    hlReports.Visible = False
                    hlCompany.Visible = False
                Case UserType.Seller
                    hlAssociateSIM.Visible = False
                    hlRegisterCarCustomer.Visible = True
                    hlRegisterUser.Visible = False
                    hlCambiarContrasena.Visible = True
                    hlResgisterModel.Visible = False
                    hlProducts.Visible = False
                    hlAdminCustomers.Visible = False
                    hlAdminCars.Visible = False
                    hlAdminSIMS.Visible = False
                    hlReports.Visible = False
                    hlCompany.Visible = False
                Case UserType.AdminBYD
                    hlAssociateSIM.Visible = False
                    hlRegisterCarCustomer.Visible = False
                    hlRegisterUser.Visible = False
                    hlCambiarContrasena.Visible = False
                    hlResgisterModel.Visible = False
                    hlProducts.Visible = False
                    hlAdminCustomers.Visible = False
                    hlAdminCars.Visible = False
                    hlAdminSIMS.Visible = False
                    hlReports.Visible = True
                    hlAdminCat.Visible = False
                    hlAdminGral.Visible = False
                    hlCompany.Visible = False
            End Select

        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    Public Sub ChangeEstatusNav(ByRef objHyperlink As HyperLink)
        objHyperlink.CssClass = "nav-link active"
    End Sub
    Protected Sub lbCerrarSesion_Click(sender As Object, e As EventArgs)
        Try
            Session("Usuario") = Nothing
            Dim nameCookie As HttpCookie = Request.Cookies("ID")
            nameCookie.Expires = DateTime.Now.AddDays(-1)
            Response.Cookies.Add(nameCookie)
            FormsAuthentication.RedirectToLoginPage()
        Catch ex As Exception
            FormsAuthentication.RedirectToLoginPage()
        End Try
    End Sub
End Class