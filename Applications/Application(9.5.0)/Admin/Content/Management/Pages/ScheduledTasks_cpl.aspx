<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ScheduledTasks_cpl.aspx.vb" Inherits="Dynamicweb.Admin.ScheduledTasks_cpl" %>

<%@ Register TagPrefix="management" TagName="ImpersonationDialog" Src="/Admin/Content/Management/ImpersonationDialog/ImpersonationDialog.ascx" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
    <!-- Default ScriptLib-->
    <dwc:ScriptLib runat="server" ID="ScriptLib1">
        <!-- Needed non-default scripts -->
        <script src="/Admin/Content/JsLib/dw/Utilities.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Toolbar/Toolbar.js" type="text/javascript"></script>
        <script src="/Admin/Content/JsLib/dw/Ajax.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/List/List.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/WaterMark.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" type="text/javascript"></script>
        <script src="/Admin/Filemanager/Upload/js/EventsManager.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Overlay/Overlay.js" type="text/javascript"></script>
        <script src="/Admin/Content/Management/ImpersonationDialog/ImpersonationDialog.js" type="text/javascript"></script>
        <script src="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" type="text/javascript"></script>
        <!-- Page specific scripts -->
        <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    </dwc:ScriptLib>

    <style type="text/css">
        @media (max-width: 800px) {
            .hide-when-w3 {
                display: none !important;
            }
        }

        @media (max-width: 970px) {
            .hide-when-w1 {
                display: none !important;
            }
        }

        @media (max-width: 1100px) {
            .hide-when-w2 {
                display: none !important;
            }
        }

        .list .dis td {
            background-color: transparent;
            opacity: 0.4;
            color: Gray;
            border-bottom-color: #e0e0e0 !important;
        }
    </style>

    <script>
        var ScheduledTask = {
            openEditForm: function (taskId) {
                Action.Execute({
                    Name: "OpenScreen",
                    Url: "ScheduledTask_Edit.aspx?IsIntegretionFrameworkBanchLocation=<%=IsIntegretionFrameworkBanchLocation%>&id=" + taskId
                });
            },
            copyTask: function () {
                var taskId = ContextMenu.callingID;
                if (taskId != null) {
                    MainForm.action = 'ScheduledTasks_cpl.aspx?action=Copy&taskId=' + taskId;
                    MainForm.submit();
                }
            }
        }

        function onContextMenuSelectView(sender, args) {
            var ret = ['taskCopyButton'];
            var row = List.getRowByID('lstTasks', ContextMenu.callingID);
            if (row && row.readAttribute('__showLog') == 'true') {
                ret.push('addInLogButton');
            }
            return ret;
        }

        function showWait() {
            var o = new overlay('wait');
            o.show();
        }

        function showLogs(caller, logFileFolder) {
            if (logFileFolder && caller) {
                dialog.show('HistoryLogDialog', "/Admin/Module/IntegrationV2/historyList.aspx?logFileFolder=" + logFileFolder + "&jobName=" + caller);
            }
        }
    </script>

</head>
<body class="area-blue">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" ID="lbSetup" Title="Scheduled tasks"></dwc:CardHeader>

                <dw:Toolbar ID="Toolbar1" runat="server" ShowEnd="false" ShowAsRibbon="true">
                    <dw:ToolbarButton ID="cmdAdd" runat="server" Disabled="true" Divide="None" Icon="PlusSquare" Text="Add" OnClientClick="ScheduledTask.openEditForm()" />
                    <dw:ToolbarButton ID="cmdImpersonate" runat="server" Divide="Before" Icon="User" Text="Impersonation" />
                </dw:Toolbar>
                <dw:Infobar runat="server" ID="pNoAccess" Type="Warning" TranslateMessage="true" Message="Du har ikke de nødvendige rettigheder til denne funktion." />
                <asp:Panel ID="pHasAccess" runat="server">
                    <dw:Infobar ID="infWarning" runat="server" Type="Warning" Visible="False" Message="In the NLB setup, all operations should be performed only on the main server."></dw:Infobar>
                    <dw:Infobar ID="infoResult" Visible="false" runat="server" />
                    <dw:Infobar ID="infoWindowsScheduler" Type="Warning" Visible="false" runat="server" TranslateMessage="false" />
                    <dw:List ID="lstTasks" ShowPaging="true" NoItemsMessage="No scheduled tasks found" ShowTitle="false" runat="server" PageSize="25">
                        <Columns>
                            <dw:ListColumn ID="colTaskIcon" runat="server" />
                            <dw:ListColumn ID="colTaskName" Name="Task name" runat="server" />
                            <dw:ListColumn ID="colRunNow" Name="Run now" Width="30" runat="server" ItemAlign="Center" CssClass="pointer" />
                            <dw:ListColumn ID="colSchedule" Name="Schedule" runat="server" CssClass="hide-when-w3" />
                            <dw:ListColumn ID="colLastRun" Name="Last run" runat="server" CssClass="hide-when-w1" />
                            <dw:ListColumn ID="colNextRun" Name="Next run" runat="server" CssClass="hide-when-w2" />
                            <dw:ListColumn ID="colActive" Name="Active" Width="30" runat="server" ItemAlign="Center" CssClass="pointer" />
                            <dw:ListColumn ID="colRemove" Name="Remove" Width="30" runat="server" ItemAlign="Center" CssClass="pointer" />
                        </Columns>
                    </dw:List>
                    <management:ImpersonationDialog ID="dlgImpersonation" runat="server" />
                </asp:Panel>
            </dwc:Card>
        </form>
    </div>
    <dw:Dialog ID="HistoryLogDialog" runat="server" Title="Scheduled add-in task log" HidePadding="true" Width="600" ShowOkButton="false" ShowCancelButton="false" ShowClose="true">
        <iframe id="HistoryLogDialogFrame" frameborder="0"></iframe>
    </dw:Dialog>

    <dw:ContextMenu runat="server" ID="lstTasksContextMenu" OnClientSelectView="onContextMenuSelectView">
        <dw:ContextMenuButton runat="server" Views="default,showLog" ID="taskCopyButton" Text="Copy" Icon="Copy" OnClientClick="ScheduledTask.copyTask()">
        </dw:ContextMenuButton>
        <dw:ContextMenuButton runat="server" Views="showLog" ID="addInLogButton" Text="Log" Icon="InfoCircle">
        </dw:ContextMenuButton>
    </dw:ContextMenu>

    <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
    </dw:Overlay>
</body>

<%Translate.GetEditOnlineScript()%>
</html>
