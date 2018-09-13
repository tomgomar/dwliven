<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb" %>

<%@ Page CodeBehind="Access_User_SendMail.aspx.vb" Language="vb" ValidateRequest="false" AutoEventWireup="false" Inherits="Dynamicweb.Admin.Access_User_SendMail" CodePage="65001" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title><%=Translate.JsTranslate("Send %%", "%%", Translate.JsTranslate("brugeroplysninger"))%></title>
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="Cache-control" content="no-cache">
    <meta http-equiv="Cache-control" content="no-cache">
    <meta http-equiv="Expires" content="Tue, 20 Aug 1996 14:25:27 GMT">

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="True" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>

    <script type="text/javascript">
        var isRecoveryMode = "<%=IsRecoveryMode%>" === "True";

        function IsValidEmail(email) {
            var regExp = /^[\w\-_]+(\.[\w\-_]+)*@[\w\-_]+(\.[\w\-_]+)*\.[a-z]{2,4}$/i;
            return regExp.test(email);
        }

        function doNothing() {
        }

        function SendMailStep(submitForm) {
            var valid = true;
            var subjectControl = document.getElementById("Form1").elements["MailTemplateSubject"];
            if (subjectControl != null && subjectControl.value == "") {
                $("helpMailTemplateSubject").innerText = "<%=Translate.JsTranslate("required")%>";
                $("helpMailTemplateSubject").style.display = "block";
		        valid = false;
            } else {
                $("helpMailTemplateSubject").style.display = "hidden";
            }

            if (!IsValidEmail(document.forms[0].MailTemplateFromEmail.value)) {
                $("helpMailTemplateFromEmail").innerText = "<%=Translate.JsTranslate("required")%>";
                $("helpMailTemplateFromEmail").style.display = "block";
                valid = false;
            } else {
                $("helpMailTemplateFromEmail").style.display = "hidden";
            }

            var MailTemplateElem = document.getElementById("FM_MailTemplate");
            if (MailTemplateElem.value == "") {
                $("helpMailTemplate").innerText = "<%=Translate.JsTranslate("required")%>";
                $("helpMailTemplate").style.display = "block";
                valid = false;
            } else {
                $("helpMailTemplate").style.display = "hidden";
            }

            if (isRecoveryMode) {
                var mailPage = document.getElementById("RecoveryPage");
                var pageId = parseInt(mailPage.value.split("=")[1]);
                if (pageId == 0 || isNaN(pageId)) {
                    $("helpMailPage").innerText = "<%=Translate.JsTranslate("required")%>";
                    $("helpMailPage").style.display = "block";
                    valid = false;
                } else {
                    $("helpMailPage").style.display = "hidden";
                }
            }

            if (!valid) {
                return false;
            }

            if (submitForm == true) {
                document.forms[0].action = '';
                document.forms[0].submit();

                var dialogId = isRecoveryMode ? 'SendRecoveryMailDialog' : 'SendUserInfoDialog';
                parent.dialog.hide(dialogId);
            } else {
                document.location.href = "Access_User_SendMail.aspx?UserID=<%=UserIDReq%>" + isRecoveryMode ? "&MailMode=recovery" : "";
		    }
        }

        function doCancel() {
            var dialogId = isRecoveryMode ? 'SendRecoveryMailDialog' : 'SendUserInfoDialog';

            parent.dialog.hide(dialogId);
            parent.dialog.set_contentUrl(dialogId, '');
        }

        function disableSelectors(setting) {
            document.getElementById('FM_MailTemplate').disabled = setting;
            document.getElementById('MailTemplateEncoding').disabled = setting;
        }

        function checkDomain() {
            var mailPage = document.getElementById("RecoveryPage");
            var domainSelector = document.getElementById("RecoveryPageDomain");
            var pageId = parseInt(mailPage.value.split("=")[1]);
            var selectedDomain = domainSelector[domainSelector.selectedIndex].value;

            if (pageId > 0) {
                new Ajax.Request("Access_User_SendMail.aspx?CMD=CheckPrimaryDomain&SelectedDomain=" + selectedDomain + "&PageId=" + pageId, {
                    onSuccess: function (response) {
                        var div = $('divDomainErrorContainer');
                        var row = $('rowDomainErrorContainer');
                        if (response.responseText.length > 0) {
                            div.innerHTML = response.responseText;
                            row.show();
                        } else {
                            row.hide();
                        }
                    }
                });
            }
        }

        function initPage() {

        }
    </script>
