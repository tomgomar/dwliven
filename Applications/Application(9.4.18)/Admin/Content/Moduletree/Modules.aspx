<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Modules.aspx.vb" Inherits="Dynamicweb.Admin.Moduletree.Modules" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.Ui.Controls" %>


<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0" />

    <dwc:ScriptLib runat="server" ID="ScriptLib1"></dwc:ScriptLib>

    <style type="text/css">
        .checkbox label > img, .radio label > img {
            margin-top: -6px;
            margin-right: 6px;
        }
        .checkbox i.fa, .checkbox i.md {
            width: 20px;
            margin-right: 3px;
            text-align: center;
        }
    </style>

    <script type="text/javascript">

        function validateForm() {
            var ret = false;
            var radioButtons = document.getElementsByName('SolutionSelectcms');

            if (radioButtons && radioButtons.length > 0) {
                for (var i = 0; i < radioButtons.length; i++) {
                    if (radioButtons[i].checked) {
                        ret = true;
                        break;
                    }
                }
            }

            if (!ret) {
                alert('<%=Translate.JsTranslate("Vælg Light, Business eller Portal.")%>');
            }

            return ret;
        }

        function save(cmd) {
            if (validateForm()) {
                if (confirm('<%=Translate.JsTranslate("Do you want to save changes?")%>')) {
                    $("cmd").value = cmd;
                    $("ModuleForm").submit();
                }
            }
            return false;
        }

        function cancel() {
            location = "/Admin/Blank.aspx";
        }

        function saveTabId(tab) {
            $("GotoTab").value = tab;
        }

        function changeSolutionVersion(typeID, solutionID) {
            new Ajax.Request('Modules.aspx?AJAX=ChangeSolution', {
                method: 'get',
                parameters: {
                    typeID: typeID,
                    solutionID: solutionID,
                    zzz: Math.random()
                },
                onSuccess: function (response) {
                    // Get values from response
                    var htmlObj = response.responseText;
                    $("Tab" + typeID).innerHTML = htmlObj;
                },

                onFailure: function () {
                    alert('Something went wrong!');
                },

                onComplete: function () {
                    // Hide the loading div again
                    //alert('Complete!');
                }
            });

            var el = null;
            switch (solutionID) {
                case "cmsProfessional2014":
                    el = document.getElementById("rdecomProfessional2014");
                    break;
                case "cmsPremium2014":
                    el = document.getElementById("rdecomPremium2014");
                    break;
                case "cmsCorporate2014":
                    el = document.getElementById("rdecomCorporate2014");
                    break;
                case "cmsEnterprise2014":
                    el = document.getElementById("rdecomEnterprise2014");
                    break;
            }
            if (el !== null) {
                el.checked = true;
                el.click();
            }

        }

        function selectAll(typeID) {
            if (confirm('<%=Translate.JsTranslate("Er du sikker på du vil installere alle moduler?")%>')) {
                var inputs = $$("#Tab" + typeID + " input");
                inputs.each(function (input) {
                    if (!input.disabled) input.checked = true;
                });
            }
        }

        (function($) {
            $(document).ready(function () {
                $('#DynamicwebModules').addClass('hidden');
            });
        })(jQuery);
    </script>
</head>
<body class="area-blue">
    <div class="dw8-container">
        <form id="ModuleForm" name="ModuleForm" runat="server">
            <input name="GotoTab" id="GotoTab" type="hidden" />
            <input name="cmd" id="cmd" type="hidden" />
            <dwc:BlockHeader runat="server" ID="Blockheader">
                <ol class="breadcrumb">
                    <li><a href="#">Settings</a></li>
                    <li><a href="#">System</a></li>
                    <li class="active"><%= Translate.Translate("Modules") %></li>
                </ol>
            </dwc:BlockHeader>

            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Modules" />

                <ul class="tab-nav" data-tab-color="green">
                    <%= RenderTabHeaders() %>
                </ul>
                <dwc:CardBody runat="server">
                    <div class="tab-content">
                        <%= RenderTabContents()%>
                    </div>
                </dwc:CardBody>
            </dwc:Card>

            <dwc:ActionBar runat="server">
                <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" OnClientClick="return save('cmdSave');" ID="cmdSave" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="return save('cmdSaveAndClose');" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
                <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="cancel(); return false;" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                </dw:ToolbarButton>
            </dwc:ActionBar>
        </form>
    </div>
</body>
<%  Translate.GetEditOnlineScript() %>
</html>
