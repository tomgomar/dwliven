<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EventViewerEmailNotification.aspx.vb" Inherits="Dynamicweb.Admin.EventViewerEmailNotification" %>

<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Event viewer details</title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerEmailNotification.js" />
            <dw:GenericResource Url="/Admin/Content/Management/EventViewer/EventViewerEmailNotification.css" />
        </Items>
    </dw:ControlResources>
</head>
<body class="screen-container">
    <form id="MainForm" runat="server">
        <input type="hidden" id="cmdValue" name="cmdValue" value="" />
        <dw:Overlay ID="PleaseWait" runat="server" />
        <div class="card">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Event viewer notifications"></dwc:CardHeader>
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="DatabaseGroupBox" runat="server" Title="Database information" GroupWidth="6">
                        <dwc:InputTextArea runat="server" ID="notifiedEmails" Label="Subscribed emails" Name="/Globalsettings/Settings/EventViewer/NotifiedEmails" Info="Email-addresses of people who should be notificed." />                        
                        <dwc:SelectPicker runat="server" ID="notificationLevel" Name="/Globalsettings/Settings/EventViewer/NotificationLevel" Label="Notification level" Info="Minimum event level that will trigger an email notification."/>                                                    
                        <dwc:InputNumber runat="server" ID="sendInterval" Label="Send interval" Name="/Globalsettings/Settings/EventViewer/SendInterval" info="Minimum minutes delay between each email notification."/>                        
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
        </div>
    </form>
    <dwc:ActionBar runat="server">
        <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" OnClientClick="EventViewerEmailNotification.save();" ID="cmdSave" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="EventViewerEmailNotification.saveAndClose();" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="EventViewerEmailNotification.cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
        </dw:ToolbarButton>
    </dwc:ActionBar>
</body>
</html>