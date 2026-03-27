<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewEvidence.aspx.vb" Inherits="WebAdminTECOMNET.ViewEvidence" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="https://cdn.jsdelivr.net/npm/medium-zoom@1.0.6/dist/medium-zoom.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style type="text/css">
        .success {
            background-color: #d5edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        h1 {
            color: #2c3e50;
            margin-bottom: 25px;
            text-align: center;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .status-message {
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }

        .image-container {
            text-align: center;
            margin-top: 30px;
            padding: 25px;
            background-color: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #2ecc71;
        }

        .image-wrapper {
            display: inline-block;
            max-width: 800px;
            margin: 0 auto;
            padding: 15px;
            background-color: white;
            border-radius: 6px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="image-wrapper" id="Div1" runat="server">
            <!-- Botón con icono Font Awesome -->
            <button type="button" class="zoom-btn-advanced" onclick="initZoom()" title="Hacer zoom">
                <i class="fas fa-search-plus"></i>Ampliar
            </button>

            <asp:Image ID="Image1" runat="server" AlternateText="Imagen....."
                CssClass="zoom-image" data-zoom-src="" />
        </div>
        <div class="image-container" id="imageContainer" runat="server">
            <div class="form-section">
                <asp:Panel ID="pnlMessage" runat="server" CssClass="status-message">
                    <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                </asp:Panel>
                <div class="image-wrapper" id="imageWrapper" runat="server">
                    <asp:Image ID="imgEvidencia" runat="server" AlternateText="Imagen....." />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
