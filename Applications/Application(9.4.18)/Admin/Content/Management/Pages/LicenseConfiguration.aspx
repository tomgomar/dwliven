<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="LicenseConfiguration.aspx.vb" Inherits="Dynamicweb.Admin.LicenseConfiguration" EnableEventValidation="false" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %><%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <dwc:ScriptLib runat="server" ID="ScriptLib1"></dwc:ScriptLib>

    <script type="text/javascript">
        var prevLicenseName = "";
        function save(cmd) {
            var confirmMsg = "<%=Translate.JsTranslate("Your changes will now be saved. After re-login your solution will be configured as you have selected and an invoice will be sent to you - for any questions please contant your sales representative.")%>";
            if (confirm(confirmMsg)) {
                $('cmd').value = cmd;
                $('form1').submit();
            } else {
                return false;
            }
        }

        function cancel() {
            window.location = "/Admin/Blank.aspx";
        }

        function onChangeLicense(radio) {
            var licenseName = radio.value;

            if (licenseName == "Professional_NOTANYMORE") {
                $("UpgradeProducts").disabled = false;
            } else {
                $("UpgradeProducts").disabled = true;
                $("UpgradeProducts").checked = false;
            }

            var select = document.getElementById("drEmailMarketingSubscribers");
            if (select.selectedIndex == 0 && (licenseName == "Free" || licenseName == "Express" || licenseName == "Standard")) {
                select.options[select.selectedIndex].value = "250";
            } else if (select.selectedIndex == 0) {
                select.options[select.selectedIndex].value = "500";
            }

            if (licenseName == "Free" || licenseName == "Express" || licenseName == "Standard") {
                $("PersonalizationLicense").checked = false;
                $("PersonalizationLicense").disabled = true;
                $("drAdditionalWebsites").disabled = false;
                $("drExtraShops").disabled = true;
                $("drIntegrationFW").disabled = true;
                $("drExtraShops").value = "0";
                $("drIntegrationFW").value = "0";
            } else if (licenseName == "Professional" || licenseName == "Premium" || licenseName == "Corporate") {
                $("PersonalizationLicense").disabled = false;
                if (prevLicenseName != "Professional" && prevLicenseName != "Premium" && prevLicenseName != "Corporate") {
                    $("PersonalizationLicense").checked = false;
                }
                $("drAdditionalWebsites").disabled = true;
                $("drExtraShops").disabled = false;
                $("drIntegrationFW").disabled = false;
            } else if (licenseName == "Enterprise") {
                $("PersonalizationLicense").disabled = true;
                $("PersonalizationLicense").checked = true;
                $("drAdditionalWebsites").disabled = true;
                $("drExtraShops").disabled = true;
                $("drIntegrationFW").disabled = false;
            }

            prevLicenseName = licenseName;
        }

        function insertParam(key, value) {
            key = encodeURI(key); value = encodeURI(value);

            var kvp = document.location.search.substr(1).split('&');

            var i = kvp.length; var x; while (i--) {
                x = kvp[i].split('=');

                if (x[0] == key) {
                    x[1] = value;
                    kvp[i] = x.join('=');
                    break;
                }
            }

            if (i < 0) { kvp[kvp.length] = [key, value].join('='); }

            //this will reload the page, it's likely better to store this until finished
            document.location.search = kvp.join('&');
        }   

        document.observe('dom:loaded', function () {
            var licenses = document.getElementsByName('LicenseSelect');
            for (var i = 0; i < licenses.length; i++) {
                if (licenses[i].checked == true) {
                    prevLicenseName = licenses[i].value;
                    onChangeLicense(licenses[i]);
                    break;
                }
            }
        });
    </script>
</head>

<body class="area-blue">
    <div class="dw8-container">
        <dwc:Card runat="server">
            <dwc:CardHeader runat="server" Title="License configuration" />



            <dwc:CardBody runat="server">
                            <dw:Infobar ID="TrialWarning" runat="server" Type="Information" Visible="False" Message="You are currently running on a trial. It's not possible to configure a trial. Please contact your partner"></dw:Infobar>
            <dwc:Button ID="RefreshLicenseBtn" runat="server" Title="Renew trial" Visible="False"/>
            <dwc:Button ID="SetupLicenseBtn" runat="server" Title="Setup License" Visible="False"/>
                <form id="form1" runat="server">
                    <input type="hidden" id="cmd" name="cmd" value="" />
                    <dwc:GroupBox ID="gbLicense" runat="server" Title="License">
                        <dw:List ID="lstLicense" ShowPaging="false" NoItemsMessage="" ShowTitle="false" ShowCollapseButton="false" runat="server">
                        </dw:List>
                    </dwc:GroupBox>

                    <dwc:GroupBox ID="gbAddOns" runat="server" Title="Add-ons">
                        <asp:Repeater ID="AddonRepeater" runat="server" EnableViewState="false">
                                <ItemTemplate>
                                    <dwc:CheckBox runat="server" Name='<%# Eval("Number") %>' Label='<%# Eval("Name") %>' Value='<%# Eval("Number") %>' Checked='<%# Eval("Checked") %>' Disabled='<%# Eval("Disabled") %>' DoTranslate="False" ></dwc:CheckBox>
                                </ItemTemplate>
                            </asp:Repeater>
                    </dwc:GroupBox>

                    <dwc:ActionBar runat="server">
                        <dw:ToolbarButton runat="server" Text="Gem" Size="Small" Image="NoImage" OnClientClick="return save('cmdSave');" ID="cmdSave" ShowWait="true" WaitTimeout="500" KeyboardShortcut="ctrl+s">
                        </dw:ToolbarButton>
                        <dw:ToolbarButton runat="server" Text="Gem og luk" Size="Small" Image="NoImage" OnClientClick="return save('cmdSaveAndClose');" ID="cmdSaveAndClose" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                        <dw:ToolbarButton runat="server" Text="Annuller" Size="Small" Image="NoImage" OnClientClick="cancel();" ID="cmdCancel" ShowWait="true" WaitTimeout="500">
                        </dw:ToolbarButton>
                    </dwc:ActionBar>
                </form>
            </dwc:CardBody>
        </dwc:Card>
    </div>
    <% Translate.GetEditOnlineScript() %>
        <script type="text/javascript">
            (function () {
                var refreshButton = document.getElementById('<%= RefreshLicenseBtn.ClientID%>');
                var setupButton = document.getElementById('<%= SetupLicenseBtn.ClientID%>');
                refreshButton.onclick = function () {
                    insertParam("RefreshLicense", "true");
                };
                setupButton.onclick = function () {
                    insertParam("SetupLicense", "true");
                };
            })();
    </script>
</body>
</html>
