Imports System.IO
Imports System.Web.Services.Description

Public Class ViewEvidence
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadImageFromFile(Request.QueryString("tipo"), Request.QueryString("VIN"))
        End If
    End Sub
    Private Sub LoadImageFromFile(ByVal Tipo As String, ByVal VIN As String)

        Dim imagen As String = String.Empty

        Select Case Tipo
            Case "1"
                imagen = "previousVersion.jpg"
            Case "2"
                imagen = "CurrentVersion.jpg"
            Case "3"
                imagen = "PreviousSIM.jpg"
            Case "4"
                imagen = "Connectivity.jpg"
        End Select

        Dim fullPath As String = String.Format("{0}\{1}\{2}", ConfigurationManager.AppSettings("CarpetaEvidencias").ToString, VIN, imagen)
        'C:\Publicaciones\LGXCE4CC0T2068659
        If File.Exists(fullPath) Then

            Dim base64String As String = ConvertImageFileToBase64(fullPath)
            imgEvidencia.ImageUrl = base64String

            ' Configurar propiedades del control
            imgEvidencia.AlternateText = "Imagen desde archivo"
            imgEvidencia.Width = 300 ' Ancho en píxeles
            imgEvidencia.Height = 300 ' Alto en píxeles            
        Else
            imgEvidencia.Visible = False
            lblMessage.Text = "Archivo de imagen no encontrado"
            pnlMessage.CssClass = $"status-message error"
            pnlMessage.Visible = True
        End If
    End Sub
    Private Function ConvertImageFileToBase64(filePath As String) As String
        Dim imageBytes As Byte() = File.ReadAllBytes(filePath)
        Dim base64String As String = Convert.ToBase64String(imageBytes)

        ' Determinar tipo MIME
        Dim extension As String = Path.GetExtension(filePath).ToLower()
        Dim mimeType As String = "image/jpg"

        Return $"data:{mimeType};base64,{base64String}"
    End Function
End Class