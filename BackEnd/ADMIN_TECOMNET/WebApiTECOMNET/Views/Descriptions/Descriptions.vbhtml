@ModelType DescriptionModel

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Descriptions</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="p-4">
    <div class="container">
        <h4>
            <span class="badge bg-success">@Model.Tipo</span>
            <span class="text-primary">@Model.Metodo</span>
        </h4>

        <p>
            <strong>@Model.Metodo:</strong><br>
            <em>@Model.Descripcion </em>
        </p>
        <p>
            <strong>NOTA:</strong> @Model.Nota
        </p>

        <!-- Resource URL -->
        <div class="card mb-3">
            <div class="card-header fw-bold">Resource URL</div>
            <div class="card-body">
                <code>@Model.ResourceURL</code>
            </div>
        </div>

        <!-- Header Parameters -->
        <div class="card" style="display: @Model.HeaderVisible">
            <div class="card-header fw-bold">Header Parameters</div>
            <div class="card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Values</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Authorization <span class="text-danger">(required)</span></td>
                            <td><span class="badge bg-secondary">6c2NnSWNMR</span></td>
                            <td>
                                Token de autorización obtenido de la operación de Generar Token. El formato es: <strong>{AccessToken}</strong><br>
                                Ejemplo: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkJZRC5URUNPTU5FVC5VU0VSX0FQSSIsIm<br />
                                5iZiI6MTc0MDg4NDYzMywiZXhwIjoxNzQwODg4MjMzLCJpYXQiOjE3NDA4ODQ2MzMsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6MT<br />
                                c2NTQiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjE3NjU0In0.ZXfM86q9tXCqyAa7IXphwMUWhbyLdOfCbvXDJ9oquYM
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- Header Parameters login-->
        <div class="card" style="display: @Model.HeaderVisibleLogin">
            <div class="card-header fw-bold">Header Parameters</div>
            <div class="card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Media Type</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>application/json</td>
                            <td>
                                {
                                "UserName": "BYD.TECOMNET.USER_API",
                                "Password": "TnhmNJk4ZW44NJMy"
                                }
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- Responses-->
        <div class="card">
            <div class="card-header fw-bold">Response</div>
            <div class="card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Type</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                @Model.ResponseType
                            </td>
                            <td>
                                @Model.ResponseDescription  
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>