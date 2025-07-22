Namespace Enums.TECOMNET

    Public Enum MovementType
        Activation = 1
        Suspend = 2
        ResumeService = 3
        Desactivate = 4
        ViewProfile = 5
    End Enum
    Public Enum UserType
        AdministratorTECOMNET = 1
        Installer = 2
        Seller = 3
        AdminBYD = 4
    End Enum
    Public Enum MethodPayment
        Card = 1
        BankTransfer = 2
    End Enum
    Public Enum AltanErrors
        Unknown = 0
        Susssuccessful = 1
        Mistake = 2
        Warning = 3
    End Enum
    Public Enum LinkXErrors
        Unknown = 0
        Susssuccessful = 1
        Mistake = 2
        Warning = 3
    End Enum
    Public Enum AltanApisMethod
        Profile = 1
        Suspend = 2
        Resumen = 3
    End Enum
    Public Enum TypeMessageMail
        Recharge = 1
        WelcomeCustomer = 2
        NotificationRecharge = 3
    End Enum
End Namespace