//*********** FileManager WebControl ************

function morefiles(selected, strCaller, strFolder, strFile, allowedExtensions, selectedCallback) {
    if (selected == 'more') {
        browse(strCaller, strFolder, strFile, allowedExtensions, selectedCallback)
    } 
}

function browse(strCaller, strFolder, strFile, allowedExtensions, selectedCallback) {
    var valEl = $(strCaller);
    if (valEl && valEl.disabled) {
        return;
    }
    strFolder = strFolder || "";
    strFile = strFile || "";

    var rootFolder = "";
    var filePath = "";
    if (strFile || strFolder) {
        if (strFolder && strFolder.substring(0, 1) != "/") {
            rootFolder += "/"
        }
        rootFolder += strFolder;
        filePath = rootFolder;
        if (strFile && strFile.substring(0, 1) != "/") {
            filePath += "/"
        }
        filePath += strFile;
    };

    _selectFile({
        extensions: allowedExtensions,
        rootFolder: rootFolder,
        filePath: filePath,
        selected: function (selectedFilePath) {
            var path = selectedFilePath;
            var relPath = _makeRelativePath(rootFolder, path);
            if (valEl.options) {                
                valEl.selectedIndex = _findOptionOrCreate(valEl, relPath, "/Files" + path);
            } else {
                valEl.value = path;
            }
            _fireEvent(valEl, "change");
        }
    });
}

function browseExternalMediaDatabase(strCaller, browserUrl) {
	DW_browse_window = window.open(browserUrl + "?Control=" + strCaller, "DW_browse_window", "resizable=yes,scrollbars=auto,toolbar=no,location=no,directories=no,status=no,minimize=no,width=1024,height=768,left=200,top=120");
	DW_browse_window.focus();
}

function _selectFile(options) {
    var queryStringParams = [];
    if (options.extensions) {
        queryStringParams.push("AllowedExtensions=" + options.extensions);
    }
    if (options.filePath || options.rootFolder) {
        queryStringParams.push("path=" + options.filePath || options.rootFolder);
    }
    if (options.rootFolder) {
        queryStringParams.push("uploadFolder=" + options.rootFolder);
    }

    var dlgAction = {
        Url: "/Admin/Files/Dialogs/SelectFile?" + queryStringParams.join("&"),
        Name: "OpenDialog",
        OnSubmitted: {
            Name: "ScriptFunction",
            Function: function (act, model) {                
                options.selected(model.Selected);
            }
        }
    };
    Action.Execute(dlgAction);
}

