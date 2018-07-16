/* ++++++ Registering namespace ++++++ */

if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

/* ++++++ End: Registering namespace ++++++ */

OMC.MessageEdit = function () {
    /// <summary>Represents a profile edit page.</summary>
    this._initialized = false;
    this._terminology = {};
    this._clientInstanceName = '';
    this._channelId = 0;
    this.cbChannelIDs = new Array();
    this._isPublishFromPage = false;
    this._isLinkInternal = false;
    this._isPublishFromEcom = false;
 }

OMC.MessageEdit.prototype.set_isPublishFromEcom = function (value) {
    this._isPublishFromEcom = value;
}

OMC.MessageEdit.prototype.set_isLinkInternal = function (value) {
    this._isLinkInternal = value;
}

OMC.MessageEdit.prototype.set_isPublishFromPage = function (value) {
    this._isPublishFromPage = value;
}

OMC.MessageEdit.prototype.set_clientInstanceName = function (value) {
    this._clientInstanceName = value;
}

OMC.MessageEdit.prototype.set_channelId = function (value) {
    this._channelId = value;
}

OMC.MessageEdit.prototype.get_terminology = function () {
    /// <summary>Gets the terminology object that holds all localized strings.</summary>

    if (!this._terminology) {
        this._terminology = {};
    }

    return this._terminology;
}

/*--------Strart--GUI methods------------------------*/

OMC.MessageEdit.prototype.isUnselectedAllChannels = function() {
    var result = true;

    if (this.cbChannelIDs.length > 0) {
        var el = null;

        for (var i = 0; i < this.cbChannelIDs.length; i++) {
            el = document.getElementById(this.cbChannelIDs[i]);

            if (el != null && el.checked) {
                result = false;
                break;
            }
        }
    }

    return result;
}

OMC.MessageEdit.prototype.validateData = function (onComplete, isValidateCustomMessage) {
    /// <summary>Validates the form.</summary>
    /// <param name="onComplete">Callback that is executed when the form is validated.</param>

    var isAlertShown = false;
    var callback = onComplete || function () { }

    if ($('DefaultName') && !$('DefaultName').value) {
        alert(this.get_terminology()['EmptyName']);

        try {
            $('DefaultName').focus();
        } catch (ex) { }

        isAlertShown = true;
        callback(false);
    }

    if (!isAlertShown && isValidateCustomMessage) {

        for (var ch = 0; ch < this.cbChannelIDs.length; ch++ ){
            var channelId = this.cbChannelIDs[ch].split('Channel')[1];
            var result = true;
            var channel = $("Channel" + channelId);
            var channelCustomMessage = $("channelCustomMessage" + channelId);
            var isShowCustomMessage = $("channelCustomMessage" + channelId + "Refresh").style.display != "none";
            var msgToLong = this.get_terminology()['MessageToLong'].replace(/\%\%/g, '"' + $('Channel' + channelId + 'Name').innerText + '"');

            var el = $('channelCustomMessage' + channelId + 'MaxSize');
            var maxSize = el != null ? parseInt(el.value) : 0;
            if (isNaN(maxSize)) maxSize = 0;

            if ($('DefaultText') && ($('DefaultText').value.length > maxSize && !isShowCustomMessage && (channel != null && channel.checked))) {
                alert(msgToLong);

                try {
                    $('DefaultText').focus();
                } catch (ex) { }
                isAlertShown = true;
                callback(false);
            } else if (($('DefaultText') && !$('DefaultText').value && (channel != null && channel.checked) && !channelCustomMessage.value)) {
                alert(this.get_terminology()['EmptyMessage']);

                try {
                    $('DefaultText').focus();
                } catch (ex) { }

                isAlertShown = true;
                callback(false);
            }

            if (channel != null && channel.checked && channelCustomMessage != null && isShowCustomMessage) {
                result = (channelCustomMessage.value.length > 0);

                if (result) {
                    result = ((maxSize - channelCustomMessage.value.length) >= 0);

                    if (!result) {
                        alert(msgToLong);

                        try {
                            channelCustomMessage.focus();
                        } catch (ex) { }

                        isAlertShown = true;
                        callback(false);
                    }
                }
                else {
                    alert(this.get_terminology()['EmptyMessage']);

                    try {
                        channelCustomMessage.focus();
                    } catch (ex) { }

                    isAlertShown = true;
                    callback(false);
                }
            }
        }
    }

    if (!isAlertShown) {
        callback(true);
    }
}

