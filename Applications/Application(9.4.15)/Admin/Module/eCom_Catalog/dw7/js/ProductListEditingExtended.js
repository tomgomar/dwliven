if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = {};
}

if (typeof (Dynamicweb.PIM) == 'undefined') {
    Dynamicweb.PIM = {};
}

var listMode = 'ListView', thumbnail = 'Thumbnail', multiEdit = 'TableView', productEdit = 'ProductEdit', productEditFieldsBulkEdit = "FieldsBulkEdit";

Dynamicweb.PIM.BulkEdit = function () {
    var QueryString = function () {
        // This function is anonymous, is executed immediately and 
        // the return value is assigned to QueryString!
        var query_string = {};
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        for (var i = 0; i < vars.length; i++) {
            var pair = [];
            var index = vars[i].indexOf('=');

            pair.push(vars[i].substring(0, index).toUpperCase())
            pair.push(vars[i].substring(index + 1, vars[i].length))

            // If first entry with this name
            if (typeof query_string[pair[0]] === "undefined") {
                query_string[pair[0]] = decodeURIComponent(pair[1]);
                // If second entry with this name
            } else if (typeof query_string[pair[0]] === "string") {
                var arr = [query_string[pair[0]], decodeURIComponent(pair[1])];
                query_string[pair[0]] = arr;
                // If third or later entry with this name
            } else {
                query_string[pair[0]].push(decodeURIComponent(pair[1]));
            }
        }
        return query_string;
    }();

    var url = new URL(window.location.href);
    if (url.searchParams && url.searchParams.get('TextSearch')) {
        url.searchParams.delete('TextSearch');
        var page = window.location.pathname.split("/").pop();
        var newState = page + "?" + url.searchParams.toString();
        window.history.replaceState({}, document.title, newState);
    }

    this._visibleFieldsLeft = null;
    this._visibleFieldsRight = null;
    this._currentlyEditingRichFieldId = '';
    this._basePath = QueryString.BASEPATH;
    this._groupId = QueryString.GROUPID;
    this._queryId = QueryString.QUERYID;
    this._form = document.forms["Form1"];
    this._missingImagePath = '/Admin/Images/eCom/missing_image.jpg';
    this._getImagePath = '/Admin/Public/GetImage.ashx?width=100&height=66&crop=0&Compression=75&image=';
    this._controlDefinitions = [];
    this._fieldDefinitions = [];

    this._formInitialState = "";
    this._productPrimaryGroup = "";
    this.terminology = {};
    this.confirmAction = { Name: "OpenDialog", Url: "/Admin/CommonDialogs/Confirm?Caption=Confirm%20Action" };
    this.openScreenAction = { Name: "OpenScreen", Url: location.pathname + location.search };
    this._viewMode = window.top.pimSelectedMode;
    this._approvalState = 0;
    this.currentAttachGroupDialog = null;
    this._currentVariantCombination = QueryString.VARIANTID;
    this._checkUnloadChanges = true;
};

Dynamicweb.PIM.BulkEdit._instance = null;

Dynamicweb.PIM.BulkEdit.get_current = function () {
    if (!Dynamicweb.PIM.BulkEdit._instance) {
        Dynamicweb.PIM.BulkEdit._instance = new Dynamicweb.PIM.BulkEdit();
    }

    return Dynamicweb.PIM.BulkEdit._instance;
};

Dynamicweb.PIM.BulkEdit.prototype.initialize = function (options) {
    var self = this;
    self.options = options
    if (options) {
        self._viewMode = options.viewMode || self._viewMode;
        self._fieldDefinitions = (options.fieldDefinitions && options.fieldDefinitions) || self._fieldDefinitions;
        self.openScreenAction = (options.actions && options.actions.openScreen) || window.openScreenAction || self.openScreenAction;
        self.confirmAction = (options.actions && options.actions.confirm) || window.confirmAction || self.confirmAction;
    }
    if (options.approvalState) {
        self._approvalState = options.approvalState;
    }
    this._formInitialState = this._getFormValues();
    this._controlDefinitions = this._createControlDefinitions();

    self.initializeFieldsBulkEdit();
    if (self._viewMode == productEditFieldsBulkEdit) {
        return;
    }

    var relatedGroupIdHidenField = $('PrimaryRelatedGroup');
    if (relatedGroupIdHidenField) {
        self._productPrimaryGroup = $('PrimaryRelatedGroup').value;
    }

    var sortByField = $("SortBy");
    if (sortByField) {
        sortByField.on("change", function () { self.sortProducts(); });
    }

    var sortOrderField = $("SortOrder");
    if (sortOrderField) {
        sortOrderField.on("change", function () { self.sortProducts(); });
    }

    if (self._viewMode == productEdit) {
        window.onbeforeunload = function (e) {
            return self._checkUnloadChanges && Dynamicweb.PIM.BulkEdit.get_current().checkFormChanged() || null;
        };
    }

    this._controlDefinitions.filter(function (definition, index, self) {
        return definition.controlType == "EditorText";
    }).forEach(function (definition) {
        var fieldDefinition = definition;
        var editor = $(definition.controlId);
        var onchange = function () {
            $(fieldDefinition.controlId.substring(0, fieldDefinition.controlId.length - "_editor".length)).value = editor.innerHTML;
        };

        editor.addEventListener("blur", onchange);
        editor.addEventListener("keyup", onchange);
        editor.addEventListener("paste", onchange);
        editor.addEventListener("copy", onchange);
        editor.addEventListener("cut", onchange);
        editor.addEventListener("delete", onchange);
        editor.addEventListener("mouseup", onchange);
    });

    if (window.CKEDITOR) {
        for (var i in CKEDITOR.instances) {
            (function (i) {
                var editor = CKEDITOR.instances[i];
                editor.on("instanceReady", function () {
                    //set base z-index greater then dialog z-index
                    editor.config.baseFloatZIndex = 1500;

                    // Replace the old save's exec function with the new one
                    var overrideCmd = new CKEDITOR.command(editor, {
                        exec: function (editor) { self.updateEditorField(editor); }
                    });
                    editor.commands.save.exec = overrideCmd.exec;
                });
                editor.on('blur', function () {
                    var editorContainer = editor.container.$.up("div.pcm-editor");
                    if (editorContainer) {
                        editorContainer.removeClassName("focused");
                    }
                    self.disableEditorToolbar(editor);
                });
                editor.on('focus', function () {
                    var editorContainer = editor.container.$.up("div.pcm-editor");
                    if (editorContainer) {
                        editorContainer.addClassName("focused");
                    }
                    self.enableEditorToolbar(editor);
                });
            })(i);
        }
    }

    const listContainer = $("listContainer");
    if (listContainer && window.imagePopupPreview && typeof (imagePopupPreview) == "function") {
        const imgPreviewObj = imagePopupPreview(300, 300, "/Admin/Images/eCom/missing_image.jpg");

        listContainer.on('click', ".image-menu-expand-button", function (e, element) {
            if (element.parentElement != null && element.parentElement.nextElementSibling != null) {
                if (element.parentElement.nextElementSibling.classList.contains("image-block")) {
                    let imageElement = element.parentElement.nextElementSibling
                    imgPreviewObj.setPosition(e.pageX, e.pageY);
                    let imgUrl = imageElement.readAttribute("data-image-path");
                    let title = imageElement.readAttribute("data-title");
                    imgPreviewObj.show(imgUrl, "", title || "");
                }
            }
        });

        listContainer.on('mouseover', ".image-cnt", function (e, element) {
            let imageMenu = element.getElementsByClassName("image-menu")[0];
            if (imageMenu) {
                imageMenu.style.display = 'block';
            }
        });

        listContainer.on('mouseout', ".image-cnt", function (e, element) {
            let imageMenu = element.getElementsByClassName("image-menu")[0];
            if (imageMenu) {
                if (e.toElement != null && (!e.toElement.classList.contains("image-menu") && (!e.toElement.parentElement.classList.contains("image-menu-button-container") && !e.toElement.parentElement.classList.contains("image-menu")))) {
                    //Show the image menu
                    imageMenu.style.display = 'none';
                }
            }
            imgPreviewObj.hide();
        });

        // related products
        const showPopupFunction = dwGlobal.debounce(function (imgUrl, title) {
            imgPreviewObj.show(imgUrl, "", title | "");
        }, 400);

        listContainer.on('mouseover', ".related-product-container > .image-block", function (e, element) {
            let imageElement = element;
            imgPreviewObj.setPosition(e.pageX, e.pageY);
            let imgUrl = imageElement.readAttribute("data-image-path");
            let title = imageElement.readAttribute("data-title");
            showPopupFunction(imgUrl, title);
        });

        listContainer.on('mouseout', ".related-product-container > .image-block", function (e, element) {
            imgPreviewObj.hide();
        });
    }
    if (self._viewMode != productEdit) {
        var selectedProducts = self.getSelectedProducts();
        if (selectedProducts.length > 0) {
            self._enableRibbonButtons();
        }
    }

    this.handleScrollAndFocus();
};

