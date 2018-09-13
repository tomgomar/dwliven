<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PimProductVariants.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.PimProductVariants" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeRequireJS="True" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
        </Items>
    </dw:ControlResources>

    <style>
        /* Fix to not hide dropdowns*/
        #B_editable-list-dialog-variantCombinations {
            overflow-x: inherit !important;
            overflow-y: inherit !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="Cmd" name="Cmd" />
        <input type="hidden" id="VariantGroupId" name="VariantGroupId" />
        <input type="hidden" id="VariantGroupList" runat="server" />
        <input type="hidden" id="justCloseDialog" runat="server" value="false" />
        <div>
            <asp:Literal ID="variantData" runat="server" />
        </div>
        <dw:Infobar runat="server" ID="errorMessage" Message="You need to save the product..." Type="Warning" Visible="false" />        
    </form>

    <dw:ContextMenu ID="VariantsContext" runat="server" MaxHeight="500">
    </dw:ContextMenu>

    <dw:Dialog ID="DeleteVariantGroup" Title="Delete variant group" ShowOkButton="true" Size="Medium" ShowCancelButton="true" ShowClose="true" runat="server">
        <div class="delete">
            <p>
                <dw:TranslateLabel Text="Are you sure you want to delete  the variant group?" runat="server" />
            </p>
            <dw:Infobar runat="server" Type="Warning" TranslateMessage="true" Message="If this variant group is deleted then all variants will also be deleted." />
        </div>
    </dw:Dialog>

    <dw:Dialog ID="AddVariantOption" Title="Add new variant option" Size="Small" ShowCancelButton="true" ShowClose="false" runat="server"
        ShowOkButton="true" OkAction="addVariantOptionComplete();" CancelAction="addVariantOptionCancel();">
        <label>
            <dw:TranslateLabel Text="Option name" runat="server" />
        </label>
        <input />
    </dw:Dialog>

    <dw:Overlay ID="ProductEditOverlay" runat="server"></dw:Overlay>

    <script>
        function saveVariants() {
            if (document.getElementById("justCloseDialog") && document.getElementById("justCloseDialog").value.toLowerCase() == 'true' && parent) {
                parent.dialog.hide("VariantsDialog");
            } else {
                var theForm = document.forms["form1"];
                theForm.Cmd.value = "SaveAndClose";

                if (theForm.onsubmit) theForm.onsubmit();
                theForm.submit();
            }
        }

        function addVariantGroup(event) {
            ContextMenu.show(event, 'VariantsContext', '', '', 'BottomRight');
        }

        function deleteVariantGroup(grpID) {
            dialog.show('DeleteVariantGroup');
            dialog.set_okButtonOnclick('DeleteVariantGroup', function () {
                DelVariantGrpLine(grpID);
                dialog.hide('DeleteVariantGroup');
            });
        }

        function DelVariantGrpLine(grpID) {
            var theForm = document.forms["form1"];
            theForm.Cmd.value = "DelVariantGrpProdRelated";
            theForm.VariantGroupId.value = grpID;
            theForm.submit();
        }

        function AddVariantGrpLine(grpID) {
            var theForm = document.forms["form1"];
            theForm.Cmd.value = "AddVariantGrpProdRelated";
            theForm.VariantGroupId.value = grpID;
            theForm.submit();
        }

        $(document).observe('dom:loaded', function () {
            var collectionHelper = Dynamicweb.Utilities.CollectionHelper;
            var typeHelper = Dynamicweb.Utilities.TypeHelper;
            var control = Dynamicweb.Ajax.ControlManager.get_current().findControl('variantCombinations');
            if (!control) {
                return;
            }

            var VALUE_ALL = '_$ALL_',
                TRANSLATION_ALL = '<%=Translate.Translate("All")%>',
                VALIDATION_ERROR = "<%=Translate.JsTranslate("Combinations must be unique!")%>",
                dataColumns,
                makeDirty = function () {
                    //ProductEdit.isDirty = true;  //!!!
                    updateVariantCombinationsText(control.count());
                },
                isRowValid = function (row) {
                    var isValid = true;
                    if (control.findRow(function (x) { return row.get_id() !== x.get_id() && row.compareTo(x); })) {
                        isValid = false;
                    }

                    return isValid;
                },
                validation = function (sender, args) {
                    if (!args.cancel && sender.findRow(function (x) { return args.row.get_id() !== x.get_id() && args.row.compareTo(x); })) {
                        alert(VALIDATION_ERROR);
                        args.cancel = true;
                    }
                };

            updateVariantCombinationsText(control.count());

            dataColumns = collectionHelper.where(control.get_columns(), function (x) { return !typeHelper.isUndefined(x.editor) && typeHelper.isInstanceOf(x.editor, Dynamicweb.Controls.EditableList.Editors.ComboboxEditor); });

            control.add_dialogOpening(function (sender, args) {
                //new one!
                if (args.row.get_id() === '') {
                    collectionHelper.forEach(dataColumns, function (column) {
                        var source, item;

                        item = column.editor.findItem(function (x) { return x.value === VALUE_ALL; });

                        if (!item) {
                            source = column.editor.get_dataSource();
                            source.push({ value: VALUE_ALL, text: TRANSLATION_ALL });
                            column.editor.set_dataSource(source);
                        }
                    });
                } else {
                    collectionHelper.forEach(dataColumns, function (column) {
                        var item;
                        item = column.editor.findItem(function (x) { return x.value === VALUE_ALL; });

                        if (item) {
                            column.editor.removeItem(item);
                        }
                    });
                }
            });

            control.add_rowUpdating(validation);
            control.add_rowCreating(validation);
            control.add_rowCreating(function (sender, args) {
                var properties = args.row.get_properties(),
                    hasAllValue = false,
                    columns = [],
                    column,
                    rows,
                    row,
                    tmp,
                    collect;

                hasAllValue = collectionHelper.any(properties, function (x) { return x === VALUE_ALL });

                if (hasAllValue) {
                    collectionHelper.forEach(properties, function (propValue, propName) {
                        var options,
                            option,
                            column = sender.getColumn(propName);

                        if (column.editor && typeHelper.isFunction(column.editor.get_dataSource)) {
                            options = [];

                            if (propValue === VALUE_ALL) {
                                collectionHelper.forEach(column.editor.findItems(function (i) { return i.value !== VALUE_ALL; }), function (o) {
                                    options.push({ name: column.name, value: o.value });
                                });
                            } else {
                                options.push({ name: column.name, value: column.editor.getItem(propValue).value });
                            }

                            columns.push(options);
                        }
                    });

                    collect = function () {
                        return Dynamicweb.Utilities.CollectionHelper.reduce(arguments, function (a, b) {
                            var ret = [];
                            collectionHelper.forEach(a, function (a) {
                                collectionHelper.forEach(b, function (b) {
                                    ret.push(a.concat([b]));
                                });
                            });
                            return ret;
                        }, [[]]);
                    };

                    tmp = collect.apply(this, columns);
                    rows = [];

                    collectionHelper.forEach(tmp, function (arr) {

                        row = { 'SimpleVariant': false };

                        collectionHelper.forEach(arr, function (o) {
                            row[o.name] = o.value;
                        });
                        if (typeHelper.isUndefined(control.findRow(function (x) { return typeHelper.compare(row, x.get_properties()); }))) {
                            rows.push(row);
                        }
                    });

                    if (collectionHelper.any(rows, function (r) { return !typeHelper.isUndefined(control.findRow(function (x) { return typeHelper.compare(r, x.get_properties()); })); })) {
                        alert(VALIDATION_ERROR);
                    } else {
                        control.addRowRange(rows);
                        setTimeout(function () {
                            sender.get_dialog().cancel();
                        }, 10);
                    }

                    args.cancel = true;
                } else {
                    validation(sender, args);
                }
            });

            control.add_rowCreated(makeDirty);
            control.add_rowUpdated(makeDirty);
            control.add_rowDeleted(makeDirty);
        });

        function updateVariantCombinationsText(count) {
            var span = document.getElementById("varinatCombinationsCount");
            if (span) {
                span.innerHTML = count;
            }
        }

        function addVariantOption(group, param) {
            addVariantOption.dialogID = 'AddVariantOption';

            if(!addVariantOption.dialog) {
                addVariantOption.dialog = $(addVariantOption.dialogID);
            }

            if (!addVariantOption.input) {
                addVariantOption.input = addVariantOption.dialog.select('input')[0];
            }

            addVariantOption.input.value = param.item.text;
            addVariantOption.param = param;
            addVariantOption.group = group;

            if (confirm('<%=Translate.Translate("Variant option does not exist. Do you want to create it?")%>')) {
                dialog.show(addVariantOption.dialogID);
                addVariantOption.input.focus();
            } else {
                param.cancel();
            }
        }
    
        function addVariantOptionComplete() {
            var over = new overlay('ProductEditOverlay');
            if (addVariantOption.param) {

                if (!addVariantOption.input.value) {
                    alert('<%= Translate.Translate("Name can not be empty.")%>')
                    return;
                }

                new Ajax.Request('/Admin/Module/eCom_Catalog/dw7/Edit/EcomUpdator.aspx', {
                    method: 'GET',
                    parameters: {
                        'CMD' : 'CreateVariantOption',
                        'ID' : '<%= ProductIdEncoded%>',
                        'LangID' :'<%=Ecommerce.Common.Context.LanguageID %>',
                        'VariantGroupID' : addVariantOption.group,
                        'VariantOptionName' : addVariantOption.input.value
                    },
                    onCreate: function () {
                        over.show();
                    },
                    onSuccess: function (transport) {
                        if (transport.responseText) {
                            addVariantOption.param.complete({
                                text: addVariantOption.input.value,
                                value: transport.responseText
                            });
                        } else {
                            alert('<%=Translate.Translate("Creation is FAILED.")%>');
                            addVariantOption.param.cancel();
                        }
                    },
                    onFailure: function () {
                        alert('<%=Translate.Translate("Unexpected internal error.")%>');
                        addVariantOption.param.cancel();
                    },
                    onComplete: function () {
                        setTimeout(function() {
                            dialog.hide(addVariantOption.dialogID);
                            over.hide();
                        }, 100);
                    }
                });
            }
        }

        function addVariantOptionCancel() {
            if (addVariantOption.param) {
                dialog.hide(addVariantOption.dialogID);
                addVariantOption.param.cancel();
            }
        }

        function sortVariant(a, b, key) {
            var column,
                option,
                vA = a,
                vB = b,
                helper = Dynamicweb.Utilities.CollectionHelper,
                func = function (v1, v2) {
                    if (v1 > v2) {
                        return 1;
                    }

                    if (v1 < v2) {
                        return -1;
                    }

                    return 0;
                };

            // memorize columns
            if (!sortVariant.cache) {
                sortVariant.cache = new Dynamicweb.Utilities.Dictionary();
                helper.forEach(variantCombinations_EditableList.get_columns(), function (c) {
                    var options;

                    if (c.editorMetadata) {
                        options = new Dynamicweb.Utilities.Dictionary();

                        helper.forEach(c.editorMetadata.options || [], function (o) {
                            options.add(o.value, o);
                        });

                        sortVariant.cache.add(c.name, options);
                    }
                });
            }

            column = sortVariant.cache.get(key);

            if (column) {
                option = column.get(a);

                if (option) {
                    vA = option.text;
                }

                option = column.get(b);

                if (option) {
                    vB = option.text;
                }
            }

            return func(vA, vB);
        }

        function getVariantIcon(variant) {
            var result = '../images/editvariantasprod_small_dim.gif';
            if (variant.get_state() !== Dynamicweb.Controls.EditableList.Enums.ModelState.NEW) {
                if (!variant.get_propertyValue('SimpleVariant')) {
                    result = '../images/editvariantasprod_small.gif';
                }
            }

            return result;
        }

        function openVariant(variant, column) {
        }

    </script>
</body>
</html>
