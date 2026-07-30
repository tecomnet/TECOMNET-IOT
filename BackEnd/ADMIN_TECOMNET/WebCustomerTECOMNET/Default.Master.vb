Imports System.IO

Public Class _Default
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim page As String = Path.GetFileNameWithoutExtension(Request.AppRelativeCurrentExecutionFilePath)

            Select Case page
                Case "Home"
                    ChangeEstatusNav(hlHome)
                Case "ChangePassword"
                    ChangeEstatusNav(hlChagePassword)
                Case "Profile"
                    ChangeEstatusNav(hlProfile)
                Case "Recharge"
                    ChangeEstatusNav(hlRecharge)
                Case "Help"
                    'ChangeEstatusNav(hlHelp)
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

            'AlexSD 09042026 - Inicia Correccion para eliminar la cookie de ID al cerrar sesión
            Session.Clear()
            Session.Abandon()
            If Request.Cookies("ID") IsNot Nothing Then
                Dim nameCookie As New HttpCookie("ID")
                nameCookie.Expires = DateTime.Now.AddDays(-1)
                Response.Cookies.Add(nameCookie)
            End If

            'Se comenta el siguiente bloque de código porque se elimina la cookie de ID al cerrar sesión,
            'por lo que no es necesario buscarla para eliminarla
            'Dim nameCookie As HttpCookie = Request.Cookies("ID")
            'nameCookie.Expires = DateTime.Now.AddDays(-1)
            'Response.Cookies.Add(nameCookie)
            FormsAuthentication.SignOut()
            'AlexSD 09042026 - Termina Correccion para eliminar la cookie de ID al cerrar sesión

            FormsAuthentication.RedirectToLoginPage()
        Catch ex As Exception
            FormsAuthentication.RedirectToLoginPage()
        End Try
    End Sub
End Class