OMC.MessageEdit.prototype.cancel = function (folderId, topFolderId) {
    /// <summary>Discards any changes and closes the form.</summary>
    var o = new overlay('saveForward');
    o.show();

    if($('IsPopUp').value == 'true')
        parent.hideSMP();
    else if (topFolderId != -1) {
        parent.OMC.MasterPage.get_current().set_contentUrl('/Admin/Module/OMC/SMP/MessageList.aspx?folderId=' + folderId + '&topFolderId=' + topFolderId);
    }else{
        parent.OMC.MasterPage.get_current().set_contentUrl('/Admin/Module/OMC/SMP/MessageList.aspx?filter=AllMessages&folderId=' + folderId + '&topFolderId=' + topFolderId);
    }
}

OMC.MessageEdit.prototype.save = function (closeWindow, publish) {
    var self = this;        
    /* Validating input */
    this.validateData(function (isValid) {
        if (isValid) {

            /* Show spinning wheel*/
            var o = new overlay('saveForward');
            o.show();

            var form = self._getPostbackForm();
            document.getElementById('CloseOnSave').value = (!!closeWindow).toString();
            if (publish) {
                document.getElementById("cmd").value = "publish"
            }
            else {
                document.getElementById("cmd").value = void (0);
            }

            if (form) {
                /* Submitting a form to a hidden frame */
                form.target = 'frmPostback';
            }
            document.getElementById('cmdSubmit').click();
        }        
    }, publish);
}

OMC.MessageEdit.prototype.saveAsDraft = function (closeWindow) {
    this.save(closeWindow, false);
}

OMC.MessageEdit.prototype.saveAndClose = function () {
    this.saveAsDraft(true);
}

OMC.MessageEdit.prototype.saveAndPublish = function () {
    this.save(true, true);
}

OMC.MessageEdit.prototype.scheduledPublish = function () {
    var self = this;    
    this.validateData(function (isValid) {
        if (isValid) {
            var form = self._getPostbackForm();
            if (form) {
                /* Submitting a form to a hidden frame */
                form.target = 'frmPostback';
            }
               $('isPublishScheduled').value = true;
               dialog.show('SchedulingDialog');
        }        
    }, true);

}

OMC.MessageEdit.prototype.showBlock = function(objName) {
    if (document.getElementById(objName) != null)
        document.getElementById(objName).style.display = '';
}

OMC.MessageEdit.prototype.hideBlock = function (objName) {
    if (document.getElementById(objName) != null)
        document.getElementById(objName).style.display = 'none';
}

OMC.MessageEdit.prototype.parseTextForLinks = function (obj) {
    document.getElementById(obj.id + 'Preview').innerHTML = obj.value.parseURL();
}

OMC.MessageEdit.prototype.showCharsCounter = function (channelId) {
    var elText = document.getElementById('channelCustomMessage' + channelId);

    if(elText != null)
    {
        var dsblParse = $('cbDisableParseLinks').checked;

        if(!dsblParse)
            updateChnlCharsCounter(channelId, elText.value);
        else
        {
            var el = document.getElementById('channelCustomMessage' + channelId + 'MaxSize');
            var maxSize = el != null ? parseInt(el.value) : 0;
            if(isNaN(maxSize)) maxSize = 0;

            el = document.getElementById('channelCustomMessage' + channelId + 'Size');
            maxSize = maxSize - newText.length;

            if(maxSize < 0)
                el.innerHTML = "<font color=\"red\">" + maxSize.toString() + "</font>";
            else
                el.innerHTML = maxSize.toString();
        }
    }
}