Dynamicweb.PIM.BulkEdit.prototype.initializeFieldsBulkEdit = function () {
    var self = this;
    var treeNodeOpeners = $$(".open-btn");
    if (treeNodeOpeners.length) {
        treeNodeOpeners.forEach(function (opener) {
            opener.on('click', function (e) {
                var innerList = opener.parentElement.next("ul");
                innerList.toggleClassName("hidden");
                if (innerList.hasClassName("hidden")) {
                    opener.removeClassName("fa-caret-down");
                    opener.addClassName("fa-caret-right");
                } else {
                    opener.removeClassName("fa-caret-right");
                    opener.addClassName("fa-caret-down");
                }

                if (e) {
                    if (typeof (e.cancelBubble) != 'undefined')
                        e.cancelBubble = true;
                    else if (typeof (e.stopPropagation) == 'function')
                        e.stopPropagation();
                }
            });
        });
    }
    if (window.dwGrid_FieldsGrid) {
        dwGrid_FieldsGrid.onRowAddedCompleted = self._updateFieldsGridRow;
    }
}

Dynamicweb.PIM.BulkEdit.prototype._createControlDefinitions = function () {
    var defs = (this.options && this.options.controlDefinitions) || window.controlRows || [];
    var controlDefinitions = [];
    defs.forEach(function (column) { controlDefinitions = controlDefinitions.concat(column); });
    return controlDefinitions;
}

