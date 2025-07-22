Imports System.Security.Claims
Imports System.Web.Mvc
Imports Microsoft.IdentityModel.Tokens

Namespace Controllers
    Friend Module TokenGenerator
        Function GenerateTokenJwt(ByVal username As String) As String
            Dim secretKey = ConfigurationManager.AppSettings("JWT_SECRET_KEY")
            Dim audienceToken = ConfigurationManager.AppSettings("JWT_AUDIENCE_TOKEN")
            Dim issuerToken = ConfigurationManager.AppSettings("JWT_ISSUER_TOKEN")
            Dim expireTime = ConfigurationManager.AppSettings("JWT_EXPIRE_MINUTES")

            Dim securityKey = New SymmetricSecurityKey(System.Text.Encoding.[Default].GetBytes(secretKey))
            Dim signingCredentials = New SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256Signature)

            Dim claimsIdentity As ClaimsIdentity = New ClaimsIdentity({New Claim(ClaimTypes.Name, username)})
            Dim tokenHandler = New System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler()
            Dim jwtSecurityToken = tokenHandler.CreateJwtSecurityToken(audience:=audienceToken, issuer:=issuerToken, subject:=claimsIdentity, notBefore:=DateTime.UtcNow, expires:=DateTime.UtcNow.AddMinutes(Convert.ToInt32(expireTime)), signingCredentials:=signingCredentials)
            Dim jwtTokenString = tokenHandler.WriteToken(jwtSecurityToken)

            Return jwtTokenString
        End Function
    End Module
End Namespace
