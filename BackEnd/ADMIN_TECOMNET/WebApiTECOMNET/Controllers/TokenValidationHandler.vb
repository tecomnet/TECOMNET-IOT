Imports Microsoft.IdentityModel.Tokens
Imports System.Net
Imports System.Net.Http
Imports System.Threading
Imports System.Threading.Tasks
Imports System.Runtime.InteropServices


Namespace Controllers
    Friend Class TokenValidationHandler
        Inherits DelegatingHandler

        Private Shared Function TryRetrieveToken(ByVal request As HttpRequestMessage, <Out> ByRef token As String) As Boolean
            token = Nothing
            Dim authzHeaders As IEnumerable(Of String)

            If Not request.Headers.TryGetValues("Authorization", authzHeaders) OrElse authzHeaders.Count() > 1 Then
                Return False
            End If

            Dim bearerToken = authzHeaders.ElementAt(0)
            token = If(bearerToken.StartsWith("Bearer "), bearerToken.Substring(7), bearerToken)
            Return True
        End Function
        Protected Overrides Function SendAsync(ByVal request As HttpRequestMessage, ByVal cancellationToken As CancellationToken) As Task(Of HttpResponseMessage)
            Dim statusCode As HttpStatusCode
            Dim token As String

            If Not TryRetrieveToken(request, token) Then
                statusCode = HttpStatusCode.Unauthorized
                Return MyBase.SendAsync(request, cancellationToken)
            End If

            Try
                Dim secretKey = ConfigurationManager.AppSettings("JWT_SECRET_KEY")
                Dim audienceToken = ConfigurationManager.AppSettings("JWT_AUDIENCE_TOKEN")
                Dim issuerToken = ConfigurationManager.AppSettings("JWT_ISSUER_TOKEN")
                Dim securityKey = New SymmetricSecurityKey(System.Text.Encoding.[Default].GetBytes(secretKey))

                Dim securityToken As SecurityToken
                Dim tokenHandler = New System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler()

                'Dim validationParameters As TokenValidationParameters = New TokenValidationParameters() With {
                '.ValidAudience = audienceToken,
                '.ValidIssuer = issuerToken,
                '.ValidateLifetime = True,
                '.ValidateIssuerSigningKey = True,
                '.LifetimeValidator = Me.LifetimeValidator(),
                '.IssuerSigningKey = securityKey
                '}

                Dim validationParameters As TokenValidationParameters = New TokenValidationParameters() With {
                    .ValidateAudience = False,
                    .ValidateIssuer = False,
                    .ValidateLifetime = True,
                    .ValidateIssuerSigningKey = True,
                    .IssuerSigningKey = securityKey
                }
                '.LifetimeValidator = Me.LifetimeValidator(),

                Thread.CurrentPrincipal = tokenHandler.ValidateToken(token, validationParameters, securityToken)
                HttpContext.Current.User = tokenHandler.ValidateToken(token, validationParameters, securityToken)
                Return MyBase.SendAsync(request, cancellationToken)
            Catch __unusedSecurityTokenValidationException1__ As SecurityTokenValidationException
                statusCode = HttpStatusCode.Unauthorized
            Catch __unusedException2__ As Exception
                statusCode = HttpStatusCode.InternalServerError
            End Try

            Return Task(Of HttpResponseMessage).Factory.StartNew(Function()
                                                                     Return New HttpResponseMessage(statusCode)
                                                                 End Function)
        End Function
        Public Function LifetimeValidator(notBefore As Date?, expires As Date?, securityToken As SecurityToken, validationParameters As TokenValidationParameters) As Boolean
            Dim valid = False

            If (expires.HasValue AndAlso DateTime.UtcNow < expires) AndAlso (notBefore.HasValue AndAlso DateTime.UtcNow > notBefore) Then
                valid = True
            End If
            Return valid
        End Function
    End Class
End Namespace
