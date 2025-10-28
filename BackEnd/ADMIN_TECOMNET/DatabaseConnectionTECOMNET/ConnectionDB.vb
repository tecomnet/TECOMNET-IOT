Imports System.Data.SqlClient
Imports System.Configuration

Public Class ConnectionDB
    Protected sqlCon As SqlConnection

    Public Sub ActivarConexion()
        sqlCon = New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString)
        sqlCon.Open()
    End Sub
    Public Function ejecutasp(ByVal nombresp As String, ByVal parametros As Collection) As Boolean
        Dim sqlcom As SqlCommand
        Dim sqlpar As SqlParameter

        sqlcom = New SqlCommand(nombresp, sqlCon)
        sqlcom.CommandType = CommandType.StoredProcedure
        For Each sqlpar In parametros
            sqlcom.Parameters.Add(sqlpar)
        Next

        Try
            sqlcom.ExecuteNonQuery()
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Function ejecutasp_int(ByVal nombresp As String, ByVal parametros As Collection) As Integer
        Dim sqlcom As SqlCommand
        Dim sqlpar As SqlParameter = Nothing
        Dim intresultado As Integer = 0
        sqlcom = New SqlCommand(nombresp, sqlCon)
        sqlcom.CommandType = CommandType.StoredProcedure
        For Each sqlpar In parametros
            sqlcom.Parameters.Add(sqlpar)
        Next
        sqlcom.ExecuteNonQuery()
        intresultado = If(IsDBNull(sqlpar.Value), 0, sqlpar.Value)
        Return intresultado
    End Function

    Public Function ejecutasp_consulta(ByVal nombresp As String, ByVal parametros As Collection) As DataSet
        Dim sqlcom As SqlCommand
        Dim sqlpar As SqlParameter
        Dim sqlda As SqlDataAdapter
        Dim dsresultado As DataSet
        dsresultado = New DataSet
        sqlcom = New SqlCommand(nombresp, sqlCon)
        sqlcom.CommandType = CommandType.StoredProcedure
        For Each sqlpar In parametros
            sqlcom.Parameters.Add(sqlpar)
        Next
        sqlda = New SqlDataAdapter(sqlcom)
        sqlda.Fill(dsresultado)
        Return dsresultado
    End Function
    Public Function ejecutaConsulta(ByVal consulta As String) As DataSet
        Dim dataset As New DataSet()
        Dim sqlda As New SqlDataAdapter(consulta, sqlCon)
        sqlda.Fill(dataset)
        Return dataset
    End Function
    Public Sub DesactivarConexion()
        sqlCon.Close()
        sqlCon = Nothing
    End Sub

    Public Shared Function ArmaParametro(ByVal nombrepar As String, ByVal tipo As SqlDbType, ByVal valor As Object, Optional ByVal direccion As ParameterDirection = ParameterDirection.Input) As SqlParameter
        Dim sqlpar As SqlParameter
        sqlpar = New SqlParameter(nombrepar, valor)
        sqlpar.SqlDbType = tipo
        sqlpar.Direction = direccion
        Return sqlpar
    End Function

    Public Function ejecutaconsulta_escalar(ByVal consulta As String) As Long
        Dim sqlcom As SqlCommand
        sqlcom = New SqlCommand(consulta, sqlCon)
        Dim valorEscalar As Long = CLng(sqlcom.ExecuteScalar())
        Return valorEscalar
    End Function
End Class