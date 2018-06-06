<%@ Page Language="vb" AutoEventWireup="false" EnableViewState="false" CodeBehind="PackageListInstalled.aspx.vb" Inherits="Dynamicweb.Admin.PackageListInstalled" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Controls" %>
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
</head>
<body class="area-blue">
    <div class="dw8-container">
        <dwc:BlockHeader runat="server" id="Blockheader">
        </dwc:BlockHeader>
        <form method="post" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Installed packages" />
                <dw:Infobar runat="server" ID="ErrorBlock" Type="Error" Visible="false" Message="This solution doesn't have the setup to use packages." Title="Error" />
                <dw:List runat="server" ID="InstalledPackagesList" ShowTitle="false">
                    <Columns>
                        <dw:ListColumn runat="server" Name="Name" />
                        <dw:ListColumn runat="server" Name="Installed" Width="100" />
                        <dw:ListColumn runat="server" Name="Version" Width="250" />
                        <dw:ListColumn runat="server" Name="Latest" Width="100" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
</body>
</html>