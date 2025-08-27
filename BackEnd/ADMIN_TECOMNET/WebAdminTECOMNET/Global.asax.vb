Imports System.Web.SessionState

Public Class Global_asax
    Inherits System.Web.HttpApplication

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al iniciar la aplicación
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al iniciar la sesión
    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al comienzo de cada solicitud
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al intentar autenticar el uso
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena cuando se produce un error
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena cuando finaliza la sesión
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena cuando finaliza la aplicación
    End Sub
    Sub Application_PostAcquireRequestState()
        If HttpContext.Current.Session IsNot Nothing AndAlso HttpContext.Current.Session("Usuario") Is Nothing Then
            Try
                If HttpContext.Current.Request.Url.AbsolutePath <> FormsAuthentication.LoginUrl And HttpContext.Current.Session("Usuario") = Nothing Then
                    Select Case HttpContext.Current.Request.Url.AbsolutePath
                        'Case "/WinsefQuick/Default"
                        'Case "/WinsefQuick/Views/Account/ResetPassword"
                        'Case "/WinsefQuick/Views/Account/ResetPasswordConfirmation"
                        Case "/ConsultaSeguro/Views/Account/ResetPassword.aspx"
                        Case "/ConsultaSeguro/Views/Account/InsuredRegistration.aspx"
                        Case "/Views/Account/ResetPassword.aspx"
                        Case "/Views/Account/InsuredRegistration.aspx"
                        Case Else
                            Server.ClearError()
                            Response.Clear()
                            FormsAuthentication.RedirectToLoginPage()
                    End Select
                End If
            Catch ex As Exception
                FormsAuthentication.RedirectToLoginPage()
            End Try
        End If
    End Sub

End Class