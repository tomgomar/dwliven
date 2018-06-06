function replaceSubstring(inputString, fromString, toString) {
    var temp = inputString;
    if (fromString == "") {
        return inputString;
    }

    fromString = "" + fromString;
    toString = "" + toString;

    if (toString.indexOf(fromString) == -1) {
        while (temp.indexOf(fromString) != -1) {
            var toTheLeft = temp.substring(0, temp.indexOf(fromString));
            var toTheRight = temp.substring(temp.indexOf(fromString) + fromString.length, temp.length);
            temp = toTheLeft + toString + toTheRight;
        }
    } else {
        var midStrings = new Array("~", "`", "_", "^", "#");
        var midStringLen = 1;
        var midString = "";

        while (midString == "") {
            for (var i = 0; i < midStrings.length; i++) {
                var tempMidString = "";
                for (var j = 0; j < midStringLen; j++) { tempMidString += midStrings[i]; }
                if (fromString.indexOf(tempMidString) == -1) {
                    midString = tempMidString;
                    i = midStrings.length + 1;
                }
            }
        }

        while (temp.indexOf(fromString) != -1) {
            var toTheLeft = temp.substring(0, temp.indexOf(fromString));
            var toTheRight = temp.substring(temp.indexOf(fromString) + fromString.length, temp.length);
            temp = toTheLeft + midString + toTheRight;
        }

        while (temp.indexOf(midString) != -1) {
            var toTheLeft = temp.substring(0, temp.indexOf(midString));
            var toTheRight = temp.substring(temp.indexOf(midString) + midString.length, temp.length);
            temp = toTheLeft + toString + toTheRight;
        }
    }
    return temp;
}

function initCategoryFieldsInheritanceUI(mainCnt) {
    var fieldObservers = {}; // => <fieldname: [<observers>]>
    var localValRefreshUrl = "/Admin/Images/Ribbon/Icons/Small/refresh.png";
    var defaultValRefreshUrl = "/Admin/Images/Ribbon/Icons/Small/refresh_disabled.png";
    mainCnt.select(".cat-field-row > .editor.type-1 .NewUIinput, .cat-field-row > .editor.type-10 .NewUIinput, .cat-field-row > .editor.type-11 .NewUIinput, .cat-field-row > .editor.type-12 .NewUIinput, .cat-field-row > .editor.type-13 .NewUIinput,\
            .cat-field-row > .editor.type-2 textarea, .cat-field-row > .editor.type-4 span, .cat-field-row > .editor.type-5 span, .cat-field-row > .editor.type-5 select, .cat-field-row > .editor.type-6 input, \
            .cat-field-row > .editor.type-7 input[type=text], .cat-field-row > .editor.type-8 input[type=text], .cat-field-row > .editor.type-9 select, .cat-field-row > .editor.type-3 input[type=checkbox], \
            .cat-field-row > .editor.type-15.pt-RadioButtonList input[type=radio], .cat-field-row > .editor.type-15.pt-CheckBoxList input[type=checkbox], .cat-field-row > .editor.type-15.pt-DropDownList select, \
            .cat-field-row > .editor.type-15.pt-MultiSelectList select, .cat-field-row > .editor.type-10 .NewUIinput, .cat-field-row > .editor.type-14 textarea").each(function (el) {
                var editor = el;
                var editorCnt = editor.up(".editor");
                var row = editorCnt.up(".cat-field-row");
                if (row.hasClassName("field-disabled")) {
                    return;
                }
                var iiEl = editorCnt.select(".is-inherited")[0];
                var rivEl = editorCnt.select(".restore-inherited-val")[0];
                var fieldName = row.readAttribute("data-field-name");
                var markAsLocal = function () {
                    if (!row.hasClassName("inherited-val")) {
                        return;
                    }
                    row.removeClassName("inherited-val");
                    iiEl.value = "false";
                    rivEl.src = localValRefreshUrl;
                };
                var o = null;
                if (editorCnt.hasClassName("type-14")) { // rte
                    o = new Dynamicweb.Utilities.RteElementObserver(fieldName, el, 0.3, markAsLocal);
                }
                else if (editorCnt.hasClassName("type-4") || editorCnt.hasClassName("type-5")) {
                    var o = new Form.Element.Observer(editorCnt.select("input")[0], 0.3, markAsLocal);
                }
                else {
                    var o = new Form.Element.Observer(el, 0.3, markAsLocal);
                }
                if (o) {
                    var arr = fieldObservers[fieldName];
                    if (!arr) {
                        arr = [];
                        fieldObservers[fieldName] = arr;
                    }
                    arr.push(o);
                }
                if (!editorCnt.hasClassName("rivevt")) {
                    rivEl.on("click", function (e) {
                        fieldObservers[fieldName].invoke("stop");
                        var defVal = rivEl.readAttribute("data-inherited-val");
                        if (editorCnt.hasClassName("type-3")) {
                            editor.checked = defVal.toLowerCase() == "true";
                        }
                        else if (editorCnt.hasClassName("type-4") || editorCnt.hasClassName("type-5")) {                            
                            var date = new Date(Date.parse(defVal, "%Y-%m-%d %H:%M"));
                            //var showsTime = editorCnt.hasClassName("type-5");
                            var datepicker = Dynamicweb.UIControls.DatePicker.get_current();
                            if (datepicker != null && editor != null) {
                                datepicker.UppdateCalendarDate(date, editor.id.replace("_label", ""));
                            }
                        }
                        else if (editorCnt.hasClassName("type-15") && editorCnt.hasClassName("pt-CheckBoxList")) {
                            var dvals = defVal.split(",");
                            editorCnt.select("input[name=" + fieldName + "]").each(function (chbEl) {
                                chbEl.checked = dvals.indexOf(chbEl.value) > -1;
                            });
                        }
                        else if (editorCnt.hasClassName("type-15") && editorCnt.hasClassName("pt-RadioButtonList")) {
                            var arr = editorCnt.select("input[name=" + fieldName + "][value=" + defVal + "]");
                            if (arr && arr.length > 0) {
                                arr[0].checked = true;
                            }
                            else {
                                arr = editorCnt.select("input[name=" + fieldName + "][checked]");
                                if (arr && arr.length > 0) {
                                    arr[0].checked = false;
                                }
                            }
                        }
                        else if (editorCnt.hasClassName("type-14")) { // rte
                            if (typeof (CKEDITOR) != 'undefined') {
                                var rte = CKEDITOR.instances[fieldName];
                                if (rte) {
                                    rte.setData(defVal);
                                }
                            }
                            else if (typeof (FCKeditorAPI) != 'undefined') {
                                var rte = FCKeditorAPI.Instances[fieldName];
                                if (rte) {
                                    rte.SetData(defVal);
                                }
                            }
                        }
                        else {
                            editor.value = defVal;
                        }
                        iiEl.value = "true"
                        row.addClassName("inherited-val");
                        rivEl.src = defaultValRefreshUrl;
                        fieldObservers[fieldName].each(function (obr) {
                            obr.lastValue = obr.getValue();
                            obr.registerCallback();
                        });
                    });
                    editorCnt.addClassName("rivevt");
                }
            });
}