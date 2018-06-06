<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="historyList.aspx.vb" Inherits="Dynamicweb.Admin.historyList" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<!DOCTYPE html>
<html>
<head id="Head1" runat="server">

    <script type="text/javascript">
        function GotoToList() {
            document.getElementById('opType').value = 'GotoToList';
            document.getElementById('historyListForm').submit();
        }
        function GotoToConfig() {
            document.getElementById('opType').value = 'GotoToConfig';
            document.getElementById('historyListForm').submit();
        }

        function SaveLastActive() {
            document.getElementById('tabActive').value = 1;
            SetActiveTab(1);
        }

        function SaveHistoryActive() {
            document.getElementById('tabActive').value = 2;
            SetActiveTab(2);
        }

        function SetActiveTab(activeID) {
            for (var i = 1; i < 15; i++) {
                if (document.getElementById("Tab" + i)) {
                    document.getElementById("Tab" + i).style.display = "none";
                }
                if (document.getElementById("Tab" + i + "_head")) {
                    document.getElementById("Tab" + i + "_head").className = "";
                }

            }
            if (document.getElementById("Tab" + activeID)) {
                document.getElementById("Tab" + activeID).style.display = "";
            }
            if (document.getElementById("Tab" + activeID + "_head")) {
                document.getElementById("Tab" + activeID + "_head").className = "activeitem";
            }
        }
    </script>

    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server" IncludeUIStylesheet="true" IncludePrototype="true">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/DwSimple.min.js" />
        </Items>
    </dw:ControlResources>
    <link rel="StyleSheet" href="/Admin/Module/IntegrationV2/css/DoMapping.css" type="text/css" />
    <style>
        .title {
            padding: 6px 16px;
            color: #616161;
        }

        .listRow td {
            max-width: initial !important;
        }
    </style>
</head>
<body>
    <div class="screen-container">
        <form id="historyListForm" runat="server">
            <input type="hidden" name="jobName" id="jobName" value="<%=Request("jobName")%>" />
            <input type="hidden" name="opType" id="opType" value="1" />
            <input type="hidden" name="tabActive" id="tabActive" value="<%=Request("tabActive")%>" />
            <dwc:Card ID="output" runat="server">
                <%If Request("logType") = "live" AndAlso Request("hideConfiguration") <> "true" Then%>

                <dw:Toolbar ID="historyListBar" runat="server" ShowStart="False" ShowEnd="False">
                    <dw:ToolbarButton ID="historyBarOkButton" runat="server" Text="OK" OnClientClick="GotoToList();" Icon="Check">
                    </dw:ToolbarButton>
                    <dw:ToolbarButton ID="historyBarReconfBtn" runat="server" Text="Reconfigure" OnClientClick="GotoToConfig();" Icon="cog">
                    </dw:ToolbarButton>
                </dw:Toolbar>
                <%ElseIf Request("logType") = "live" Then%>
                <dw:Toolbar ID="Toolbar1" runat="server" ShowStart="False" ShowEnd="False">
                    <dw:ToolbarButton ID="ToolbarButton1" runat="server" Text="OK" OnClientClick="GotoToList();" Icon="Check">
                    </dw:ToolbarButton>
                </dw:Toolbar>
                <%Else%>
                <dw:TabHeader ID="logTabs" ReturnWhat="all" runat="server" Tabs="Last" />
                <%End If%>
                <div id="refreshArea">
                    <input type="hidden" id="continueRefresh" runat="server" value="true" />
                    <div id="Tab1">
                        <dw:List ID="lastCtrl" runat="server" ShowTitle="False" TranslateTitle="False" PageSize="25" UseCountForPaging="true" HandlePagingManually="true">
                            <Columns>
                                <dw:ListColumn ID="clmLastTime" runat="server" Name="Time" EnableSorting="True" Width="170"></dw:ListColumn>
                                <dw:ListColumn ID="clmLastMessage" runat="server" Name="Message" WidthPercent="100"></dw:ListColumn>
                            </Columns>
                        </dw:List>
                    </div>
                    <div id="Tab2" style="display: none;">
                        <dw:List ID="historyCtrl" runat="server" ShowTitle="False" TranslateTitle="False" PageSize="25" UseCountForPaging="true" HandlePagingManually="true">
                            <Columns>
                                <dw:ListColumn ID="clmHistoryTime" runat="server" Name="Time" EnableSorting="True" Width="170"></dw:ListColumn>
                                <dw:ListColumn ID="clmHistoryMessage" runat="server" Name="Message"></dw:ListColumn>
                            </Columns>
                        </dw:List>
                    </div>
                    <dw:Infobar runat="server" Visible="false" ID="logFilesWarning" TranslateMessage="true" UseInlineStyles="true" Message="Showing the 5 newest logs. Older logs can be found in the file archive"></dw:Infobar>
                </div>
            </dwc:Card>
        </form>
    </div>
    <%If Request("logType") = "live" Then%>
    <script type="text/javascript">
        //This JS refreshes the logging information until the logfile is finished, at which point the loop is terminated.
        var refreshIntervalId = null;
        function stopEndlessLoop(doc) {
            if (doc.getElementById("continueRefresh").value == "false" && refreshIntervalId !== null) {
                clearInterval(refreshIntervalId);
            }
        }
        if (document.getElementById("continueRefresh").value == "true") {
            refreshIntervalId = setInterval(function () {
                reloadElement("refreshArea", stopEndlessLoop);
            }, 2000);
        }
    </script>
    <%End If%>
</body>
<%Translate.GetEditOnlineScript()%>
</html>
