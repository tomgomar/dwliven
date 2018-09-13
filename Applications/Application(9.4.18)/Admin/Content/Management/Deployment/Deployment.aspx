<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Deployment.aspx.vb" Inherits="Dynamicweb.Admin.Deployment" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">    
    <title>Deployment</title>
    <dw:ControlResources CombineOutput="False" IncludePrototype="false" runat="server">
        <Items>
            <dw:GenericResource Url="js/Deployment.min.js" />
        </Items>
    </dw:ControlResources>
    <style>
        .comparison {
            width:100%;
        }
        .comparison > ul {
            padding:0;
        }
        .comparison li {
            list-style-type: none;
        }        
        .comparison td i {
            margin-right:10px;
        }
        .comparison-summary {
            margin: 10px 0 10px 180px;
            border: 1px solid #9e9e9e;
        }
        .comparison-summary th, .comparison-summary td {
            padding: 10px;
        }
        .comparison-summary th {
            text-align:left;
        }
        .comparison-summary th i {
            margin-right:10px;
        }
        .comparison-summary td {
            text-align:right;
        }
        .comparison-status {
            width: 25px;
        }
        .comparison-details {
            width: 70px;
        }
    </style>
</head>
<body>
    <form id="dataGroupForm" runat="server" enableviewstate="false">
        <div class="screen-container">
            <input type="hidden" id="deploymentAction" name="deploymentAction" runat="server" />
            <input type="hidden" id="dataGroupId" name="dataGroupId" runat="server" />
            <input type="hidden" id="destinationId" name="destinationId" runat="server" />
            <dwc:Card ID="output" runat="server">
                <dwc:CardHeader Title="Transfer selection" runat="server"></dwc:CardHeader>
                <dw:Toolbar ID="toolbar1" runat="server" ShowAsRibbon="true">
                    <dw:ToolbarButton runat="server" Text="Transfer selected" ID="cmdTransfer" Icon="Exchange" OnClientClick="TransferButtonClicked();" ShowWait="true" WaitTimeout="500">
                    </dw:ToolbarButton>
                </dw:Toolbar>
                <dw:GroupBox runat="server">
                    <dw:Infobar ID="destinationInfobar" runat="server" Type="Warning" Message="" TranslateMessage="False" Visible="false" />
                    <dwc:InputText ID="destinationName" Name="destinationName" runat="server" Label="Destination" Value="" Disabled="true"></dwc:InputText>
                </dw:GroupBox>
            </dwc:Card>
        </div>
        <dwc:ActionBar ID="actionbar1" runat="server">
            <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" ID="cmdCancel" ShowWait="true" WaitTimeout="500" OnClientClick="Cancel();">
            </dw:ToolbarButton>
        </dwc:ActionBar>
        <dw:Dialog ID="ComparisonDetailsDialog" Title="Comparison" Size="Large" HidePadding="true" ShowOkButton="true" ShowCancelButton="false" ShowClose="true" runat="server">
            <iframe id="ComparisonDetailsDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>
    </form>
</body>
</html>
<%Translate.GetEditOnlineScript()%>