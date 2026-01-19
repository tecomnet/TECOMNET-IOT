Imports System.ComponentModel.Design
Imports System.Data.Common
Imports System.Drawing
Imports System.Net
Imports System.Reflection.Emit
Imports System.Runtime.InteropServices
Imports System.Security
Imports System.Security.Cryptography
Imports System.Text
Imports ModelsTECOMNET.Enums.TECOMNET
Imports ModelsTECOMNET.TECOMNET
Imports ModelsTECOMNET.TECOMNET.AltanRedes
Imports ModelsTECOMNET.TECOMNET.LinkX

Public Class ConvertObject
    Public Shared Function SIM(ByVal dr As DataRow) As SIM
        Dim objSIM As New SIM

        Try
            If dr.Table.Columns.Contains("SIMID") Then objSIM.SIMID = dr("SIMID")
            If dr.Table.Columns.Contains("BE_ID") Then objSIM.BE_ID = dr("BE_ID")
            If dr.Table.Columns.Contains("IMSI") Then objSIM.IMSI = dr("IMSI")
            If dr.Table.Columns.Contains("IMSI_rb1") Then objSIM.IMSI_rb1 = dr("IMSI_rb1")
            If dr.Table.Columns.Contains("IMSI_rb2") Then objSIM.IMSI_rb2 = dr("IMSI_rb2")
            If dr.Table.Columns.Contains("ICCID") Then objSIM.ICCID = dr("ICCID")
            If dr.Table.Columns.Contains("MSISDN") Then objSIM.MSISDN = dr("MSISDN")
            If dr.Table.Columns.Contains("PIN") Then objSIM.PIN = dr("PIN")
            If dr.Table.Columns.Contains("PUK") Then objSIM.PUK = dr("PUK")
            If dr.Table.Columns.Contains("serie") Then objSIM.Serie = dr("serie")
            If dr.Table.Columns.Contains("producto") Then objSIM.Producto = dr("producto")
            If dr.Table.Columns.Contains("CarID") Then objSIM.CarID = IIf(IsDBNull(dr("CarID")), Nothing, dr("CarID"))
            If dr.Table.Columns.Contains("ExpirationDate") Then objSIM.ExpirationDate = IIf(IsDBNull(dr("ExpirationDate")), Nothing, dr("ExpirationDate"))
            If dr.Table.Columns.Contains("AssignedMB") Then objSIM.AssignedMB = IIf(IsDBNull(dr("AssignedMB")), Nothing, dr("AssignedMB"))
            If dr.Table.Columns.Contains("UsedMB") Then objSIM.UsedMB = IIf(IsDBNull(dr("UsedMB")), Nothing, dr("UsedMB"))
            If dr.Table.Columns.Contains("AvailableMB") Then objSIM.AvailableMB = IIf(IsDBNull(dr("AvailableMB")), Nothing, dr("AvailableMB"))
            If dr.Table.Columns.Contains("AdditionalMB") Then objSIM.AdditionalMB = IIf(IsDBNull(dr("AdditionalMB")), Nothing, dr("AdditionalMB"))
            If dr.Table.Columns.Contains("Active") Then objSIM.Active = dr("Active")
            If dr.Table.Columns.Contains("CreationDate") Then objSIM.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("InstallationDate") Then objSIM.InstallationDate = IIf(IsDBNull(dr("InstallationDate")), Nothing, dr("InstallationDate"))
            If dr.Table.Columns.Contains("ActivationDate") Then objSIM.ActivationDate = IIf(IsDBNull(dr("ActivationDate")), Nothing, dr("ActivationDate"))
            If dr.Table.Columns.Contains("ReactivationDate") Then objSIM.ReactivationDate = IIf(IsDBNull(dr("ReactivationDate")), Nothing, dr("ReactivationDate"))
            If dr.Table.Columns.Contains("SuspensionDate") Then objSIM.SuspensionDate = IIf(IsDBNull(dr("SuspensionDate")), Nothing, dr("SuspensionDate"))
            If dr.Table.Columns.Contains("BillingStartDate") Then objSIM.BillingStartDate = IIf(IsDBNull(dr("BillingStartDate")), Nothing, dr("BillingStartDate"))
            If dr.Table.Columns.Contains("CustomerSaleDate") Then objSIM.CustomerSaleDate = IIf(IsDBNull(dr("CustomerSaleDate")), Nothing, dr("CustomerSaleDate"))
            If dr.Table.Columns.Contains("Status") Then objSIM.Status = IIf(IsDBNull(dr("Status")), Nothing, dr("Status"))
            If dr.Table.Columns.Contains("LastDate") Then objSIM.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))
        Catch ex As Exception
        End Try
        Return objSIM

    End Function
    Public Shared Function SIMDetail(ByVal dr As DataRow) As SIMDetail
        Dim objSIM As New SIMDetail

        Try
            If dr.Table.Columns.Contains("SIMID") Then objSIM.SIMID = dr("SIMID")
            If dr.Table.Columns.Contains("BE_ID") Then objSIM.BE_ID = dr("BE_ID")
            If dr.Table.Columns.Contains("IMSI") Then objSIM.IMSI = dr("IMSI")
            If dr.Table.Columns.Contains("IMSI_rb1") Then objSIM.IMSI_rb1 = dr("IMSI_rb1")
            If dr.Table.Columns.Contains("IMSI_rb2") Then objSIM.IMSI_rb2 = dr("IMSI_rb2")
            If dr.Table.Columns.Contains("ICCID") Then objSIM.ICCID = dr("ICCID")
            If dr.Table.Columns.Contains("MSISDN") Then objSIM.MSISDN = dr("MSISDN")
            If dr.Table.Columns.Contains("PIN") Then objSIM.PIN = dr("PIN")
            If dr.Table.Columns.Contains("PUK") Then objSIM.PUK = dr("PUK")
            If dr.Table.Columns.Contains("serie") Then objSIM.Serie = dr("serie")
            If dr.Table.Columns.Contains("producto") Then objSIM.Producto = dr("producto")
            If dr.Table.Columns.Contains("CarID") Then objSIM.CarID = IIf(IsDBNull(dr("CarID")), Nothing, dr("CarID"))
            If dr.Table.Columns.Contains("ExpirationDate") Then objSIM.ExpirationDate = IIf(IsDBNull(dr("ExpirationDate")), Nothing, dr("ExpirationDate"))
            If dr.Table.Columns.Contains("AssignedMB") Then objSIM.AssignedMB = IIf(IsDBNull(dr("AssignedMB")), Nothing, dr("AssignedMB"))
            If dr.Table.Columns.Contains("UsedMB") Then objSIM.UsedMB = IIf(IsDBNull(dr("UsedMB")), Nothing, dr("UsedMB"))
            If dr.Table.Columns.Contains("AvailableMB") Then objSIM.AvailableMB = IIf(IsDBNull(dr("AvailableMB")), Nothing, dr("AvailableMB"))
            If dr.Table.Columns.Contains("AdditionalMB") Then objSIM.AdditionalMB = IIf(IsDBNull(dr("AdditionalMB")), Nothing, dr("AdditionalMB"))
            If dr.Table.Columns.Contains("Active") Then objSIM.Active = dr("Active")
            If dr.Table.Columns.Contains("CreationDate") Then objSIM.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("InstallationDate") Then objSIM.InstallationDate = IIf(IsDBNull(dr("InstallationDate")), Nothing, dr("InstallationDate"))
            If dr.Table.Columns.Contains("ActivationDate") Then objSIM.ActivationDate = IIf(IsDBNull(dr("ActivationDate")), Nothing, dr("ActivationDate"))
            If dr.Table.Columns.Contains("ReactivationDate") Then objSIM.ReactivationDate = IIf(IsDBNull(dr("ReactivationDate")), Nothing, dr("ReactivationDate"))
            If dr.Table.Columns.Contains("SuspensionDate") Then objSIM.SuspensionDate = IIf(IsDBNull(dr("SuspensionDate")), Nothing, dr("SuspensionDate"))
            If dr.Table.Columns.Contains("BillingStartDate") Then objSIM.BillingStartDate = IIf(IsDBNull(dr("BillingStartDate")), Nothing, dr("BillingStartDate"))
            If dr.Table.Columns.Contains("CustomerSaleDate") Then objSIM.CustomerSaleDate = IIf(IsDBNull(dr("CustomerSaleDate")), Nothing, dr("CustomerSaleDate"))
            If dr.Table.Columns.Contains("Status") Then objSIM.Status = IIf(IsDBNull(dr("Status")), Nothing, dr("Status"))
            If dr.Table.Columns.Contains("LastDate") Then objSIM.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))

            If dr.Table.Columns.Contains("VIN") Then objSIM.VIN = IIf(IsDBNull(dr("VIN")), String.Empty, dr("VIN"))
            If dr.Table.Columns.Contains("Model") Then objSIM.Model = IIf(IsDBNull(dr("Model")), String.Empty, dr("Model"))
            If dr.Table.Columns.Contains("CustomerName") Then objSIM.CustomerName = IIf(IsDBNull(dr("CustomerName")), String.Empty, dr("CustomerName"))
            If dr.Table.Columns.Contains("RFC") Then objSIM.RFC = IIf(IsDBNull(dr("RFC")), String.Empty, dr("RFC"))

        Catch ex As Exception
        End Try
        Return objSIM

    End Function
    Public Shared Function BYDModels(ByVal dr As DataRow) As BYDModels
        Dim objBYDModels As New BYDModels

        Try
            If dr.Table.Columns.Contains("ModelID") Then objBYDModels.ModelID = dr("ModelID")
            If dr.Table.Columns.Contains("Model") Then objBYDModels.Model = dr("Model")
            If dr.Table.Columns.Contains("CreationDate") Then objBYDModels.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("LastDate") Then objBYDModels.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))

        Catch ex As Exception
        End Try
        Return objBYDModels

    End Function
    Public Shared Function Products(ByVal dr As DataRow) As Product
        Dim objProduct As New Product
        Try
            If dr.Table.Columns.Contains("ProductID") Then objProduct.ProductID = dr("ProductID")
            If dr.Table.Columns.Contains("ProductName") Then objProduct.ProductName = dr("ProductName")
            If dr.Table.Columns.Contains("Price") Then objProduct.Price = dr("Price")
            If dr.Table.Columns.Contains("MB") Then objProduct.MB = dr("MB")
            If dr.Table.Columns.Contains("OfferIdAltan") Then objProduct.OfferIdAltan = dr("OfferIdAltan")
            If dr.Table.Columns.Contains("CompanyID") Then objProduct.CompanyID = dr("CompanyID")
            If dr.Table.Columns.Contains("CreationDate") Then objProduct.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("LastDate") Then objProduct.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))
        Catch ex As Exception
        End Try
        Return objProduct
    End Function
    Public Shared Function ProductsDetail(ByVal dr As DataRow) As ProductDetail
        Dim objProduct As New ProductDetail
        Try
            If dr.Table.Columns.Contains("ProductID") Then objProduct.ProductID = dr("ProductID")
            If dr.Table.Columns.Contains("ProductName") Then objProduct.ProductName = dr("ProductName")
            If dr.Table.Columns.Contains("Price") Then objProduct.Price = dr("Price")
            If dr.Table.Columns.Contains("MB") Then objProduct.MB = dr("MB")
            If dr.Table.Columns.Contains("OfferIdAltan") Then objProduct.OfferIdAltan = dr("OfferIdAltan")
            If dr.Table.Columns.Contains("CompanyID") Then objProduct.CompanyID = dr("CompanyID")
            If dr.Table.Columns.Contains("CreationDate") Then objProduct.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("LastDate") Then objProduct.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))

            If dr.Table.Columns.Contains("Company") Then objProduct.Company = dr("Company")
        Catch ex As Exception
        End Try
        Return objProduct
    End Function
    Public Shared Function Cars(ByVal dr As DataRow) As Car
        Dim objCar As New Car
        Try
            If dr.Table.Columns.Contains("CarID") Then objCar.CarID = dr("CarID")
            If dr.Table.Columns.Contains("ModelID") Then objCar.ModelID = dr("ModelID")
            If dr.Table.Columns.Contains("VIN") Then objCar.VIN = dr("VIN")
            If dr.Table.Columns.Contains("YEAR") Then objCar.YEAR = dr("YEAR")
            If dr.Table.Columns.Contains("brand") Then objCar.brand = dr("brand")
            If dr.Table.Columns.Contains("CustomerID") Then objCar.CustomerID = IIf(IsDBNull(dr("CustomerID")), Nothing, dr("CustomerID"))
            If dr.Table.Columns.Contains("Color") Then objCar.Color = dr("Color")
            If dr.Table.Columns.Contains("CreationDate") Then objCar.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("LastDate") Then objCar.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))
        Catch ex As Exception
        End Try
        Return objCar
    End Function
    Public Shared Function CarsDetail(ByVal dr As DataRow) As CarDetail
        Dim objCar As New CarDetail
        Try
            If dr.Table.Columns.Contains("CarID") Then objCar.CarID = dr("CarID")
            If dr.Table.Columns.Contains("ModelID") Then objCar.ModelID = dr("ModelID")
            If dr.Table.Columns.Contains("VIN") Then objCar.VIN = dr("VIN")
            If dr.Table.Columns.Contains("YEAR") Then objCar.YEAR = dr("YEAR")
            If dr.Table.Columns.Contains("brand") Then objCar.brand = dr("brand")
            If dr.Table.Columns.Contains("CustomerID") Then objCar.CustomerID = IIf(IsDBNull(dr("CustomerID")), Nothing, dr("CustomerID"))
            If dr.Table.Columns.Contains("Color") Then objCar.Color = dr("Color")
            If dr.Table.Columns.Contains("CreationDate") Then objCar.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("LastDate") Then objCar.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))

            If dr.Table.Columns.Contains("Model") Then objCar.Model = IIf(IsDBNull(dr("Model")), String.Empty, dr("Model"))
            If dr.Table.Columns.Contains("CustomerName") Then objCar.CustomerName = IIf(IsDBNull(dr("CustomerName")), String.Empty, dr("CustomerName"))
            If dr.Table.Columns.Contains("RFC") Then objCar.RFC = IIf(IsDBNull(dr("RFC")), String.Empty, dr("RFC"))
        Catch ex As Exception
        End Try
        Return objCar
    End Function
    Public Shared Function Customers(ByVal dr As DataRow) As Customer
        Dim objCustomer As New Customer
        Try
            If dr.Table.Columns.Contains("CustomerID") Then objCustomer.CustomerID = dr("CustomerID")
            If dr.Table.Columns.Contains("PaternalSurname") Then objCustomer.PaternalSurname = dr("PaternalSurname")
            If dr.Table.Columns.Contains("MaternalSurname") Then objCustomer.MaternalSurname = dr("MaternalSurname")
            If dr.Table.Columns.Contains("Name") Then objCustomer.Name = dr("Name")
            If dr.Table.Columns.Contains("CustomerName") Then objCustomer.CustomerName = dr("CustomerName")
            If dr.Table.Columns.Contains("DateBirth") Then objCustomer.DateBirth = IIf(IsDBNull(dr("DateBirth")), Nothing, dr("DateBirth"))
            If dr.Table.Columns.Contains("Email") Then objCustomer.Email = dr("Email")
            If dr.Table.Columns.Contains("Password") Then objCustomer.Password = dr("Password")
            If dr.Table.Columns.Contains("PhoneNumber") Then objCustomer.PhoneNumber = dr("PhoneNumber")
            If dr.Table.Columns.Contains("RFC") Then objCustomer.RFC = dr("RFC")
            If dr.Table.Columns.Contains("CreationDate") Then objCustomer.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("RegistrationDate") Then objCustomer.RegistrationDate = IIf(IsDBNull(dr("RegistrationDate")), Nothing, dr("RegistrationDate"))
            If dr.Table.Columns.Contains("Sex") Then objCustomer.Sex = dr("Sex")
            If dr.Table.Columns.Contains("Country") Then objCustomer.Country = dr("Country")
            If dr.Table.Columns.Contains("State") Then objCustomer.State = dr("State")
            If dr.Table.Columns.Contains("Cologne") Then objCustomer.Cologne = dr("Cologne")
            If dr.Table.Columns.Contains("Address") Then objCustomer.Address = dr("Address")
            If dr.Table.Columns.Contains("ZipCode") Then objCustomer.ZipCode = dr("ZipCode")
            If dr.Table.Columns.Contains("LastDate") Then objCustomer.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))
        Catch ex As Exception
        End Try
        Return objCustomer
    End Function
    Public Shared Function Users(ByVal dr As DataRow) As User
        Dim objUser As New User
        Try
            If dr.Table.Columns.Contains("UserID") Then objUser.UserID = dr("UserID")
            If dr.Table.Columns.Contains("UserName") Then objUser.UserName = dr("UserName")
            If dr.Table.Columns.Contains("Name") Then objUser.Name = dr("Name")
            If dr.Table.Columns.Contains("Email") Then objUser.Email = dr("Email")
            If dr.Table.Columns.Contains("Password") Then objUser.Password = dr("Password")
            If dr.Table.Columns.Contains("PhoneNumber") Then objUser.PhoneNumber = dr("PhoneNumber")
            If dr.Table.Columns.Contains("UserType") Then objUser.UserType = dr("UserType")
            If dr.Table.Columns.Contains("CreationDate") Then objUser.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("LastDate") Then objUser.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))
        Catch ex As Exception
        End Try
        Return objUser
    End Function
    Public Shared Function CustomerPayments(ByVal dr As DataRow) As CustomerPayments
        Dim objCustomerPayments As New CustomerPayments

        Try
            If dr.Table.Columns.Contains("PaymentID") Then objCustomerPayments.PaymentID = dr("PaymentID")
            If dr.Table.Columns.Contains("ProductID") Then objCustomerPayments.ProductID = dr("ProductID")
            If dr.Table.Columns.Contains("SIMID") Then objCustomerPayments.SIMID = dr("SIMID")
            If dr.Table.Columns.Contains("CarID") Then objCustomerPayments.CarID = dr("CarID")
            If dr.Table.Columns.Contains("CustomerID") Then objCustomerPayments.CustomerID = dr("CustomerID")
            If dr.Table.Columns.Contains("PurchaseDate") Then objCustomerPayments.PurchaseDate = dr("PurchaseDate")
            If dr.Table.Columns.Contains("PaymentAmount") Then objCustomerPayments.PaymentAmount = dr("PaymentAmount")
            If dr.Table.Columns.Contains("MethodPayment") Then objCustomerPayments.MethodPayment = dr("MethodPayment")
            If dr.Table.Columns.Contains("InvoiceRequired") Then objCustomerPayments.InvoiceRequired = dr("InvoiceRequired")
            If dr.Table.Columns.Contains("InvoiceID") Then objCustomerPayments.InvoiceID = IIf(IsDBNull(dr("InvoiceID")), Nothing, dr("InvoiceID"))
            If dr.Table.Columns.Contains("DepositID") Then objCustomerPayments.DepositID = IIf(IsDBNull(dr("DepositID")), Nothing, dr("DepositID"))
        Catch ex As Exception
        End Try
        Return objCustomerPayments

    End Function
    Public Shared Function CustomerPaymentsDetails(ByVal dr As DataRow) As CustomerPaymentsDetails
        Dim objCustomerPayments As New CustomerPaymentsDetails

        Try
            If dr.Table.Columns.Contains("PaymentID") Then objCustomerPayments.PaymentID = dr("PaymentID")
            If dr.Table.Columns.Contains("ProductID") Then objCustomerPayments.ProductID = dr("ProductID")
            If dr.Table.Columns.Contains("SIMID") Then objCustomerPayments.SIMID = dr("SIMID")
            If dr.Table.Columns.Contains("CarID") Then objCustomerPayments.CarID = dr("CarID")
            If dr.Table.Columns.Contains("CustomerID") Then objCustomerPayments.CustomerID = dr("CustomerID")
            If dr.Table.Columns.Contains("PurchaseDate") Then objCustomerPayments.PurchaseDate = dr("PurchaseDate")
            If dr.Table.Columns.Contains("PaymentAmount") Then objCustomerPayments.PaymentAmount = dr("PaymentAmount")
            If dr.Table.Columns.Contains("MethodPayment") Then objCustomerPayments.MethodPayment = dr("MethodPayment")
            If dr.Table.Columns.Contains("InvoiceRequired") Then objCustomerPayments.InvoiceRequired = dr("InvoiceRequired")
            If dr.Table.Columns.Contains("InvoiceID") Then objCustomerPayments.InvoiceID = IIf(IsDBNull(dr("InvoiceID")), Nothing, dr("InvoiceID"))
            If dr.Table.Columns.Contains("DepositID") Then objCustomerPayments.DepositID = IIf(IsDBNull(dr("DepositID")), Nothing, dr("DepositID"))

            If dr.Table.Columns.Contains("CustomerName") Then objCustomerPayments.CustomerName = dr("CustomerName")
            If dr.Table.Columns.Contains("ProductName") Then objCustomerPayments.ProductName = dr("ProductName")
            If dr.Table.Columns.Contains("ICCID") Then objCustomerPayments.ICCID = dr("ICCID")
            If dr.Table.Columns.Contains("brand") Then objCustomerPayments.brand = dr("brand")
            If dr.Table.Columns.Contains("Color") Then objCustomerPayments.Color = dr("Color")
        Catch ex As Exception
        End Try
        Return objCustomerPayments

    End Function
    Public Shared Function PaymentRequestTecomnet(ByVal dr As DataRow) As PaymentRequestTecomnet
        Dim objPaymentRequest As New PaymentRequestTecomnet

        Try
            If dr.Table.Columns.Contains("OrderID") Then objPaymentRequest.OrderID = dr("OrderID")
            If dr.Table.Columns.Contains("SIMID") Then objPaymentRequest.SIMID = dr("SIMID")
            If dr.Table.Columns.Contains("ProductID") Then objPaymentRequest.ProductID = dr("ProductID")
            If dr.Table.Columns.Contains("CarID") Then objPaymentRequest.CarID = dr("CarID")
            If dr.Table.Columns.Contains("CustomerID") Then objPaymentRequest.CustomerID = dr("CustomerID")
            If dr.Table.Columns.Contains("estatus_pago") Then objPaymentRequest.estatus_pago = dr("estatus_pago")
            If dr.Table.Columns.Contains("id_transaction") Then objPaymentRequest.id_transaction = dr("id_transaction")
            If dr.Table.Columns.Contains("auth_number") Then objPaymentRequest.auth_number = dr("auth_number")
            If dr.Table.Columns.Contains("authCode") Then objPaymentRequest.authCode = dr("authCode")
            If dr.Table.Columns.Contains("reason") Then objPaymentRequest.reason = dr("reason")
            If dr.Table.Columns.Contains("CreationDate") Then objPaymentRequest.CreationDate = dr("CreationDate")
        Catch ex As Exception
        End Try
        Return objPaymentRequest
    End Function
    Public Shared Function Company(ByVal dr As DataRow) As Company
        Dim objCompany As New Company
        Try
            If dr.Table.Columns.Contains("CompanyID") Then objCompany.CompanyID = dr("CompanyID")
            If dr.Table.Columns.Contains("Company") Then objCompany.Company = dr("Company")
            If dr.Table.Columns.Contains("CreationDate") Then objCompany.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("LastDate") Then objCompany.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))
        Catch ex As Exception
        End Try
        Return objCompany
    End Function
    Public Shared Function Ticket(ByVal dr As DataRow) As Ticket
        Dim objTicket As New Ticket
        Try
            If dr.Table.Columns.Contains("TicketID") Then objTicket.TicketID = dr("TicketID")
            If dr.Table.Columns.Contains("UserID") Then objTicket.UserID = dr("UserID")
            If dr.Table.Columns.Contains("GUID") Then objTicket.GUID = dr("GUID")
            If dr.Table.Columns.Contains("RegistrationDate") Then objTicket.RegistrationDate = dr("RegistrationDate")
            If dr.Table.Columns.Contains("StartDate") Then objTicket.StartDate = IIf(IsDBNull(dr("StartDate")), Nothing, dr("StartDate"))
            If dr.Table.Columns.Contains("EndDate") Then objTicket.EndDate = IIf(IsDBNull(dr("EndDate")), Nothing, dr("EndDate"))
            If dr.Table.Columns.Contains("Type") Then objTicket.Type = dr("Type")
            If dr.Table.Columns.Contains("Stage") Then objTicket.Stage = dr("Stage")
            If dr.Table.Columns.Contains("Status") Then objTicket.Status = dr("Status")
            If dr.Table.Columns.Contains("Subject") Then objTicket.Subject = dr("Subject")
            If dr.Table.Columns.Contains("Reference") Then objTicket.Reference = dr("Reference")
            If dr.Table.Columns.Contains("Description") Then objTicket.Description = dr("Description")
            If dr.Table.Columns.Contains("Comments") Then objTicket.Comments = dr("Comments")
        Catch ex As Exception
        End Try
        Return objTicket
    End Function
    Public Shared Function InstallationStatus(ByVal dr As DataRow) As InstallationStatus
        Dim objInstallationStatus As New InstallationStatus
        Try
            If dr.Table.Columns.Contains("VIN") Then objInstallationStatus.VIN = IIf(IsDBNull(dr("VIN")), "", dr("VIN"))
            If dr.Table.Columns.Contains("ICCID") Then objInstallationStatus.ICCID = IIf(IsDBNull(dr("ICCID")), "", dr("ICCID"))
            If dr.Table.Columns.Contains("PreviousVersion") Then objInstallationStatus.PreviousVersion = IIf(IsDBNull(dr("PreviousVersion")), "", dr("PreviousVersion"))
            If dr.Table.Columns.Contains("CurrentVersion") Then objInstallationStatus.CurrentVersion = IIf(IsDBNull(dr("CurrentVersion")), "", dr("CurrentVersion"))
            If dr.Table.Columns.Contains("PreviousSIM") Then objInstallationStatus.PreviousSIM = IIf(IsDBNull(dr("PreviousSIM")), "", dr("PreviousSIM"))
            If dr.Table.Columns.Contains("Connectivity") Then objInstallationStatus.Connectivity = IIf(IsDBNull(dr("Connectivity")), "", dr("Connectivity"))
            If dr.Table.Columns.Contains("SIMStatus") Then objInstallationStatus.SIMStatus = IIf(IsDBNull(dr("SIMStatus")), "", dr("SIMStatus"))
            If dr.Table.Columns.Contains("State") Then objInstallationStatus.State = IIf(IsDBNull(dr("State")), "", dr("State"))
        Catch ex As Exception
        End Try
        Return objInstallationStatus
    End Function
    Public Shared Function InstallationEvidence(ByVal dr As DataRow) As InstallationEvidence
        Dim objInstallationEvidence As New InstallationEvidence
        Try
            If dr.Table.Columns.Contains("VIN") Then objInstallationEvidence.VIN = IIf(IsDBNull(dr("VIN")), "", dr("VIN"))
            If dr.Table.Columns.Contains("PreviousVersion") Then objInstallationEvidence.PreviousVersion = IIf(IsDBNull(dr("PreviousVersion")), "", dr("PreviousVersion"))
            If dr.Table.Columns.Contains("CurrentVersion") Then objInstallationEvidence.CurrentVersion = IIf(IsDBNull(dr("CurrentVersion")), "", dr("CurrentVersion"))
            If dr.Table.Columns.Contains("PreviousSIM") Then objInstallationEvidence.PreviousSIM = IIf(IsDBNull(dr("PreviousSIM")), "", dr("PreviousSIM"))
            If dr.Table.Columns.Contains("Connectivity") Then objInstallationEvidence.Connectivity = IIf(IsDBNull(dr("Connectivity")), "", dr("Connectivity"))
        Catch ex As Exception
        End Try
        Return objInstallationEvidence
    End Function
End Class
Public Class Securyty
    Public Shared Function Cifrar(ByVal cadena As String) As String
        Dim strEncriptar As String
        Dim Codificar As New UnicodeEncoding()
        Dim BytesTexto() As Byte = Codificar.GetBytes(cadena)
        Dim Md5 As New MD5CryptoServiceProvider()
        Dim TablaBytes() As Byte = Md5.ComputeHash(BytesTexto)
        strEncriptar = Convert.ToBase64String(TablaBytes).ToString

        Return strEncriptar
    End Function
    Public Shared Function DecodeBase64ToString(valor As String) As String
        Dim myBase64ret As Byte() = Convert.FromBase64String(valor)
        Dim myStr As String = System.Text.Encoding.UTF8.GetString(myBase64ret)
        Return myStr
    End Function
    Public Shared Function EncodeStrToBase64(valor As String) As String
        Dim myByte As Byte() = System.Text.Encoding.UTF8.GetBytes(valor)
        Dim myBase64 As String = Convert.ToBase64String(myByte)
        Return myBase64
    End Function

End Class
