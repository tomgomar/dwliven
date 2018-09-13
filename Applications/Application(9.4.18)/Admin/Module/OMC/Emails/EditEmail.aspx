<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/Marketing.Master" CodeBehind="EditEmail.aspx.vb" Inherits="Dynamicweb.Admin.OMC.Emails.EditEmail" %>

<%@ Import Namespace="Dynamicweb.EmailMarketing" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        function showHelp() {
            <%=Gui.Help("omc.email.list", "omc.email.list")%>
        }

        <% If Core.Converter.ToString(Dynamicweb.Context.Current.Request("NavigatorSync")).ToLower() = "selectnode" Then %>
        <%= Dynamicweb.Management.Marketing.Nodes.EmailMarketing.EmailNode.RefreshEmailListAction(Core.Converter.ToInt32(Request("folderId")), Core.Converter.ToInt32(TopFolderId), False).ToString() %>;
        <% End If %>
    </script>

    <script type="text/javascript">
        function getNewsletterName() {
            return $('txSubject').value;             
        }

        function getScheduledDate() {            
            var scheduledDate = "";
            if($('<%=dsStartDate.UniqueID%>_calendar') && Dynamicweb && Dynamicweb.UIControls && Dynamicweb.UIControls.DatePicker){
                scheduledDate = Dynamicweb.UIControls.DatePicker.get_current().GetDate('<%=dsStartDate.UniqueID%>');
            }
            return scheduledDate; 
        }

        function getConfirmText() {
            var confirmText= '<%=Translate.JsTranslate("The sending of e-mail")%>' + " '" + getNewsletterName() + "' " + '<%=Translate.JsTranslate(" will be scheduled for ")%>' + getScheduledDate() + '<%=Translate.JsTranslate(". Do you want to continue?")%>';
            return confirmText;
        }


        function showPreviewEmailDialog() {  
            var userId = $('PreviewEmailSelectorhidden').value;            
            if (userId) {
                var url = "/Admin/Module/OMC/Emails/EditEmail.aspx";
                var hasSplitTest = $('chkOriginal') ? true : false;
                    
                new Ajax.Request(url, {
                    method: 'get',
                    parameters: {
                        UserID: userId
                    },
                    onSuccess: function (transport) {
                        if(transport.responseText.length > 0) {
                            alert(transport.responseText);
                        } else {
                            window.open('/Admin/Module/OMC/Emails/PreviewMailPage.aspx?emailId=' + <%=EmailID%> + '&userId=' + userId + '&hasSplitTest=' + hasSplitTest, 'PreviewMailPopup', 'status=1,toolbar=0,menubar=0,resizable=1,directories=0,titlebar=0,modal=no');
                        }
                    }, 
                });
            } else {
                alert('<%=Translate.JsTranslate("Please select a user")%>');
            }
        }

        function getVariantPageId() {
            var pageUrl = $('lmVariantEmailPage').value;
            var pageId = pageUrl.split('=')[1];

            return pageId;
        }

        function execResponse(text) {
            if(!text && text != "") {
                eval(text);
            }
        }

        function disableInputsFields() {
            $('cbCreateSplitTestVariation').disable();
            $('<%=DomainSelector.ClientID%>').disable();
            $('RecipientAddinControlDiv').disabled =true;
            $('RecipientAddinControlDiv').select('img').each(function(element) {
                element.onclick = "";
            });
        }

        function OnRecipientsCountChanged(ids) {
            var el = $('lblTotalRecipientsValue');

            if(el != null) {
                var url = '/Admin/Module/OMC/Emails/EditEmail.aspx?newsletterId=<%=EmailID%>';

                new Ajax.Request(url, {
                    method: 'get',
                    parameters: {
                        OpType: 'OnRecipientsCountChanged',
                        IncludedIds: ids,
                        ExcludedIds: document.getElementById('RecipientsExcluded').value
                    },
                    onSuccess: function (transport) {
                        if(transport.responseText != null && transport.responseText.length > 0)
                            el.textContent = transport.responseText;
                        else
                            el.textContent = '0';
                    }
                });      
            }
        }

        function ShowRecipientsPopup() {
            <%=If(IsEmailSent(), "return;", String.Empty)%>
            var included = document.getElementById('<%=RecipientSelector.ID%>hidden').value;
            var excluded = document.getElementById('RecipientsExcluded').value;

            dwGlobal.marketing.showDialog(
                '/Admin/Module/OMC/Emails/RecipientsList.aspx?emailId=<%=EmailID%>&included=' + included + '&excluded=' + excluded, 
                950, 
                482, 
                { title: '<%=Translate.Translate("All recipients")%>', hideCancelButton: true },
                updateRecipients);
            }

        function OnAddEmailTagClosed() {
            var subj = $('<%=txSubject.ClientID%>');
            var list = $('<%=EmailTagsList.ClientID%>');
            var val = list.options[list.selectedIndex].value

            insertAtCaret(subj, val);
            dialog.hide('AddEmailTag');
        }

        function OnAddVarEmailTagClosed() {
            var subj = $('<%=txtVariantSubject.ClientID%>');
            var list = $('<%=Me.VarEmailTagsList.ClientID%>');
            var val = list.options[list.selectedIndex].value

            insertAtCaret(subj, val);
            dialog.hide('AddVarEmailTag');
        }

        function insertAtCaret(el, text) {
            if (document.selection) { 
                el.focus();
                sel = document.selection.createRange();
                sel.text = text;
                el.focus();
            } else if (el.selectionStart || el.selectionStart == '0') { 
                var startPos = el.selectionStart, endPos = el.selectionEnd, scrollTop = el.scrollTop;
                el.value = el.value.substring(0, startPos) + text + el.value.substring(endPos, el.value.length);
                el.focus();
                el.selectionStart = startPos + text.length;
                el.selectionEnd = startPos + text.length;
                el.scrollTop = scrollTop;
            } else {
                el.value += text;
                el.focus();
            }
        }

            function updateRecipients() {
                <%="UserSelector" + Me.RecipientSelector.ID%>.clearExcluded();
                var excluded = document.getElementById('RecipientsExcluded').value;
                var items = excluded.split(',');

                for(i = 0; i < items.length; i++)
                    <%="UserSelector" + Me.RecipientSelector.ID%>.excludeUser('u' + items[i]);   

                <%="UserSelector" + Me.RecipientSelector.ID%>.renderItems('', '');
                OnRecipientsCountChanged(document.getElementById('<%=Me.RecipientSelector.ID%>hidden').value);
            }

            function RenderRecipientControl() {
                var providerSelector = $('Dynamicweb.EmailMarketing.EmailRecipientProvider_AddInTypes');
                var provType = providerSelector.value;
                var providerName = providerSelector[providerSelector.selectedIndex].text;
                var translatedText = '<%=Translate.Translate("Using a custom recipient provider")%>: ';

                if(provType != '<%=GetType(RecipientProviders.AccessUserRecipientProvider).FullName%>') {
                    var customDiv;
                    customDiv = document.getElementById('CustomRecipientSelectorDiv');
                    customDiv.innerHTML = translatedText + '<a href="javascript:dialog.show(\'RecipientProviderDialog\')">' + providerName + '</a>';
                    customDiv.removeAttribute('style');

                    document.getElementById('RecipientAddinControlDiv').style.display = 'none';
                    var isEmailSent = eval('<%=_email.IsEmailSent()%>'.toLowerCase());
                if(isEmailSent) {
                    var addTagEl = document.getElementById("addTag");
                    if (addTagEl){
                        addTagEl.style.visibility = "hidden";
                    }
                    var addVarTagEl = document.getElementById("addVarTag");
                    if (addVarTagEl) {
                        addVarTagEl.style.visibility = "hidden";
                    }
                }
            } else {
                document.getElementById('RecipientAddinControlDiv').removeAttribute('style');
                document.getElementById('CustomRecipientSelectorDiv').style.display = 'none';
                var addTagEl = document.getElementById("addTag");
                if (addTagEl){
                    addTagEl.style.visibility = "visible";
                }
                var addVarTagEl = document.getElementById("addVarTag");
                if (addVarTagEl) {
                    addVarTagEl.style.visibility = "visible";
                }
            }          
        }

        function toggleScheduledRepeatSettings() {
            var intervalDropDown = $("<%= ddlScheduledRepeatInterval.ClientID%>");

            var endTimeRow = $("trRepeatEndTime");
            if (intervalDropDown.options[intervalDropDown.selectedIndex].value == "0") {
                endTimeRow.hide();
            }
            else {
                endTimeRow.show();
            }
        }

        function toggleQuarantinePeriodSettings() {
            var quarantineDropDown = $("<%= ddlQuarantinePeriod.ClientID%>");
            var uniqueRecipients = $("<%= chkUniqueRecipients.ClientID%>").checked;
            var quarantineBox = $("boxCustomQuarantinePeriod");
            var quarantineRow = $("trQuarantinePeriod");

            if (uniqueRecipients)
                quarantineRow.hide();
            else
                quarantineRow.show();

            if (quarantineDropDown.options[quarantineDropDown.selectedIndex].value == "_")
                quarantineBox.show();
            else
                quarantineBox.hide();
        }

        function togglePlainTextRow() {
            var usePlainText = $("<%= radioCustomPlainText.ClientID%>").checked;
            var plainTextRow = $("trPlainTextRow");

            if (usePlainText)
                plainTextRow.show();
            else
                plainTextRow.hide();
        }

        function onLinkManagerSelect(controlId, model) {
            $(controlId).value = model.SelectedAreaAndPageName;
            currentPage.checkLinkedPage(null, controlId);
        }

        Event.observe(window, "load", function () {
            RenderRecipientControl();
        });

        function HideUnsubscribeDialog() {
            var messageText = '<%=Translate.Translate("It is not recommended to disable unsubscribe link unless it is absolutely necessary. It can be illegal to do so.")%>';
            var checked = $("DoNotAddUnsubscribe").checked;
            if (checked) {
                alert(messageText);
            }
            dialog.hide('UnsubscribeDialog');
        }
    </script>