OMC.MessageEdit.prototype.refreshCharsCounters = function ()
{
    showDefaultCharsCounter();

    for(var ch = 0; ch < this.cbChannelIDs.length; ch++)
    {
        var channelId = this.cbChannelIDs[ch].split('Channel')[1];
        showCharsCounter(channelId);
    }
}

OMC.MessageEdit.prototype.updateChnlCharsCounter = function(channelId, newText)
{
    new Ajax.Request("/Admin/Module/OMC/SMP/EditMessage.aspx",
    {
        method: 'get',
        parameters: { Action: 'CalcCharsCount', Text: newText },
        onComplete: function(transport)
        {
            var el = document.getElementById('channelCustomMessage' + channelId + 'MaxSize');
            var maxSize = el != null ? parseInt(el.value) : 0;
            if(isNaN(maxSize)) maxSize = 0;

            el = document.getElementById('channelCustomMessage' + channelId + 'Size');
            maxSize = maxSize - (newText.length + parseInt(transport.responseText));

            if(maxSize < 0)
                el.innerHTML = "<font color=\"red\">" + maxSize.toString() + "</font>";
            else
                el.innerHTML = maxSize.toString();
        }
    });
}

OMC.MessageEdit.prototype.populateChannelFieldsFromDefault = function (channelId) {
    var textField = document.getElementById('channelCustomMessage' + channelId);

    this.parseTextForLinks(textField);
    var nameField = document.getElementById('channelCustomName' + channelId);
    if (nameField != null) {
        nameField.value = document.getElementById('DefaultName').value;
    }
    //for the link and image, update text and hidden
    var linkField = document.getElementById('Link_channelCustomLink' + channelId);
    if (linkField != null) {
        linkField.value = document.getElementById('Link_DefaultLink').value;
    }
    var linkField = document.getElementById('channelCustomLink' + channelId);
    if (linkField != null) {
        linkField.value = document.getElementById('Link_DefaultLink').value;
    }
    var defaultImageField = document.getElementById('FM_DefaultImage');
    var imageField = document.getElementById('FM_channelCustomImage' + channelId);
    if (imageField != null) {
        imageField.options.length = 0;
        for (var i = 0; i < defaultImageField.options.length; i++) {
            imageField.options[imageField.options.length] = new Option(defaultImageField.options[i].text, defaultImageField.options[i].value);
        }
        imageField.selectedIndex = defaultImageField.selectedIndex;
    }

    return false;
}

OMC.MessageEdit.prototype.showChannelContent = function (channelId, isShowContent) {
    this._channelId = channelId;
    var row = document.getElementById("channelCustomMessageRow" + channelId);

    if (!isShowContent) {
        row.style.display = "none";        
    } else {
        row.style.display = "";        
        this.populateChannelFieldsFromDefault(channelId);        
    }
}

OMC.MessageEdit.prototype.useChannel = function (channelId) {
    this._channelId = channelId;
    var cb = document.getElementById("Channel" + channelId);

    this.hideBlock("channelCustomMessageRow" + channelId);

    if (cb.checked) {
        this.hideBlock("channelCustomMessage" + channelId + 'Refresh');
        this.showBlock("channelCustomMessageAction" + channelId + 'Container');
        this.showBlock("channelCustomMessage" + channelId + 'Edit');
        this.showChannelContent(channelId, false);
        this.populateChannelFieldsFromDefault(channelId);
    }
    else {
        this.hideBlock("channelCustomMessageAction" + channelId + 'Container');
        this.hideBlock("channelCustomMessage" + channelId + 'Edit');
        this.hideBlock("channelCustomMessage" + channelId + 'Refresh');
    }

    this.showLinkField();
    this.updateToolbarBtns();
}

