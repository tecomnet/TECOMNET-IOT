Imports DatabaseConnectionTECOMNET
Imports Telerik.Web.UI
Public Class Reports
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            rdpStart.SelectedDate = New Date(Now.Year, Now.Month, 1)
            rdpEnd.SelectedDate = Now

            rdpStartInstallation.SelectedDate = New Date(Now.Year, 1, 1)
            rdpEndInstallation.SelectedDate = Now

            rgInstallation.DataSource = String.Empty
            rgResult.DataSource = String.Empty
            rgResult.Style.Add("display", "none")
            rgInstallation.Style.Add("display", "none")
        End If
    End Sub

    Private Sub rgResult_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgResult.NeedDataSource
        Dim controller As New Controller
        Dim sql As String = String.Empty

        Select Case rtsReports.SelectedTab.Value
            Case "1"
                Select Case rrblCustomer.SelectedValue
                    Case "1"
                        sql = "SELECT DISTINCT CustomerName AS Nombre,FORMAT(DateBirth, 'dd/MM/yyyy') AS FechaDeCumpleaños,FORMAT(Customer.CreationDate, 'dd/MM/yyyy') AS FechaDeAlta,Country AS PAIS,State AS Estado FROM Customer " &
                            " INNER JOIN Car AS C ON Customer.CustomerID = C.CustomerID " &
                            " INNER JOIN SIM AS S ON C.CarID = S.CarID " &
                            " INNER JOIN [Product] AS P ON S.ProductID = P.ProductID " &
                            " INNER JOIN Company AS Com ON P.CompanyID=Com.CompanyID "
                        sql += " WHERE Customer.LastDate IS NULL AND Com.CompanyID=3"
                    Case "2"
                        sql = "SELECT DISTINCT CustomerName AS Nombre,FORMAT(DateBirth, 'dd/MM/yyyy') AS FechaDeCumpleaños,FORMAT(Customer.CreationDate, 'dd/MM/yyyy') AS FechaDeAlta,Country AS PAIS,State AS Estado, FORMAT(Customer.LastDate, 'dd/MM/yyyy') AS FechaDeBaja  FROM Customer " &
                            " INNER JOIN Car AS C ON Customer.CustomerID = C.CustomerID " &
                            " INNER JOIN SIM AS S ON C.CarID = S.CarID " &
                            " INNER JOIN [Product] AS P ON S.ProductID = P.ProductID " &
                            " INNER JOIN Company AS Com ON P.CompanyID=Com.CompanyID "
                        sql += " WHERE Customer.LastDate IS NOT NULL AND Com.CompanyID=3"
                End Select
            Case "2"
                Select Case rrblVehiculos.SelectedValue
                    Case "1"
                        sql = "SELECT m.Model AS Modelo,VIN, Year,FORMAT(c.CreationDate, 'dd/MM/yyyy') AS FechaAlta FROM Car as c inner join BYDModels AS m on c.ModelID = m.modelid " &
                            " INNER JOIN SIM AS S ON C.CarID = S.CarID " &
                            " INNER JOIN [Product] AS P ON S.ProductID = P.ProductID " &
                            " INNER JOIN Company AS Com ON P.CompanyID=Com.CompanyID "
                        sql += " WHERE c.LastDate IS NULL AND Com.CompanyID=3"
                    Case "2"
                        sql = "SELECT m.Model AS Modelo,VIN, Year,FORMAT(c.CreationDate, 'dd/MM/yyyy') AS FechaDeAlta,FORMAT(c.LastDate, 'dd/MM/yyyy') AS FechaDeBaja FROM Car as c inner join BYDModels AS m on c.ModelID = m.modelid" &
                            " INNER JOIN SIM AS S ON C.CarID = S.CarID " &
                            " INNER JOIN [Product] AS P ON S.ProductID = P.ProductID " &
                            " INNER JOIN Company AS Com ON P.CompanyID=Com.CompanyID "
                        sql += " WHERE c.LastDate IS NOT NULL AND Com.CompanyID=3"
                End Select
            Case "3"
                Select Case rrblSIMS.SelectedValue
                    Case "1"
                        sql = "SELECT ICCID,MSISDN,VIN,Producto,FORMAT(ExpirationDate, 'dd/MM/yyyy') AS Expira,AssignedMB AS MegasAsignados,UsedMB AS ConsumoEnMB, " &
                              " Case WHEN AvailableMB = 1 THEN 'ILIMITADO' ELSE CAST(AvailableMB AS NVARCHAR(10)) END AS MegasDisponibles, " &
                              " Case WHEN AdditionalMB = 1 THEN 'ILIMITADO' ELSE CAST(AdditionalMB AS NVARCHAR(10)) END AS MegasAdicionales,Active AS Activo from SIM LEFT JOIN Car AS c ON SIM.CARID = c.CarID " &
                              " INNER JOIN [Product] AS p ON SIM.ProductID=p.ProductID INNER JOIN Company AS Com ON p.CompanyID=Com.CompanyID "
                        sql += " WHERE Active=1 and Com.CompanyID=3"
                    Case "2"
                        sql = "SELECT ICCID,MSISDN,VIN,Producto,FORMAT(ExpirationDate, 'dd/MM/yyyy') AS Expira,AssignedMB AS MegasAasignados,UsedMB AS ConsumoEnMB, " &
                               " CASE WHEN AvailableMB = 1 THEN 'ILIMITADO' ELSE CAST(AvailableMB AS NVARCHAR(10)) END AS MegasDisponibles, " &
                               " Case WHEN AdditionalMB = 1 THEN 'ILIMITADO' ELSE CAST(AdditionalMB AS NVARCHAR(10)) END AS MegasAdicionales,Active, " &
                               " Format(sim.LastDate, 'dd/MM/yyyy') AS FechaDeBaja FROM SIM LEFT JOIN Car AS c ON SIM.CARID = c.CarID " &
                               " INNER JOIN [Product] AS p ON SIM.ProductID=p.ProductID INNER JOIN Company AS Com ON p.CompanyID=Com.CompanyID "
                        sql += " WHERE Active=0 and Com.CompanyID=3"
                End Select
            Case "4"
                sql = "select bm.Model AS Modelo, p.ProductName AS Paquete, PurchaseDate AS DiaDeCompra, CASE WHEN p.MB = 1 THEN 'ILIMITADO' ELSE CAST(p.MB AS NVARCHAR(10)) END AS MEGAS, " &
                      " CASE WHEN MethodPayment = 1 Then 'TDC' ELSE 'TRANSFERENCIA' END AS FormaDePago FROM CustomerPayments AS cp " &
                      " INNER JOIN [Product] As p On cp.ProductID = p.ProductID INNER JOIN Car As c On cp.CarID = c.CarID" &
                      " INNER JOIN BYDModels AS bm ON c.ModelID = bm.ModelId " &
                      " INNER JOIN Company AS Com ON P.CompanyID= Com.CompanyID "
                sql += String.Format("WHERE Com.CompanyID=3 AND CAST(PurchaseDate AS DATE) BETWEEN '{0:yyyy/MM/dd}' AND '{1:yyyy/MM/dd}'", rdpStart.SelectedDate, rdpEnd.SelectedDate)
        End Select
        rgResult.DataSource = controller.TransactionsQuerys(sql)
    End Sub
    Private Sub rgInstallation_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgInstallation.NeedDataSource
        Dim controller As New Controller
        Dim sql As String = String.Empty

        Select Case rtsReports.SelectedTab.Value
            Case "5"
                sql = "select c.VIN,ICCID, s.installationDate AS FechaInstalacion,s.[Status] AS Estado,PreviousVersion AS VersionAnterior,CurrentVersion AS VersionActual, " &
                      " PreviousSIM AS SIM_Anterior,Connectivity AS Conectividad from Car as c left join SIM as s on c.CarID = s.CarID left join InstallationEvidence as ie  " &
                      " on c.VIN = ie.VIN "
                sql += String.Format(" WHERE CAST(s.installationDate AS DATE) BETWEEN '{0:yyyy/MM/dd}' AND '{1:yyyy/MM/dd}'", rdpStartInstallation.SelectedDate, rdpEndInstallation.SelectedDate)
        End Select
        rgInstallation.DataSource = controller.TransactionsQuerys(sql)
    End Sub
    Private Sub rgResult_ColumnCreated(sender As Object, e As GridColumnCreatedEventArgs) Handles rgResult.ColumnCreated
        Select Case rtsReports.SelectedTab.Value
            Case "3"
                If TypeOf e.Column Is GridBoundColumn Then
                    Dim boundColumn As GridBoundColumn = CType(e.Column, GridBoundColumn)
                    Dim nombre As String = If(String.IsNullOrEmpty(boundColumn.DataField), boundColumn.UniqueName, boundColumn.DataField)
                    Select Case nombre
                        Case "ICCID", "MSISDN", "VIN", "Producto"
                            boundColumn.AllowFiltering = True
                            boundColumn.ShowFilterIcon = False
                            boundColumn.FilterDelay = 1000
                            boundColumn.CurrentFilterFunction = GridKnownFunction.Contains
                            boundColumn.FilterControlWidth = Unit.Percentage(100)
                        Case "Activo"
                            boundColumn.AllowFiltering = False
                        Case Else
                            boundColumn.AllowFiltering = False
                    End Select
                End If
        End Select
    End Sub

    Private Sub rgResult_ItemCommand(sender As Object, e As GridCommandEventArgs) Handles rgResult.ItemCommand
        If e.CommandName = Telerik.Web.UI.RadGrid.ExportToExcelCommandName Then
            rgResult.ExportSettings.Excel.Format = GridExcelExportFormat.Biff
            rgResult.ExportSettings.IgnorePaging = True
            rgResult.ExportSettings.ExportOnlyData = True
            rgResult.ExportSettings.FileName = "Result"
        End If
    End Sub

    Private Sub btnFind_Click(sender As Object, e As EventArgs) Handles btnFind.Click
        Select Case rtsReports.SelectedTab.Value
            Case "1", "2", "3", "4"
                rgResult.Style.Remove("display")
                rgInstallation.Style.Add("display", "none")
                rgResult.Rebind()
            Case "5"
                rgInstallation.Style.Remove("display")
                rgResult.Style.Add("display", "none")
                rgInstallation.Rebind()
        End Select
    End Sub
End Class