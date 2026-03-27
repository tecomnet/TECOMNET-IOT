Imports ModelsTECOMNET
Imports ModelsTECOMNET.TECOMNET

Public Class ControllerCar
    Public Function GetCars() As List(Of CarDetail)
        Dim controller As New Controller
        Dim lstCar As New List(Of CarDetail)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCar(Of DataSet)(1, New CarDetail)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstCar
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstCar.Add(ConvertObject.CarsDetail(dr))
                Next
            End If
        Catch ex As Exception
            Return lstCar
        End Try
        Return lstCar
    End Function
    Public Function GetCar(ByVal CarID As Integer) As Car
        Dim controller As New Controller
        Dim objCar As New Car
        objCar.CarID = CarID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCar(Of DataSet)(2, objCar)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCar = ConvertObject.Cars(dr)
            Next
        Catch ex As Exception
            Return objCar
        End Try
        Return objCar
    End Function
    Public Function AddCar(ByVal objCar As Car) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCar(Of Integer)(3, objCar)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdateCar(ByVal objCar As Car) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCar(Of Integer)(4, objCar)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function DeactivateCar(ByVal CarID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objCar As New Car
        objCar.CarID = CarID
        objCar.LastDate = Now
        Try
            exito = controller.TransactionsCar(Of Integer)(5, objCar)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function GetAvailableCarByMatch(ByVal TextSearch As String) As List(Of Car)
        Dim controller As New Controller
        Dim lstCar As New List(Of Car)
        Try
            Dim dt As New DataSet
            Dim objCar As New Car
            objCar.VIN = TextSearch
            dt = controller.TransactionsCar(Of DataSet)(6, objCar)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstCar
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstCar.Add(ConvertObject.Cars(dr))
                Next
            End If
        Catch ex As Exception
            Return lstCar
        End Try
        Return lstCar
    End Function
    Public Function GetAvailableCarCustomerByMatch(ByVal TextSearch As String) As List(Of Car)
        Dim controller As New Controller
        Dim lstCar As New List(Of Car)
        Try
            Dim dt As New DataSet
            Dim objCar As New Car
            objCar.VIN = TextSearch
            dt = controller.TransactionsCar(Of DataSet)(7, objCar)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstCar
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstCar.Add(ConvertObject.Cars(dr))
                Next
            End If
        Catch ex As Exception
            Return lstCar
        End Try
        Return lstCar
    End Function
    Public Function AssociateCarToCustomer(ByVal objCar As Car) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCar(Of Integer)(8, objCar)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function GetCarByVIN(ByVal VIN As String) As Car
        Dim controller As New Controller
        Dim objCar As New Car
        objCar.VIN = VIN
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCar(Of DataSet)(9, objCar)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCar = ConvertObject.Cars(dr)
            Next
        Catch ex As Exception
            Return objCar
        End Try
        Return objCar
    End Function
    Public Function GetCarDetailSIMByVIN(ByVal VIN As String) As CarDetailSIM
        Dim controller As New Controller
        Dim objCar As New CarDetailSIM
        objCar.VIN = VIN
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCar(Of DataSet)(10, objCar)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCar = ConvertObject.CarsDetail(dr)
            Next
        Catch ex As Exception
            Return objCar
        End Try
        Return objCar
    End Function
    Public Function GetInstallationStatusByVIN(ByVal VIN As String) As InstallationStatus
        Dim controller As New Controller
        Dim objInstallationStatus As New InstallationStatus
        Dim objCar As New Car

        objCar.VIN = VIN

        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCar(Of DataSet)(11, objCar)

            For Each dr As DataRow In dt.Tables(0).Rows
                objInstallationStatus = ConvertObject.InstallationStatus(dr)
            Next
        Catch ex As Exception
            Return objInstallationStatus
        End Try
        Return objInstallationStatus
    End Function
End Class