OMC.MessageEdit.prototype.updateToolbarBtns = function () {
    var isDisabledPublish = this.isUnselectedAllChannels();
         
    $('btnSaveAndPublish').select('button')[0].setAttribute('onclick', '');
    $('btnScheduledMessage').select('button')[0].setAttribute('onclick', '');

    document.getElementById('btnSaveAndPublish').disabled = true;
    document.getElementById('btnScheduledMessage').disabled = true;

    if (!isDisabledPublish) {
        $('btnSaveAndPublish').select('button')[0].setAttribute('onclick', this._clientInstanceName + '.saveAndPublish();');
        $('btnScheduledMessage').select('button')[0].setAttribute('onclick', this._clientInstanceName + '.scheduledPublish();');
    }    
}

OMC.MessageEdit.prototype.showLinkField = function()
{
    if (this._isPublishFromPage) {
        $('trLink').style.display = "";
        if (!eval($('isPrimaryWebsiteDomainSet').value)) {
            $('trDomain').style.display = "";
        }
    } else if (this._isPublishFromEcom) {
        $('trLink').style.display = "none";
        if (!eval($('isPrimaryWebsiteDomainSet').value)) {
            $('trDomain').style.display = "";
        }
    } else {
        $('trLink').style.display = 'none';
        if ($('trDomain')) {
            $('trDomain').style.display = 'none';
        }

        for (var ch = 0; ch < this.cbChannelIDs.length; ch++) {
            var channelId = this.cbChannelIDs[ch].split('Channel')[1];
            var channel = $("Channel" + channelId);
            var adapterName = $("channel" + channelId + "AdapterName").innerHTML;

            if (channel != null && channel.checked && adapterName.indexOf("Facebook") != -1) {
                $('trLink').style.display = "";
                if (this._isLinkInternal || $('DefaultLink').value.indexOf('Default.aspx?ID=') != -1) {
                    if ($('trDomain')) {
                        $('trDomain').style.display = "";
                    }
                }
                break;
            }
        }
    }
}

OMC.MessageEdit.prototype.nochannels = function () {
    setTimeout(function(){
        this.updateToolbarBtns();
        alert("There are no social media channels configured");
    }, 500);
}

OMC.MessageEdit.prototype.onCancelEditChannel = function (channelId) {
    this.hideBlock("channelCustomMessageRow" + channelId);
    this.hideBlock("channelCustomMessage" + channelId + 'Refresh');

    this.showBlock("channelCustomMessageAction" + channelId + 'Container');
    this.showBlock("channelCustomMessage" + channelId + 'Edit');

    this.showChannelContent(channelId, false);
    this.populateChannelFieldsFromDefault(channelId);

    this.EditPostBody(channelId, false);

    return false;
}

OMC.MessageEdit.prototype.onEditChannel = function (channelId) {
    this.showChannelContent(channelId, true);
    this.EditPostBody(channelId, true);
    this.hideBlock("channelCustomMessage" + channelId + 'Edit');
    this.showBlock("channelCustomMessage" + channelId + 'Refresh');
    this.showCharsCounter(channelId);
}

OMC.MessageEdit.prototype.EditPostBody = function (channelId, copy) {
    var textField = document.getElementById('channelCustomMessage' + channelId);

    if (copy == true)
        textField.value = document.getElementById('DefaultText').value;
    else
        textField.value = '';
}

OMC.MessageEdit.prototype.CheckInternalLink = function (linkUrl) {
    if (!eval($('isPrimaryWebsiteDomainSet').value)) {
        if (linkUrl.indexOf('Default.aspx?ID=') != -1) {
            if ($('trDomain')) {
                $('trDomain').style.display = '';
            }
        }
    } 
}

/*-------------End GUI methods---------------*/

