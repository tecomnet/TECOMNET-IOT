Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
        If Not Page.IsPostBack Then
            Try
                Recordar()
            Catch ex As Exception
            End Try
        End If
    End Sub

    Private Sub btnIngresar_Click(sender As Object, e As EventArgs) Handles btnIngresar.Click

        Dim objUsuario As New User
        Dim objController As New ControllerUser

        objUsuario = objController.LoginUser(txtCorreo.Text, Securyty.Cifrar(txtPassword.Text))

        If objUsuario.UserID > 0 Then
            Session("Usuario") = objUsuario

            If cbRecordarme.Checked Then
                Dim nameCookie As New HttpCookie("ID")
                nameCookie.Values("ID") = objUsuario.UserID
                nameCookie.Expires = DateTime.Now.AddDays(30)
                Response.Cookies.Add(nameCookie)
            End If
            Response.Redirect("../../Home.aspx")
        Else
            ErrorMessageDiv.Visible = True
            FailureText.Text = "Usuario o contraseña incorrectos"
        End If
    End Sub
    Protected Sub Recordar()
        Dim ID As Integer = 0
        Dim nameCookie As HttpCookie = Request.Cookies("ID")

        If nameCookie IsNot Nothing Then
            Dim name As String = If(nameCookie IsNot Nothing, nameCookie.Value.Split("="c)(1), "undefined")
            ID = Val(name)

            Dim objUsuario As New User
            Dim objController As New ControllerUser

            objUsuario = objController.GetUser(ID)
            Session("Usuario") = objUsuario
            Response.Redirect("../../Home.aspx")
        End If
    End Sub
End Class