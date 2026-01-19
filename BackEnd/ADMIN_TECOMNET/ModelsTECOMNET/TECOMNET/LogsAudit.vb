Namespace TECOMNET
    Public Class LogsAudit
        Public Property LogID As Long
        'Información del evento    
        Public Property EventType As String 'CREATE, UPDATE, DELETE, RECHARGE, CONFIG, etc.
        Public Property CategoryID As Short 'Categoría del evento
        Public Property UserType As String 'usuario o cliente
        ' Información de la entidad afectada
        Public Property AffectedEntity As String 'Nombre de la tabla/entidad    
        'Datos del cambio
        Public Property PreviousData As String 'Datos antes del cambio (para UPDATE/DELETE)
        Public Property NewData As String 'Datos después del cambio (para CREATE/UPDATE)
        Public Property DetailedChanges As String 'Campos específicos que cambiaron
        'Contexto de la operación  
        Public Property source_ip As String 'Dirección IP del cliente
        Public Property user_agent As String 'Agente de usuario/navegador
        Public Property endpoint_api As String 'Endpoint/URL que inició la acción

        'Información del usuario/sistema
        Public Property UserID As Integer 'ID del usuario que realizó la acción
        Public Property UserName As String 'Nombre completo del usuario
        Public Property UserRol As String 'Rol del usuario

        'Información del sistema
        Public Property ApplicationModule As String 'Módulo de la aplicación
        Public Property ApplicationVersion As String 'Versión de la app

        'Metadatos de la transacción
        Public Property TransactionID As String 'ID de transacción relacionada
        Public Property ExternalReference As String 'Referencia externa (ej: número de factura)

        ''Estados y resultados
        Public Property OperationState As String 'SUCCESS, FAILED, PENDING
        Public Property Error_Code As String 'Código de Error si falló
        Public Property ErrorMessage As String 'Mensaje detallado del Error
        Public Property severidad As String 'INFO', -- INFO, WARNING, ERROR, CRITICAL    

        'Tiempos
        Public Property EventDate As DateTime 'Default CURRENT_TIMESTAMP,
        Public Property Creationdate As DateTime 'Default CURRENT_TIMESTAMP,
        Public Property DurationMS As Integer 'Duración en milisegundos

        Public Sub New()
            Me.LogID = 0
            Me.EventType = String.Empty
            Me.CategoryID = 0
            Me.UserType = String.Empty
            Me.AffectedEntity = String.Empty
            Me.PreviousData = String.Empty
            Me.NewData = String.Empty
            Me.DetailedChanges = String.Empty
            Me.source_ip = String.Empty
            Me.user_agent = String.Empty
            Me.endpoint_api = String.Empty
            Me.UserID = 0
            Me.UserName = String.Empty
            Me.UserRol = String.Empty
            Me.ApplicationModule = String.Empty
            Me.ApplicationVersion = String.Empty
            Me.TransactionID = String.Empty
            Me.ExternalReference = String.Empty
            Me.OperationState = String.Empty
            Me.Error_Code = String.Empty
            Me.ErrorMessage = String.Empty
            Me.severidad = String.Empty
            Me.EventDate = Now
            Me.Creationdate = Now
            Me.DurationMS = 0
        End Sub
    End Class
End Namespace