OMC.MessageEdit.prototype.initialize = function () {
    /// <summary>Initializes the object.</summary>
    var name = null;
    var self = this;
    var binder = null;

    if (!this._initialized) {
        setTimeout(function () {
            //try {
            //    $('txSenderName').focus();
            //} catch (ex) { }
        }, 200);

        this._initialized = true;
    }

    setTimeout(function()
    {
        self.safeCall(function () {
            self.updateToolbarBtns()
        });
    });
}

OMC.MessageEdit.prototype.onAfterSave = function (response) {
    /// <summary>Occurs when the postback frame gets loaded.</summary>
    /// <param name="response">Response.</param>

    var form = this._getPostbackForm();
    var nodeItemID = '/SocialMediaPublishing/top-sys:' + response.TopFolderID;

    if (form) {
        /* Clearing the target, just in case */
        form.target = '';
    }

    if($('IsPopUp').value == 'true')
    {
        if(response.Close == true && response.IsError != true)
            parent.hideSMP();
        else
            parent.reloadSMP(response.ID);
    }
    else
    {
        var self = parent.OMC.MasterPage.get_current();;

        if(response)
        {
            if(response.Saved == true)
            {
                self.reload('/SocialMediaPublishing');

                if(response.Close == true)
                {
                    self.reload(nodeItemID, null);
                    if (!response.Published && !response.Scheduled && response.FolderID && response.FolderID != -1)
                        self.navigate('/Admin/Module/OMC/SMP/MessageList.aspx?filter=allunpublished&folderId=' + response.FolderID + '&topFolderId=' + response.TopFolderID);
                    else if(response.Scheduled)
                        self.navigate('/Admin/Module/OMC/SMP/MessageList.aspx?filter=allscheduled&folderId=' + response.FolderID + '&topFolderId=' + response.TopFolderID);
                    else if(response.Published == true && response.IsError == true)
                        self.navigate('/Admin/Module/OMC/SMP/EditMessage.aspx?ID=' + response.ID + '&folderId=' + response.FolderID + '&topFolderId=' + response.TopFolderID);
                    else
                        self.navigate('/Admin/Module/OMC/SMP/MessageDetails.aspx?messageId=' + response.ID);
                }
                else
                    self.reloadSocialMediaPublishing(response.ID, nodeItemID);
            }
        }
    }

    /* Changing the text back shortly */
    setTimeout(function () {
        document.getElementById('btnSaveNews').disabled = false;
    }, 3000);
}  

OMC.MessageEdit.prototype._getPostbackForm = function () {
    /// <summary>Returns a postback form.</summary>

    var ret = null;
    var form = null;
    var forms = document.getElementsByTagName('form');

    if (forms && forms.length) {
        if (forms.length == 1) {
            ret = forms[0];
        } else {
            for (var i = 0; i < forms.length; i++) {
                form = $(forms[i]);

                if (form.readAttribute('action') == 'post' && form.readAttribute('name') == 'aspnetForm') {
                    ret = forms[i];
                    break;
                }
            }
        }
    }

    return ret;
}

OMC.MessageEdit.prototype.safeCall = function (code) {
    /// <summary>Executes the given code with a fallback in case of the exception - the execution will be postponed.</summary>
    /// <param name="code">Code to execute.</param>

    this._safeCallRecursive(code, 10, 1);
}

OMC.MessageEdit.prototype._safeCallRecursive = function (code, maxIterations, currentIteration) {
    /// <summary>Executes the given code with a fallback in case of the exception - the execution will be postponed.</summary>
    /// <param name="code">Code to execute.</param>
    /// <param name="maxIterations">The maximum number of iterations.</param>
    /// <param name="currentIteration">Current iteration number.</param>
    /// <private />

    var self = this;

    if (code) {
        try {
            if (typeof (code) == 'function') {
                code.apply(window);
            } else if (typeof (code) == 'string') {
                eval(code);
            }
        } catch (ex) {
            if (currentIteration < maxIterations) {
                setTimeout(function () {
                    self._safeCallRecursive(code, maxIterations, currentIteration + 1);
                }, 50);
            }
        }
    }
}
