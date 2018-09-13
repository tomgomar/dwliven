<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="LicenseConfiguration_cpl.aspx.vb" Inherits="Dynamicweb.Admin.LicenseConfiguration_cpl" EnableEventValidation="false" %>

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
                <form id="form1" runat="server">
                    <input type="hidden" id="cmd" name="cmd" value="" />
                    <dwc:GroupBox ID="gbLicense" runat="server" Title="License">
                        <dw:List ID="lstLicense" ShowPaging="false" NoItemsMessage="" ShowTitle="false" ShowCollapseButton="false" runat="server">
                            <Columns>
                                <dw:ListColumn ID="colNames" Name="" Width="250" runat="server" TranslateName="false" />
                                <dw:ListColumn ID="colFree" Name="Free" Width="100" runat="server" HeaderAlign="Center" ItemAlign="Center" TranslateName="false" />
                                <dw:ListColumn ID="colExpress" Name="Express" Width="100" runat="server" HeaderAlign="Center" ItemAlign="Center" TranslateName="false" />
                                <dw:ListColumn ID="colStandard" Name="Standard" Width="100" runat="server" HeaderAlign="Center" ItemAlign="Center" TranslateName="false" />
                                <dw:ListColumn ID="colMarketing" Name="Marketing" Width="100" runat="server" HeaderAlign="Center" ItemAlign="Center" TranslateName="false" />
                                <dw:ListColumn ID="colProfessional" Name="Professional" Width="100" runat="server" HeaderAlign="Center" ItemAlign="Center" TranslateName="false" />
                                <dw:ListColumn ID="colBusiness" Name="Business" Width="100" runat="server" HeaderAlign="Center" ItemAlign="Center" TranslateName="false" />
                                <dw:ListColumn ID="colPremium" Name="Premium" Width="100" runat="server" HeaderAlign="Center" ItemAlign="Center" TranslateName="false" />
                                <dw:ListColumn ID="colEnterprise" Name="Enterprise" Width="100" runat="server" HeaderAlign="Center" ItemAlign="Center" TranslateName="false" />
                            </Columns>
                        </dw:List>
                    </dwc:GroupBox>

                    <dwc:GroupBox ID="gbAddOns" runat="server" Title="Add-ons">
                        <div class="form-group">
                            <label class="control-label" for="drAdditionalWebsites"><%=Translate.Translate("Additional websites/languages")%></label>
                            <asp:DropDownList CssClass="selectpicker" runat="server" ID="drAdditionalWebsites" ClientIDMode="Static" />
                        </div>

                        <div class="form-group">
                            <label class="control-label" for="drExtraShops"><%=Translate.Translate("Extra Ecommerce shops")%></label>
                            <asp:DropDownList CssClass="selectpicker" runat="server" ID="drExtraShops" ClientIDMode="Static" />
                        </div>

                        <div class="form-group">
                            <label class="control-label" for="drIntegrationFW"><%=Translate.Translate("Integration Framwork license")%></label>
                            <asp:DropDownList runat="server" ID="drIntegrationFW" CssClass="selectpicker" ClientIDMode="Static" />
                        </div>

                        <dwc:Checkbox runat="server" name="PersonalizationLicense" id="PersonalizationLicense" value="1" label="Personalization license" />
                        <dwc:Checkbox runat="server" name="UpgradeProducts" id="UpgradeProducts" value="1" label="Upgrade to 5.000 products" />
   
                        <div class="form-group">
                            <label class="control-label" for="drEmailMarketingSubscribers"><%=Translate.Translate("Email Marketing subscribers")%></label>
                            <asp:DropDownList CssClass="selectpicker" runat="server" ID="drEmailMarketingSubscribers" ClientIDMode="Static" />
                        </div>

                        <div class="form-group">
                            <label class="control-label" for="drEmailMarketingSubscribers"><%=Translate.Translate("Currently in DB:")%></label>
                            <asp:Literal ID="emailAllowedUsersCount" runat="server"></asp:Literal>
                        </div>

                        <dwc:Checkbox runat="server" name="StagingTestLicense" id="StagingTestLicense" value="1" label="Staging/Test license" />
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
</body>
</html>