</head>
<body onload="initPage();">

    <%--<%=Dynamicweb.SystemTools.Gui.MakeHeaders("", Translate.Translate("Send %%", "%%", Translate.Translate("brugeroplysninger")), "")%>--%>
    <form id="Form1" method="post" runat="server" action="Access_User_SendMail.aspx">
        <dw:Infobar ID="NotValidEmailInfo" runat="server" Type="Error" Message="User email not valid" />
            <div id="TemplateSelector">
                <dw:GroupBox runat="server">
                    <table class="formsTable disableMedia">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Subject"></dw:TranslateLabel>
                            </td>
                            <td>
                                <dwc:InputText runat="server" ID="MailTemplateSubjectInput" Name="MailTemplateSubject" />
                                <small class="help-block error" id="helpMailTemplateSubject"></small>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Sender name"></dw:TranslateLabel>
                            </td>
                            <td>
                                <dwc:InputText runat="server" ID="MailTemplateFromNameInput" Name="MailTemplateFromName" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Sender e-mail"></dw:TranslateLabel>
                            </td>
                            <td>
                                <dwc:InputText runat="server" ID="MailTemplateFromEmailInput" Name="MailTemplateFromEmail" />
                                <small class="help-block error" id="helpMailTemplateFromEmail"></small>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Encoding"></dw:TranslateLabel>
                            </td>
                            <td>
                                <%=Gui.EncodingList(MailTemplateEncoding, "MailTemplateEncoding", True, False)%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:Label runat="server" ID="TemplateEmailLabel" doTranslation="false"></dw:Label>
                            </td>
                            <td>
                                <%=Gui.FileManager(MailTemplate, "Templates/ExtranetExtended", "MailTemplate")%>
                                <small class="help-block error" id="helpMailTemplate"></small>
                            </td>
                        </tr>
                        <%if IsRecoveryMode Then%>
                            <tr>
                                <td>
                                    <dw:TranslateLabel Text="Page" runat="server" />
                                </td>
                                <td>
                                    <dw:LinkManager ID="RecoveryPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" CssClass="std field-name" ClientAfterSelectCallback="checkDomain" />
                                    <small class="help-block error" id="helpMailPage"></small>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dw:TranslateLabel Text="Domain" runat="server" />
                                </td>
                                <td>
                                    <select runat="server" id="RecoveryPageDomain" class="std" name="RecoveryPageDomain" onchange="checkDomain();" ClientIDMode="Static">
                                    </select>
                                </td>
                            </tr>
                            <tr id="rowDomainErrorContainer" style="display: none;">
                                <td></td>
                                <td>
                                    <div id="divDomainErrorContainer" style="color: red;"></div>
                                </td>
                            </tr>
                        <%End If%>
                    </table>
            </dw:GroupBox>
        </div>
        <div class="cmd-pane-wrapper">
            <div class="cmd-pane">
                <button type="button" runat="server" id="SendButton" class="dialog-button-ok btn btn-clean" onclick="SendMailStep(true)"><dw:TranslateLabel Text="Send" runat="server" /></button>
                <button type="button" class="dialog-button-ok btn btn-clean" onclick="doCancel()"><dw:TranslateLabel Text="Cancel" runat="server" /></button>
            </div>
        </div>
    </form>
</body>
</html>