function _makeRelativePath(baseFolder, fullPath) {    
    var strFile = fullPath;
    if (baseFolder && !strFile.toLowerCase().startsWith(baseFolder.toLowerCase())) {
        var count = (baseFolder.match(/\//g) || []).length;
        if (count > 0) {
            var dotsPath = (new Array(count + 1)).join("../");
            if (dotsPath && dotsPath.substring(dotsPath.length - 1) == "/" && strFile.substring(0, 1) == "/") {
                strFile = strFile.substring(1);
            }
            strFile = dotsPath  + strFile;
        }
    }
    else {
        if (baseFolder == "/")
            strFile = strFile.substring(1, strFile.length);
        else
            strFile = strFile.substring(baseFolder.length + 1, strFile.length);
    }
    return strFile;
}

function _findOptionOrCreate(selObj, relFilePath, fullPath, searchByFullPath, upgradeIfFound)
{    
    var index = -1;
    for (var i = 0; i < selObj.options.length; i++) {
        if (searchByFullPath ? selObj.options[i].getAttribute('fullPath') == fullPath : selObj.options[i].value == relFilePath) {
            index = i;
            break;
        }
    }
    if (index < 0) {
        selObj.options[selObj.options.length] = new Option(relFilePath, relFilePath);
        index = selObj.options.length - 1;
        selObj.options[index].setAttribute('fullPath', fullPath);
    }
    else if (upgradeIfFound) {
        var opt = selObj.options[index];
        opt.innerText = relFilePath;
        opt.value = relFilePath;
        opt.setAttribute('fullPath', fullPath);
    }
    return index;
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

function browseFullPath(strCaller, strFolder, strFile, allowedExtensions, selectedCallback) {
    var valEl = $(strCaller);
    if (valEl && valEl.disabled) {
        return;
    }
    strFolder = strFolder || "";
    strFile = strFile || "";

    var rootFolder = "";
    var filePath = "";
    if (strFile || strFolder) {
        if (strFolder && strFolder.substring(0, 1) != "/") {
            rootFolder += "/"
        }
        rootFolder += strFolder;
        if (!strFile) {
            filePath = rootFolder;
        } else {
            if (strFile.substring(0, 1) != "/") {
                filePath += "/"
            }
            filePath += strFile;
        }
    }

    _selectFile({
        extensions: allowedExtensions,
        rootFolder: rootFolder,
        filePath: filePath,
        selected: function (selectedFilePath) {            
            var path = selectedFilePath;
            if (valEl.options) {                
                valEl.selectedIndex = _findOptionOrCreate(valEl, path, "/Files" + path);
            } else {
                valEl.value = path;
            }
            _fireEvent(valEl, "change");
            if (selectedCallback) {
                selectedCallback(path);
            }
        }
    });
}


function templateActions(action, controlID, folder, useNewEditor, caller, showFullPath) {
    var originalID = null,
        origFolder = folder,
        templatesRoot = 'templates/',
        file = document.getElementById(controlID).value,
        lastSlash = -1,
        params = {},
        url,
        genUrl = function(_url, _params) {
            var prop,
                pair,
                result = _url;
            
            for (prop in _params) {
                if (_params[prop] && _params.hasOwnProperty(prop)) {
                    pair = prop + "=" + _params[prop];
                    if (result.indexOf('?') !== -1) {
                        result += '&' + pair;
                    } else {
                        result += '?' + pair;
                    }
                }
            }

            return result;
        };
    
    if (controlID) {
        originalID = controlID.replace('FM_', '');


        if (origFolder.toLowerCase().indexOf(templatesRoot) >= 0) {
            var hidden = document.getElementById(originalID + '_path');
            if (hidden && hidden.value) {
                var templatesIndex = hidden.value.toLowerCase().indexOf(templatesRoot);
                if (templatesIndex > 0) {
                    file = hidden.value.substring(templatesIndex, hidden.value.length);
                }
            }
        }
    }

    lastSlash = file.lastIndexOf('/');
    if (_canExecuteAction(action, originalID)) {
        if (lastSlash >= 0 && lastSlash < (file.length - 1)) {
            folder = file.substring(0, lastSlash);
            folder = folder.replace('../', '');

            if (origFolder.toLowerCase().indexOf(templatesRoot) >= 0 &&
                folder.toLowerCase().indexOf(templatesRoot) < 0) {
                
                folder = templatesRoot + folder;
            }
            
            file = file.substring(lastSlash, file.length).replace('/', '');
        }

        params['File'] = file;
        params['Folder'] = folder;
        params['CallerOriginalID'] = originalID;
        params['CallerCallback'] = caller.attributes['data-caller-callback'] ? caller.attributes['data-caller-callback'].value : '';
        params['CallerReload'] = caller.attributes['data-caller-reload'] ? caller.attributes['data-caller-reload'].value : '';
        params['ShowFullPath'] = showFullPath;

        url = genUrl('/Admin/FileManager/FileEditor/FileManager_FileEditorV2.aspx', params);

        var wnd = window.open(url, '', 'scrollbars=no,toolbar=no,location=no,directories=no,status=no,resizable=yes');
        wnd.focus();
    }
}

function _canExecuteAction(action, controlID) {
    var img = null;
    var ret = true;
    var imgID = 'editImage_' + controlID;
    
    if (action == 'translate') {
       imgID = 'translateImage_' + controlID;
    }

    img = document.getElementById(imgID);

    if (img && _attr(img, '_enabled')) {
        ret = (_attr(img, '_enabled') == 'true');
    }

    return ret;
}

function _attr(obj, attributeName, attributeValue) {
    var ret = null;

    if (obj) {
        if (attributeName) {
            if (!attributeValue) {
                if (typeof (obj.readAttribute) != 'undefined') {
                    ret = obj.readAttribute(attributeName);
                } else if (typeof (obj.getAttribute) != 'undefined') {
                    ret = obj.getAttribute(attributeName);
                }
            } else {
            if (typeof (obj.writeAttribute) != 'undefined') {
                    obj.writeAttribute(attributeName, attributeValue);
                } else if (typeof (obj.setAttribute) != 'undefined') {
                    obj.setAttribute(attributeName, attributeValue);
                }
            }
        }
    }

    return ret;
}

function updateHiddenPath(inputName) {
    var dropDown = document.getElementById('FM_' + inputName);
    var hidden = document.getElementById(inputName + '_path');

    if(dropDown && hidden)
    {
        var selectedOption = dropDown[dropDown.selectedIndex];

        if (selectedOption && selectedOption.attributes['fullPath'])
            hidden.value = selectedOption.attributes['fullPath'].nodeValue;
        else
            hidden.value = '';

        
        if (hidden.onchange) {
            hidden.onchange();
        }

        _showSelectedFile(inputName, hidden.value, selectedOption ? selectedOption.text : "");

        //hidden.fire('FileManager:HiddenPathChanged');
    }
}

function _showSelectedFile(inputName, filePath, relPath) {    
    var fileName = filePath.split("/").pop();
    var fileType = fileName.split('.').pop().toLowerCase();
    var img = document.getElementById('FM_' + inputName + "_image");
    var addicon = document.getElementById('FM_' + inputName + "_addicon");
    var namecontainer = document.getElementById('FM_' + inputName + "_filename");

    if (img) {
        if (fileType == "jpg" || fileType == "jpeg" || fileType == "png" || fileType == "gif" || fileType == "pdf"
            || fileType == "psd" || fileType == "eps" || fileType == "ai" || fileType == "tif" || fileType == "tiff" || fileType == "svg") {
            img.src = "/Admin/Public/GetImage.ashx?width=270&height=270&donotupscale=1&crop=5&Compression=75&image=" + filePath;
                 
            img.className = "";
            addicon.className = "hidden";
            namecontainer.innerText = relPath;
        } else if (fileName == "") {
            img.src = "";
            img.className = "hidden";
            addicon.className = "fa fa-plus-circle thumbnail-add-file";
            addicon.style = "display: block";
            namecontainer.innerText = "";
        } else {
            img.src = "";
            img.className = "hidden";
            addicon.className = "fa fa-file thumbnail-add-file";
            addicon.style = "display: block";
            namecontainer.innerText = "";
        }
    }
}

function clearFileSelection(strCaller) {
    var valEl = $(strCaller);
    if (valEl && valEl.disabled) {
        return;
    }
    if (valEl.options) {
        valEl.selectedIndex = _findOptionOrCreate(valEl, "", "");
    } else {
        valEl.value = "";
    }
    _fireEvent(valEl, "change");
}

function browseFolder(strCaller, strFolder, strFile) {
    var valEl = $(strCaller);
    if (valEl && valEl.disabled) {
        return;
    }

    strFolder = strFolder || "";
    strFile = strFile || "";

    var dlgAction = {
        Url: "/Admin/Files/Dialogs/SelectFolder?folder=" + strFile || strFolder,
        Name: "OpenDialog",
        OnSubmitted: {
            Name: "ScriptFunction",
            Function: function (act, model) {
                var path = model.Selected;
                valEl.value = path;
                _fireEvent(valEl, "change");
            }
        }
    };
    Action.Execute(dlgAction);
}

function fileUpload(strCaller, strFolder) {
    var valEl = $(strCaller);
    if (valEl && valEl.disabled) {
        return;
    }

    strFolder = strFolder || "";
    if (strFolder && strFolder.substring(0, 1) != "/") {
        strFolder = "/" + strFolder;
    }
 
    var wnd = window.top;
    wnd.startUpload(strFolder, function (objResponse) {
        if (objResponse.success) {
            var fileName = objResponse.files[0].name;
            var path = strFolder + "/" + fileName;
            if (valEl.options) {
                var optionIdx = _findOptionOrCreate(valEl, fileName, "/Files" + path);
                valEl.options[optionIdx].innerText = fileName + " (" + dwGlobal.humanFileSize(objResponse.files[0].size) + ")";
                valEl.selectedIndex = optionIdx;
            }
            else {
                valEl.value = path;
            }
            _fireEvent(valEl, "change");
        }
        else {
            Action.Execute({
                Name: "ShowMessage",
                Message: objResponse.message
            });
        }
    });
}

//*********** FileArchive WebControl ************

function previewImgFile(objFile) {
    var sFile = encodeURIComponent(objFile.value);
    
    if (sFile.length > 0) {
        window.open('/Admin/FileManager/FileManager_preview.aspx?File=' + sFile, '', 'resizable=no,scrollbars=auto,toolbar=no,location=no,directories=no,status=no,minimize=no,help=no,width=608,height=315,left=200,top=120').focus();
    }
}

var dwGlobal = dwGlobal || {};
dwGlobal.humanFileSize = dwGlobal.humanFileSize || function (bytes) {
    var thresh = 1024;
    if (Math.abs(bytes) < thresh) {
        return bytes + " B";
    }
    var units = ["Kb", "Mb", "Gb"];
    var unitPrecisions = [0, 1, 3];
    var u = -1;
    do {
        bytes /= thresh;
        u ++;
    } while (Math.abs(bytes) >= thresh && u < units.length - 1);
    return bytes.toFixed(unitPrecisions[u]) + " " + units[u];
}