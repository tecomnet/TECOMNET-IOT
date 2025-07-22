Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web.Http
Imports WebApiTECOMNET.Controllers
Public Module WebApiConfig
    Public Sub Register(ByVal config As HttpConfiguration)
        ' Configuración y servicios de Web API

        ' Rutas de Web API
        config.MapHttpAttributeRoutes()
        ' Agregamos validación de Token
        config.MessageHandlers.Add(New TokenValidationHandler())

        config.Routes.MapHttpRoute(
            name:="DefaultApi",
            routeTemplate:="api/{controller}/{id}",
            defaults:=New With {.id = RouteParameter.Optional}
        )
    End Sub
End Module
