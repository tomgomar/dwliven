<%@ Page Language="vb" AutoEventWireup="false" EnableViewState="false" CodeBehind="PackageListUpdates.aspx.vb" Inherits="Dynamicweb.Admin.PackageListUpdates" EnableEventValidation="false" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib">
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/WaterMark.js" type="text/javascript"></script>
        <link rel="stylesheet" type="text/css" href="/Admin/Resources/css/dw8stylefix.css" />
    </dwc:ScriptLib>
    <% If ShowLicenseWarning Then %>
    <script>
        Action.Execute(<%=GetLicenseWarningDialog()%>)
    </script>
    <% End If %>
    <script type="text/javascript">
        function showOverlay(message, hide) {
            if (!window.actionOverlay) {
                window.actionOverlay = new overlay("ActionOverlay");
            }
            if (message) {
                window.actionOverlay.message(message);
            }
            if (hide) {
                window.actionOverlay.hide();
            }
            else {
                window.actionOverlay.show();
            }
        }
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader runat="server" id="Blockheader">
        </dwc:BlockHeader>
        <form method="post" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Available updates" />
                <dw:Infobar runat="server" ID="ErrorBlock" Type="Error" Visible="false" Message="This solution doesn't have the setup to use packages." Title="Error" />
                <dw:List runat="server" ID="UpdatesPackagesList" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn runat="server" Name="Name" />
                        <dw:ListColumn runat="server" Name="Update" Width="100" />
                        <dw:ListColumn runat="server" Name="Version" Width="250" />
                        <dw:ListColumn runat="server" Name="Latest" Width="250" />
                    </Columns>
                </dw:List>
                <div class="container" runat="server" id="CommandPane">                            
                    <button runat="server" type="submit" id="RestoreButton" visible="false" name="RestoreButton" onclick="showOverlay()" class="btn btn-flat waves-effect" value="1"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Restore, True)%>"></i> Restore</button>
                    <button runat="server" type="submit" id="UpdateButton" name="UpdateButton" onclick="showOverlay()" class="btn btn-flat waves-effect" value="1"><i class="<%=KnownIconInfo.ClassNameFor(KnownIcon.Refresh, True)%>"></i> Update all</button>                         
                </div>
                <dw:Infobar runat="server" ID="ActionResultLabel" Type="Information" Visible="false" TranslateMessage="False" Title="" Message="" />
                <dw:Infobar runat="server" ID="RestoreWarning" Type="Warning" Visible="False" TranslateMessage="True" Title="" Message="Some packages are missing from application. Please, click to restore." />
                <dw:Overlay ID="ActionOverlay" Message="Please wait" ShowWaitAnimation="true" runat="server"></dw:Overlay>
            </dwc:Card>
        </form>
    </div>
</body>
</html>