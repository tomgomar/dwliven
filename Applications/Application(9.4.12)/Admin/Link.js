function browseFileLink(strCaller, strFile, allowedExtensions, selectedCallback) {
    var valEl = document.getElementById(strCaller);
    if (valEl && valEl.disabled) {
        return;
    }

    strFile = strFile || "";
    if (strFile.toLowerCase().startsWith("/files/")) {
        strFile = strFile.substring("/files".length);
    }
    var filePath = strFile;
    var queryStringParams = [];
    if (allowedExtensions) {
        queryStringParams.push("AllowedExtensions=" + allowedExtensions);
    }
    if (filePath) {
        queryStringParams.push("path=" + filePath);
    }

    var callback = function (act, model) {
        var selectedFilePath = model.Selected;
        var path = "/Files" + selectedFilePath;
        valEl.value = path;
        _fireEvent(valEl, "change");
        if (selectedCallback) {
            selectedCallback(path);
        }
    };

    var dlgAction = createLinkDialog(LinkDialogTypes.File, queryStringParams, callback);

    Action.Execute(dlgAction);
}

function browseInternalPageLink(strCaller, pageId, areaID, selectedCallback, queryStringParams) {
    var valEl = document.getElementById(strCaller);
    if (valEl && valEl.disabled) {
        return;
    }

    var queryStringParams = queryStringParams || [];
    if (pageId) {
        queryStringParams.push("PageId=" + _getPageId(pageId));
    }
    if (areaID) {
        queryStringParams.push("AreaId=" + areaID);
    }

    var callback = function (act, model) {
        var path = "Default.aspx?Id=" + model.Selected;
        model.path = path;
        valEl.value = path;
        _fireEvent(valEl, "change");
        if (selectedCallback) {
            selectedCallback(model);
        }
    };

    var dlgAction = createLinkDialog(LinkDialogTypes.Page, queryStringParams, callback);

    Action.Execute(dlgAction);
}

function browseInternalPageParagraphLink(strCaller, pageId, areaID, selectedCallback, queryStringParams) {
    var valEl = document.getElementById(strCaller);
    if (valEl && valEl.disabled) {
        return;
    }

    var queryStringParams = queryStringParams || [];
    if (pageId) {
        queryStringParams.push("PageId=" + _getPageId(pageId));
        var para = _getPageParagraphId(pageId);
        if (para) {
            queryStringParams.push("ParagraphId=" + para);
        }
    }
    if (areaID) {
        queryStringParams.push("AreaId=" + areaID);
    }

    var callback = function (act, model) {
        var pageId = model.PageID;
        var paragraphId = model.ParagraphID;
        var paragraphName = model.ParagraphName
        var path = "Default.aspx?Id=" + pageId + "#" + paragraphId;
        model.path = path;
        valEl.value = path;
        _fireEvent(valEl, "change");
        if (selectedCallback) {
            selectedCallback(model);
        }
    };

    var dlgAction = createLinkDialog(LinkDialogTypes.Paragraph, queryStringParams, callback);

    Action.Execute(dlgAction);
}

var LinkDialogTypes = { 'Page': 0, 'Paragraph': 1, 'File': 2 };

function createLinkDialog(dialogType, queryStringParams, afterSelectCallback) {
    var url = "";

    queryStringParams = queryStringParams || [];

    switch (dialogType) {
        case LinkDialogTypes.Page:
            url = '/Admin/Content/Dialogs/SelectPage?';
            break;
        case LinkDialogTypes.Paragraph:
            url = '/Admin/Content/Dialogs/SelectParagraph?';
            break;
        case LinkDialogTypes.File:
            url = '/Admin/Files/Dialogs/SelectFile?';
            break;
    }

    var dlgAction = {
        Url: url + queryStringParams.join("&"),
        Name: "OpenDialog",
        OnSubmitted: {
            Name: "ScriptFunction",
            Function: afterSelectCallback
        }
    };
    return dlgAction;
}

function internal(ID, AreaID, Name, strShowParagraphsOption) {
    if (strShowParagraphsOption) {
        browseInternalPageParagraphLink(Name, ID, AreaID);
    } else {
        browseInternalPageLink(Name, ID, AreaID);
    }
}

function internalEcom(ID, AreaID, Name, strShowParagraphsOption) {
    internal(ID, AreaID, Name, strShowParagraphsOption);
}

function CKEditorBrowse(event) {
    var editor = event.editor;
    var dialogDefinition = event.data.definition;
    switch (event.data.name.toLowerCase()) {
        case 'link': {
            var browseButton = dialogDefinition.contents[0].get('browse');
            if (browseButton !== null) {
                browseButton.hidden = false;
                browseButton.onClick = function () {
                    editor._.filebrowserSe = this;
                    var editorName = editor.name;
                    if (window.dwFrontendEditing && window.dwFrontendEditing.editorName) {
                        editorName = window.dwFrontendEditing.editorName;
                        CKEDITOR.instances[editorName] = editor; // hack to support one default link dlg for all.
                    }
                    Action.OpenDialog({ Url: "/Admin/Editor/ckeditor/browser.aspx?type=link&fId={FID}" }, { FID: CKEDITOR.instances[editorName]._.filebrowserFn });
                }
            }
            break;
        }
        case 'image': {
            var tabCount = dialogDefinition.contents.length;
            for (var i = 0; i < tabCount; i++) {
                var browseButton = dialogDefinition.contents[i].get('browse');
                if (browseButton !== null) {
                    browseButton.hidden = false;
                    var old = browseButton.onClick;
                    browseButton.onClick = function (definition) {
                        var callerID = CKEDITOR.dialog.getCurrent().getContentElement(definition.data.dialog._.currentTabId, "txtUrl")._.inputId;
                        var val = document.getElementById(callerID).value
                        browseFileLink(callerID, val || CKEDITOR.defaulImageFolder || "", "gif,jpg,jpeg,png");
                    }
                }
            }
            break;
        }
    }

}

function _fireEvent(element, event) {
    if (document.createEventObject) {
        var evt = document.createEventObject();
        return element.fireEvent('on' + event, evt)
    } else {
        var evt = document.createEvent("HTMLEvents");
        evt.initEvent(event, true, true);
        return !element.dispatchEvent(evt);
    }
}

function _getPageId(link) {
    if (link.indexOf("Default.aspx") >= 0) {
        var pageId = link.substring("Default.aspx?Id=".length);
        var paragraphIdIndex = pageId.indexOf("#");
        if (paragraphIdIndex > 0) {
            pageId = pageId.substring(0, paragraphIdIndex);
        }
        return pageId;
    } else {
        return link;
    }
}

function _getPageParagraphId(link) {
    if (link.indexOf("Default.aspx") >= 0) {
        var pageId = link.substring("Default.aspx?Id=".length);
        var paragraphIdIndex = pageId.indexOf("#");
        var para = "";
        if (paragraphIdIndex > 0) {
            para = pageId.substring(paragraphIdIndex + 1);
        }
        return para;
    }
    return null;
}