</asp:Content>

<asp:Content ID="mainContent1" ContentPlaceHolderID="MainContent" runat="server">
    <dwc:Card runat="server">
        <dw:RibbonBar runat="server" ID="EditEmailRibbon">
            <dw:RibbonBarTab runat="server" ID="tabEmailEdit" Name="General">
                <dw:RibbonBarGroup runat="server" Name="Tools">
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save" ID="cmdSave" OnClientClick="currentPage.save(false)" />
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save and close" ID="cmdSave_and_close" OnClientClick="currentPage.save(true)" />
                    <dw:RibbonBarButton runat="server" Icon="Cancel" Size="Small" IconColor="Danger" Text="Cancel" ID="cmdCancel" OnClientClick="currentPage.cancel()" />
                    <dw:RibbonBarButton runat="server" Icon="TimerOff" Size="Small" Text="Cancel schedule" ID="cmdCancel_schedule" OnClientClick="currentPage.cancelSchedule()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Send">
                    <dw:RibbonBarPanel runat="server">
                        <dw:RibbonBarButton runat="server" ID="cmdSend_Mail" Icon="EnvelopeO" Size="Large" Text="Send" ContextMenuId="SendMenu"></dw:RibbonBarButton>
                    </dw:RibbonBarPanel>
                    <dw:RibbonBarButton runat="server" ID="cmdStart_split_test" Icon="CallSplit" Size="Large" Text="Setup split test"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Content">
                    <dw:RibbonBarButton runat="server" Icon="Pencil" Size="Large" Text="Edit content" ID="Edit_content" OnClientClick="currentPage.editContent()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Preview">
                    <dw:RibbonBarButton runat="server" Icon="Pageview" Size="Large" Text="Preview" ID="cmdPreview" OnClientClick="currentPage.previewEmail()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Help">
                    <dw:RibbonBarButton runat="server" Icon="Help" Size="Large" Text="Help" ID="cmdHelp" OnClientClick="currentPage.help()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>

            <dw:RibbonBarTab runat="server" ID="tabEmailAdvanced" Name="Advanced">
                <dw:RibbonBarGroup runat="server" Name="Tools">
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save" ID="cmdSave_2" OnClientClick="currentPage.save(false)" />
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Save and close" ID="cmdSave_and_close_2" OnClientClick="currentPage.save(true)" />
                    <dw:RibbonBarButton runat="server" Icon="Cancel" Size="Small" IconColor="Danger" Text="Cancel" ID="cmdCancel_2" OnClientClick="currentPage.cancel()" />
                    <dw:RibbonBarButton runat="server" Icon="TimerOff" Size="Small" Text="Cancel schedule" ID="cmdCancel_schedule_2" OnClientClick="currentPage.cancelSchedule()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Options">
                    <dw:RibbonBarButton runat="server" Icon="AttachFile" Size="Small" Text="Attachments" ID="cmdAttachments" OnClientClick="currentPage.showAttachments()" />
                    <dw:RibbonBarButton runat="server" Icon="Translate" Size="Small" Text="Encoding" ID="cmdEncoding" OnClientClick="currentPage.showEncoding()" />
                    <dw:RibbonBarButton runat="server" Icon="File" Size="Small" Text="Save as template" ID="cmdSave_as_template" OnClientClick="currentPage.showSaveAsTemplate()" />
                    <dw:RibbonBarButton runat="server" Icon="Flag" Size="Small" Text="Unsubscribe" ID="cmdUnsubscribe" OnClientClick="currentPage.showUnsubscribe()" />
                    <dw:RibbonBarButton runat="server" Icon="FileText" Size="Small" Text="Content settings" ID="cmdContent_settings" OnClientClick="currentPage.showContentSettings()" />
                    <dw:RibbonBarButton runat="server" Icon="Group" Size="Small" Text="Recipient settings" ID="cmdRecipient_settings" OnClientClick="currentPage.showRecipientSettings()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Measuring">
                    <dw:RibbonBarButton runat="server" ImagePath="/Admin/Images/Ribbon/Icons/Small/Seo.png" Size="Small" Text="Engagement Index" ID="cmdEngagement_Index" OnClientClick="currentPage.showEngagementIndex()" />
                    <dw:RibbonBarButton runat="server" Icon="LineChart" Size="Small" Text="Tracking" ID="cmdTracking" OnClientClick="currentPage.showTracking()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Distribution">
                    <dw:RibbonBarButton runat="server" Icon="Group" Size="Small" Text="Recipient provider" ID="cmdRecipient_provider" OnClientClick="currentPage.showRecipientProvider()" />
                    <dw:RibbonBarButton runat="server" ImagePath="/Admin/Images/Ribbon/Icons/Small/funnel.png" Size="Small" Text="Delivery provider" ID="cmdDelivery_provider" OnClientClick="currentPage.showDeliveryProvider()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Validate">
                    <dw:RibbonBarButton runat="server" Icon="Save" Size="Small" Text="Validate emails" ID="cmdValidate_emails" OnClientClick="currentPage.validateEmails()" />
                </dw:RibbonBarGroup>
                <dw:RibbonBarGroup runat="server" Name="Help">
                    <dw:RibbonBarButton runat="server" Icon="Help" Size="Large" Text="Help" ID="cmdHelp_2" OnClientClick="currentPage.help()"></dw:RibbonBarButton>
                </dw:RibbonBarGroup>
            </dw:RibbonBarTab>
        </dw:RibbonBar>
        <dwc:CardBody runat="server">
            <dw:Overlay ID="saveForward" runat="server"></dw:Overlay>
            <dw:Infobar runat="server" ID="OMCInfoBar" Visible="False" />
            <dw:Infobar runat="server" ID="ibSubscribers" Visible="False" Type="Warning" />
            <div id="OMCInfoBarSplitDiv" style="display: none;">
                <dw:Infobar runat="server" ID="OMCInfoBarSplit" />
            </div>
            <div id="OMCInfoBarEmailPersonalizationDiv" style="display: none;">
                <dw:Infobar runat="server" ID="OMCInfoBarEmailPersonalization" />
            </div>
            <div id="ScriptNumberSelectorDiv">
                <asp:Literal ID="ScriptNumberSelectorLiteral" runat="server"></asp:Literal>
            </div>
            <div id="hasDeprecatedTagsInfoDiv" style="display: none;">
                <dw:Infobar runat="server" ID="hasDeprecatedTagsInfoBar" Type="Warning" Message="Choosen page has deprecated format of unsubscribe tags, use {{EmailMarketing:Email.UnsubscribeLink}} format instead" />
            </div>

            <dwc:GroupBox ID="gbGeneral" Title="General" runat="server">
                <dwc:InputText runat="server" ID="emailName" Label="Email name" />
                <dwc:InputText runat="server" ID="txTemplateName" Label="Template name" />
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel5" Text="Subject" runat="server" />
                        </td>
                        <td>
                            <asp:TextBox ID="txSubject" CssClass="std field-name with-add" runat="server" Rows="4" TextMode="MultiLine" />
                            <asp:Literal runat="server" ID="AddEmailTagLiteral" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="TranslateLabel6" Text="To" runat="server" />
                        </td>
                        <td>
                            <div id="CustomRecipientSelectorDiv" <%If DefaultRecipientSelector Then%>style="display: none;" <%End If%>>
                            </div>
                            <div id="RecipientAddinControlDiv" <%If Not DefaultRecipientSelector Then%>style="display: none;" <%End If%>>
                                <asp:Literal runat="server" ID="RecipientsExcluded" ClientIDMode="Static"></asp:Literal>
                                <div id="DefaultRecipientSelector">
                                    <dw:UserSelector runat="server" ID="RecipientSelector" NoneSelectedText="No one recipients selected" HeightInRows="7" DiscoverHiddenItems="False" MaxOne="False" OnlyBackend="False" ShowSmartSearches="True" Width="250" CountChangedCallback="OnRecipientsCountChanged" />
                                    <div>
                                        <div style="float: left;">
                                            <dw:TranslateLabel Text="Total recipients:" runat="server" ID="lblTotalRecipients" />
                                            <asp:Label ID="lblTotalRecipientsValue" runat="server" Style="margin-left: 4px;" ClientIDMode="Static"></asp:Label>
                                        </div>
                                        <br />
                                        <div style="margin-top: 3px;">
                                            <dw:Button ID="btnRecipientsList" runat="server" Name="List of recipients" OnClick="ShowRecipientsPopup();" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <dwc:InputText runat="server" ID="txSenderName" Label="From: Name" />
                <dwc:InputText runat="server" ID="txSenderEmail" Label="From: email" />
                <dwc:InputTextArea runat="server" ID="originalPreHeaderText" Label="Pre-header" Rows="3"></dwc:InputTextArea>
                <div class="form-group">
                    <dw:TranslateLabel runat="server" CssClass="control-label" UseLabel="true" Text="Page" />
                    <dw:LinkManager ID="lmEmailPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" CssClass="std field-name" ClientAfterSelectCallback="onLinkManagerSelect.bind(null, 'Link_lmEmailPage')" />
                </div>
                <dwc:SelectPicker runat="server" ID="DomainSelector" Label="Domain" />
                <table class="formsTable" id="rowDomainErrorContainer" style="display: none;">
                    <tr>
                        <td>&nbsp;</td>
                        <td>
                            <div id="divDomainErrorContainer" style="color: red;"></div>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>

            <dwc:GroupBox ID="GroupBox1" Title="Split test" runat="server">
                <dwc:CheckBox runat="server" ID="cbCreateSplitTestVariation" Name="cbCreateSplitTestVariation" Label="Create split test variation" Value="1" OnClick="currentPage.setSplitTestmodeVariation(this)" />
                <div id="trVariation" runat="server">
                    <dwc:InputText runat="server" ID="txtVariantSenderName" Label="From: Name" />
                    <dwc:InputText runat="server" ID="txtVariantSenderEmail" Label="From: email" />
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel Text="Subject" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="txtVariantSubject" CssClass="std field-name with-add" runat="server" Rows="4" TextMode="MultiLine" />
                                <asp:Literal runat="server" ID="AddVarEmailTagLiteral" />
                            </td>
                        </tr>
                    </table>
                    <dwc:InputTextArea runat="server" ID="variantPreHeaderText" Label="Pre-header" Rows="3"></dwc:InputTextArea>
                    <div class="form-group">
                        <dw:TranslateLabel runat="server" CssClass="control-label" UseLabel="true" Text="Page" />
                        <dw:LinkManager ID="lmVariantEmailPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" CssClass="std field-name" ClientAfterSelectCallback="onLinkManagerSelect.bind(null, 'Link_lmVariantEmailPage')" />
                    </div>
                </div>
            </dwc:GroupBox>

            <dw:ContextMenu runat="server" ID="SendMenu">
                <dw:ContextMenuButton runat="server" ID="SendNow" Text="Send Now" Icon="EnvelopeO" OnClientClick="currentPage.sendMail()" />
                <dw:ContextMenuButton runat="server" ID="SendScedule" Text="Scheduled Send" Icon="ClockO" OnClientClick="currentPage.sheduledEmail()" />
            </dw:ContextMenu>

            <dw:Dialog runat="server" ID="pwDialog" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" HidePadding="true">
                <iframe id="pwDialogFrame"></iframe>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="UnsubscribeDialog" Size="Medium" Title="Unsubscribe email" HidePadding="false" ShowOkButton="true" OkAction="HideUnsubscribeDialog();">
                <%If Request.Browser.Browser = "IE" Then%>
                <style type="text/css">
                    #UnsubscribeDiv table.tabTable, #UnsubscribeDiv fieldset {
                        display: block;
                        width: 470px;
                    }
                </style>
                <%Else%>
                <style type="text/css">
                    #UnsubscribeDiv table.tabTable, #UnsubscribeDiv fieldset {
                        display: block;
                        width: 460px;
                    }
                </style>
                <%End If%>
                <div id="UnsubscribeDiv">
                    <dw:GroupBoxStart runat="server" ID="SubscriptionStart" doTranslation="true" Title="Unsubscribe" ToolTip="Unsubscribe" />
                    <table class="formsTable">
                        <tr>
                            <td></td>
                            <td>
                                <dw:CheckBox Label="Do not add unsubscribe link" ID="DoNotAddUnsubscribe" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Unsubscribe text" />
                            </td>
                            <td>
                                <asp:TextBox runat="server" ID="txbUnsubscribeText" CssClass="std field-name" MaxLength="255" />&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="TranslateLabel2" runat="server" Text="Redirect after unsubscribe" />
                            </td>
                            <td>
                                <dw:LinkManager ID="lmUnsubscriptionPage" runat="server" DisableFileArchive="true" DisableParagraphSelector="true" DisableTyping="true" />
                            </td>
                        </tr>
                    </table>
                    <dw:GroupBoxEnd runat="server" ID="SubscriptionEnd" />
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ContentSettingsDialog" Width="590" Title="Content settings" ShowClose="true" HidePadding="true" ShowOkButton="True">
                <style type="text/css">
                    #ContentSettingsDiv table.tabTable, #ContentSettingsDiv fieldset {
                        display: block;
                        width: 510px;
                    }
                </style>
                <div id="ContentSettingsDiv" class="content-main">
                    <dw:GroupBox runat="server" Title="Render content for each recipient">
                        <table border="0">
                            <tr>
                                <td class="left-label">
                                    <dw:TranslateLabel runat="server" Text="Content" />
                                </td>
                                <td>
                                    <label>
                                        <asp:CheckBox runat="server" ID="chkContentPerRecipient" />
                                        <dw:TranslateLabel runat="server" Text="Render content for each recipient" CssClass="std" />
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                    <dw:GroupBox runat="server" Title="Plain text">
                        <table border="0">
                            <tr>
                                <td class="left-label">
                                    <dw:TranslateLabel Text="Plain text" runat="server" />
                                </td>
                                <td>
                                    <ul class="unstyled">
                                        <li>
                                            <label>
                                                <input type="radio" id="radioNoPlainText" name="radioPlainTextSelector" value="None" onchange="togglePlainTextRow();" runat="server" />
                                                <dw:TranslateLabel runat="server" Text="No plain text" CssClass="std" />
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input type="radio" id="radioAutoPlainText" name="radioPlainTextSelector" value="Auto" onchange="togglePlainTextRow();" runat="server" />
                                                <dw:TranslateLabel runat="server" Text="Generate automatically from content" CssClass="std" />
                                            </label>
                                        </li>
                                        <li>
                                            <label>
                                                <input type="radio" id="radioCustomPlainText" name="radioPlainTextSelector" value="Custom" onchange="togglePlainTextRow();" runat="server" />
                                                <dw:TranslateLabel runat="server" Text="Specify custom text" CssClass="std" />
                                            </label>
                                        </li>
                                    </ul>
                                </td>
                            </tr>
                            <tr id="trPlainTextRow">
                                <td class="left-label">
                                    <dw:TranslateLabel runat="server" Text="Plain text content" />
                                </td>
                                <td>
                                    <textarea runat="server" id="txtPlainTextContent" class="std" cols="75" rows="10" style="width: 325px;"></textarea>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="RecipientSettingsDialog" Width="440" Title="Recipient settings" ShowClose="true" HidePadding="true" ShowOkButton="True">
                <style type="text/css">
                    #RecipientSettingsDiv table.tabTable, #RecipientSettingsDiv fieldset {
                        display: block;
                        width: 360px;
                    }
                </style>
                <div id="RecipientSettingsDiv" class="content-main">
                    <dw:GroupBox runat="server" Title="Recipient settings">
                        <table border="0">
                            <tr>
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Recipient uniqueness" />
                                </td>
                                <td>
                                    <label>
                                        <asp:CheckBox runat="server" ID="chkUniqueRecipients" onchange="toggleQuarantinePeriodSettings();" />
                                        <dw:TranslateLabel runat="server" Text="Ensure unique recipients" />
                                    </label>
                                </td>
                            </tr>
                            <tr id="trQuarantinePeriod">
                                <td>
                                    <dw:TranslateLabel runat="server" Text="Quarantine period" />
                                </td>
                                <td>
                                    <asp:DropDownList runat="server" ID="ddlQuarantinePeriod" onchange="toggleQuarantinePeriodSettings();" CssClass="std" Width="175" />
                                    <div id="boxCustomQuarantinePeriod" style="display: none;">
                                        <asp:TextBox runat="server" ID="txtCustomQuarantinePeriod" CssClass="std" Width="175" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="AddEmailTag" Width="460" Title="Add email tag" ClientIDMode="Static" HidePadding="False" ShowCancelButton="False" ShowClose="True" ShowOkButton="True" OkAction="OnAddEmailTagClosed();">
                <div id="AddEmailTagDiv">
                    <table border="0" class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Tag" CssClass="std" />
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="EmailTagsList" CssClass="std" DataTextField="Text" DataValueField="Value" ClientIDMode="Static" />
                            </td>
                        </tr>
                    </table>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="AddVarEmailTag" Width="460" Title="Add email tag" ClientIDMode="Static" HidePadding="False" ShowCancelButton="False" ShowClose="True" ShowOkButton="True" OkAction="OnAddVarEmailTagClosed();">
                <div id="AddVarEmailTagDiv">
                    <table border="0" class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Tag" CssClass="std" />
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="VarEmailTagsList" CssClass="std" DataTextField="Text" DataValueField="Value" ClientIDMode="Static" />
                            </td>
                        </tr>
                    </table>
                </div>
            </dw:Dialog>

            <dw:Dialog ID="CMAttachDialog" runat="server" Width="350" ShowCancelButton="false" ShowOkButton="true" Title="Attachments" ShowClose="True">
                <div id="AttachmentsDiv">
                    <dw:GroupBox ID="GroupBox4" Title="Email attachments" runat="server">
                        <omc:AttachmentsListBox ID="CMAttachListBox" runat="server" CssClass="attachmentControl"></omc:AttachmentsListBox>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="EmailTemplateDialog" Width="350" Title="Template" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('EmailTemplateDialog');">
                <div id="LayoutTemplateDiv">
                    <dw:GroupBox ID="gbLayoutTemplate" Title="Layout template" runat="server">
                        <table class="formsTable">
                            <tr>
                                <td>
                                    <dw:TranslateLabel ID="TranslateLabel15" Text="Choose a different layout template for the e-mail page" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select id="PageLayoutSelector" class="std" name="PageLayoutSelector">
                                        <asp:Literal ID="PageLayoutList" runat="server"></asp:Literal>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="SchedulingDialog" Size="Medium" Title="Scheduling" ShowCancelButton="true" ShowOkButton="true" OkText="Schedule" OkAction="document.getElementById('SchedulingScheduleButton').click();">
                <dw:GroupBox ID="GroupBox5" runat="server" Title="Setup scheduling" DoTranslation="true">
                    <dw:DateSelector runat="server" ID="dsStartDate" Label="Start" IncludeTime="True" />
                    <div id="trRepeatEndTime">
                        <dw:DateSelector runat="server" ID="dsEndDate" Label="End" IncludeTime="True" AllowNeverExpire="true" SetNeverExpire="true" />
                    </div>
                    <dwc:SelectPicker runat="server" ID="ScheduledSendTimeZone" Label="&nbsp;"></dwc:SelectPicker>
                    <dwc:SelectPicker runat="server" ID="ddlScheduledRepeatInterval" ClientIDMode="Static" Label="Repeat every"></dwc:SelectPicker>
                    <asp:Button runat="server" Text="Schedule" ID="SchedulingScheduleButton" ClientIDMode="Static" CssClass="buttonSubmit" CausesValidation="false" Style="display: none;" OnClientClick="if(!confirm(getConfirmText())){return false;}" />
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="PreviewMailDialog" Title="Preview settings" ShowClose="true">
                <dwc:GroupBox ID="GroupBoxPreviewRecipients" runat="server" Title="Preview as user" DoTranslation="true">
                    <div style="margin: 10px 10px 0px 10px;">
                        <dw:UserSelector runat="server" ID="PreviewEmailSelector" NoneSelectedText="No recipients selected" HeightInRows="7" DiscoverHiddenItems="False" MaxOne="True" OnlyBackend="False" Show="Users" />
                    </div>
                </dwc:GroupBox>
                <dwc:GroupBox ID="GroupBoxEmailSplitTest" runat="server" DoTranslation="True" Title="Split test preview">
                    <dwc:CheckBox ID="chkOriginal" runat="server" Value="Original" Label="Original" />
                    <dwc:CheckBox ID="chkVariant" runat="server" Value="Variant" Label="Variant" />
                </dwc:GroupBox>

                <dwc:GroupBox ID="GroupBoxEmailPreview" runat="server" DoTranslation="True" Title="Preview">
                    <table>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="lbPreviewInMail" Text="Preview in mail" runat="server" />
                            </td>
                            <td>
                                <asp:TextBox ID="txPreviewInMail" CssClass="std field-name" runat="server" />
                            </td>
                            <td>
                                <asp:Button runat="server" Text="Send" ID="bnSendTestMail" CssClass="buttonSubmit" />
                                <asp:RequiredFieldValidator ID="EmailValidator" ControlToValidate="txPreviewInMail" Display="None" runat="server" />
                                <asp:RegularExpressionValidator ID="RegexEmailValidator" ControlToValidate="txPreviewInMail" Display="None" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="lbPreviewInBrowser" Text="Preview in browser" runat="server" />
                            </td>
                            <td>
                                <input id="PreviewBrowser" class="buttonSubmit" onclick="showPreviewEmailDialog();" value="Open in browser" type="button" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <dw:TranslateLabel ID="lbPreviewInFile" Text="Preview in file" runat="server" />
                            </td>
                            <td>
                                <asp:Button ID="btnPreviewInFile" Text="Preview in file" runat="server" CausesValidation="false" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:CustomValidator ID="RecipientValidate" OnServerValidate="ValidatePreviewRecipient" Display="None" runat="server" />
                                <asp:ValidationSummary ID="ValidationSummary1" ShowMessageBox="true" ShowSummary="false" runat="server" />
                            </td>
                        </tr>
                    </table>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="EmailEncodingDialog" Width="500" Title="Encoding" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('EmailEncodingDialog');">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Encoding" />
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="crlEncoding" DataTextField="Text" DataValueField="Value" CssClass="std" />
                        </td>
                    </tr>
                </table>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="EmailTrackingDialog" Width="520" TranslateTitle="True" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('EmailTrackingDialog');" Title="Tracking">
                <dw:GroupBox ID="GroupBox2" runat="server" Title="Select Tracking">
                    <asp:Literal runat="server" ID="LoadParametersScript"></asp:Literal>
                    <de:AddInSelector ID="TrackingProviderAddIn" runat="server" AddInShowNothingSelected="true" AddInGroupName="Select Tracking" AddInParameterName="Settings" AddInTypeName="Dynamicweb.EmailMarketing.EmailTrackingProvider" AddInShowFieldset="false" />
                    <asp:Literal runat="server" ID="LoadParameters"></asp:Literal>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="RecipientProviderDialog" Width="530" Title="Recipient provider" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('RecipientProviderDialog'); RenderRecipientControl();">
                <dw:GroupBox ID="GroupBox6" runat="server" Title="Select Recipient Provider">
                    <div id="RecipientProviderAddInDiv">
                        <asp:Literal runat="server" ID="LoadRecipientProviderScript"></asp:Literal>
                        <de:AddInSelector ID="RecipientProviderAddIn" runat="server" AddInShowNothingSelected="False" AddInGroupName="Select Recipient Provider" AddInParameterName="Settings" AddInTypeName="Dynamicweb.EmailMarketing.EmailRecipientProvider" AddInShowFieldset="False" />
                        <asp:Literal runat="server" ID="LoadRecipientProvider"></asp:Literal>
                    </div>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="DeliveryProviderDialog" Width="400" Title="Delivery provider" HidePadding="false" ShowOkButton="true" OkAction="dialog.hide('DeliveryProviderDialog');">
                <dw:GroupBox runat="server" Title="Select Delivery Provider Configuration">
                    <table class="formsTable">
                        <tr>
                            <td>
                                <dw:TranslateLabel runat="server" Text="Provider" />
                            </td>
                            <td>
                                <asp:DropDownList runat="server" ID="ddlDeliveryProviders" CssClass="std"></asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="dlgSaveAsTemplate" Title="Save as template" OkText="Ok" ShowCancelButton="true" ShowClose="false" ShowOkButton="true" OkAction="currentPage.saveAsTemplate()">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Name" />
                        </td>
                        <td>
                            <input type="text" id="TemplateName" name="TemplateName" class="NewUIinput" maxlength="255" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel runat="server" Text="Description" />
                        </td>
                        <td>
                            <input type="text" id="TemplateDescription" name="TemplateDescription" class="NewUIinput" />
                        </td>
                    </tr>
                </table>
                <br />
                <br />
            </dw:Dialog>

            <input type="submit" id="cmdSend" name="cmdSend" value="Send" style="display: none" />
            <input type="submit" id="cmdCancelSchedule" name="cmdCancelSchedule" value="Submit" style="display: none" />
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="submit" id="cmdCheckLinkedPage" name="cmdCheckLinkedPage" value="Submit" style="display: none" />
            <input type="submit" id="cmdCheckVariationLinkedPage" name="cmdCheckVariationLinkedPage" value="Submit" style="display: none" />
            <input type="submit" id="cmdSaveAsTemplate" name="cmdSaveAsTemplate" value="Submit" style="display: none;" />
            <input type="hidden" id="CloseOnSave" name="CloseOnSave" value="True" />
            <input type="hidden" id="EmailScheduled" name="EmailScheduled" value="false" />
            <input type="hidden" id="topFldrID" name="topFldrID" value="" runat="server" />

        </dwc:CardBody>

    </dwc:Card>

</asp:Content>
