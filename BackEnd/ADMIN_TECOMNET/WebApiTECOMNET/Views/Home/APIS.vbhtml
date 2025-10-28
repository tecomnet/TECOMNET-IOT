@model 
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TECOMNET - API</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2 class="text-primary">APIS IOT</h2>
        <p>
            En este apartado se describen los recursos destinados a los clientes <strong>TECOMNET</strong> DE IOT.
            Para el uso de esta API se requiere utilizar un access token otorgado por el API de JWT. Para la fase de integración en los diferentes ambientes la
            URL será la siguiente:
            basePath (prod): /tecomnet.net/TECOMNET/APIDeveloper/api/            
        </p>

        <h4 class="mt-4">Operaciones Batch.</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Método</th>
                    <th>Operación</th>
                    <th>Descripción</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><span class="badge bg-success">POST</span></td>
                    <td style="width:25%">
                        Batch_Obtener_SIMS_Activos<br />
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerSIMs/Activos", "Descriptions", "Descriptions", New With {.Tipo = "SIMSACTIVOS"}, Nothing)
                    </td>
                    <td>Permite obtener un archivo CSV plano con la información de los SIMS activos.</td>
                </tr>
                <tr>
                    <td><span class="badge bg-success">POST</span></td>
                    <td>
                        Batch_Obtener_SIMS_Inactivos<br />                        
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerSIMs/Inactivos", "Descriptions", "Descriptions", New With {.Tipo = "SIMSINACTIVOS"}, Nothing)
                    </td>
                    <td>Permite obtener un archivo CSV plano con la información de los SIMS inactivos.</td>
                </tr>
                <tr>
                    <td><span class="badge bg-success">POST</span></td>
                    <td>
                        Batch_Obtener_Vehículos_Activos<br />                        
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerVehiculos/Activos", "Descriptions", "Descriptions", New With {.Tipo = "VEHICULOSACTIVOS"}, Nothing)
                    </td>
                    <td>Permite obtener un archivo CSV plano con la información de los vehículos activos.</td>
                </tr>
                <tr>
                    <td><span class="badge bg-success">POST</span></td>
                    <td>
                        Batch_Obtener_Vehículos_Inactivos<br />                        
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerVehiculos/Inactivos", "Descriptions", "Descriptions", New With {.Tipo = "VEHICULOSINACTIVOS"}, Nothing)
                    </td>
                    <td>Permite obtener un archivo CSV plano con la información de los vehículos inactivos.</td>
                </tr>
                <tr>
                    <td><span class="badge bg-success">POST</span></td>
                    <td>
                        Batch_Obtener_Clientes_Activos<br />                        
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerClientes/Activos", "Descriptions", "Descriptions", New With {.Tipo = "CLIENTESACTIVOS"}, Nothing)
                    </td>
                    <td>Permite obtener un archivo CSV plano con la información de los clientes activos.</td>
                </tr>
                <tr>
                    <td><span class="badge bg-success">POST</span></td>
                    <td>
                        Batch_Obtener_Clientes_Inactivos<br />                        
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerClientes/Inactivos", "Descriptions", "Descriptions", New With {.Tipo = "CLIENTESINACTIVOS"}, Nothing)
                    </td>
                    <td>Permite obtener un archivo CSV plano con la información de los clientes inactivos.</td>
                </tr>
                <tr>
                    <td><span class="badge bg-success">POST</span></td>
                    <td>
                        Batch_Obtener_Recargas<br />                        
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerRecargas/Desde/{yyyy-MM-dd}/Hasta/{yyyy-MM-dd}", "Descriptions", "Descriptions", New With {.Tipo = "RECARGAS"}, Nothing)
                    </td>
                    <td>Permite obtener un archivo CSV plano con la información de las recargas.</td>
                </tr>
            </tbody>
        </table>
        <h4 class="mt-4">MSISDN.</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Método</th>
                    <th>Operación</th>
                    <th>Descripción</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><span class="badge bg-primary">GET</span></td>
                    <td>
                        Consulta_de_perfil<br />                        
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/BYD/ObtenerPerfil/5584616246", "Descriptions", "Descriptions", New With {.Tipo = "PERFIL"}, Nothing)
                    </td>
                    <td>Esta operación permite consultar el perfil de un usuario final por medio de su MSISDN.</td>
                </tr>
            </tbody>
        </table>
        <h4 class="mt-4">Generación de token.</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Método</th>
                    <th>Operación</th>
                    <th>Descripción</th>
                </tr>
            </thead>
            <tbody>                
                <tr>
                    <td><span class="badge bg-success">POST</span></td>
                    <td>
                        Generacion_de_Token <br />                        
                        @Html.ActionLink("https://tecomnet.net/TECOMNET/APIDeveloper/api/Account", "Descriptions", "Descriptions", New With {.Tipo = "TOKEN"}, Nothing)
                    </td>
                    <td>Generación de Token: Esta operación permite generar un token que se utilizará para consumir el resto de los recursos.</td>
                </tr>
            </tbody>
        </table>
    </div>
</body>
</html>