Dynamicweb.PIM.BulkEdit.prototype.handleScrollAndFocus = function () {
    if (this._viewMode != multiEdit && this._viewMode != productEdit) {
        if (this._viewMode != productEdit) {
            this.setScrollCoordinates(null);
        }
        return;
    }
    // Get saved scroll position
    var list = $("listContainer");
    var header = $$(".pcm-wrap-header")[0];
    var scrollCoordinates = this.getScrollCoordinates();

    var self = this;
    if (this._viewMode == productEdit) {
        list.on('scroll', function () {
            header.scrollLeft = list.scrollLeft;

            dwGlobal.debounce(function () {
                self.setScrollCoordinates({ top: list.scrollTop, left: list.scrollLeft });
            }, 250)();
        });
    }

    var url = new URL(window.location.href);
    var focusableControl = null;

    // Set focus on Variant edit form if extended variant was created
    if (this.extendedVariantWasCreated()) {
        var variantContainers = $$(".variant-item-container");
        var productId = url.searchParams.get("ID");
        var languages = this.getViewLanguages();
        var languageId = languages[0];
        for (var i = 0; i < variantContainers.length; i++) {
            var variantId = variantContainers[i].readAttribute("data-variant-id");
            for (var j = 0; j < this._fieldDefinitions.length; j++) {
                var fieldDefiniton = this._fieldDefinitions[j];
                var controlId = this.getControlId(productId, variantId, languageId, fieldDefiniton.fieldId, fieldDefiniton.type);
                var controlDefinition = this._controlDefinitions.find(function (definition) { return definition.controlId == controlId; });
                if ($(controlId) && controlDefinition && this.canBeFocused(controlDefinition)) {
                    focusableControl = controlDefinition;
                    break;
                }
            }
            if (focusableControl) {
                break;
            }
        }
        if (focusableControl) {
            this.setFocusOnField(focusableControl);
        }

        return;
    }

    // Set focus on field with error
    if (this.formHasErrors()) {
        for (var i = 0; i < this._controlDefinitions.length; i++) {
            var controlDefinition = this._controlDefinitions[i];
            if (controlDefinition.hasError && this.canBeFocused(controlDefinition)) {
                focusableControl = controlDefinition;
                break;
            }
        }
        if (focusableControl) {
            this.setFocusOnField(focusableControl);
        }

        return;
    }

    if (this._viewMode != productEdit) {
        return;
    }

    // Set scroll position
    var variantsContainer = $$(".pcm-list-item.variant");
    if (!!window.top.navigateToVariants && variantsContainer.length > 0) { // Scroll to variants container after clicking in variant tree
        window.top.navigateToVariants = null;
        variantsContainer[0].scrollIntoView();
    } else if (scrollCoordinates) { // Scroll to saved position
        list.scrollTop = scrollCoordinates.top;
        list.scrollLeft = scrollCoordinates.left;
    }

    // Find focusable control in view port
    var fieldInViewport = function (elem) {
        var containerLocation = $("listContainer").getBoundingClientRect();
        var elementLocation = elem.getBoundingClientRect();
        return elementLocation.left > containerLocation.left && elementLocation.top > containerLocation.top &&
            elementLocation.right < containerLocation.right && elementLocation.bottom < containerLocation.bottom;
    }

    for (var i = 0; i < this._controlDefinitions.length; i++) {
        var controlDefinition = this._controlDefinitions[i];
        var field = this.getFieldByControlDefinition(controlDefinition);
        if (!field) {
            continue;
        }
        if (this.canBeFocused(controlDefinition) && fieldInViewport(field)) {
            field.focus();
            break;
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.getScrollCoordinates = function () {
    return window.top.scrollCoordinates || null;
};

Dynamicweb.PIM.BulkEdit.prototype.setScrollCoordinates = function (point) {
    window.top.scrollCoordinates = point;
};

Dynamicweb.PIM.BulkEdit.prototype.canBeFocused = function (controlDefinition) {
    switch (controlDefinition.controlType) {
        case "Text":
        case "TextLong":
        case "EditorText":
        case "Integer":
        case "Double":
        case "Select":
        case "MultiSelectList":
        case "RadioButtonList":
        case "CheckBoxList":
        case "Link":
            return !this.isFieldEditorReadonly(controlDefinition);
    }
    return false;
};

Dynamicweb.PIM.BulkEdit.prototype.getFieldByControlDefinition = function (controlDefinition) {
    var field = null;
    switch (controlDefinition.controlType) {
        case "CheckBoxList":
        case "RadioButtonList":
        case "MultiSelectList":
        case "Select":
            var elements = $$("[name=" + controlDefinition.controlId + "]");
            if (elements.length > 0) {
                field = elements[0];
            }
            break;

        case "Text":
        case "TextLong":
        case "EditorText":
        case "Integer":
        case "Double":
        case "Link":
            field = $(controlDefinition.controlId);
            break;
    }
    return field;
};

Dynamicweb.PIM.BulkEdit.prototype.setFocusOnField = function (controlDefinition) {
    var field = this.getFieldByControlDefinition(controlDefinition)
    if (field) {
        // Expand GroupBox
        var groupbox = $(controlDefinition.controlId).up(".groupbox");
        if (groupbox && Dynamicweb.Utilities.GroupBox.isCollapsed(groupbox)) {
            Dynamicweb.Utilities.GroupBox.toggleCollapse(groupbox, true);
        }

        field.focus();
    }
};

Dynamicweb.PIM.BulkEdit.prototype.extendedVariantWasCreated = function () {
    var url = new URL(window.location.href);
    var variantContainers = $$(".variant-item-container");
    var makeExtendedVariant = url.searchParams.get("makeExtendedVariant");
    return !!makeExtendedVariant && makeExtendedVariant.toLowerCase() == "true" && variantContainers.length > 0;
};

Dynamicweb.PIM.BulkEdit.prototype.formHasErrors = function () {
    for (var i = 0; i < this._controlDefinitions.length; i++) {
        if (this._controlDefinitions[i].hasError) {
            return true;
        }
    }

    return false;
};

Dynamicweb.PIM.BulkEdit.prototype._getFormValues = function () {
    return $$("#pim-hidden-fields input:not([id='Cmd']):not([id='categoryFields']), #listContainer input:not([id$='_datepicker'])").map(function (element) { return element.value; }).join();
};

Dynamicweb.PIM.BulkEdit.prototype.checkFormChanged = function () {
    return this._getFormValues() != this._formInitialState;
};

Dynamicweb.PIM.BulkEdit.prototype.submitFormWithCommand = function (command, checkChanges) {
    $('Cmd').value = command;
    this._checkUnloadChanges = !!checkChanges;
    this._form.submit();
};

Dynamicweb.PIM.BulkEdit.prototype.save = function (close) {
    this.submitFormWithCommand(close ? "SaveAndClose" : "Save");
};

Dynamicweb.PIM.BulkEdit.prototype.changePageIndex = function (pageNumber) {
    var pageNumberhidden = $("PageNumber");
    pageNumberhidden.value = pageNumber || pageNumberhidden.value + 1;
    this.submitFormWithCommand("ChangePageIndex");
};

Dynamicweb.PIM.BulkEdit.prototype.cancel = function () {
    this.submitFormWithCommand("Cancel");
};

Dynamicweb.PIM.BulkEdit.prototype.switchViewMode = function (mode) {
    var url = this.getListViewUrl(mode);
    window.top.pimSelectedMode = mode;
    openScreenAction.Url = url;
    Action.Execute(openScreenAction);
};

Dynamicweb.PIM.BulkEdit.prototype.getListViewUrl = function (mode) {
    var url = '/Admin/Module/eCom_Catalog/dw7/PIM/PimProductList.aspx?ViewMode=' + mode;
    if (mode == "TableView") {
        url = '/Admin/Module/eCom_Catalog/dw7/PIM/PimMultiEdit.aspx?FromPIM=True';
    }
    if (this._queryId) {
        url += '&QueryID=' + this._queryId + '&groupID=' + this._groupId;
    } else if (this._groupId) {
        url += '&GroupID=' + this._groupId;
    }
    if (this._basePath) {
        url += '&BasePath=' + this._basePath;
    }
    var pageNumber = $("PageNumber");
    var pageSize = $("PageSize");

    if (pageNumber && pageSize) {
        url += '&PreviousViewPageNumber=' + (pageNumber.value || 1);
        url += '&PreviousViewPageSize=' + pageSize.value;
    }

    var searchApplied = $('SearchApplied');
    if (searchApplied && searchApplied.value == '1') {
        var searchBox = $('TextSearch');
        if (searchBox && searchBox.value.trim().length > 0) {
            url += '&TextSearch=' + searchBox.value;
        }
    }
    return url;
}

Dynamicweb.PIM.BulkEdit.prototype.getViewLanguages = function () {
    var languages = $("viewLanguages").value.split(",");
    return languages;
};

Dynamicweb.PIM.BulkEdit.prototype.setViewLanguages = function (languages) {
    $("viewLanguages").value = languages.join();
};

Dynamicweb.PIM.BulkEdit.prototype.changeLanguages = function (languageId) {
    //var languages = "";
    //var addEventLanguage = true;
    //var langIndex = "chk_LanguageCheckbox_".length;
    //var container = e.element().up("table.section");

    //container.select("input[id^='chk_LanguageCheckbox_']").each(function (element) {
    //    if (element.value == 'true' || element.value == 'True') {
    //        var languageId = element.id.substring(langIndex);
    //        if (languageId) {
    //            languages += languageId + ",";
    //        }
    //    }
    //});
    var languages = this.getViewLanguages();
    var languagePosition = languages.indexOf(languageId);
    if (languagePosition == -1) {
        languages.push(languageId);
    } else {
        languages.splice(languagePosition, 1);
    }
    this.setViewLanguages(languages);

    this.submitFormWithCommand("ChangeLanguages");
};

Dynamicweb.PIM.BulkEdit.prototype.changeFields = function () {
    $("viewFields").value = SelectionBox.getElementsRightAsArray("ViewFieldList").join();
    this._visibleFieldsLeft = null;
    this._visibleFieldsRight = null;

    this.setScrollCoordinates(null);
    this.submitFormWithCommand("ChangeFields");
};

Dynamicweb.PIM.BulkEdit.prototype.openVisibleFields = function (dialogId) {
    if (this._visibleFieldsLeft && this._visibleFieldsRight) {
        var left = new Array();
        var right = new Array();

        for (var i = 0; i < this._visibleFieldsLeft.length; i++) {
            left.push({ Name: this._visibleFieldsLeft[i].text, Value: this._visibleFieldsLeft[i].value });
        }
        for (var i = 0; i < this._visibleFieldsRight.length; i++) {
            right.push({ Name: this._visibleFieldsRight[i].text, Value: this._visibleFieldsRight[i].value });
        }

        SelectionBox.fillLists(JSON.stringify({ left: left, right: right }), 'ViewFieldList');
    } else {
        this._visibleFieldsLeft = SelectionBox.getElementsLeftAsOptionArray('ViewFieldList');
        this._visibleFieldsRight = SelectionBox.getElementsRightAsOptionArray('ViewFieldList');
    }

    dialog.show(dialogId);
};

Dynamicweb.PIM.BulkEdit.prototype.sortProducts = function () {
    if (this._checkSortByField()) {
        this._form.submit();
    }
}

Dynamicweb.PIM.BulkEdit.prototype._checkSortByField = function () {
    var sortBy = $("SortBy");
    if (!sortBy) {
        return false;
    }
    if (!sortBy.value) {
        sortBy.focus();
        return false;
    }
    return true;
};

Dynamicweb.PIM.BulkEdit.prototype.getSelectedProducts = function () {
    if (this._viewMode != listMode) {
        return $$("input[id^='SelectedProductCheckbox']:checked").map(function (checkbox) { return checkbox.value; });
    } else {
        return List.getSelectedRows('ProductList').map(function (row) { return row.getAttribute("itemid"); });
    }
}

Dynamicweb.PIM.BulkEdit.prototype.productListItemSelected = function () {
    var self = this;
    var selectedProducts = self.getSelectedProducts();
    if (selectedProducts.length > 0) {
        self._enableRibbonButtons();
    } else {
        self._disableRibbonButtons();
    }
};

Dynamicweb.PIM.BulkEdit.prototype.selectVariantProduct = function (element, id) {
    $$("input[id^='SelectedProductCheckbox" + id + "']").forEach(function (checkbox) { checkbox.checked = element.checked; });

    var lastIndexOfVariantSeparator = id.lastIndexOf('.');
    if (id && lastIndexOfVariantSeparator != -1) {
        var variantGroupCheckBoxId = id.substring(0, lastIndexOfVariantSeparator);
        $("SelectedProductCheckbox" + variantGroupCheckBoxId).checked = $$("input[id^='SelectedProductCheckbox" + variantGroupCheckBoxId + ".']").every(function (checkbox) { return checkbox.checked });
    }
};

Dynamicweb.PIM.BulkEdit.prototype.updateChildTreeNodesCheckboxes = function (element, id) {
    let childCheckboxes = element.closest(".list-item").nextElementSibling.querySelectorAll("li>.list-item .checkbox");
    for (let i = 0; i < childCheckboxes.length; i++) {
        let checkbox = childCheckboxes[i];
        checkbox.checked = element.checked;
    }
    this.recalcParentNodeState(childCheckboxes[0]);
};

Dynamicweb.PIM.BulkEdit.prototype.recalcParentNodeState = function (element) {
    let listItems = element.closest(".list");
    let checkbox = listItems.parentElement.querySelector(".list-item .checkbox");
    let label = listItems.parentElement.querySelector(".list-item label.node-title");
    let childCheckboxes = listItems.querySelectorAll("ul>li>.list-item .checkbox");
    let count = 0;
    for (let i = 0; i < childCheckboxes.length; i++) {
        let checkbox = childCheckboxes[i];
        if (checkbox.checked) {
            count++;
        }
    }
    checkbox.checked = count > 0;
    let tpl = label.readAttribute("title-tpl");
    label.innerHTML = Action.Transform(tpl, { count: count });
}

Dynamicweb.PIM.BulkEdit.prototype.selectProduct = function (element, id) {
    var self = this;
    if (self._viewMode != listMode) {
        $$("input[id^='SelectedProductCheckbox" + id + "']").forEach(function (checkbox) { checkbox.checked = element.checked; });

        if (id) {
            $("SelectAll").checked = $$("input[id^='SelectedProductCheckbox']").every(function (checkbox) { return checkbox.checked });
        }
    }

    var selectedProducts = self.getSelectedProducts();
    if (selectedProducts.length > 0) {
        self._enableRibbonButtons();
    } else {
        self._disableRibbonButtons();
    }
};

Dynamicweb.PIM.BulkEdit.prototype._disableRibbonButtons = function () {
    BulkEdit.addClassName("disabled");
    BulkEdit.stopObserving('click');
    btnAttachMultipleProducts.addClassName("disabled");
    btnAttachMultipleProducts.stopObserving('click');
    btnPublishMultipleProducts.addClassName("disabled");
    btnPublishMultipleProducts.stopObserving('click');
};

Dynamicweb.PIM.BulkEdit.prototype._enableRibbonButtons = function () {
    this._enableBulkEditRibbonButton();
    this.enableAttachProductsRibbonButtons();
};

Dynamicweb.PIM.BulkEdit.prototype._enableBulkEditRibbonButton = function () {
    var self = this;
    BulkEdit.removeClassName("disabled");
    BulkEdit.on("click", function () {
        let selectedProducts = self.getSelectedProducts();
        self.productsFieldsBulkEdit(selectedProducts);
    });
};

Dynamicweb.PIM.BulkEdit.prototype.enableAttachProductsRibbonButtons = function () {
    var self = this;
    btnAttachMultipleProducts.removeClassName("disabled");
    btnAttachMultipleProducts.on("click", function () {
        self.currentAttachGroupDialog = "ProductWarehouseOnly";
        dialog.setTitle("AddGroupsDialog", self.terminology["AddPimGroup"] || "Add to PIM warehouse group");
        dialog.show('AddGroupsDialog', "/Admin/Module/Ecom_Catalog/dw7/edit/EcomGroupTree.aspx?shopsToShow=ProductWarehouseOnly&CMD=ShowGroupRel&caller=parent.document.getElementById('Form1').GroupsToAdd");
    });
    btnPublishMultipleProducts.removeClassName("disabled");
    btnPublishMultipleProducts.on("click", function () {
        self.currentAttachGroupDialog = "ShopOnly";
        dialog.setTitle("AddGroupsDialog", self.terminology["AddEcomGroup"] || "Publish to Ecom group");
        dialog.show('AddGroupsDialog', "/Admin/Module/Ecom_Catalog/dw7/edit/EcomGroupTree.aspx?shopsToShow=ShopOnly&CMD=ShowGroupRel&caller=parent.document.getElementById('Form1').GroupsToAdd");
    });
};

Dynamicweb.PIM.BulkEdit.prototype.getMultiEditLanguageCheckboxes = function (onlyChecked) {
    var languageCheckboxes = null;
    if (onlyChecked) {
        languageCheckboxes = $$("[name$='MultiEditLanguages']:checked");
    }
    else {
        languageCheckboxes = $$("[name$='MultiEditLanguages']");
    }
    return languageCheckboxes;
};

Dynamicweb.PIM.BulkEdit.prototype.selectMultiEditLanguage = function (selectAll) {
    var languageCheckboxes = this.getMultiEditLanguageCheckboxes();
    var allLanguagesCheckbox = languageCheckboxes.shift();
    if (selectAll) {
        languageCheckboxes.forEach(function (checkbox) { checkbox.checked = allLanguagesCheckbox.checked; });
    } else {
        allLanguagesCheckbox.checked = languageCheckboxes.every(function (checkbox) { return checkbox.checked; });
    }
};

Dynamicweb.PIM.BulkEdit.prototype.openEditor = function (currentFieldId, fieldName) {
    var fieldIdParts = currentFieldId.split("_;_");
    function setEditorStateFunction(editor, disabled, currentlyActive) {
        return function () {
            var editorContainer = editor.container.$.up("div.pcm-editor");
            editorContainer.removeClassName("focused");
            if (currentlyActive && !disabled) {
                editorContainer.addClassName("focused");
            }
            editor.setReadOnly(disabled);
            if (disabled) {
                editor.commands["source"].disable();
                setTimeout(function () { editor.document.$.body.style = "color: rgb(170, 170, 170);background-color: whitesmoke;"; }, 100);
            }
        };
    }

    var fieldLangId = fieldIdParts[2];

    var languages = this.getViewLanguages();
    for (var i = 0; i < languages.length; i++) {
        var editorId = "editor" + languages[i];
        var editor = CKEDITOR.instances[editorId];
        var fieldId = [fieldIdParts[0], fieldIdParts[1], languages[i], fieldIdParts[3]].join("_;_");
        var disabled = $(fieldId + "_editor").classList.contains("disabled");
        var isCurrentEditor = fieldLangId.toLowerCase() == languages[i].toLowerCase();
        if (!disabled && isCurrentEditor) {
            editor.setData($(fieldId).value, function () {
                this.focus();
            });
            this.enableEditorToolbar(editor);
        } else {
            editor.setData($(fieldId).value);
            this.disableEditorToolbar(editor);
        }
        if (editor.document) {
            (setEditorStateFunction(editor, disabled, isCurrentEditor))();
        }
        else {
            editor.on('instanceReady', setEditorStateFunction(editor, disabled, isCurrentEditor));
        }
    }

    this._currentlyEditingRichFieldId = currentFieldId;
    dialog.setTitle("EditorDialog", fieldName);
    dialog.show("EditorDialog");
};

Dynamicweb.PIM.BulkEdit.prototype.updateEditorField = function (editor) {
    var fieldIdParts = this._currentlyEditingRichFieldId.split("_;_");
    var languages = this.getViewLanguages();
    for (var i = 0; i < languages.length; i++) {
        var editorId = "editor" + languages[i];
        if (!editor || (editor && editor.name == editorId)) { // If editor is not defined - save all, otherwise - save only specified editor
            var fieldId = [fieldIdParts[0], fieldIdParts[1], languages[i], fieldIdParts[3]].join("_;_");
            var disabled = $(fieldId + "_editor").classList.contains("disabled");

            if (!disabled) {
                var fieldValue = CKEDITOR.instances[editorId].getData();
                $(fieldId).value = fieldValue;
                $(fieldId + "_editor").innerHTML = fieldValue;
            }
            if (editor) {
                break;
            }
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype.closeEditorDialog = function () {
    this.updateEditorField();
    dialog.hide("EditorDialog");
};

Dynamicweb.PIM.BulkEdit.prototype.enableEditorToolbar = function (editor) {
    for (var commnad in editor.commands) {
        editor.commands[commnad].enable();
    }
};

Dynamicweb.PIM.BulkEdit.prototype.disableEditorToolbar = function (editor) {
    for (var commnad in editor.commands) {
        editor.commands[commnad].disable();
    }
};

Dynamicweb.PIM.BulkEdit.prototype.getControlId = function (productId, variantId, languageId, fieldId, fieldType) {
    var arr = [productId, variantId, languageId, fieldId];
    var id = arr.join("_;_");
    switch (fieldType) {
        case "EditorText":
            id += "_editor";
            break;
        case "Date":
        case "DateTime":
            id += "_label";
            break;
        case "Filemanager":
            id = "FM_" + id;
            break;
        case "Link":
            id = "Link_" + id;
            break;
    }
    return id;
};

Dynamicweb.PIM.BulkEdit.prototype.updateVariantFields = function (fieldUpdateFn) {
    var selected = $$("input[id^='SelectedProductCheckbox']:checked:not([value='none'])").map(function (checkbox) { return checkbox.value; });
    this.updateFields(selected, fieldUpdateFn);
}

Dynamicweb.PIM.BulkEdit.prototype.updateFields = function (selectedProductIds, fieldUpdateFn) {
    var self = this;
    var selectedProducts = (selectedProductIds || self.getSelectedProducts()).uniq();
    var editedFields = self._getFieldsFromGrid();

    var selectedLanguages = self.getMultiEditLanguageCheckboxes(true).map(function (languageCheckbox) {
        return languageCheckbox.value;
    });

    if (!selectedLanguages.length || selectedLanguages.indexOf("AllLanguages") > -1) {
        // nothing languages selected mean that all items selected
        selectedLanguages = self.getMultiEditLanguageCheckboxes().map(function (languageCheckbox) {
            return languageCheckbox.value;
        });
    }
    var allIdx = selectedLanguages.indexOf("AllLanguages");
    if (allIdx > -1) {
        selectedLanguages.splice(allIdx, 1);
    }
    let getControlInfo = null;
    if (self.options.viewMode == productEditFieldsBulkEdit) {
        getControlInfo = function (productId, variantId, languageId, fieldId, fieldType) {
            const controlId = self.getControlId(productId, variantId, languageId, fieldId, fieldType);
            return {
                controlId: controlId,
                controlType: fieldType
            };
        };
    }
    else {
        let ctrlDefIdx = {};
        self._controlDefinitions.each(function (item) {
            ctrlDefIdx[item.controlId] = item;
        });
        getControlInfo = function (productId, variantId, languageId, fieldId, fieldType) {
            const controlId = self.getControlId(productId, variantId, languageId, fieldId, fieldType);
            const fieldDefinition = ctrlDefIdx[controlId];
            return fieldDefinition;
        };
    }

    var documentFragment = document.createDocumentFragment();

    for (var k = 0; k < editedFields.length; k++) {
        var editedFieldObj = editedFields[k];
        for (var i = 0; i < selectedProducts.length; i++) {
            var arr = selectedProducts[i].split("_;_");
            var prodId = arr[0];
            var varId = "";
            if (arr.length > 1) {
                varId = arr[1];
            }
            for (var j = 0; j < selectedLanguages.length ; j++) {
                const langId = selectedLanguages[j];
                const fieldDefinition = getControlInfo(prodId, varId, langId, editedFieldObj.key, editedFieldObj.fieldType);
                fieldUpdateFn(fieldDefinition, editedFieldObj, documentFragment);
            }
        }
    }

    this.getForm().appendChild(documentFragment);
};

Dynamicweb.PIM.BulkEdit.prototype.getEditedFields = function () {
    var self = this;
    var editedFields = self._getFieldsFromGrid();

    return editedFields;
};

Dynamicweb.PIM.BulkEdit.prototype.isFieldEditorReadonly = function (fieldDifinition) {
    var isReadonly = false;
    switch (fieldDifinition.controlType) {
        case "Select":
        case "MultiSelectList":
            var fields = document.getElementsByName(fieldDifinition.controlId);
            isReadonly = fields.length == 0 || fields[0].hasClassName("disabled") || fields[0].disabled;
            break;
        case "RadioButtonList":
        case "CheckBoxList":
            var fields = document.getElementsByName(fieldDifinition.controlId);
            isReadonly = fields.length == 0 || fields[0].hasClassName("disabled") || fields[0].disabled;
            break;
        default:
            var el = document.getElementById(fieldDifinition.controlId);
            isReadonly = el.hasClassName("disabled") || el.disabled;
            break;
    }

    return isReadonly;
};

Dynamicweb.PIM.BulkEdit.prototype._createHidden = function (frm, controlId, value) {
    var el = document.getElementsByName(controlId);
    if (!el.length) {
        el = document.createElement('input');
        el.type = 'hidden';
        el.name = controlId;
        frm.appendChild(el);
    }
    el.value = value;
};

Dynamicweb.PIM.BulkEdit.prototype.createMultiEditHiddenField = function (fieldDefinition, updatedValue, documentFragment) {
    if (!fieldDefinition) {
        return;
    }
    var controlId = fieldDefinition.controlId;
    switch (fieldDefinition.controlType) {
        case "Date":
        case "DateTime":
            var tmpVal = updatedValue && updatedValue.value ? updatedValue.value : "";
            if (tmpVal.length > 4 && tmpVal.substr(0, 4) === "2999") {
                tmpVal = "";
            }
            updatedValue.value = tmpVal;
            controlId = controlId.substring(0, controlId.length - "_label".length);
            break;
        case "EditorText":
            controlId = controlId.substring(0, controlId.length - "_editor".length);
            break;
        case "Filemanager":
            controlId = controlId.substring("FM_".length);
            break;
    }
    this._createHidden(documentFragment, controlId, updatedValue.value);
};

Dynamicweb.PIM.BulkEdit.prototype._setFileManageControlValue = function (controlId, value) {
    var valEl = document.getElementById(controlId);
    var relPath = "";
    var path = "";
    if (value) {
        relPath = value;
        path = "/Files" + value;
    }

    if (valEl.options) {
        valEl.selectedIndex = _findOptionOrCreate(valEl, relPath, path);
    } else {
        valEl.value = path;
    }
    _fireEvent(valEl, "change");
};

Dynamicweb.PIM.BulkEdit.prototype._getFieldsFromGrid = function () {
    var self = this;
    var editedFields = dwGrid_FieldsGrid.rows.getAll().map(function (row) {
        var fieldSelector = row.element.select("select[id$='Fields']")[0];
        var id = fieldSelector.value;
        var label = fieldSelector.select("option[value='" + id + "']")[0].innerHTML.trim();
        var fieldType = self._getControlType(id);

        var editorcontainer = null;
        for (var i = 0; i < row.element.children[1].children.length; i++) {
            var container = row.element.children[1].children[i];
            if (container.tagName === "DIV") {
                if (!!self._getFieldsGridEditor(fieldType, container)) {
                    editorcontainer = container;
                    break;
                }
            }
        }
        if (!editorcontainer) {
            editorcontainer = row.element.children[1].firstElementChild;
        }

        var value = self._getEditorValue(editorcontainer, fieldType);

        return { key: id, value: value, fieldType: fieldType, label: label };
    });

    return editedFields;
};

Dynamicweb.PIM.BulkEdit.prototype._getControlType = function (controlId) {
    var self = this;
    var controlType = "Text";

    var controlDifinition = self._getControlDefinition(controlId);

    if (controlDifinition && controlDifinition.controlType) {
        controlType = controlDifinition.controlType;
    }

    return controlType;
};

Dynamicweb.PIM.BulkEdit.prototype._getControlDefinition = function (controlId) {
    var self = this;
    return self._controlDefinitions.find(function (definition, index) {
        return definition.controlType == "EditorText" ? self._controlIdEndsWith(definition.controlId, controlId + "_editor") : self._controlIdEndsWith(definition.controlId, controlId);
    });
};

Dynamicweb.PIM.BulkEdit.prototype._controlIdEndsWith = function (controlId, searchString) {
    var lastIndex = controlId.lastIndexOf(searchString);

    //Value not found
    if (lastIndex == -1) {
        return false;
    }

    //The value is found in the end of the controlId
    if (controlId.length == (lastIndex + searchString.length)) {
        return true;
    }

    return false;

};

Dynamicweb.PIM.BulkEdit.prototype._getEditorValue = function (editorContainer, fieldType) {
    switch (fieldType) {
        case "Filemanager":
            return editorContainer.select("[id$='FM_" + fieldType + "FieldEditor']")[0].value;
        case "Date":
        case "DateTime":
            if (editorContainer.select("[id$='" + fieldType + "FieldEditor_notSet']")[0].value == "True") {
                return "";
            }
            return editorContainer.select("[id$='" + fieldType + "FieldEditor_calendar']")[0].value;
        case "Checkbox":
        case "Bool":
            return editorContainer.select("[id$='" + fieldType + "FieldEditor']")[0].checked;
        case "EditorText":
            if (window.CKEDITOR) {
                var editorId = editorContainer.id.substring("cke_".length);
                var editor = CKEDITOR.instances[editorId];
                return editor.getData();
            }
            return editorContainer.select("[id$='TextFieldEditor']")[0].value;
        case "MultiSelectList":
        case "CheckBoxList":
            var values = [];
            var editor = editorContainer.select("[id$='" + fieldType + "FieldEditor']")[0];
            for (var i = 0; i < editor.options.length; i++) {
                var option = editor.options[i];
                if (option.selected) {
                    values.push(option.value);
                }
            }
            return values;
        default:
            return editorContainer.select("[id$='" + fieldType + "FieldEditor']")[0].value;
    }
};

Dynamicweb.PIM.BulkEdit.prototype._updateFieldsGridRow = function (row) {
    row.element.hide();
    var self = Dynamicweb.PIM.BulkEdit.get_current();
    var editor = CKEDITOR.instances[(row.ID - 1) + "EditorTextFieldEditor"];
    editor.on('instanceReady', function () {
        //set base z-index greater then dialog z-index
        editor.config.baseFloatZIndex = 1500;

        self._setEditorsVisibility(row.element, row.element.select("select[id$='Fields']")[0].value);
        row.element.select("select[id$='Fields']")[0].on('change', function () {
            self._setEditorsVisibility(row.element, this.value);
        });
        row.element.show();
    }, this);
};

Dynamicweb.PIM.BulkEdit.prototype._getFieldsGridEditor = function (fieldType, container) {
    if (fieldType == "EditorText" && container.id.lastIndexOf("EditorTextFieldEditor") > -1) {
        return container.previousElementSibling;
    } else if (fieldType == "Text") {
        return container.select("[id='TextFieldEditor']")[0];
    } else {
        return container.select("[id$='" + fieldType + "FieldEditor']")[0] || container.select("[id$='" + fieldType + "FieldEditor_calendar']")[0];
    }
};

Dynamicweb.PIM.BulkEdit.prototype._setEditorsVisibility = function (row, controlId) {
    var self = this;
    var fieldEditor = null;
    var definition = self._getControlDefinition(controlId);
    var values = null;
    var fieldType = "Text";
    if (definition) {
        if (definition.controlType) {
            fieldType = definition.controlType;
        }
        if (definition.predefinedValues) {
            values = definition.predefinedValues;
        }
    }
    for (var i = 0; i < row.children[1].children.length; i++) {
        var container = row.children[1].children[i];
        if (container.tagName === "DIV") {
            var currentEditor = self._getFieldsGridEditor(fieldType, container);
            if (currentEditor) {
                if (!fieldEditor) {
                    fieldEditor = currentEditor;
                }
                container.show();
            } else {
                container.hide();
            }
        }
    }
    if (!fieldEditor) {
        row.lastElementChild.firstElementChild.show();
    } else if ((fieldType == "GroupDropDownList" || fieldType == "Select" || fieldType == "MultiSelectList" || fieldType == "RadioButtonList" || fieldType == "CheckBoxList") && fieldEditor && fieldEditor.tagName === "SELECT" && values && values.length) {
        fieldEditor.innerHTML = "";
        if (!values || !values.length) {
            fieldEditor.options.add(new Option(self.terminology["SelectPickerNoneOptionText"] || "None", ""));
        } else {
            self._populateDropDownList(fieldEditor, values);
        }
        if (fieldEditor.multiple) {
            var multiselectSize = fieldEditor.readAttribute("data-size");
            if (multiselectSize) {
                fieldEditor.size = (values.length > multiselectSize ? multiselectSize : values.length);
            }
        }
    }
};

Dynamicweb.PIM.BulkEdit.prototype._populateDropDownList = function (el, values, selectedValue) {
    var addOptionGroup = function (el, label) {
        var gr = document.createElement('OPTGROUP');
        gr.label = label;
        el.appendChild(gr);
        return gr;
    };
    var addOption = function (el, label, value) {
        var opt = document.createElement('OPTION');
        opt.textContent = label;
        opt.value = value;
        el.appendChild(opt);
        return opt;
    };
    var defaultGroup = el;
    for (var i = 0; i < values.length; i++) {
        var dropdownItem = values[i];
        if (dropdownItem.isOptionsGroup) {
            defaultGroup = addOptionGroup(el, dropdownItem.text);
        }
        else {
            var opt = addOption(defaultGroup, dropdownItem.text, dropdownItem.value);
            if (dropdownItem.value == selectedValue) {
                opt.setAttribute("selected", "selected");
            }
        }
    }

}

Dynamicweb.PIM.BulkEdit.prototype.openPreview = function (pageId, productId, variantId, groupId, languageId, showInList) {
    var variantIdParameter = (variantId && showInList) ? "&VariantID=" + variantId : "";
    var previewUrl = "/Admin/Module/eCom_Catalog/dw7/PIM/ProductPreview.aspx?PageId={0}&ProductID={1}{2}&GroupID={3}&LanguageID={4}&PimPreview=true".format(pageId, productId, variantIdParameter, groupId, languageId);
    Action.OpenWindow({ Url: previewUrl, OpenInNewTab: true });
};

Dynamicweb.PIM.BulkEdit.prototype.editProductImages = function (productImageId) {
    this.currentlyEditingProductRow = productImageId;
    this._setFileManageControlValue('FM_ProductImageSmall', $(productImageId + '__ProductImageSmall').value.replace(/^(\/Files\/)/, ""));
    this._setFileManageControlValue('FM_ProductImageMedium', $(productImageId + '__ProductImageMedium').value.replace(/^(\/Files\/)/, ""));
    this._setFileManageControlValue('FM_ProductImageLarge', $(productImageId + '__ProductImageLarge').value.replace(/^(\/Files\/)/, ""));

    dialog.show('ProductImagesPicker');
};

Dynamicweb.PIM.BulkEdit.prototype.changeImages = function () {
    var smallImage = $('ProductImageSmall_path').value;
    var mediumImage = $('ProductImageMedium_path').value;
    var largeImage = $('ProductImageLarge_path').value;

    smallImage = this._fixImagePath(smallImage);
    mediumImage = this._fixImagePath(mediumImage);
    largeImage = this._fixImagePath(largeImage);

    $(this.currentlyEditingProductRow + '__ProductImageSmall').value = smallImage;
    $(this.currentlyEditingProductRow + '__ProductImageMedium').value = mediumImage;
    $(this.currentlyEditingProductRow + '__ProductImageLarge').value = largeImage;

    var productRowImage = $(this.currentlyEditingProductRow + '__Image');
    if (!smallImage && !mediumImage && !largeImage) {
        productRowImage.src = this._missingImagePath;
        productRowImage.addClassName("missing-image");
    } else {
        var image = smallImage || mediumImage || largeImage;
        productRowImage.src = this._getImagePath + encodeURIComponent(this._getCorrectImagePath(image));
        productRowImage.removeClassName("missing-image");
    }

    dialog.hide('ProductImagesPicker');
    this.currentlyEditingProductRow = "";
};

Dynamicweb.PIM.BulkEdit.prototype._getCorrectImagePath = function (path) {
    if (path != null && path.toLowerCase().startsWith("/files")) {
        path = "/Files" + path;
    }
    return path;
}

Dynamicweb.PIM.BulkEdit.prototype._fixImagePath = function (image) {
    var newPath = image.replace(/^(\/Files\/)/, "");
    if (newPath.length > 0) {
        newPath = newPath[0] === "/" ? newPath : "/" + newPath;
    }

    return newPath;
};

Dynamicweb.PIM.BulkEdit.prototype.closeRelatedGroupsDialog = function (pimGroupsShown) {
    var self = this;
    dialog.hide(pimGroupsShown ? "RelatedPimGroupsDialog" : "RelatedEcomGroupsDialog");
    if (self._productPrimaryGroup != $('PrimaryRelatedGroup').value || $("GroupsToDelete").value) {
        var message = self.terminology["ChangeRelatedGroup"] || "Do you want to save group changes on product?";
        self.showConfirmMessage(message, function () { self.submitFormWithCommand("SaveRelatedGroupChanges") });
    }
};

Dynamicweb.PIM.BulkEdit.prototype.showConfirmMessage = function (message, onConfirm, onCancel) {
    var self = this;
    var confirmation = self._cloneAction(self.confirmAction);
    if (confirmation) {
        if (confirmation.Url.indexOf("&Message=") > -1) {
            confirmation.Url = confirmation.Url.replace(new RegExp('Message=[^&]*&*', "ig"), "");
        }
        confirmation.Url += "&Message=" + encodeURIComponent(message);
        if (onConfirm) {
            if (typeof (onConfirm) == "function") {
                confirmation.OnSubmitted = { Name: "ScriptFunction", Function: function () { onConfirm() } };
            } else if (typeof (onConfirm) == "object") {
                confirmation.OnSubmitted = onConfirm;
            }
        }
        if (onCancel) {
            if (typeof (onCancel) == "function") {
                confirmation.OnCancelled = { Name: "ScriptFunction", Function: function () { onCancel() } };
            } else if (typeof (onCancel) == "object") {
                confirmation.OnCancelled = onCancel;
            }
        }
        Action.Execute(confirmation);
    }
};

Dynamicweb.PIM.BulkEdit.prototype.navigateToProduct = function (confirmMassage, productId, queryId, groupId, variantId, variantTreeClicked) {
    var self = this;

    var navigateAction = self._cloneAction(self.openScreenAction);
    variantId = variantId || "";

    queryId = queryId || self._queryId;
    if (queryId) {
        parameters = "&queryId=" + queryId + "&groupID=" + self._groupId;
    } else {
        parameters = "&GroupID=" + (groupId || self._groupId);
    }
    if (self._basePath) {
        parameters += "&BasePath=" + self._basePath;
    }

    this.setScrollCoordinates(null);
    if (!!variantTreeClicked) {
        window.top.navigateToVariants = true;
    }
    navigateAction.Url = "/Admin/Module/eCom_Catalog/dw7/PIM/PimProduct_Edit.aspx?ID=" + productId + "&VariantID=" + variantId + parameters;
    Action.Execute(navigateAction);
};

Dynamicweb.PIM.BulkEdit.prototype._cloneAction = function (originalAction) {
    if (null == originalAction || "object" != typeof originalAction) return originalAction;
    var copy = originalAction.constructor();
    for (var attr in originalAction) {
        if (originalAction.hasOwnProperty(attr)) copy[attr] = originalAction[attr];
    }
    return copy;
};

Dynamicweb.PIM.BulkEdit.prototype.setPageSize = function (size) {
    var prevSize = $("PageSizeHidden").value;
    var pageNumberEl = $("PageNumber");
    var ratio = prevSize / size;
    var newNumber = 1;
    if (ratio < 1) {
        newNumber = Math.ceil(pageNumberEl.value * ratio);
    } else {
        newNumber = Math.floor(ratio) * (pageNumberEl.value - 1) + 1;
    }
    pageNumberEl.value = newNumber < 1 ? 1 : newNumber;
    $("PageSizeHidden").value = size;
    this.submitFormWithCommand("");
};

Dynamicweb.PIM.BulkEdit.prototype.importFromExcelButtonClick = function () {
    dialog.show('ImportFromExcelDialog', "/Admin/Module/eCom_Catalog/dw7/PIM/PimImportFromExcel.aspx");
};

Dynamicweb.PIM.BulkEdit.prototype.closeImportFromExcel = function () {
    var okBtn = dialog.get_okButton('ImportFromExcelDialog');
    if (okBtn != null) {
        okBtn.style.display = "none";
    }
    var cancelBtn = dialog.get_cancelButton('ImportFromExcelDialog');
    if (cancelBtn != null) {
        cancelBtn.innerHTML = "Close";
    }
};
Dynamicweb.PIM.BulkEdit.prototype.importFromExcel = function () {
    var metadataDialogFrame = document.getElementById('ImportFromExcelDialogFrame');
    var iFrameDoc = (metadataDialogFrame.contentWindow || metadataDialogFrame.contentDocument);
    iFrameDoc.importFromExcel();
};

Dynamicweb.PIM.BulkEdit.prototype.closeExportDialog = function (url) {
    if (parent != null) {
        parent.closeExportToExcel();
    }
    self._checkUnloadChanges = false;
    window.location = url;
};


////           Draft/workflow

Dynamicweb.PIM.BulkEdit.prototype.useDraft = function () {
    if (this._approvalState > 0) {
        dialog.show("QuitDraftDialog");
    }
    else {
        this.toggleDraft();
    }
}

Dynamicweb.PIM.BulkEdit.prototype.previewCompare = function (productId, versionId) {
    var url = '/Admin/Module/eCom_Catalog/dw7/Workflow/ProductVersionsCompare.aspx?ProductId=' + productId + '&VersionId=' + versionId;
    dialog.show('ProductVersionsCompareDialog', url);
}

Dynamicweb.PIM.BulkEdit.prototype.publishChanges = function () {    
    this.submitFormWithCommand(this.terminology["PublishDraftCommand"] || "PublishDraft");
}

Dynamicweb.PIM.BulkEdit.prototype.discardChanges = function (skipChangesWarning) {
    var self = this;

    if (skipChangesWarning) {
        self.submitFormWithCommand(self.terminology["DiscardChangesCommand"] || "DiscardChanges");
    } else {
        var message = self.terminology["ConfirmDiscard"] || "Discard changes?";
        self.showConfirmMessage(message, function () { self.submitFormWithCommand(self.terminology["DiscardChangesCommand"] || "DiscardChanges") });
    }
}

Dynamicweb.PIM.BulkEdit.prototype.showVersions = function (productId, variantId, languageId) {
    var url = '/Admin/Module/eCom_Catalog/dw7/Workflow/ProductVersionsList.aspx?';
    url += 'ProductId=' + productId;
    url += '&ProductVariantId=' + variantId;
    url += '&ProductLanguageId=' + languageId;

    dialog.show('ProductVersionsDialog', url);
}

Dynamicweb.PIM.BulkEdit.prototype.toggleDraft = function () {
    var self = this;
    self.submitFormWithCommand(self.terminology["ToggleDraftCommand"] || "ToggleDraft", true);
}

Dynamicweb.PIM.BulkEdit.prototype.quitDraftCancel = function () {
    dialog.hide("QuitDraftDialog");
    Ribbon.checkBox("cmdUseDraft");
}

Dynamicweb.PIM.BulkEdit.prototype.quitDraftOk = function () {
    if (document.getElementById("QuitDraftPublish").checked) {
        this.publishChanges();
        //ToDO check if start workflow needed
        //this.startWorkflowCmd(true, "ToggleDraft");
    }
    if (document.getElementById("QuitDraftDiscard").checked) {
        this.discardChanges(true);
    }
};

Dynamicweb.PIM.BulkEdit.prototype.productFieldsBulkEdit = function (productId) {

    var url = "/Admin/Module/eCom_Catalog/dw7/PIM/FieldsBulkEdit.aspx?ids={productId}&groupId={groupId}&queryId={queryId}";
    this.openScreenAction.Url = url;
    Action.Execute(this.openScreenAction, {
        productId: productId,
        groupId: this._groupId || "",
        queryId: this._queryId || ""
    });
};

Dynamicweb.PIM.BulkEdit.prototype.productsFieldsBulkEdit = function (productIds) {
    var filteredProductIds = productIds;

    if (productIds.length >= 100) {
        filteredProductIds = productIds.slice(0, 75)
    }

    var url = "/Admin/Module/eCom_Catalog/dw7/PIM/FieldsBulkEdit.aspx?ids={ids}&groupId={groupId}&queryId={queryId}&multiProducts={multiProducts}&returnUrl={returnUrl}";
    this.openScreenAction.Url = url;
    Action.Execute(this.openScreenAction, {
        ids: filteredProductIds.join('|,|'),
        multiProducts: true,
        groupId: this._groupId || "",
        queryId: this._queryId || "",
        returnUrl: this.getListViewUrl(this._viewMode)
    });
};

Dynamicweb.PIM.BulkEdit.prototype.getForm = function () {
    return this._form;
};

Dynamicweb.PIM.BulkEdit.prototype.openCategoryFieldsDialog = function () {
    dialog.show('ProductCategoryFieldsDialog');
};

Dynamicweb.PIM.BulkEdit.prototype.changeCategoryFields = function () {
    new overlay('__ribbonOverlay').show();
    dialog.hide('ProductCategoryFieldsDialog');
    $("categoryFields").value = SelectionBox.getElementsRightAsArray("CategoryFieldsList").join();
    this.submitFormWithCommand("ChangeCategoryFields", true);
};

Dynamicweb.PIM.BulkEdit.prototype.uploadImageForProduct = function (e, btn, controlId) {
    const self = this;
    const initialProductNumber = btn.readAttribute("data-product-number");
    const uploadPath = btn.readAttribute("data-base-upload-folder");
    const imagesContainer = e.target.closest(".images-container");
    dwGlobal.fileUpload(self.getImagesUploadFolder(controlId, uploadPath, initialProductNumber), function (uploadInfo) {
        var folder = uploadInfo.Folder;
        if (folder && folder.substring(folder.length - 1) != "/") {
            folder += "/";
        }
        var files = uploadInfo.Files.map(function (fileInfo) {
            return folder + fileInfo.name;
        });
        self.addFilesToImageDetails(files, controlId, imagesContainer);
    }, false, true);
    return false;
};

Dynamicweb.PIM.BulkEdit.prototype.getImagesUploadFolder = function (controlId, uploadPath, initialProductNumber) {
    var folder = uploadPath;
    if (folder && folder.substring(folder.length - 1) != "/") {
        folder += "/";
    }
    if (initialProductNumber != null) {
        var arr = controlId.split("_;_");
        var controlId = this.getControlId(arr[0], arr[1], arr[2], "__product_property__number", "");
        var el = document.getElementById(controlId);
        var productNumber = initialProductNumber;
        if (el) {
            productNumber = el.value;
        }
        folder += (productNumber || "").replace(/[/\\?%*:|"\'<>]/g, '_');
    }
    return folder;
};

Dynamicweb.PIM.BulkEdit.prototype.selectImageForProduct = function (e, btn, controlId) {
    var imagesContainer = e.target.closest(".images-container");
    var imageSelectorElId = "ImageSelector_" + controlId;
    var el = document.getElementById(imageSelectorElId);
    var self = this;
    browseFileLink(imageSelectorElId, el.value, "gif,jpg,jpeg,png", function (filePath) {
        var relPath = _makeRelativePath("/Files", filePath);
        if (relPath && relPath.substring(0, 1) != "/") {
            relPath = "/" + relPath;
        }
        self.addFilesToImageDetails([relPath], controlId, imagesContainer);
    });
    return false;
};

Dynamicweb.PIM.BulkEdit.prototype.addFilesToImageDetails = function (files, controlId, imagesContainer) {
    var data = new FormData();
    data.append("CMD", "ImageDetailsItems");
    var storageEl = imagesContainer.querySelector(".added-images-details");
    var filesVal = [];
    var addedFiles = storageEl.value ? storageEl.value.split(":") : [];
    files.forEach(function (file) {
        filesVal.push(file);
    });
    data.append('files', filesVal.join(":"));
    storageEl.value = addedFiles.concat(filesVal).join(":");
    var url = this.options.urls.taskRunner;
    var cnt = imagesContainer.querySelector(".field-container-with-border");
    var self = this;
    fetch(url, {
        method: 'POST',
        credentials: 'same-origin',
        body: data
    }).then(function (response) {
        if (response.status >= 200 && response.status < 300) {
            return response.text()
        }
        else {
            var error = new Error(response.statusText)
            error.response = response
            throw error
        }
    }).then(function (responseText) {
        cnt.insertAdjacentHTML("beforeend", responseText);
    }).catch(function (error) {
        console.log('There has been a problem with your fetch operation: ' + error.message);
        alert(error.message);
    });
}

Dynamicweb.PIM.BulkEdit.prototype.deleteDetailImage = function (e) {
    var imageCnt = e.target.closest(".image-cnt");
    var imagesContainer = imageCnt.closest(".images-container");
    if (dwGlobal.Dom.hasClass(imageCnt, "new-detail-image")) {
        var storageEl = imagesContainer.querySelector(".added-images-details");
        var allAddedImages = imagesContainer.querySelectorAll(".image-cnt.new-detail-image");
        var index = -1;
        for (var i = 0; i < allAddedImages.length; i++) {
            if (allAddedImages[i] === imageCnt) {
                index = i;
                break;
            }
        }
        if (index > -1) {
            var addedFiles = storageEl.value ? storageEl.value.split(":") : [];
            addedFiles.splice(index, 1);
            storageEl.value = addedFiles.join(":");
        }
    }
    else {
        var storageEl = imagesContainer.querySelector(".removed-images-details");
        var removedFiles = storageEl.value ? storageEl.value.split(":") : [];
        var detailId = imageCnt.readAttribute("data-detail-id");
        removedFiles.push(detailId);
        storageEl.value = removedFiles.join(":");
    }
    imageCnt.remove();
}

Dynamicweb.PIM.BulkEdit.prototype.makeDetailImageAsPrimaryImage = function (e) {
    var imageCnt = e.target.closest(".image-cnt");
    var imgPath = imageCnt.querySelector(".image-block").readAttribute("data-image-path");
    var imagesContainer = imageCnt.closest(".images-container");
    var storageEl = imagesContainer.querySelector(".new-primary-image");
    var data = new FormData();
    data.append("CMD", "NewPrimaryImage");
    data.append('file', imgPath);
    storageEl.value = imgPath;

    var url = this.options.urls.taskRunner;
    var borderCnt = imagesContainer.querySelector(".field-container-with-border");
    var primaryImgCnt = imagesContainer.querySelector(".primary-image-container");
    var self = this;
    fetch(url, {
        method: 'POST',
        credentials: 'same-origin',
        body: data
    }).then(function (response) {
        if (response.status >= 200 && response.status < 300) {
            return response.text()
        }
        else {
            var error = new Error(response.statusText)
            error.response = response
            throw error
        }
    }).then(function (responseText) {
        if (primaryImgCnt) {
            primaryImgCnt.remove();
        }
        borderCnt.insertAdjacentHTML("afterbegin", responseText);
    }).catch(function (error) {
        console.log('There has been a problem with your fetch operation: ' + error.message);
        alert(error.message);
    });
}