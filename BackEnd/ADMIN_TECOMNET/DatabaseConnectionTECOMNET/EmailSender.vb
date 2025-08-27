Imports System.Net.Mail
Imports System.IO
Imports ModelsTECOMNET.Enums.TECOMNET
Imports System.Configuration
Public Class EmailSender
    Public Shared Function RechargeNotification(Nombre As String, plan As String, email As String, Template As TypeMessageMail) As Boolean
        Try
            Dim mail As New MailMessage()
            Dim templatePath As String = String.Empty
            Dim htmlBody As String = String.Empty

            ' 📌 Cargar la plantilla HTML
            Select Case Template
                Case TypeMessageMail.Recharge
                    templatePath = ConfigurationManager.AppSettings("PathTempleatesMail").ToString & "Recharge.html"
                    htmlBody = File.ReadAllText(templatePath)
                Case TypeMessageMail.WelcomeCustomer
                Case TypeMessageMail.NotificationRecharge

            End Select

            Select Case Template
                Case TypeMessageMail.Recharge
                    htmlBody = htmlBody.Replace("{Nombre}", Nombre)
                    htmlBody = htmlBody.Replace("{plan}", plan)
                Case TypeMessageMail.WelcomeCustomer
                Case TypeMessageMail.NotificationRecharge

            End Select

            'Configurar el correo            
            mail.From = New MailAddress("c.anaya@tecomnet.mx", "TECOMNET")
            mail.To.Add(email)
            mail.Subject = "Compra de producto"
            mail.Body = htmlBody
            mail.IsBodyHtml = True ' Indicamos que es HTML
            mail.SubjectEncoding = System.Text.Encoding.UTF8 'Codificacion
            mail.BodyEncoding = System.Text.Encoding.UTF8
            mail.Priority = System.Net.Mail.MailPriority.Normal

            ' 📌 Configurar el servidor SMTP
            Dim smtp As New SmtpClient("smtp.hostinger.com")
            smtp.Port = 587
            smtp.Credentials = New System.Net.NetworkCredential("c.anaya@tecomnet.mx", "Gfv456yh54o2#")
            smtp.EnableSsl = True


            ' 📌 Enviar el correo            
            smtp.Send(mail)

            Return True

        Catch ex As Exception
            Return False
        End Try
    End Function

End Class
