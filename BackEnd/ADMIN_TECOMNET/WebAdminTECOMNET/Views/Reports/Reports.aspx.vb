Imports DatabaseConnectionTECOMNET
Imports Telerik.Web.UI
Public Class Reports
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            rdpStart.SelectedDate = New Date(Now.Year, Now.Month, 1)
            rdpEnd.SelectedDate = Now
        End If
    End Sub

    Private Sub rgResult_NeedDataSource(sender As Object, e As GridNeedDataSourceEventArgs) Handles rgResult.NeedDataSource
        Dim controller As New Controller
        Dim sql As String = String.Empty

        Select Case rtsReports.SelectedTab.Value
            Case "1"
                Select Case rrblCustomer.SelectedValue
                    Case "1"
                        sql = "SELECT CustomerName AS Nombre,FORMAT(DateBirth, 'dd/MM/yyyy') AS FechaDeCumpleaños,FORMAT(CreationDate, 'dd/MM/yyyy') AS FechaDeAlta,Country AS PAIS,State AS Estado FROM Customer"
                        sql += " WHERE LastDate IS NULL"
                    Case "2"
                        sql = "SELECT CustomerName AS Nombre,FORMAT(DateBirth, 'dd/MM/yyyy') AS FechaDeCumpleaños,FORMAT(CreationDate, 'dd/MM/yyyy') AS FechaDeAlta,Country AS PAIS,State AS Estado, FORMAT(LastDate, 'dd/MM/yyyy') AS FechaDeBaja FROM Customer"
                        sql += " WHERE LastDate IS not NULL"
                End Select
            Case "2"
                Select Case rrblVehiculos.SelectedValue
                    Case "1"
                        sql = "SELECT m.Model AS Modelo,VIN, Year,FORMAT(c.CreationDate, 'dd/MM/yyyy') AS FechaAlta FROM Car as c inner join BYDModels AS m on c.ModelID = m.modelid "
                        sql += " WHERE c.LastDate IS NULL"
                    Case "2"
                        sql = "SELECT m.Model AS Modelo,VIN, Year,FORMAT(c.CreationDate, 'dd/MM/yyyy') AS FechaDeAlta,FORMAT(c.LastDate, 'dd/MM/yyyy') AS FechaDeBaja FROM Car as c inner join BYDModels AS m on c.ModelID = m.modelid"
                        sql += " WHERE c.LastDate IS NOT NULL"
                End Select
            Case "3"
                Select Case rrblSIMS.SelectedValue
                    Case "1"
                        sql = "SELECT MSISDN,VIN,Producto,FORMAT(ExpirationDate, 'dd/MM/yyyy') AS Expira,AssignedMB AS MegasAasignados,UsedMB AS ConsumoEnMB, " &
                              " Case WHEN AvailableMB = 1 THEN 'ILIMITADO' ELSE CAST(AvailableMB AS NVARCHAR(10)) END AS MegasDisponibles, " &
                              " Case WHEN AdditionalMB = 1 THEN 'ILIMITADO' ELSE CAST(AdditionalMB AS NVARCHAR(10)) END AS MegasAdicionales,Active AS Activo from SIM INNER JOIN Car AS c ON SIM.CARID = c.CarID "
                        sql += " WHERE Active=1"
                    Case "2"
                        sql = "SELECT MSISDN,VIN,Producto,FORMAT(ExpirationDate, 'dd/MM/yyyy') AS Expira,AssignedMB AS MegasAasignados,UsedMB AS ConsumoEnMB, " &
                               " CASE WHEN AvailableMB = 1 THEN 'ILIMITADO' ELSE CAST(AvailableMB AS NVARCHAR(10)) END AS MegasDisponibles, " &
                               " Case WHEN AdditionalMB = 1 THEN 'ILIMITADO' ELSE CAST(AdditionalMB AS NVARCHAR(10)) END AS MegasAdicionales,Active, " &
                               " Format(sim.LastDate, 'dd/MM/yyyy') AS FechaDeBaja FROM SIM INNER JOIN Car AS c ON SIM.CARID = c.CarID "
                        sql += " WHERE Active=0"
                End Select
            Case "4"
                sql = "select bm.Model AS Modelo, p.ProductName AS Paquete, PurchaseDate AS DiaDeCompra, CASE WHEN p.MB = 1 THEN 'ILIMITADO' ELSE CAST(p.MB AS NVARCHAR(10)) END AS MEGAS, " &
                      " CASE WHEN MethodPayment = 1 Then 'TDC' ELSE 'TRANSFERENCIA' END AS FormaDePago FROM CustomerPayments AS cp " &
                      " INNER JOIN [Product] As p On cp.ProductID = p.ProductID INNER JOIN Car As c On cp.CarID = c.CarID" &
                      " INNER JOIN BYDModels AS bm ON c.ModelID = bm.ModelId "
                sql += String.Format("WHERE CAST(PurchaseDate AS DATE) BETWEEN '{0:yyyy/MM/dd}' AND '{1:yyyy/MM/dd}'", rdpStart.SelectedDate, rdpEnd.SelectedDate)
                End Select
                rgResult.DataSource = controller.TransactionsQuerys(sql)
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
        rgResult.Rebind()
    End Sub
End Class