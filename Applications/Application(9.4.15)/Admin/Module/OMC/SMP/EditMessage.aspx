<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Module/OMC/EntryContent.Master" CodeBehind="EditMessage.aspx.vb" Inherits="Dynamicweb.Admin.OMC.SMP.MessageEdit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="omc" Namespace="Dynamicweb.Controls.OMC" Assembly="Dynamicweb.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<asp:Content ID="cHeadMessage" ContentPlaceHolderID="HeadContent" runat="server">
        <script type="text/javascript">
            var defTimerID = 0;
            var chnlTimerID = [];
            var bodyDefAdd = 0;
            var bodyChnlAdd = [];
            var currentPageId = 0;
            var previousPageId = 0;
            var currentGroupId = '';

            function showCharsCounter(channelId)
            {
                var elText = document.getElementById('channelCustomMessage' + channelId);

                if (elText != null) 
                {
                    var dsblParse = $('cbDisableParseLinks').checked;

                    if(dsblParse)
                    {
                        this.bodyDefAdd = 0;
                        this.bodyChnlAdd = [];
                    }

                    UpdateLocalChnlCounter(channelId, elText.value);
                    clearTimeout(this.chnlTimerID[channelId]);
                    
                    if(!dsblParse)
                        this.chnlTimerID[channelId] = setTimeout(function(){updateChnlCharsCounter(channelId, elText.value)}, 2000);
                }
            }    
            
            function UpdateLocalChnlCounter(channelId, str)
            {
                var el = document.getElementById('channelCustomMessage' + channelId + 'MaxSize');
                var maxSize = el != null ? parseInt(el.value) : 0;
                if (isNaN(maxSize)) maxSize = 0;

                el = document.getElementById('channelCustomMessage' + channelId + 'Size');

                var al = 0;

                if(self.bodyChnlAdd && self.bodyChnlAdd[channelId])
                    al = self.bodyChnlAdd[channelId];

                maxSize = maxSize - (str.length + al);

                if (maxSize < 0 ) 
                    el.innerHTML = "<font color=\"red\">" + maxSize.toString() + "</font>";
                else 
                    el.innerHTML = maxSize.toString();
            }

            function updateChnlCharsCounter(channelId, newText)
            {
                var self = this;

                new Ajax.Request("/Admin/Module/OMC/SMP/EditMessage.aspx", 
                {
                    method: 'get',
                    parameters: { Action: 'CalcCharsCount', Text: newText },
                    onComplete: function (transport) 
                    {
                        var el = document.getElementById('channelCustomMessage' + channelId + 'MaxSize');
                        var maxSize = el != null ? parseInt(el.value) : 0;
                        if (isNaN(maxSize)) maxSize = 0;

                        el = document.getElementById('channelCustomMessage' + channelId + 'Size');
                        self.bodyChnlAdd[channelId] = parseInt(transport.responseText);
                        maxSize = maxSize - (newText.length + self.bodyChnlAdd[channelId]);

                        if (maxSize < 0 ) 
                            el.innerHTML = "<font color=\"red\">" + maxSize.toString() + "</font>";
                        else 
                            el.innerHTML = maxSize.toString();
                    }
                });
            }

            function showDefaultCharsCounter()
            {
                var elText = $('DefaultText');

                if (elText != null) 
                {
                    var dsblParse = $('cbDisableParseLinks').checked;

                    if(dsblParse)
                    {
                        this.bodyDefAdd = 0;
                        this.bodyChnlAdd = [];
                    }

                    UpdateLocalDefaultCounter(elText.value);
                    clearTimeout(this.defTimerID);

                    if(!dsblParse)
                        this.defTimerID = setTimeout(function(){updateCharsCounter(elText.value)}, 2000);
                }
            }

            function UpdateLocalDefaultCounter(str)
            {
                var el = document.getElementById('DefaultMessageSize');
                el.innerHTML = str.length + this.bodyDefAdd;
            }

            function updateCharsCounter(newText, disableParse)
            {
                var self = this;

                new Ajax.Request("/Admin/Module/OMC/SMP/EditMessage.aspx", 
                {
                    method: 'get',
                    parameters: { Action: 'CalcCharsCount', Text: newText },
                    onComplete: function (transport) 
                    {
                        var el = document.getElementById('DefaultMessageSize');
                        self.bodyDefAdd = parseInt(transport.responseText);
                        el.innerHTML = newText.length + self.bodyDefAdd;
                    }
                });
            }

            String.prototype.parseURL = function () {
                    return this.replace(/<%=LINK_PARSE_REGEX%>/g, function (url) {
                        return url.replace(url, '<span style="text-decoration: underline;">' + url + '</span>');
                });
            };

            function parseTextForLinks(obj) {
                document.getElementById(obj.id + 'Preview').innerHTML = obj.value.parseURL();
            }

            Event.observe(document, 'dom:loaded', function () {
                setTimeout(function(){ document.getElementById('DefaultName').focus();}, 500);
                showDefaultCharsCounter();
            });

            function showErrorsDialog() {
                dialog.show('showErrorsDlg');
            }

            function changeMode(hideElementId, showElementId){
                if (hideElementId != null && hideElementId != '' && document.getElementById(hideElementId) != null)
                    document.getElementById(hideElementId).style.display = 'none';

                if (showElementId != null && showElementId != '' && document.getElementById(showElementId) != null)
                    document.getElementById(showElementId).style.display = '';
            }

            function getMessageName() {                
                var messageName = "Unknown";
                for (var i = 0; i < $$('input.std').length; i++) {
                    var inputField = $$('input.std')[i];
                    if (inputField.name.include('DefaultName')) {
                        messageName = " '" + inputField.value + "' ";
                    }
                }
                return messageName; 
            }

            function getScheduledDate() {
                var scheduledDate = "";
                if($('<%=dsStartDate.UniqueID%>_calendar') && Dynamicweb && Dynamicweb.UIControls && Dynamicweb.UIControls.DatePicker){
                    scheduledDate = Dynamicweb.UIControls.DatePicker.get_current().GetDate('<%=dsStartDate.UniqueID%>');
                }
                return scheduledDate; 
            }

        function getConfirmText(){
            var confirmText= '<%=Dynamicweb.SystemTools.Translate.JsTranslate("The social message")%>' + getMessageName() + '<%=Dynamicweb.SystemTools.Translate.JsTranslate(" will be scheduled for ")%>' + getScheduledDate() + '<%=Dynamicweb.SystemTools.Translate.JsTranslate(". Do you want to continue?")%>';
            return confirmText;
        }

            function AddLink() 
            {
                var isPublishFromPage = <%=Me.IsPublishFromPage.ToString.ToLower()%>;
                var isPublishFromEcom = <%=Me.IsPublishFromEcom.ToString.ToLower()%>;

                if (isPublishFromPage || (isPublishFromEcom && $('DefaultLink').value.length > 0))
                {
                    var domainName = $('DomainSelector').value;

                    if(!$('previousDomain').value)
                    {
                        $('DefaultText').value = $('DefaultText').value + ' ' + '<%= HttpContext.Current.Request.Url.Scheme%>' + '://' + domainName + '/' + $('DefaultLink').value;
                    }
                    else
                    {
                        var defaultText =  $('DefaultText').value;
                        var previousDomain = $('previousDomain').value;
                        var result = defaultText.replace(previousDomain, domainName);
                        $('DefaultText').value = result;
                    }

                $('previousDomain').value = domainName;

                if( previousPageId != 0 && $('DefaultLink').value.indexOf(previousPageId) == -1 )
                {
                    var defaultText =  $('DefaultText').value;
                    var result = defaultText.replace(previousPageId, currentPageId);
                    $('DefaultText').value = result;
                }

                showDefaultCharsCounter();
                previousPageId = currentPageId;
            }
        }

        function SelectProductPage() {
            dialog.show('SelectProductPageDialog' , "/Admin/Module/OMC/SMP/SelectProductPage.aspx");
        }

        function AddProductPage(pageId, pageBreadcrumb) 
        {
            $('txPageProductCatalog').value = pageBreadcrumb; 
            $('DefaultLink').value = 'Default.aspx?ID=' + pageId + '&ProductID=' + '<%=Me._productId%>';

            if($('cbIncludeGroup') && $('cbIncludeGroup').checked && this.currentGroupId.length != 0)
                $('DefaultLink').value += '&GroupID=' + encodeURI(this.currentGroupId);

            currentPageId = pageId;
            dialog.hide('SelectProductPageDialog');
            AddLink();
            FillDomainListForSelectedPage(pageId);
        }

        function FillDomainListForSelectedPage(pageId){
            var self = this;

            new Ajax.Request("/Admin/Module/OMC/SMP/EditMessage.aspx", 
            {
                method: 'get',
                parameters: { Action: 'FillDomainList', PageId: pageId },
                onSuccess: function (transport) 
                {
                    if(transport.responseText.length > 0 && transport.responseText.indexOf('@@') != -1){
                        document.getElementById("DomainSelector").innerHTML = transport.responseText.split('@@')[1];
                        AddLink() ;
                        var isPrimaryDomainSet = eval(transport.responseText.split('@@')[0].split('=')[1]);
                        if (!isPrimaryDomainSet) {
                            if ($('trDomain')) {
                                $('trDomain').style.display = '';
                            }
                        }else if ($('trDomain')) {
                            $('trDomain').style.display = 'none';
                        }
                    }
                }
            });
        }

        function UpdateGroup() 
        {
            var cbInclGrp = $('cbIncludeGroup'); 
            var ddlGroups = $('ddlGroups'); 
            var defLink = $('DefaultLink');
            var defText = $('DefaultText');

            if(cbInclGrp.checked)
            {  
                ddlGroups.disabled = false;
                var grpId = ddlGroups[ddlGroups.selectedIndex].value;

                if($('txPageProductCatalog').value)
                {
                    if(this.currentGroupId.length == 0)
                    {
                        var oldDefLink = defLink.value;
                        defLink.value += '&GroupID=' + encodeURI(grpId);
                        defText.value = defText.value.replace(oldDefLink, defLink.value);
                    }
                    else
                    {  
                        defLink.value = defLink.value.replace('&GroupID=' + encodeURI(this.currentGroupId), '&GroupID=' + encodeURI(grpId));
                        defText.value = defText.value.replace('&GroupID=' + encodeURI(this.currentGroupId), '&GroupID=' + encodeURI(grpId));
                    }
                }

                this.currentGroupId = grpId;
            }
            else
            {
                ddlGroups.disabled = true;               
                defLink.value = defLink.value.replace('&GroupID=' + encodeURI(this.currentGroupId), '');
                defText.value = defText.value.replace('&GroupID=' + encodeURI(this.currentGroupId), '');
                this.currentGroupId = '';
            }
        }
        </script>
   </asp:Content>

   <asp:Content ID="cMain" ContentPlaceHolderID="MainContent" runat="server">
            <dw:Overlay ID="saveForward" runat="server"></dw:Overlay>
      
       <dw:Toolbar ID="tbSMP" runat="server" ShowEnd="False" ShowStart="False">
           <dw:ToolbarButton ID="btnSaveNews" runat="server" Text="Save" Icon="Save" />
           <dw:ToolbarButton ID="btnSaveAndCloseNews" runat="server" Text="Save and close" Icon="Save" />
           <dw:ToolbarButton ID="btnSaveAndPublish" runat="server" Text="" Icon="Users" />
           <dw:ToolbarButton ID="btnCancel" runat="server" Text="Cancel" Icon="Cancel" />           
           <dw:ToolbarButton ID="btnScheduledMessage" runat="server" Text="Schedule message" Icon="Schedule" Visible="False" />
           <dw:ToolbarButton ID="btnHelp" runat="server" Text="Help" Icon="Help" Visible="False" Divide="Before" />
       </dw:Toolbar>

       <div id="PageContent">
                <h2 class="subtitle" id="titleText" runat="server"></h2>
                <dw:Infobar ID="notPublishedInfo" runat="server" Type="Error" Visible="False" TranslateMessage="False"></dw:Infobar>
                <input type="hidden" name="cmd" id="cmd" value="" />
                <input type="hidden" name="ID" id="ID" value="" runat="server" />
                <input type="hidden" name="closewindow" id="closewindow" value="" runat="server" />
                <input type="hidden" id="primaryDomain" name="primaryDomain" runat="server" value="" />
                <input type="hidden" id="previousDomain" name="previousDomain" runat="server" value="" />
                <input type="hidden" id="isPrimaryWebsiteDomainSet" name="isPrimaryDomainSet" runat="server" value="" />
                <div style="height:10px;width:10px;"></div>
                <dw:GroupBox ID="gbGeneral" Title="Settings" runat="server">
                    <table border="0" class="tabTableWide">
                        <tr>
                            <td style="width:170px">
                                <dw:TranslateLabel ID="lbName" Text="Name" runat="server" /><br />
                            </td>
                            <td>
                                <input type="text" id="DefaultName" name="DefaultName" class="std field-name" style="width:360px;" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="width: 170px;">
                                <dw:TranslateLabel ID="lbImage" Text="Image" runat="server" />
                            </td>
                            <td>
                                <dw:FileManager ID="DefaultImage" runat="server" ShowOnlyAllowedExtensions="true" Extensions="jpg,gif,png,jpeg" />
                            </td>
                        </tr>
                        <tr id="trLink" runat="server" style="display:none;">
                            <td valign="top" style="width: 170px;">
                                <dw:TranslateLabel ID="lbLink" Text="Link(Facebook)" runat="server" ClientIDMode="Static"/>
                            </td>
                            <td>
                                <dw:LinkManager runat="server" ID="DefaultLink" DisableFileArchive="true" DisableParagraphSelector="true" onchange="alert(1);"/>
                            </td>
                        </tr>
                         <tr id="trProductCatalogPage" runat="server">
                            <td style="width: 170px;">
                                <dw:TranslateLabel ID="TranslateLabel1" Text="Page with product catalog" runat="server" ClientIDMode="Static"/>
                            </td>
                            <td>
                                <input type="text" id="txPageProductCatalog" class="std field-name" runat="server" style="margin-left:0px; width: 338px;" clientidmode="Static" readonly="readonly" /> 
                                <button type="button" class="action-btn" title="Select product page" onclick="SelectProductPage();"><i class="fa fa-archive"></i></button>                                
                            </td>
                        </tr>
                        <tr id="trDomain" runat="server" style="display:none;">
                            <td style="width: 170px">
                                <dw:TranslateLabel ID="TranslateLabel8" Text="Domain" runat="server" />
                            </td>
                            <td>
                                <select id="DomainSelector" class="std" name="DomainSelector" style="width: 365px"  onchange="AddLink();">
                                    <asp:Literal ID="DomainList" runat="server"></asp:Literal>
                                </select>
                            </td>
                        </tr>
                        <tr id="trIncludeGroup" runat="server" visible="False">
                            <td style="width: 170px;">
                                &nbsp
                            </td>
                            <td>
                                <dwc:CheckBox ID="cbIncludeGroup" Name="cbIncludeGroup" Label="Include group in URL" ClientIDMode="Static" runat="server" OnClick="UpdateGroup();" />				                                                                                
                            </td>
                        </tr>
                        <tr id="trGroupsList" runat="server" visible="False">
                            <td style="width: 170px;">
                                <dw:TranslateLabel ID="trlRelatedGroups" Text="Related Groups" runat="server" />
                            </td>
                            <td>
                                <select id="ddlGroups" class="std" name="ddlGroups" style="width: 365px" disabled="disabled" onchange="UpdateGroup();">
                                    <asp:Literal ID="ddlGroupsLiteral" runat="server"></asp:Literal>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="width: 170px;">                                
                            </td>
                            <td onclick="<%=Me.ClientInstanceName%>.refreshCharsCounters();" >
                                <dwc:CheckBox ID="cbDisableParseLinks" Name="cbDisableParseLinks" Label="Disable statistics collection on links" ClientIDMode="Static" runat="server" />				                                                
                            </td>
                        </tr>
                        <tr id="ScheduleDateRow" runat="server" Visible="false">
                            <td valign="top" style="width: 170px;">
                                <dw:TranslateLabel ID="lbScheduleDate" Text="Date" runat="server" />
                            </td>
                            <td>
                                <dw:DateSelector runat="server" ID="ScheduleDate" Name="ScheduleDate" EnableViewState="false" AllowNeverExpire="false" IncludeTime="true" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="width: 170px;">
                                <dw:TranslateLabel ID="lbDescription" Text="Text" runat="server" />
                            </td>
                                <td style="vertical-align:top;">
                                <table class="thinTable" cellpadding="0" cellspacing="0" border="0">
                                    <tr id="trEditMainText">
                                         <td style="vertical-align:top; text-align:right;">
                                            <textarea rows="10" id="DefaultText" name="DefaultText" class="std field-description" style="height: 120px; width: 365px;" onkeyup="parseTextForLinks(this);showDefaultCharsCounter();" runat="server"></textarea>
                                            <br />
                                             <table style="width:100%">
                                                 <tr>
                                                     <td  nowrap="nowrap" style="width: 66%; text-align: left;">
                                                            <div id="DefaultMessageSize" class="message-chars-number">0</div>
                                                     </td>
                                                     <td style="vertical-align:top; text-align:right;">
                                                            <a class="preview-link" href="#" onclick="changeMode('trEditMainText','trViewMainText');" title="<%= Dynamicweb.SystemTools.Translate.Translate("Show tracked links")%>"><%= Dynamicweb.SystemTools.Translate.Translate("Show tracked links")%></a>
                                                     </td>
                                                 </tr>
                                             </table>
                                        </td>
                                    </tr>
                                    <tr id="trViewMainText" style="display:none;">
                                        <td style="vertical-align:top; text-align:right;">
                                            <div id="DefaultTextPreview" class="messagePreview" style="text-align:left;"><asp:Label ID="lblPreviewText" runat="server"></asp:Label></div>
                                            <a class="preview-link" href="#" onclick="changeMode('trViewMainText','trEditMainText');" title="<%= Dynamicweb.SystemTools.Translate.Translate("Hide tracked links")%>" ><%= Dynamicweb.SystemTools.Translate.Translate("Hide tracked links")%></a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </dw:GroupBox>
                <dw:GroupBox ID="GroupBox1" Title="Publish to channels" runat="server">
                    <table border="0" style="width: 100%;">
                        <tr>
                            <td valign="top" style="width: 170px;">
                                <b><dw:TranslateLabel ID="lbChannels" Text="Channels" runat="server" /></b>
                            </td>
                            <td id="channelListCell" runat="server"></td>
                        </tr>
                    </table>
                </dw:GroupBox>                    
            </div>

            <dw:Dialog runat="server" ID="SchedulingDialog" Width="406" Title="Scheduling" ShowClose="true" HidePadding="true">
                <div id="SchedulingDiv" class="content-main">
                    <dw:GroupBox ID="GroupBox5" runat="server" Title="Setup scheduling" DoTranslation="true">
                        <table border="0">
                            <tr>
                                <td style="padding-top: 5px">
                                    <dw:TranslateLabel ID="TranslateLabel22" Text="Send e-mail at:" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-top: 5px;">
                                    <dw:DateSelector ID="dsStartDate" runat="server" IncludeTime="True" Width="350" />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-top: 5px;">
                                    <asp:DropDownList runat="server" ID="ScheduledSendTimeZone" DataTextField="Text" DataValueField="Value" Style="width: 350px;" />
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-top: 5px;">
                                    <input type="button" id="Button1" class="buttonSubmit" value="Cancel" style="float: right; margin-left: 5px;" onclick="dialog.hide('SchedulingDialog');" />
                                    <asp:Button runat="server" Text="Schedule" ID="SchedulingScheduleButton" CssClass="buttonSubmit" CausesValidation="false" Style="float: right;" OnClientClick="if(!confirm(getConfirmText())){return false;}" />
                                </td>
                            </tr>
                        </table>
                    </dw:GroupBox>
                </div>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="showErrorsDlg" Width="600" ShowClose="false" ShowOkButton="true" ShowCancelButton="false" Title="Errors found in push message">
                <table border="0" style="width: 100%;">
                    <tr>
                        <td style="vertical-align: middle; text-align:center;"><IMG src="/Admin/Images/Ribbon/Icons/error.png" /></td>
                        <td style="vertical-align: middle;"><h2><dw:TranslateLabel ID="lblMappingErrorText" Text="" runat="server" /></h2></td>
                    </tr>
                </table>
                <dw:List ID="errorList" runat="server" Title="Errors List" TranslateTitle="True" StretchContent="false" PageSize="25" ShowPaging="true" Height="300">
                    <Columns>
                        <dw:ListColumn ID="MediaColumn" EnableSorting="false" runat="server" Name="Source" Width="30"></dw:ListColumn>
                        <dw:ListColumn ID="NameColumn" EnableSorting="false" runat="server" Name="Channel Name"></dw:ListColumn>
                        <dw:ListColumn ID="FirstlineColumn" EnableSorting="false" runat="server" Name="Problem description"></dw:ListColumn>
                    </Columns>
                </dw:List>
            </dw:Dialog>

           <dw:Dialog ID="SelectProductPageDialog" runat="server" Title="Select product page" HidePadding="true" Width="400">
                <iframe id="SelectProductPageDialogFrame" frameborder="0"></iframe>
           </dw:Dialog>

            <asp:HiddenField  ID="hiddenMessageID" runat="server" Value="0" />

            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="CloseOnSave" name="CloseOnSave" value="True" />
            <input type="hidden" id="isPublishScheduled" name="isPublishScheduled" value="false" />
            <input type="hidden" id="IsPopUp" name="IsPopUp" value="<%=If(Dynamicweb.Environment.RequestExtensions.GetBoolean(Dynamicweb.Context.Current.Request, "popup"), "true", "false")%>" />
            <iframe name="frmPostback" src="" style="display: none"></iframe>
     </asp:Content>
