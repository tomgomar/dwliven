<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UserAndGroupTypeSelect.aspx.vb" Inherits="Dynamicweb.Admin.UserAndGroupTypeSelect" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <dwc:ScriptLib runat="server">
        <script type="text/javascript" src="/Admin/Content/JsLib/prototype-1.7.js"></script>
        <script type="text/javascript" src="/Admin/Content/JsLib/dw/Utilities.js"></script>
        <script type="text/javascript" src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js"></script>
    </dwc:ScriptLib>
    <title></title>
    <script>
        function createRegular() {
            location.href = "<%= GetTargetPath() %>&BasedOn=|regular|";
        }

        function createTypeBased(basedOn) {
            if (!basedOn || typeof (basedOn) != "string" || basedOn.trim().length < 1) {
                createRegular();
                return;
            }

            location.href = "<%= GetTargetPath() %>&BasedOn=" + basedOn;
        }
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" ID="CardHeader" />
            <dwc:CardBody runat="server">
                <dwc:GroupBox runat="server" ID="regularGroupBox" Title="Choose paragraph type">
                    <div onclick="createRegular();">
                        <span class="large-icon page-type-select-icon">
                            <i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.PlusSquare)%>"></i>
                        </span>

                        <span class="page-type-select-btn-center">
                            <a href="javascript:;" id="TemplateName0" class="btn btn-link">
                                <dw:TranslateLabel runat="server" ID="RegularObjectText" />
                            </a>
                        </span>

                        <div class="description-text">
                            <dw:TranslateLabel ID="TranslateLabel6" runat="server" Text="Choose this to create a new regular user" />
                        </div>
                    </div>
                </dwc:GroupBox>

                <dwc:GroupBox runat="server" ID="userTypesGroupBox" Title="Item types">
                    <asp:Repeater ID="UserAndGroupTypeRepeater" runat="server" EnableViewState="false">
                        <ItemTemplate>
                            <div onclick="createTypeBased('<%# Eval("SystemName") %>');">
                                <span id="iconSpan" runat="server" class="large-icon page-type-select-icon"></span>

                                <span class="page-type-select-btn-center">
                                    <a href="javascript:;" class="btn btn-link"><%# Eval("Name") %></a>
                                </span>

                                <div class="description-text">
                                    <label class="control-label"><%# Converter.ToString(Eval("Description")) %></label>
                                </div>
                            </div>
                            <div class="clearfix"></div>
                        </ItemTemplate>
                    </asp:Repeater>
                </dwc:GroupBox>

                <div class="m-l-10" id="MessageBlock" runat="server">
                    <dw:TranslateLabel Text="No user and group types is available." runat="server" />
                </div>
            </dwc:CardBody>
        </dwc:Card>
    </div>
</body>
</html>
