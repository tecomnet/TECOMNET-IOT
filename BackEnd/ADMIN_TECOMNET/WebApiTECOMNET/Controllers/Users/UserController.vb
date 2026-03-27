Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnectionTECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports ModelsTECOMNET.Enums.TECOMNET
Imports WebApiTECOMNET.API.Tecomnet
Imports System.IO
Imports System.Threading.Tasks
Imports System.Text.Json

Namespace Controllers.Users
    Public Class UserController
        Inherits ApiController
        '5.1 Valida acceso como instalador y asociar vehiculos con App.
        <HttpPost>
        <Route("api/User/Login/Installer")>
        Public Function Login(objLogin As LoginAccount) As HttpResponseMessage
            Try
                Dim objUser As New User
                Dim objController As New ControllerUser

                If Not ModelState.IsValid Then
                    Return Request.CreateResponse(HttpStatusCode.Unauthorized, New With {
                        Key .mensaje = "Usuario o contraseña no valida."
                        })
                End If

                objUser = objController.LoginUser(objLogin.UserName, Securyty.Cifrar(objLogin.Password))

                If objUser.UserID > 0 And (objUser.UserType = UserType.Installer Or objUser.UserType = UserType.Dealership) Then
                    objUser.Password = String.Empty
                    Return Request.CreateResponse(HttpStatusCode.OK, objUser)
                Else
                    Return Request.CreateResponse(HttpStatusCode.Unauthorized, New With {
                        Key .mensaje = "Usuario o contraseña no valida."
                        })
                End If


            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                    Key .error = "Ocurrió un error al generar la solicitud.",
                    Key .detalle = ex.Message
                    })
                Return errorResponse
            End Try
        End Function
    End Class
End Namespace