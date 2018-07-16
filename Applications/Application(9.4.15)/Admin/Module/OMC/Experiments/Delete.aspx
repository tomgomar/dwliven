<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Delete.aspx.vb" Inherits="Dynamicweb.Admin.Delete1" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>

<%@ Import Namespace="Dynamicweb.Core" %>
<!DOCTYPE html>

<html>
<head runat="server">
    <dw:ControlResources ID="ControlResources1" runat="server" IncludeUIStylesheet="true" IncludePrototype="false" />
    <title></title>
    <link rel="StyleSheet" href="Setup.css" type="text/css" />
    <script type="text/javascript" src="/Admin/Resources/js/layout/dwglobal.js"></script>
    <script type="text/javascript" src="/Admin/Resources/js/layout/Actions.js"></script>
    <script type="text/javascript">

        function deleteExperiment() {
            var o = new overlay('forward');
            o.show();
            if (!document.getElementById("deleteConfirm").checked) {
                alert('<%= Dynamicweb.SystemTools.Translate.Translate("Please confirm to delete this split test.")%>');
                o.hide();
                return false;
            }
            document.getElementById("deleteForm").submit();
        }

        function close() {
            <%If (Not Converter.toBoolean(Dynamicweb.Context.Current.Request("FromOMC")))%>
            var reloadLocation = parent.location.toString().replace("#", "");
            if (reloadLocation.indexOf("omc") < 0) {
                if (reloadLocation.indexOf("?") < 0) {
                    reloadLocation += "?omc=true";
                }
                else {
                    reloadLocation += "&omc=true";
                }
                if (reloadLocation.indexOf("NavigatorSync") < 0) {
                    reloadLocation += "&NavigatorSync=refreshandselectpage";
                }
            }
            parent.location = reloadLocation;
            <% Else %>
            <%=GetRefreshContentAreaAction()%>            
            parent.location.reload();
            <% End If %>
        }
    </script>
</head>
<body>
    <dw:Overlay ID="forward" Message="Please wait" runat="server">
    </dw:Overlay>
    <div runat="server" id="closeJs" visible="false">
        <script type="text/javascript">
            close();
        </script>
    </div>
    <form id="deleteForm" runat="server" action="Delete.aspx" method="post">
        <input type="hidden" runat="server" id="id" name="id" />
        <input type="hidden" id="FromOMC" name="FromOMC" value="<%=Converter.toBoolean(Dynamicweb.Context.Current.Request("FromOMC"))%>" />
        <div id="step1Delete">
            <div class="mainArea">
                <div class="option2">
                    <img src="/Admin/Images/Ribbon/Icons/media_stop_red.png" />
                    <b><%= Dynamicweb.SystemTools.Translate.Translate("Stop experiment?")%></b>
                    <ul>
                        <li><%= Dynamicweb.SystemTools.Translate.Translate("All data on visitors and conversions will be deleted.")%></li>
                        <li><%= Dynamicweb.SystemTools.Translate.Translate("Disable the split test instead if data is still needed.")%></li>
                    </ul>
                    <input type="checkbox" id="deleteConfirm" />
                    <label for="deleteConfirm"><%= Dynamicweb.SystemTools.Translate.Translate("Yes, stop this split test!")%></label><br />
                    <br />
                    <div id="optionsDiv" name="optionsDiv" runat="server">
                        <b><%= Dynamicweb.SystemTools.Translate.Translate("What do you want to do with your test variations?")%></b><br />
                        <dw:RadioButton ID="WhatToKeepAll" runat="server" FieldName="WhatToKeep" FieldValue="All" SelectedFieldValue="All" />
                        <label for="WhatToKeepAll"><%= Dynamicweb.SystemTools.Translate.Translate("Keep all versions, with original published")%></label><br />
                        <dw:RadioButton ID="WhatToKeep1" runat="server" FieldName="WhatToKeep" FieldValue="1" />
                        <label for="WhatToKeep1"><%= Dynamicweb.SystemTools.Translate.Translate("Keep original and delete variation")%></label><br />
                        <dw:RadioButton ID="WhatToKeep2" runat="server" FieldName="WhatToKeep" FieldValue="2" />
                        <label for="WhatToKeep2"><%= Dynamicweb.SystemTools.Translate.Translate("Keep variation and delete original")%></label><br />
                        <dw:RadioButton ID="WhatToKeep3" runat="server" FieldName="WhatToKeep" FieldValue="Best" />
                        <label for="WhatToKeepBest"><%= Dynamicweb.SystemTools.Translate.Translate("Keep the best performing version and delete the other")%></label><br />
                    </div>
                </div>
            </div>
            <div class="footer">
                <input type="button" value="OK" id="Button1" onclick="deleteExperiment();" />
            </div>
        </div>
    </form>
</body>
<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</html>
