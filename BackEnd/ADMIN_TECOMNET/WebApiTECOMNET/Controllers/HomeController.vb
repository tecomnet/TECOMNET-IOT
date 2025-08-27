Public Class HomeController
    Inherits System.Web.Mvc.Controller

    Function Index() As ActionResult
        ViewData("Title") = "Home Page"

        Return View()

    End Function
    Function APIS() As ActionResult
        ViewData("Title") = "APIS Page"

        Return View()

    End Function
End Class
