<%@ Page Title="Pago Seguro" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="SurePay.aspx.vb" Inherits="WebCustomerTECOMNET.SurePay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://js.stripe.com/v3/"></script>
    <script>
        function ValidateForm() {

            if (Page_ClientValidate()) {
                var opcion;
                opcion = $('#<%= rblpaymentMethod.ClientID %> input:checked').val();

                if (opcion == 1) {
                    return true;
                } else {
                    $('#ConfirmationModalTransferencia').modal('show');
                    return false;
                }
            } else {
                return false; // Evita el postback
            }
        }        
</script>
    <link rel="stylesheet" href="../../Css/bootstrap.min.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Información de pago</label>
    </div>
    <div class="container containerGral">
        <div class="container-xxl">
            <main>
                <div class="py-3 text-center">
                    <p class="lead text-T">Por favor ingrese los datos solicitados, el pago se procesa a traves de un medio seguro.</p>
                </div>
                <div class="row g-5">
                    <div class="col-md-5 col-lg-4 order-md-last">
                        <h4 class="d-flex justify-content-between align-items-center mb-3">
                            <span class="text-C">Paquete seleccionado</span>
                        </h4>
                        <ul class="list-group mb-3">
                            <li class="list-group-item d-flex justify-content-between">
                                <div>
                                    <asp:Label ID="lblProduct" runat="server" CssClass="h5 my-0"></asp:Label>
                                    <br />
                                    <small class="text-muted">
                                        <asp:Label ID="lblMB" runat="server"></asp:Label></small>
                                </div>
                            </li>
                            <li class="list-group-item d-flex justify-content-between">
                                <strong>
                                    <span class="h5 my-0">Costo de paquete</span>
                                </strong>
                                <strong>
                                    <asp:Label ID="lblPrice" runat="server" CssClass="text-C"></asp:Label>
                                </strong>
                            </li>

                            <li class="list-group-item d-flex justify-content-between">
                                <strong>
                                    <span class="h5 my-0">Costo de plataforma</span>
                                </strong>
                                <strong>
                                    <asp:Label ID="lblUsoPlataforma" runat="server" CssClass="text-C"></asp:Label>
                                </strong>
                            </li>

                            <li class="list-group-item d-flex justify-content-between">
                                <strong>
                                    <span class="text-C">Total</span>
                                </strong>
                                <strong>
                                    <asp:Label ID="lblTotal" runat="server" CssClass="text-C"></asp:Label>
                                </strong>
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-7 col-lg-8">                        
                        <h4 class="mb-3 text-C">Forma de Pago</h4>
                        <div class="my-3">
                            <div class="form-check">
                                <asp:RadioButtonList ID="rblpaymentMethod" runat="server" RepeatDirection="Vertical">
                                    <asp:ListItem Text="Tarjeta Crédito/Debito" Value="1" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Transferencia Bancaría" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <hr class="my-4">
                        <asp:ValidationSummary ID="Pago" runat="server" CssClass="alert alert-danger alert-dismissible fade show" />
                        <div id="ErrorMessageDiv" runat="server" class="alert alert-success alert-dismissible fade show text-center" visible="false">
                            <asp:Literal runat="server" ID="FailureText" />
                        </div>
                        <asp:Button ID="btnContinuar" runat="server" Text="Continuar al pago" CssClass="w-100 btn btn-primary btn-lg"
                            OnClientClick="return ValidateForm();" OnClick="btnContinuar_Click" />
                    </div>
                </div>
            </main>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="ConfirmationModalTransferencia" tabindex="-1" aria-labelledby="exampleModalLabelTransferencia" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title" id="exampleModalLabelTransferencia">Su pedido fue registrado satisfactoriamente</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>
                        Dejamos a su disposición los datos bancarios para realizar el pago correspondiente y nos haga llegar el comprobante de pago.
                    </p>
                    <ul>
                        <li>TECOMNET</li>
                        <li>BANCO: Scotiabank</li>
                        <li>CTA: 25601134029</li>
                        <li>CLABE: 044180256011340298</li>
                        <li>RFC: TEC240716AX8</li>
                        <li>Email: info@tecomnet.mx</li>
                        <li>Teléfono: 5597297420</li>
                    </ul>
                    <p>
                        Agradecemos su preferencia.
                    </p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnAceptarTransferencia" runat="server" Text="Aceptar" CssClass="btn btn-primary" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
