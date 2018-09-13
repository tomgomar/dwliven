﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LiveIntegrationAddInSettings.aspx.vb" Inherits="Dynamicweb.Admin.LiveIntegrationAddInSettings" %>

<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <title>Live Integration Add-In Settings</title>
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Module/IntegrationV2/js/SelectDestination.js" />
            <dw:GenericResource Url="/Admin/Images/Controls/UserSelector/UserSelector.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript" src="/Admin/Resources/js/layout/Actions.js"></script>
    <script type="text/javascript" src="/Admin/Module/IntegrationV2/js/LiveIntegrationAddInSettings.js"></script>
    <script type="text/javascript" src="/Admin/Link.js"></script>
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <style type="text/css">
        #PageContent {
            overflow: auto;
            margin: 0px 0px 0px 10px;
        }

        .infobar {
            margin-left: 0px !important;
        }
    </style>
    <asp:Literal ID="litImagesFolderName" runat="server" />
    <asp:Literal ID="litScript" runat="server" />
    <script language="javascript" type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () { return save(false); };
        page.saveAndClose = function () { return save(true); };

        function save(close) {
            var o = new overlay('saveOverlay');
            o.show();
            var url = "/Admin/Module/IntegrationV2/LiveIntegration/LiveIntegrationAddInSettings.aspx?Save=True";
            if (close)
                url += "&Close=True";
            $("MainForm").action = url;
            $("MainForm").submit();
        }

        /**
         * @brief Wait for something to be ready before triggering a timeout
         * @param {callback} isready Function which returns true when the thing we're waiting for has happened
         * @param {callback} success Function to call when the thing is ready         
         * @param {int} count Number of times to retry the timeout (default 300 or 6s)
         * @param {int} interval Number of milliseconds to wait between attempts (default 20ms)
         */
        function waitUntil(isready, success, count, interval) {
            if (count === undefined) {
                count = 300;
            }
            if (interval === undefined) {
                interval = 20;
            }
            if (isready()) {
                success();
                return;
            }
            // The call back isn't ready. We need to wait for it
            setTimeout(function () {
                if (count) {
                    // Try again
                    waitUntil(isready, success, count - 1, interval);
                }
            }, interval);
        }

        function changeElementType() {
            var el = document.getElementById("Security_key");
            if (el != null) {
                el.type = "password";
            }
        }

        function onload() {
            waitUntil(function () { var el = document.getElementById("Security_key"); return el != null; }, function () { changeElementType() }, 1200, 100);
        }
    </script>
</head>
<body onload="onload();">
    <form id="MainForm" runat="server" action="LiveIntegrationAddInSettings.aspx" name="frmGlobalSettings">
        <input id="hiddenSource" type="hidden" name="_source" value="ManagementCenter" />
        <input id="hiddenCheckboxNames" type="hidden" name="CheckboxNames" />
        <dw:Overlay ID="saveOverlay" Message="Please wait" runat="server"></dw:Overlay>
        <div id="divToolbar" style="height: auto; min-width: 600px;">
            <dw:Toolbar ID="Buttons" runat="server" ShowEnd="false">
                <dw:ToolbarButton ID="cmdSave" runat="server" Divide="None" Icon="Save" Text="Save" OnClientClick="SettingsPage.getInstance().save();" ShowWait="False">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="cmdSaveAndClose" runat="server" Divide="None" Icon="Save" Text="Save and close" OnClientClick="SettingsPage.getInstance().saveAndClose();" ShowWait="False">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="cmdCancel" runat="server" Divide="None" Icon="TimesCircle" Text="Cancel" OnClientClick="SettingsPage.getInstance().cancel()" ShowWait="True">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="showHistoryLog" runat="server" Divide="None" Icon="EventNote" Text="Show log">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="downloadLog" runat="server" Divide="None" Icon="Download" Text="Download log">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="cmdTestConnection" runat="server" Divide="None" Icon="user" IconColor="Users" Text="Test connection" OnClientClick="window.location.href = '/Admin/Module/IntegrationV2/TestConnection.aspx';">
                </dw:ToolbarButton>
                <dw:ToolbarButton ID="cmdHelp" runat="server" Divide="None" Icon="Help" Text="Help" OnClientClick="SettingsPage.getInstance().help();">
                </dw:ToolbarButton>
            </dw:Toolbar>
        </div>

        <div id="PageContent">
            <dw:GroupBox ID="GroupBox1" runat="server" Title="Live Integration Add-In Settings" DoTranslation="true">
                <asp:Literal ID="checkWebServiceConnectionStatus" runat="server"></asp:Literal>
                <asp:Literal ID="addInSelectorScripts" runat="server"></asp:Literal>
                <de:AddInSelector ID="addInSelector" runat="server" UseLabelAsName="True" AddInShowNothingSelected="false"
                    AddInTypeName="Dynamicweb.Ecommerce.Integration.BaseLiveIntegrationAddIn" AddInShowSelector="false" AddInShowFieldset="false" />
                <asp:Literal ID="addInSelectorLoadScript" runat="server"></asp:Literal>
            </dw:GroupBox>
        </div>

        <dw:Dialog ID="HistoryLogDialog" runat="server" Title="Live Integration add-in log" HidePadding="true" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
            <iframe id="HistoryLogDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>

        <% 
            Translate.GetEditOnlineScript()
        %>
    </form>
</body>
<script type="text/javascript">
    SettingsPage.getInstance().initialize();
</script>
</html>
