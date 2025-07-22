Imports ModelsTECOMNET.TECOMNET

Public Class ControllerProduct
    Public Function GetProducts() As List(Of ProductDetail)
        Dim controller As New Controller
        Dim lstProducts As New List(Of ProductDetail)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsProduct(Of DataSet)(1, New ProductDetail)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstProducts
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstProducts.Add(ConvertObject.ProductsDetail(dr))
                Next
            End If
        Catch ex As Exception
            Return lstProducts
        End Try
        Return lstProducts
    End Function
    Public Function GetProduct(ByVal ProductID As Integer) As Product
        Dim controller As New Controller
        Dim objProduct As New Product
        objProduct.ProductID = ProductID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsProduct(Of DataSet)(2, objProduct)

            For Each dr As DataRow In dt.Tables(0).Rows
                objProduct = ConvertObject.Products(dr)
            Next
        Catch ex As Exception
            Return objProduct
        End Try
        Return objProduct
    End Function
    Public Function AddProduct(ByVal objProduct As Product) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsProduct(Of Integer)(3, objProduct)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function UpdateProduct(ByVal objProduct As Product) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsProduct(Of Integer)(4, objProduct)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function DeactivateProduct(ByVal ProductID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objProduct As New Product
        objProduct.ProductID = ProductID
        objProduct.LastDate = Now
        Try
            exito = controller.TransactionsProduct(Of Integer)(5, objProduct)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function GetAvailableProducts(ByVal CompanyID As Integer) As List(Of Product)
        Dim controller As New Controller
        Dim lstProducts As New List(Of Product)
        Dim objProduct As New Product
        objProduct.CompanyID = CompanyID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsProduct(Of DataSet)(6, objProduct)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstProducts
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstProducts.Add(ConvertObject.Products(dr))
                Next
            End If
        Catch ex As Exception
            Return lstProducts
        End Try
        Return lstProducts
    End Function
End Class
