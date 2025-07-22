<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title>@ViewBag.Title - TECOMNET</title>
    @Styles.Render("~/Content/css")
    @Scripts.Render("~/bundles/modernizr")
</head>
<body>
    <nav class="navbar navbar-expand-sm navbar-toggleable-sm navbar-dark bg-dark">
        <div class="container">
            @Html.ActionLink("TECOMNET", "Index", "Home", New With {.area = ""}, New With {.class = "navbar-brand"})
            <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target=".navbar-collapse" title="Alternar navegación" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse d-sm-inline-flex justify-content-between">
                <ul class="navbar-nav flex-grow-1">
                    <li>@Html.ActionLink("Inicio", "Index", "Home", New With {.area = ""}, New With {.class = "nav-link"})</li>
                    @*<li>@Html.ActionLink("API", "Index", "Help", New With { .area = "" }, New With { .class = "nav-link" })</li>*@
                    <li>@Html.ActionLink("API", "APIS", "Home", New With {.area = ""}, New With {.class = "nav-link"})</li>
                </ul>
            </div>
        </div>
    </nav>
    <div class="container body-content">
        @RenderBody()
        <hr />        
            <footer class="text-center mt-4 p-3 bg-light">
                <p>Derechos reservados © @DateTime.Now.Year - <strong>TECOMNET</strong> | <a href="https://www.tecomnet.mx/tecomnet-s-a-p-i-de-c-v-aviso-de-privacidad/">Política de privacidad</a> | <a href="https://www.tecomnet.mx/">Contacto</a></p>
            </footer>        
    </div>

    @Scripts.Render("~/bundles/jquery")
    @Scripts.Render("~/bundles/bootstrap")
    @RenderSection("scripts", required:=False)
</body>
</html>
