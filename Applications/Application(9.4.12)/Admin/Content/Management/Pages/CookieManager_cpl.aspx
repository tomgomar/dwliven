<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" CodeBehind="CookieManager_cpl.aspx.vb" Inherits="Dynamicweb.Admin.CookieManager_cpl" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Register Assembly="Dynamicweb.Controls" Namespace="Dynamicweb.Controls" TagPrefix="dw" %>
<%@ Register Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" TagPrefix="dwc" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/FileManager/FileManager_browse2.js"></script>
    <script src="/Admin/Images/SelectionBox/SelectionBox.js" type="text/javascript"></script>
    <asp:Literal ID="litScript" runat="server" />
    <asp:Literal ID="litImagesFolderName" runat="server" />

    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () { return save(false); };
        page.saveAndClose = function () { return save(true); };

        function save(close) {
            document.getElementById('CookiesSelectorValue').value = SelectionBox.getElementsRightAsArray('CookiesSelector');
            document.getElementById('SecureCookiesSelectorValue').value = SelectionBox.getElementsRightAsArray('SecureCookiesSelector');

            var url = "CookieManager_cpl.aspx?Save=true";
            if (close)
                url += "&Close=True";
            $("MainForm").action = url;
            $("MainForm").submit();
        }

        function addCustomCookie() {
            var list = document.getElementById("CookiesSelector_lstLeft");
            var secureList = document.getElementById("SecureCookiesSelector_lstLeft");
            var option = document.createElement("option");
            var value = document.getElementById('customCookieText').value;
            if (value != null && value != "") {
                option.text = value;
                document.getElementById('customCookieText').value = "";
                try {
                    // for IE earlier than version 8
                    list.add(option, list.options[null]);
                    secureList.add(option, list.options[null]);
                }
                catch (e) {
                    list.add(option, null);
                    secureList.add(option, null);
                }
            }
        }

        (function ($) {
            $(function () {
                var enableNotificationEl = $('input[type=radio][name=UserNotificationGroup]');
                var templateSelector = $('[name=templateContainer]');
                var showHide = function () {
                    if (this.value === 'rbWarnings') {
                        templateSelector.show();
                    } else {
                        templateSelector.hide();
                    }
                };
                enableNotificationEl.on("change", showHide);
            });
        })(jQuery);
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <div id="breadcrumb"></div>

        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="lbSetup" Title="Cookie Manager"></dwc:CardHeader>
        <dwc:CardBody runat="server">
            <input id="hiddenSource" type="hidden" name="_source" value="ManagementCenter" />
            <input id="hiddenCheckboxNames" type="hidden" name="CheckboxNames" />

            <dwc:GroupBox ID="GroupBox3" runat="server" Title="User notification" GroupWidth="6">

                <dwc:CheckBox Name="cbDisableTrackingCookies" ID="cbDisableTrackingCookies" Label="Enable cookie manager" runat="server" />

                <div style="display: none;">
                    <dwc:CheckBox Name="cbDeleteJsTrackingCookies" ID="cbDeleteJsTrackingCookies" Label="Delete js tracking cookies" runat="server" />
                </div>

                <div class="selection-box">
                    <dwc:RadioGroup runat="server" Name="UserNotificationGroup">
                        <dwc:RadioButton ID="rbWarnings" FieldValue="rbWarnings" Label="Template based warnings" runat="server" />
                        <dwc:RadioButton ID="rbCustomUserNotifications" FieldValue="rbCustomUserNotifications" Label="Custom (set with Javascript or .Net)" runat="server" />
                    </dwc:RadioGroup>
                </div>

                <div id="templateContainer" name="templateContainer" runat="server">                    
                    <dw:FileManager ID="templateSelector" runat="server" Label="Select template" FixFieldName="true" ShowPreview="false" Folder="Templates/CookieWarning" ShowNothingSelectedOption="False" />
                </div>                                    
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox1" runat="server" Title="Cookie deactivation">
                <dw:SelectionBox ID="CookiesSelector" runat="server" LeftHeader="All cookies" RightHeader="Selected cookies" Label="Tracking cookies" TranslateHeaders="true" Height="250" />
                <input type="hidden" name="CookiesSelectorValue" id="CookiesSelectorValue" value="" />

                <div class="form-group">
                    <label class="control-label" for="customCookieText"><%=Translate.Translate("Add custom cookie to list")%></label>
                    <div class=" input-group">
                        <input type="text" id="customCookieText" value="" class="form-control fg-input" />
                        <span class="input-group-addon">
                            <i id="editImage_templateSelector" class="fa fa-plus color-success" data-role="filemanager-button-edit" onclick="addCustomCookie();" border="0" align="absMiddle" alt="Add" style="cursor: pointer;" title="Add"></i>
                        </span>
                    </div>
                </div>

                <dwc:SelectPicker ID="drCookieLifetime" Label="Cookie lifetime" runat="server"></dwc:SelectPicker>

                <dwc:CheckBox Name="cbDisableHttpOnlyCookies" ID="cbDisableHttpOnlyCookies" Label="Disable httponly cookies" runat="server" />

                <dw:SelectionBox ID="SecureCookiesSelector" runat="server" LeftHeader="All cookies" RightHeader="Selected cookies" Label="Secure cookies" TranslateHeaders="true" Height="250" />
                <input type="hidden" name="SecureCookiesSelectorValue" id="SecureCookiesSelectorValue" value="" />
            </dwc:GroupBox>
            
            <asp:Literal ID="LoaderJavaScript" runat="server" />

            <dw:Overlay ID="wait" runat="server" Message="Please wait" ShowWaitAnimation="True">
            </dw:Overlay>
        </dwc:CardBody>
    </dwc:Card>
    <% Translate.GetEditOnlineScript() %>
</asp:Content>