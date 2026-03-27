Imports System.Web.Compilation
Imports ModelsTECOMNET.TECOMNET

Public Class CustomerControl
    Inherits System.Web.UI.UserControl
#Region "Properties"
    Public Property CustomerID As Integer
        Get
            Return Val(hfCustomerID.Value)
        End Get
        Set(value As Integer)
            hfCustomerID.Value = value
        End Set
    End Property
    Public Property PaternalSurname As String
        Get
            Return rtbPaternalSurname.Text
        End Get
        Set(value As String)
            rtbPaternalSurname.Text = value
        End Set
    End Property
    Public Property MaternalSurname As String
        Get
            Return rtbMaternalSurname.Text
        End Get
        Set(value As String)
            rtbMaternalSurname.Text = value
        End Set
    End Property
    Public Property Name As String
        Get
            Return rtbName.Text
        End Get
        Set(value As String)
            rtbName.Text = value
        End Set
    End Property
    Public Property CustomerName As String
        Get
            Return rtbCustomerName.Text
        End Get
        Set(value As String)
            rtbCustomerName.Text = value
        End Set
    End Property
    Public Property DateBirth As Date?
        Get
            Return rdpDateBirth.SelectedDate
        End Get
        Set(value As Date?)
            rdpDateBirth.SelectedDate = value
        End Set
    End Property
    Public Property Email As String
        Get
            Return tbEmail.Text
        End Get
        Set(value As String)
            tbEmail.Text = value
        End Set
    End Property
    Public Property PhoneNumber As String
        Get
            Return tbPhoneNumber.Text
        End Get
        Set(value As String)
            tbPhoneNumber.Text = value
        End Set
    End Property
    Public Property RFC As String
        Get
            Return rtbRFC.Text
        End Get
        Set(value As String)
            rtbRFC.Text = value
        End Set
    End Property
    Public Property CURP As String
        Get
            Return rtbCURP.Text
        End Get
        Set(value As String)
            rtbCURP.Text = value
        End Set
    End Property


    Public Property Sex As String
        Get
            Return ddlSex.SelectedValue
        End Get
        Set(value As String)
            ddlSex.SelectedValue = value
        End Set
    End Property
    Public Property Country As String
        Get
            Return ddlCountry.SelectedValue
        End Get
        Set(value As String)
            ddlCountry.SelectedValue = value
        End Set
    End Property
    Public Property State As String
        Get
            Return ddlState.SelectedValue
        End Get
        Set(value As String)
            ddlState.SelectedValue = value
        End Set
    End Property

    Public Property Cologne As String
        Get
            Return rtbCologne.Text
        End Get
        Set(value As String)
            rtbCologne.Text = value
        End Set
    End Property
    Public Property Address As String
        Get
            Return rtbAddress.Text
        End Get
        Set(value As String)
            rtbAddress.Text = value
        End Set
    End Property
    Public Property ZipCode As String
        Get
            Return rtbZipCode.Text
        End Get
        Set(value As String)
            rtbZipCode.Text = value
        End Set
    End Property
    Private Sub CustomerControl_Load(sender As Object, e As EventArgs) Handles Me.Load
        hfCustomerID.Value = Me.CustomerID
        rtbPaternalSurname.Text = Me.PaternalSurname
        rtbMaternalSurname.Text = Me.MaternalSurname
        rtbName.Text = Me.Name
        rtbCustomerName.Text = Me.CustomerName
        rdpDateBirth.SelectedDate = Me.DateBirth
        tbEmail.Text = Me.Email
        tbPhoneNumber.Text = Me.PhoneNumber
        rtbRFC.Text = Me.RFC
        ddlSex.SelectedValue = Me.Sex
        ddlCountry.SelectedValue = Me.Country
        ddlState.SelectedValue = Me.State
        rtbCologne.Text = Me.Cologne
        rtbAddress.Text = Me.Address
        rtbZipCode.Text = Me.ZipCode
    End Sub
#End Region
#Region "Events"
#End Region
End Class