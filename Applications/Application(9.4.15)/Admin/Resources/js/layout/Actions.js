var Action = {};
(function () {

    Action.Transform = function (template, data, isUrl) {
        if (data) {
            return template.replace(/\{([\w\.]*)\}/g, function (str, key) {
                var keys = key.split("."), v = data[keys.shift()];
                for (var i = 0, l = keys.length; i < l; i++) v = v[keys[i]];
                v = isUrl ? encodeURIComponent(v) : v;
                return (typeof v !== "undefined" && v !== null) ? v : "";
            });
        }
        return template;
    }

    Action.Execute = function (action, model) {
        this[action.Name].apply(this, arguments);
        return false;
    };

    Action._getCurrentDialogLevel = function () {
        var win = window.top;
        var frm = window.frameElement;
        var dlgToOpenLevel = 0;
        if (frm) {
            if (privateMethods.dom.hasClass(frm, "dialog")) {
                dlgToOpenLevel = parseInt(frm.parentNode.getAttribute("data-dialog-level"));
            }
        }
        return dlgToOpenLevel;
    };

    Action._getCurrentDialogAction = function () {
        var win = window.top;
        var level = Action._getCurrentDialogLevel();
        var opener = privateMethods.cache(win, "dialog-" + level + "_action");
        return opener;
    };

    Action._getCurrentDialogModel = function () {
        var win = window.top;
        var level = Action._getCurrentDialogLevel();
        var model = privateMethods.cache(win, "dialog-" + level + "_model");
        return model;
    };

    Action._getCurrentDialogOpener = function () {
        var win = window.top;
        var level = Action._getCurrentDialogLevel();
        var opener = privateMethods.cache(win, "dialog-" + level + "_opener");
        return opener;
    };

    Action.OpenDialog = function (action, model) {
        var dlgToOpenLevel = Action._getCurrentDialogLevel() + 1;
        privateMethods.dialog.open(dlgToOpenLevel, Action.Transform(action.Url, model, true));
        var win = window.top;
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_action", action);
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_model", model);
        privateMethods.cache(win, "dialog-" + dlgToOpenLevel + "_opener", window);
        return false;
    };

    Action.CloseDialog = function (action) {
        var dlgToOpenLevel = Action._getCurrentDialogLevel();
        if (dlgToOpenLevel > 0) {
            privateMethods.dialog.close(dlgToOpenLevel);
        }

        if (action) {
            var nextAction = null;
            var _action = Action._getCurrentDialogAction();
            var _model = Action._getCurrentDialogModel();
            var _opener = Action._getCurrentDialogOpener();
            if (_action) {
                if (action.Result === "cancel") {
                    nextAction = _action.OnCancelled;
                }
            }

            if (nextAction) {
                _opener.Action.Execute(nextAction, action.Model || _model);
            }
        }
    };

    Action.OpenScreen = function (action, model) {
        var url = Action.Transform(action.Url, model, true);        
        if (action.TargetArea) {
            var targetArea = Action.Transform(action.TargetArea, model);
            window.top.$(".static-menu li > a[data-target='" + targetArea + "']").trigger("click", { defaultAreaAction: url });
        }
        else if (window.top != window.self) {
            if (window.dwGlobal && action.Ancestors && action.Ancestors.length > 0) {
                var navWnd = window.parent.name ? window.dwGlobal.getNavigatorWindow(window.parent.name) : window;
                navWnd.dwGlobal.currentNavigator.expandAncestors(action.Ancestors);
            }
            var mainWnd = window.mainframe || window;
            if (!mainWnd.location) {
                mainWnd = mainWnd.contentWindow;
            }
            if (!mainWnd.document.getElementById("screenLoaderOverlay")) {
                var cnt = mainWnd.document.body;
                if (cnt) {
                    var overlayHtml = '<div class="overlay-container" id="screenLoaderOverlay"><div class="overlay-panel"><i class="fa fa-refresh fa-3x fa-spin"></i></div></div> ';
                    cnt.insertAdjacentHTML("afterbegin", overlayHtml);
                }
            }
            mainWnd.location.href = url;
        }
        else if (!window.areas || window.areas.length == 0) {
            window.location.href = url;
        }
        else {

            for (var i = 0; i < window.areas.length; i++) {
                $('#' + window.areas[i] + '-iframe').addClass("iframe-closed");
            }
            $('#' + window.areas[0] + '-iframe')
                .removeClass("iframe-closed")
                .addClass("iframe-open")
                .attr('src', url);
        }

        return false;
    };

    Action.OpenWindow = function (action, model) {
        action.Url = Action.Transform(action.Url, model, true);
        var win = window.top;
        if (action.currentWindowAsOpener) {
            win = window;
        }
        var hasVerb = !!action.ActionVerb && action.ActionVerb != "GET";
        startUrl = hasVerb ? '' : action.Url;

        // Screen center
        var x = screen.width / 2 - 800 / 2;
        var y = screen.height / 2 - 600 / 2;
        var width = action.Width || 800;
        var height = action.Height || 600;
        var target = "_blank";
        
        if (action.OpenInNewTab) {
            win.open(startUrl, target);
            win.focus();
        } else {
            target = "dwpopup";
            win.open(startUrl, target, 'width=' + width + ',height=' + height + ',resizable=yes,scrollbars=yes,status=yes,left=' + x + ',top=' + y);
        }

        if (hasVerb) {
            openWindowWithVerb(action.ActionVerb, action.Url, model, target);
        }
        return false;
    };

    // Arguments :
    //  verb : 'GET'|'POST'
    //  target : an optional opening target (a name, or "_blank"), defaults to "_self"
    function openWindowWithVerb(verb, url, data, target) {
        var form = document.createElement("form");
        form.action = url;
        form.method = verb;
        form.target = target || "_self";
        if (data) {
            for (var key in data) {
                var input = document.createElement("input");
                input.setAttribute("type", "hidden");
                input.name = key;
                input.value = typeof data[key] === "object" ? JSON.stringify(data[key]) : data[key];
                form.appendChild(input);
            }
        }
        form.style.display = 'none';
        document.body.appendChild(form);
        form.submit();
    };

    Action.OpenHelp = function (action) {
        var win = window.top;
        win.open(action.Url, "dwpopup", 'width=800,height=600,resizable=yes,scrollbars=yes,status=yes,left=' + x + ',top=' + y);

        return false;

    };

    Action.ShowMessage = function (action, model) {
        model = model || {};
        model.Caption =  Action.Transform(model.Caption || action.Caption || model.Title || "", model);
        model.Message = Action.Transform(model.Message || action.Message || "", model);
        Action.OpenDialog({
            Url: "/Admin/CommonDialogs/Confirm?Buttons=Close&Caption={Caption}&Message={Message}",
            Buttons: "Close"
        }, model);

        return false;
    };

    Action.ShowPermissions = function (action, model) {
        model = model || {};
        model.Key = model.Key || action.PermissionKey || "";
        model.Name = model.Name || action.PermissionName || "";
        model.SubName = model.SubName || action.PermissionSubName || "";
        model.Title = model.Title || action.PermissionTitle || "";

        Action.OpenDialog({
            Url: "/Admin/Content/Permissions/PermissionEdit.aspx?Key={Key}&Name={Name}&SubName={SubName}&Title={Title}" 
        }, model);

        return false;
    };

    Action.Script = function (action, model) {
        if (action.Script) window.eval(action.Script);
    };

    Action.SetValue = function (action, model) {

        if (action.scope === "opener") {
            var opener = Action._getCurrentDialogOpener();
            if (action.Value) {
                if (model) {
                    opener.document.getElementById(action.Target).value = Action.Transform(action.Value, model);
                }
                else {
                    opener.document.getElementById(action.Target).value = action.Value;
                }
            } else {
                opener.document.getElementById(action.Target).value = encodeURIComponent(JSON.stringify(model));
            }
        }
        else {
            if (action.Value) {
                if (model) {
                    document.getElementById(action.Target).value = Action.Transform(action.Value, model);
                }
                else {
                    document.getElementById(action.Target).value = action.Value;
                }
            } else {
                document.getElementById(action.Target).value = encodeURIComponent(JSON.stringify(model));
            }

        }

    };

    Action.ConfirmMessage = function (action, model) {
        if (confirm(action.Message)) {
            Action.Execute(action.OnConfirm, model);
        }

        return false;
    }

    Action.ScriptFunction = function (action, model) {
        var context = window;
        if (action.Context) {
            if (typeof action.Context === 'string') {
                context = window[action.Context];
            } else if (typeof action.Context === 'object') {
                context = action.Context;
            }
        }
        var opts = {};
        for (var propertyName in action) {
            if (propertyName != "Name" && propertyName != "Context" && propertyName != "Function") {
                var val = action[propertyName];
                if (typeof val == 'string' && model) {
                    val = Action.Transform(val, model);
                }
                opts[propertyName] = val;
            }
        }

        if (action.Function) {
            var fn = typeof action.Function !== 'function' ? context[action.Function] : action.Function;
            if (typeof fn !== 'function') {
                fn = eval(action.Function);
            }
            if (typeof fn == 'function') {
                fn.apply(context, [opts, model]);
            }
        }
        return false;
    }

    var execAjaxRequest = function (action, model) {
        action.Url = Action.Transform(action.Url, model, true)
        var params = {};
        for (var propertyName in action.Parameters) {
            var val = action.Parameters[propertyName];
            if (typeof val == 'string' && model) {
                val = Action.Transform(val, model);
            }
            params[propertyName] = val;
        }        
        var heads = {};
        for (var header in action.Headers) {
            var key = action.Headers[header].Key;
            var value = action.Headers[header].Value;
            if (key.length > 0 && value.length > 0) {
                if (key in heads) {
                    heads[key] = heads[key] + ',' + value;
                } else {
                    heads[key] = value;
                }
            }
        }
        var ajaxFn = $.ajax || window.top.$.ajax;
        var ajaxRequest = ajaxFn({
            url: action.Url,
            type: action.Type,
            data: params,
            headers: heads
        });
        return ajaxRequest;
    };

    Action.AjaxAction = function (action, model) {
        var ajaxRequest = execAjaxRequest(action, model);
        if (action.OnSuccess) {
            ajaxRequest.done(function (result, textStatus) {
                Action.Execute(action.OnSuccess, result, textStatus);
            });
        }
        if (action.OnFail || action.ShowError) {
            ajaxRequest.fail(function (jqXHR, textStatus, textStatusDescription) {
                if (action.ShowError) {
                    alert(textStatusDescription);
                    console.log(jqXHR.responseText);
                }
                if (action.OnFail) {
                    Action.Execute(action.OnFail, model, textStatus);
                }
            });
        }
        return false;
    }

    Action.ApplicationResponseAjaxAction = function (action, model) {
        var ajaxRequest = execAjaxRequest(action, model);
        if (action.OnSuccess) {
            ajaxRequest.done(function (responseModel, textStatus) {
                if (responseModel.Succeeded) {
                    Action.Execute(action.OnSuccess, responseModel.Data);
                }
                else if (action.OnFail) {
                    Action.Execute(action.OnFail, responseModel);
                }
            });
        }
        ajaxRequest.fail(function (jqXHR, textStatus, textStatusDescription) {
            // something wrong
            console.error("Abnormal behavior", action, model, jqXHR);
            if (action.OnFail) {
                Action.Execute(action.OnFail, {
                    Message: textStatusDescription
                }, textStatus);
            }
        });

        return false;
    }

    Action.Composite = function (action, model) {
        if (action.Actions) {
            for (var i = 0; i < action.Actions.length; i++) {
                Action.Execute(action.Actions[i], model);
            };
        }
        return false;
    }

    var privateMethods = {
        dom: {
            hasClass: function (el, className) {
                if (el.classList)
                    return el.classList.contains(className);
                else
                    return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
            }
        },

        dialog: {
            open: function (dlgLevel, url) {
                var dlgObj = this.getDialog(dlgLevel, true);
                var win = window.top;
                var backDrop = win.document.getElementById(dlgObj.backdrop);
                var frm = win.document.getElementById(dlgObj.frame);
                backDrop.style.display = "block";
                frm.className = "dialog iframe-open";
                frm.setAttribute("src", url);
                if (dlgLevel == 1) {
                    dlgObj.topWndStyle = win.document.body.style;
                    win.document.body.style.overflow = "hidden";
                }
            },

            getDialog: function (dlgLevel, create) {
                var win = window.top;
                var dlgObj = privateMethods.cache(win, "dialog-" + dlgLevel + "_def");
                if (dlgObj || !create) {
                    return dlgObj || null;
                }
                var dlgHtml = '<div class="dialog-iframe-container" data-dialog-level="' + dlgLevel + '" id="dialog-cnt-' + dlgLevel + '"> \
                                <iframe src="" class="dialog iframe-closed" id="dialog-frame-' + dlgLevel + '"></iframe> \
                                <div class="modal-backdrop overlay-container" id="dialog-backdrop-' + dlgLevel + '"><div class="overlay-panel"><i class="fa fa-refresh fa-3x fa-spin"></i></div></div> \
                                </div>';
                dlgObj = {
                    container: "dialog-cnt-" + dlgLevel,
                    frame: "dialog-frame-" + dlgLevel,
                    backdrop: "dialog-backdrop-" + dlgLevel
                };
                var dlgDoc = win.document;
                dlgDoc.body.insertAdjacentHTML("afterbegin", dlgHtml);
                privateMethods.cache(win, "dialog-" + dlgLevel + "_def", dlgObj);
                return dlgObj;
            },

            close: function (dlgLevel) {
                var dlgObj = this.getDialog(dlgLevel, false);
                if (dlgObj) {
                    var win = window.top;
                    var backDrop = win.document.getElementById(dlgObj.backdrop);
                    var frm = win.document.getElementById(dlgObj.frame);
                    backDrop.style.display = "none";
                    frm.className = "dialog iframe-closed";
                    frm.setAttribute("src", "about:blank");
                    if (dlgLevel == 1 && dlgObj.topWndStyle) {
                        win.document.body.style = dlgObj.topWndStyle;
                    }
                }
            }
        },

        cache: function (win, key, val) {
            win.g_actions_cache = win.g_actions_cache || {};
            if (val === undefined) {
                return win.g_actions_cache[key] || null;
            }
            if (val === null) {
                if (win.g_actions_cache[key] !== undefined) {
                    delete win.g_actions_cache[key];
                }
                return null;
            }
            win.g_actions_cache[key] = val;
            return val
        }
    };
})();