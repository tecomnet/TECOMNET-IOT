Imports ModelsTECOMNET
Imports ModelsTECOMNET.TECOMNET
Public Class Controller
    Public Function TransactionsBYDModels(Of ReturnType)(opcion As Integer, ByVal objBYDModels As BYDModels) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@ModelId", SqlDbType.Int, objBYDModels.ModelID))
        parametros.Add(ConnectionDB.ArmaParametro("@Model", SqlDbType.NVarChar, objBYDModels.Model))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, objBYDModels.CreationDate))
        parametros.Add(ConnectionDB.ArmaParametro("@LastDate", SqlDbType.DateTime, IIf(IsNothing(objBYDModels.LastDate), DBNull.Value, objBYDModels.LastDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_BYDModels]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_BYDModels]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_BYDModels]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)

    End Function
    Public Function TransactionsCar(Of ReturnType)(opcion As Integer, ByVal objCar As Car) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@CarID", SqlDbType.Int, objCar.CarID))
        parametros.Add(ConnectionDB.ArmaParametro("@ModelID", SqlDbType.Int, objCar.ModelID))
        parametros.Add(ConnectionDB.ArmaParametro("@VIN", SqlDbType.NVarChar, objCar.VIN))
        parametros.Add(ConnectionDB.ArmaParametro("@Year", SqlDbType.Int, objCar.YEAR))
        parametros.Add(ConnectionDB.ArmaParametro("@brand", SqlDbType.NVarChar, objCar.brand))
        parametros.Add(ConnectionDB.ArmaParametro("@CustomerID", SqlDbType.Int, objCar.CustomerID))
        parametros.Add(ConnectionDB.ArmaParametro("@Color", SqlDbType.NVarChar, objCar.Color))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, objCar.CreationDate))
        parametros.Add(ConnectionDB.ArmaParametro("@LastDate", SqlDbType.DateTime, IIf(IsNothing(objCar.LastDate), DBNull.Value, objCar.LastDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Car]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Car]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Car]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)

    End Function
    Public Function TransactionsCustomer(Of ReturnType)(opcion As Integer, ByVal objCustomer As Customer) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@CustomerID", SqlDbType.Int, objCustomer.CustomerID))
        parametros.Add(ConnectionDB.ArmaParametro("@PaternalSurname", SqlDbType.NVarChar, objCustomer.PaternalSurname))
        parametros.Add(ConnectionDB.ArmaParametro("@MaternalSurname", SqlDbType.NVarChar, objCustomer.MaternalSurname))
        parametros.Add(ConnectionDB.ArmaParametro("@Name", SqlDbType.NVarChar, objCustomer.Name))
        parametros.Add(ConnectionDB.ArmaParametro("@CustomerName", SqlDbType.NVarChar, objCustomer.CustomerName))
        parametros.Add(ConnectionDB.ArmaParametro("@DateBirth", SqlDbType.DateTime, IIf(IsNothing(objCustomer.DateBirth), DBNull.Value, objCustomer.DateBirth)))
        parametros.Add(ConnectionDB.ArmaParametro("@Email", SqlDbType.NVarChar, objCustomer.Email))
        parametros.Add(ConnectionDB.ArmaParametro("@Password", SqlDbType.NVarChar, objCustomer.Password))
        parametros.Add(ConnectionDB.ArmaParametro("@Phonenumber", SqlDbType.NVarChar, objCustomer.PhoneNumber))
        parametros.Add(ConnectionDB.ArmaParametro("@RFC", SqlDbType.NVarChar, objCustomer.RFC))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, objCustomer.CreationDate))
        parametros.Add(ConnectionDB.ArmaParametro("@RegistrationDate", SqlDbType.DateTime, IIf(IsNothing(objCustomer.RegistrationDate), DBNull.Value, objCustomer.RegistrationDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@Sex", SqlDbType.NVarChar, objCustomer.Sex))
        parametros.Add(ConnectionDB.ArmaParametro("@Country", SqlDbType.NVarChar, objCustomer.Country))
        parametros.Add(ConnectionDB.ArmaParametro("@State", SqlDbType.NVarChar, objCustomer.State))
        parametros.Add(ConnectionDB.ArmaParametro("@Cologne", SqlDbType.NVarChar, objCustomer.Cologne))
        parametros.Add(ConnectionDB.ArmaParametro("@Address", SqlDbType.NVarChar, objCustomer.Address))
        parametros.Add(ConnectionDB.ArmaParametro("@ZipCode", SqlDbType.NVarChar, objCustomer.ZipCode))
        parametros.Add(ConnectionDB.ArmaParametro("@LastDate", SqlDbType.DateTime, IIf(IsNothing(objCustomer.LastDate), DBNull.Value, objCustomer.LastDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))
        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Customer]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Customer]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Customer]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsCustomerPayments(Of ReturnType)(opcion As Integer, ByVal objCustomerPayments As CustomerPayments) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@PaymentID", SqlDbType.Int, objCustomerPayments.PaymentID))
        parametros.Add(ConnectionDB.ArmaParametro("@ProductID", SqlDbType.Int, objCustomerPayments.ProductID))
        parametros.Add(ConnectionDB.ArmaParametro("@SIMID", SqlDbType.Int, objCustomerPayments.SIMID))
        parametros.Add(ConnectionDB.ArmaParametro("@CarID", SqlDbType.Int, objCustomerPayments.CarID))
        parametros.Add(ConnectionDB.ArmaParametro("@CustomerID", SqlDbType.Int, objCustomerPayments.CustomerID))
        parametros.Add(ConnectionDB.ArmaParametro("@PurchaseDate", SqlDbType.DateTime, objCustomerPayments.PurchaseDate))
        parametros.Add(ConnectionDB.ArmaParametro("@PaymentAmount", SqlDbType.Float, objCustomerPayments.PaymentAmount))
        parametros.Add(ConnectionDB.ArmaParametro("@MethodPayment", SqlDbType.Int, objCustomerPayments.MethodPayment))
        parametros.Add(ConnectionDB.ArmaParametro("@InvoiceRequired", SqlDbType.Int, objCustomerPayments.InvoiceRequired))
        parametros.Add(ConnectionDB.ArmaParametro("@OrderID", SqlDbType.Int, IIf(IsNothing(objCustomerPayments.OrderID), DBNull.Value, objCustomerPayments.OrderID)))
        parametros.Add(ConnectionDB.ArmaParametro("@InvoiceID", SqlDbType.Int, IIf(IsNothing(objCustomerPayments.InvoiceID), DBNull.Value, objCustomerPayments.InvoiceID)))
        parametros.Add(ConnectionDB.ArmaParametro("@DepositID", SqlDbType.Int, IIf(IsNothing(objCustomerPayments.DepositID), DBNull.Value, objCustomerPayments.DepositID)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_CustomerPayments]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_CustomerPayments]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_CustomerPayments]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsMovementHistory(Of ReturnType)(opcion As Integer, ByVal objMovementHistory As MovementHistory) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@MovementID", SqlDbType.Int, objMovementHistory.MovementID))
        parametros.Add(ConnectionDB.ArmaParametro("@MovementDate", SqlDbType.DateTime, objMovementHistory.MovementDate))
        parametros.Add(ConnectionDB.ArmaParametro("@MovementType", SqlDbType.Int, objMovementHistory.MovementType))
        parametros.Add(ConnectionDB.ArmaParametro("@SIMID", SqlDbType.Int, objMovementHistory.SIMID))
        parametros.Add(ConnectionDB.ArmaParametro("@Description", SqlDbType.NVarChar, objMovementHistory.Description))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_MovementHistory]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_MovementHistory]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_MovementHistory]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsProduct(Of ReturnType)(opcion As Integer, ByVal objProduct As Product) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@ProductID", SqlDbType.Int, objProduct.ProductID))
        parametros.Add(ConnectionDB.ArmaParametro("@ProductName", SqlDbType.NVarChar, objProduct.ProductName))
        parametros.Add(ConnectionDB.ArmaParametro("@Price", SqlDbType.Float, objProduct.Price))
        parametros.Add(ConnectionDB.ArmaParametro("@MB", SqlDbType.Float, objProduct.MB))
        parametros.Add(ConnectionDB.ArmaParametro("@OfferIdAltan", SqlDbType.NVarChar, objProduct.OfferIdAltan))
        parametros.Add(ConnectionDB.ArmaParametro("@CompanyID", SqlDbType.Int, objProduct.CompanyID))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, objProduct.CreationDate))
        parametros.Add(ConnectionDB.ArmaParametro("@LastDate", SqlDbType.DateTime, IIf(IsNothing(objProduct.LastDate), DBNull.Value, objProduct.LastDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Product]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Product]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Product]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsSIM(Of ReturnType)(opcion As Integer, ByVal objSIM As SIM) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@SIMID", SqlDbType.Int, objSIM.SIMID))
        parametros.Add(ConnectionDB.ArmaParametro("@BE_ID", SqlDbType.NVarChar, objSIM.BE_ID))
        parametros.Add(ConnectionDB.ArmaParametro("@IMSI", SqlDbType.NVarChar, objSIM.IMSI))
        parametros.Add(ConnectionDB.ArmaParametro("@IMSI_rb1", SqlDbType.NVarChar, objSIM.IMSI_rb1))
        parametros.Add(ConnectionDB.ArmaParametro("@IMSI_rb2", SqlDbType.NVarChar, objSIM.IMSI_rb2))
        parametros.Add(ConnectionDB.ArmaParametro("@ICCID", SqlDbType.NVarChar, objSIM.ICCID))
        parametros.Add(ConnectionDB.ArmaParametro("@MSISDN", SqlDbType.NVarChar, objSIM.MSISDN))
        parametros.Add(ConnectionDB.ArmaParametro("@PIN", SqlDbType.NVarChar, objSIM.PIN))
        parametros.Add(ConnectionDB.ArmaParametro("@PUK", SqlDbType.NVarChar, objSIM.PUK))
        parametros.Add(ConnectionDB.ArmaParametro("@serie", SqlDbType.NVarChar, objSIM.Serie))
        parametros.Add(ConnectionDB.ArmaParametro("@producto", SqlDbType.NVarChar, objSIM.Producto))
        parametros.Add(ConnectionDB.ArmaParametro("@CarID", SqlDbType.Int, IIf(IsNothing(objSIM.CarID), DBNull.Value, objSIM.CarID)))
        parametros.Add(ConnectionDB.ArmaParametro("@ExpirationDate", SqlDbType.DateTime, IIf(IsNothing(objSIM.ExpirationDate), DBNull.Value, objSIM.ExpirationDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@AssignedMB", SqlDbType.Int, IIf(IsNothing(objSIM.AssignedMB), DBNull.Value, objSIM.AssignedMB)))
        parametros.Add(ConnectionDB.ArmaParametro("@UsedMB", SqlDbType.Int, IIf(IsNothing(objSIM.UsedMB), DBNull.Value, objSIM.UsedMB)))
        parametros.Add(ConnectionDB.ArmaParametro("@AvailableMB", SqlDbType.Int, IIf(IsNothing(objSIM.AvailableMB), DBNull.Value, objSIM.AvailableMB)))
        parametros.Add(ConnectionDB.ArmaParametro("@AdditionalMB", SqlDbType.Int, IIf(IsNothing(objSIM.AdditionalMB), DBNull.Value, objSIM.AdditionalMB)))
        parametros.Add(ConnectionDB.ArmaParametro("@Active", SqlDbType.Bit, objSIM.Active))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, IIf(IsNothing(objSIM.CreationDate), Now, objSIM.CreationDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@LastDate", SqlDbType.DateTime, IIf(IsNothing(objSIM.LastDate), DBNull.Value, objSIM.LastDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_SIM]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_SIM]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_SIM]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsUser(Of ReturnType)(opcion As Integer, ByVal objUser As User) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@UserID", SqlDbType.Int, objUser.UserID))
        parametros.Add(ConnectionDB.ArmaParametro("@UserName", SqlDbType.NVarChar, objUser.UserName))
        parametros.Add(ConnectionDB.ArmaParametro("@Name", SqlDbType.NVarChar, objUser.Name))
        parametros.Add(ConnectionDB.ArmaParametro("@Email", SqlDbType.NVarChar, objUser.Email))
        parametros.Add(ConnectionDB.ArmaParametro("@Password", SqlDbType.NVarChar, objUser.Password))
        parametros.Add(ConnectionDB.ArmaParametro("@Phonenumber", SqlDbType.NVarChar, objUser.PhoneNumber))
        parametros.Add(ConnectionDB.ArmaParametro("@UserType", SqlDbType.Int, objUser.UserType))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, objUser.CreationDate))
        parametros.Add(ConnectionDB.ArmaParametro("@LastDate", SqlDbType.DateTime, IIf(IsNothing(objUser.LastDate), DBNull.Value, objUser.LastDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_User]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_User]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_User]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsPaymentRequest(Of ReturnType)(opcion As Integer, ByVal objPaymentRequest As PaymentRequestTecomnet) As ReturnType
        Dim parametros As New Collection
        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@OrderID", SqlDbType.Int, objPaymentRequest.OrderID))
        parametros.Add(ConnectionDB.ArmaParametro("@SIMID", SqlDbType.Int, objPaymentRequest.SIMID))
        parametros.Add(ConnectionDB.ArmaParametro("@ProductID", SqlDbType.Int, objPaymentRequest.ProductID))
        parametros.Add(ConnectionDB.ArmaParametro("@CarID", SqlDbType.Int, objPaymentRequest.CarID))
        parametros.Add(ConnectionDB.ArmaParametro("@CustomerID", SqlDbType.Int, objPaymentRequest.CustomerID))
        parametros.Add(ConnectionDB.ArmaParametro("@InvoiceRequired", SqlDbType.Bit, objPaymentRequest.InvoiceRequired))
        parametros.Add(ConnectionDB.ArmaParametro("@CP", SqlDbType.NVarChar, objPaymentRequest.CP))
        parametros.Add(ConnectionDB.ArmaParametro("@RFC", SqlDbType.NVarChar, objPaymentRequest.RFC))
        parametros.Add(ConnectionDB.ArmaParametro("@Regimen", SqlDbType.NVarChar, objPaymentRequest.Regimen))
        parametros.Add(ConnectionDB.ArmaParametro("@estatus_pago", SqlDbType.NVarChar, IIf(IsNothing(objPaymentRequest.estatus_pago), DBNull.Value, objPaymentRequest.estatus_pago)))
        parametros.Add(ConnectionDB.ArmaParametro("@id_transaction", SqlDbType.NVarChar, IIf(IsNothing(objPaymentRequest.id_transaction), DBNull.Value, objPaymentRequest.id_transaction)))
        parametros.Add(ConnectionDB.ArmaParametro("@auth_number", SqlDbType.NVarChar, IIf(IsNothing(objPaymentRequest.auth_number), DBNull.Value, objPaymentRequest.auth_number)))
        parametros.Add(ConnectionDB.ArmaParametro("@authCode", SqlDbType.NVarChar, IIf(IsNothing(objPaymentRequest.authCode), DBNull.Value, objPaymentRequest.authCode)))
        parametros.Add(ConnectionDB.ArmaParametro("@reason", SqlDbType.NVarChar, IIf(IsNothing(objPaymentRequest.reason), DBNull.Value, objPaymentRequest.reason)))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, objPaymentRequest.CreationDate))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_PaymentRequestTecomnet]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_PaymentRequestTecomnet]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_PaymentRequestTecomnet]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsQuerys(ByVal query As String) As DataSet
        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As DataSet
        result = cnx.ejecutaConsulta(query)
        cnx.DesactivarConexion()
        cnx = Nothing
        Return result
    End Function
    Public Function TransactionsCDR(Of ReturnType)(opcion As Integer, ByVal objCDR As CDR) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@CreateDate", SqlDbType.DateTime, objCDR.CreateDate))
        parametros.Add(ConnectionDB.ArmaParametro("@Service", SqlDbType.NVarChar, objCDR.Service))
        parametros.Add(ConnectionDB.ArmaParametro("@Total", SqlDbType.Float, objCDR.Total))
        parametros.Add(ConnectionDB.ArmaParametro("@IMEI", SqlDbType.NVarChar, objCDR.IMEI))
        parametros.Add(ConnectionDB.ArmaParametro("@IMSI", SqlDbType.NVarChar, objCDR.IMSI))
        parametros.Add(ConnectionDB.ArmaParametro("@MainOfferingID", SqlDbType.NVarChar, objCDR.MainOfferingID))
        parametros.Add(ConnectionDB.ArmaParametro("@LastEffectOffering", SqlDbType.NVarChar, objCDR.LastEffectOffering))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_CDR]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_CDR]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_CDR]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)

    End Function
    Public Function TransactionsCompany(Of ReturnType)(opcion As Integer, ByVal objCompany As Company) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@CompanyID", SqlDbType.Int, objCompany.CompanyID))
        parametros.Add(ConnectionDB.ArmaParametro("@Company", SqlDbType.NVarChar, objCompany.Company))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, objCompany.CreationDate))
        parametros.Add(ConnectionDB.ArmaParametro("@LastDate", SqlDbType.DateTime, IIf(IsNothing(objCompany.LastDate), DBNull.Value, objCompany.LastDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Company]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Company]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Company]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)

    End Function
End Class
