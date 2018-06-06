<%@ Page MasterPageFile="/Admin/Content/Management/EntryContent.Master" Language="vb" AutoEventWireup="false" ClientIDMode="Static" CodeBehind="SecuritySetup_cpl.aspx.vb" Inherits="Dynamicweb.Admin.SecuritySetup_cpl" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Admin" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="/Admin/Validation.js"></script>

    <script type="text/javascript">
        var page = SettingsPage.getInstance();
        page.onSave = function () {
            var eml = document.getElementById("FormAntiSpamReportTo");
            if (IsEmailValid(eml,
			    "<%=Translate.JsTranslate("Ugyldig_værdi_i:_%%", "%%", Translate.JsTranslate("Send kopi til e-mail"))%>")) {
                page.submit();
            }
            return false;
        };

        (function($) {
            $(function () {
                $("#DisableSQLInjectionCheck").on("change", function() {
                    $("#SQLInjectionSkip").prop("disabled", $(this).is(":checked"));
                }).trigger("change");
            });
        })(jQuery);
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="HeaderContext" runat="server">
    <dwc:BlockHeader runat="server" ID="Blockheader">
        <ol class="breadcrumb">
            <li><a href="#">Settings</a></li>            
            <li><a href="#">Web and HTTP</a></li>
            <li class="active">Security</li>
        </ol>
        <ul class="actions">
            <li>
                <a class="icon-pop" href="javascript:SettingsPage.getInstance().help();"><i class="md md-help"></i></a>
            </li>
        </ul>
    </dwc:BlockHeader>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dwc:CardHeader runat="server" ID="CardHeader" Title="Security" />
        <dwc:CardBody runat="server">
            <dwc:GroupBox ID="GroupBox1" Title="Formular" runat="server">
                <dwc:CheckBox runat="server" ID="FormAntiSpam" Name="/Globalsettings/System/Security/FormAntiSpam" Label="Aktiver antispam funktion" Info="Forms" />
                <dwc:CheckBox runat="server" ID="FormAntiSpamEnableForUserCreate" Name="/Globalsettings/System/Security/FormAntiSpamEnableForUserCreate" Label="Aktiver antispam funktion" Info="Users" />
                <dwc:InputText runat="server" ID="FormAntiSpamReportTo" Name="/Globalsettings/System/Security/FormAntiSpamReportTo" Label="Send kopi til e-mail" MaxLength="255" />
                <dwc:InputNumber runat="server" ID="FormAntiSpamMinSeconds" Name="/Globalsettings/System/Security/FormAntiSpamMinSeconds" Label="Seconds before post" MaxLength="3" Placeholder="2" />
                <dwc:InputNumber runat="server" ID="FormAntiSpamMaxIpSubmits" Name="/Globalsettings/System/Security/FormAntiSpamMaxIpSubmits" Label="Submits from same IP" MaxLength="3" Placeholder="15" />
                <dwc:CheckBox runat="server" ID="FormAntiSpamDisableExtended" Name="/Globalsettings/System/Security/FormAntiSpamDisableExtended" Label="Disable extended checks" />
                
            </dwc:GroupBox>

            <%If Session("DW_Admin_UserType") = 0 Or Session("DW_Admin_UserType") = 1 Or Session("DW_Admin_UserType") = 3 Then%>
            <dwc:GroupBox ID="GroupBox2" Title="Dynamicweb support" runat="server">
                <dwc:CheckBox runat="server" ID="AngelLocked" Name="/Globalsettings/System/Security/AngelLocked" Label="Restrict access for support users" />
            </dwc:GroupBox>
            <%End If%>
            <dwc:GroupBox ID="gbInjection" Title="SQL injection check" runat="server">
                <dwc:CheckBox runat="server" ID="DisableSQLInjectionCheck" Name="/Globalsettings/System/http/DisableSQLInjectionCheck" Label="Disable" />
                <dwc:InputTextArea runat="server" ID="SQLInjectionSkip" Name="/Globalsettings/System/Security/SQLInjectionSkip" Label="Ignore the following fields" Placeholder="Use comma to separate field names." />
                <dwc:CheckBox runat="server" ID="DoNotBanIps" Name="/Globalsettings/System/Security/DoNotBanIps" Label="Do not ban IPs" />
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox3" Title="SQL injection emails" runat="server">
                <dwc:InputTextArea runat="server" Name="/Globalsettings/System/Security/SQLInjectionEmailRecipients" Label="List of recipients" Placeholder="Use comma to separate email addresses." />
            </dwc:GroupBox>
            <% Translate.GetEditOnlineScript() %>
        </dwc:CardBody>
    </dwc:Card>
</asp:Content>
