function dataLoaded(data) {
    //get data from serverver into named variables
    var selectedSourceTable = data[0];
    var selectedDestinationTable = data[1];
    var conditionals = data[2];
    var sourceTableColumns = data[3];
    var destinationTableColumns = data[4];
    var columnMappings = data[5];
    var divName = data[6];

    var mappingName = "mapping" + data[7];
    var mappingId = data[7];
    var schemaIsActive = data[8];
    destinationTableKeyColumns[mappingId] = data[9];
    tableScriptClasses[mappingId] = data[10];

    //Find the div for current talble mapping
    var currentDiv = document.getElementById(divName + "div");
    currentDiv.innerHTML = "";
    var currentMappingDiv = document.getElementById("columnMappings" + divName);
    currentMappingDiv.innerHTML = "";
    if(document.getElementById("activeMapping").value != divName)
        currentMappingDiv.style.display = "none";
    else
        currentDiv.style.background = "#f5f5f5";

    var sourceSelector = 'sourceTable' + mappingName;
    var destinationSelector = 'destinationTable' + mappingName;
    //add hidden field, that tells if the mapping has been deleted.

    currentDiv.appendChild(createInput("hidden", mappingName + "deleted", mappingName + "deleted", "false", ""));


    //add source and destination table dropdowns
    var cd = new Array();
    cd[0] = conditionals;
    cd[1] = sourceTableColumns;
    conditionalsData[mappingId] = cd;
    var sourceSelect = CreateTablePicker(sourceTables, selectedSourceTable, 'sourceTable' + mappingName, "doCallback('" + divName + "', { selectedSourceTable: document.getElementById('" + sourceSelector + "').value, selectedDestinationTable: document.getElementById('" + destinationSelector + "').value }, dataLoaded);", "sourceTablePicker std");
    var sourceTableSelectDiv = document.createElement("div");

    sourceTableSelectDiv.className = "SourceTableSelectorDiv";
    sourceTableSelectDiv.appendChild(sourceSelect);
    currentDiv.appendChild(sourceTableSelectDiv);
    var destinationSelect = CreateTablePicker(destinationTables, selectedDestinationTable, 'destinationTable' + mappingName, "doCallback('" + divName + "', { selectedSourceTable: document.getElementById('" + sourceSelector + "').value, selectedDestinationTable: document.getElementById('" + destinationSelector + "').value }, dataLoaded)", "destinationTablePicker std");
    var destinationTableSelectDiv = document.createElement("div");
    destinationTableSelectDiv.className = "DestinationTableSelectorDiv";
    destinationTableSelectDiv.appendChild(destinationSelect);
    currentDiv.appendChild(destinationTableSelectDiv);
    //add "add" and "delete" buttons

    currentDiv.appendChild(createIconButton('', '', 'border-left', "setupAddConditionalDialog('" + mappingId + "');", 'fa fa-plus', 'Add conditional'));
    if(conditionals.length > 0) {
        currentDiv.appendChild(createIconButton('', '', '', "setupEditConditionalDialog('" + mappingId + "');", 'fa fa-pencil', 'Edit conditionals'));
    }

    if (tableScriptClasses[mappingId].length > 0) {
        var selected = false;
        for (var i = 0; i < tableScriptClasses[mappingId].length; i++) {
            if (!selected) {
                selected = tableScriptClasses[mappingId][i][2];
            }
        }

        if (selected) {
            currentDiv.appendChild(createIconButton('', '', '', "showTableScriptingDialog('" + mappingId + "');", 'fa fa-plus-square', 'Edit Scripting'));
        } else {
            currentDiv.appendChild(createIconButton('', '', '', "showTableScriptingDialog('" + mappingId + "');", 'fa fa-pencil-square', 'Add Scripting'));
        }
    }

    currentDiv.appendChild(createIconButton('', '', '', "showKeysDialog('" + mappingId + "');", 'fa fa-key', 'Set keys'));
    var addSourceButton = createAddSourceButton(mappingId);
    if(schemaIsActive == "False") {
        addSourceButton.classList.add("disabled")
        addSourceButton.onclick = function() { return false; };
    }
    currentDiv.appendChild(addSourceButton);

    currentDiv.appendChild(CreateDeleteButton(divName + "div", mappingName));
    var clearfix = document.createElement("div");
    clearfix.className = "clearfix";
    currentDiv.appendChild(clearfix);
    var allMappingsActive = true;
    var sourceColumnSelect = createColumnSelector(sourceTableColumns);
    var destinationColumnSelect = createColumnSelector(destinationTableColumns);
    for(var i = 0; i < columnMappings.length; i++) {
        var columnMappingPicker = CreateColumnMappingPicker(sourceTableColumns, destinationTableColumns, columnMappings[i], mappingName, mappingId, sourceColumnSelect.cloneNode(true), destinationColumnSelect.cloneNode(true), currentMappingDiv, divName);
        var idSeed = mappingName + "columnMapping" + columnMappings[i][3];
        if(columnMappings[i][2] == "false") {
            allMappingsActive = false;
        }
        else
            $(idSeed + "Active").checked = true;
        document.getElementById(idSeed + "Active").onclick = function() { setCheckAll(); };
    }

    setCheckAll();
}
function CreateColumnMappingPicker(sourceTableColumns, destinationTableColumns, columnMapping, mappingName, mappingId, sourceColumn, destinationColumn, currentDiv, classForCheckboxes) {
    var idSeed = mappingName + "columnMapping" + columnMapping[3];
    var isActive = columnMapping[2];

    var div = document.createElement("div");

    var sourceColumnDiv = document.createElement("div");
    sourceColumnDiv.className = "selectedSourceColumnDiv";
    sourceColumnDiv.appendChild(sourceColumn);
    var destinationColumnDiv = document.createElement("div");
    destinationColumnDiv.className = "selectedDestinationColumnDiv";
    destinationColumnDiv.appendChild(destinationColumn);
    div.setAttribute("id", idSeed + "div");
    div.className = "columnMappingDiv";
    var input = document.createElement('input');
    input.setAttribute("type", "checkbox");
    input.name = idSeed + "Active";
    input.classList.add("checkbox");
    input.classList.add("ColumnMappingSelectedCheckbox");
    input.classList.add("ColumnMappingSelectedCheckbox" + classForCheckboxes);
    input.value = "on";
    input.id = idSeed + "Active";
    input.onclick = "setCheckAll()";
    div.appendChild(input);
    if(isActive == "true")
        input.checked = 'true';
    var label = document.createElement('label');
    label.setAttribute("for", idSeed + "Active");
    div.appendChild(label);
    div.appendChild(sourceColumnDiv);
    div.appendChild(destinationColumnDiv);

    var scriptButton = document.createElement("span");
    scriptButton.classList.add("input-group-addon");
    scriptButton.classList.add("border-left");
    scriptButton.classList.add("addScripting" + mappingId);
    scriptButton.id = "addScripting" + mappingId;
    scriptButton.onclick = function () { eval("showScriptingDialog('" + mappingId + "','" + columnMapping[3] + "','" + columnMapping[4] + "','" + columnMapping[5] + "','" + columnMapping[6] + "');"); return false; };
    
    var scriptButtonIcon = document.createElement('i');
    if(columnMapping[4] === 'None') {
        scriptButton.setAttribute("title", "Add Scripting");
        scriptButtonIcon.setAttribute('class', 'fa fa-code');
    } else {
        scriptButton.setAttribute("title", "Edit Scripting");        
        scriptButtonIcon.setAttribute('class', 'fa fa-pencil');
        setBackgroundColorForRowWithCondition(sourceColumn, destinationColumn);
        
        if(columnMapping[4] == 'Constant') {
            sourceColumn.setAttribute("disabled", "true");
        }
    }
    scriptButton.appendChild(scriptButtonIcon);

    div.appendChild(createInput("hidden", idSeed + "deleted", idSeed + "deleted", "false", ""));
    div.appendChild(scriptButton);
    var deleteButton = createIconButton("", "", "", "columnMappingDelete('" + idSeed + "div', '" + idSeed + "deleted');", 'fa fa-remove color-danger', 'Delete column mapping');
    div.appendChild(deleteButton);
    var clearfix = document.createElement("div");
    clearfix.className = "clearfix";
    div.appendChild(clearfix);
    currentDiv.appendChild(div);

    if (columnMapping[4] == 'Constant') {
        columnMapping[0] = "None";//Set source column selector to None when Constant condition is used
    }

    updateColumnSelector(sourceColumn, columnMapping[0], 'selectedSourceColumn', idSeed);
    updateColumnSelector(destinationColumn, columnMapping[1], 'selectedDestinationColumn', idSeed);

    return div;
}
function createColumnSelector(TableColumns) {
    var sourceColumn = document.createElement("select");
    sourceColumn.className = "std";
    sourceColumn.options[0] = new Option("None", "-1");

    for(j = 0; j < TableColumns.length; j++) {
        sourceColumn.options[sourceColumn.options.length] = new Option(TableColumns[j], TableColumns[j]);
    }
    return sourceColumn
}

function updateColumnSelector(sourceColumnSelector, selectedColumn, classname, idSeed) {
    sourceColumnSelector.className = classname + " std";
    sourceColumnSelector.id = idSeed + classname;
    sourceColumnSelector.setAttribute('name', idSeed + classname);
    for(var k = 0; k < sourceColumnSelector.options.length; k++) {

        if (sourceColumnSelector.options[k].value.toLowerCase() == selectedColumn.toLowerCase()) {
            sourceColumnSelector.selectedIndex = k;
            sourceColumnSelector.options[k].setAttribute("selected", "true");
            k = sourceColumnSelector.options.length;
        }
    }
}

function setupEditConditionalDialog(mappingId) {
    $('editConditionalsDiv').innerHTML = "";

    $('currentMapping').value = mappingId;
    $('addConditionalColumn').options.length = 0;
    var conditionalsColumns = conditionalsData[mappingId][1];
    var conditionals = conditionalsData[mappingId][0];
    for(var i = 0; i < conditionals.length; i++) {
        var conditionDiv = document.createElement("div");
        conditionDiv.setAttribute("id", "conditionDiv" + conditionals[i][3]);
        conditionDiv.setAttribute("style", "margin-bottom:10px;");

        var conditionColumn = document.createElement("select");
        conditionColumn.setAttribute("name", "conditionColumn" + conditionals[i][3]);
        conditionColumn.className = "std";
        conditionColumn.setAttribute("style", "width:35%;margin-right:3px;");

        for(var j = 0; j < conditionalsColumns.length; j++) {
            var column = conditionalsColumns[j]
            if(column == conditionals[i][1])
                conditionColumn.options[conditionColumn.options.length] = new Option(column, column, false, true);
            else
                conditionColumn.options[conditionColumn.options.length] = new Option(column, column, false);
        }
        conditionDiv.appendChild(conditionColumn);


        var conditionOperator = document.createElement("select");
        conditionOperator.setAttribute("name", "conditionOperator" + conditionals[i][3]);
        conditionOperator.className = "std";
        conditionOperator.setAttribute("style", "width:15%;margin-right:3px;");

        if(conditionals[i][2] == "EqualTo") {
                conditionOperator.options[conditionOperator.options.length] = new Option("=", "EqualTo", false, true);
        }
        else conditionOperator.options[conditionOperator.options.length] = new Option("=", "EqualTo", false);

        if(conditionals[i][2] == "LessThan") {
                conditionOperator.options[conditionOperator.options.length] = new Option("<", "LessThan", false, true);
        }
        else conditionOperator.options[conditionOperator.options.length] = new Option("<", "LessThan", false);

        if(conditionals[i][2] == "GreaterThan") {
                conditionOperator.options[conditionOperator.options.length] = new Option(">", "GreaterThan", false, true);
        }
        else conditionOperator.options[conditionOperator.options.length] = new Option(">", "GreaterThan", false);

        if(conditionals[i][2] == "DifferentFrom") {
                conditionOperator.options[conditionOperator.options.length] = new Option("<>", "DifferentFrom", false, true);
        }
        else conditionOperator.options[conditionOperator.options.length] = new Option("<>", "DifferentFrom", false);

        if (conditionals[i][2] == "Contains") {
                conditionOperator.options[conditionOperator.options.length] = new Option("Contains", "Contains", false, true);
        }
        else conditionOperator.options[conditionOperator.options.length] = new Option("Contains", "Contains", false);

        conditionDiv.appendChild(conditionOperator);
        conditionDiv.appendChild(createInput("text", "condition" + conditionals[i][3], "", conditionals[i][0], "", "condition", "", "std", "width:35%;margin-right:5px;"));
        conditionDiv.appendChild(createIconButton("", "Delete", "", "$('conditionDiv" + conditionals[i][3] + "').hide(); $('conditionDeleted" + conditionals[i][3] + "').value='true';", 'fa fa-remove color-danger', 'Delete'));
        conditionDiv.appendChild(createInput("hidden", "conditionDeleted" + conditionals[i][3], "conditionDeleted" + conditionals[i][3], "", ""));
        $('editConditionalsDiv').appendChild(conditionDiv);
    }
    stopConfirmation();
    dialog.show('editConditionals');
}


function setupAddConditionalDialog(mappingId) {
    $('currentMapping').value = mappingId;
    $('addConditionalColumn').options.length = 0;
    var conditionalsColumns = conditionalsData[mappingId][1];
    var leng = conditionalsColumns.length;

    for (var i = 0; i < leng; i++) {
        var column = conditionalsColumns[i]
        $('addConditionalColumn').options[$('addConditionalColumn').options.length] = new Option(column, column, false);
    }
    stopConfirmation();
    dialog.show('addConditional');
}
function showKeysDialog(mappingId) {
    $('currentMapping').value = mappingId;
    var keyColumns = destinationTableKeyColumns[mappingId];
    var leng = keyColumns.length;
    $('selectKeyColumns').innerHTML = "";

    for (var i = 0; i < leng; i++) {
        var column = keyColumns[i]
        var input = document.createElement('input');
        input.setAttribute("type", "checkbox");
        input.value = "True";
        input.name = column[0] + "IsKey";
        input.className = 'checkbox';
        if (column[1]=="True")
            input.checked = 'true';
        input.id = column[0] + "IsKey";
        $('selectKeyColumns').appendChild(input);
        var label = document.createElement('label');
        label.innerHTML = column[0];
        label.className = 'm-b-5';
        label.setAttribute("for", column[0] + "IsKey");
        $('selectKeyColumns').appendChild(label);
        $('selectKeyColumns').appendChild(document.createElement("br"));
    }
    stopConfirmation();
    dialog.show('selectKeys');
}

function CreateTablePicker(tableList, selectedTable, id, callbackFunction, classname) {
    var result = document.createElement("select");
    result.className = classname;
    result.id = id;
    result.setAttribute('name', id);

    result.onchange = function() { eval(callbackFunction) };

    for(i = 0; i < tableList.length; i++) {
        var table = tableList[i];

        if (table.toLowerCase() == selectedTable.toLowerCase()) {
                result.options[result.options.length] = new Option(table, table, false, true);
        }
        else {
            result.options[result.options.length] = new Option(table, table);
        }
    }
    return result;
}

function showScriptingDialog(mappingId, columnMappingId, scriptingType, scriptingValue, scriptingValueForInsert) {
    $('currentMapping').value = mappingId;
    $('currentColumnMapping').value = columnMappingId;
    $('scriptValue').value = scriptingValue;
    if(scriptingType === "None")
        $('scriptType').selectedIndex = 0;
    if(scriptingType === "Append")
        $('scriptType').selectedIndex = 1;
    if(scriptingType === "Prepend")
        $('scriptType').selectedIndex = 2;
    if(scriptingType === "Constant")
        $('scriptType').selectedIndex = 3;
    if ($('checkScriptValueForInsert') != null) {
        $('checkScriptValueForInsert').checked = (scriptingValueForInsert != null && scriptingValueForInsert.toLowerCase() == 'true') ? true : false;
        toggleScriptTypeSelection();
    }    
    stopConfirmation();
    dialog.show('editScripting');
}

function setBackgroundColorForRowWithCondition(sourceColumn, destinationColumn) {
    if(sourceColumn != null && destinationColumn != null) {
        sourceColumn.setAttribute("style", "background-color:#FFF8DC;");
        destinationColumn.setAttribute("style", "background-color:#FFF8DC;");
    }
}

function columnMappingDelete(divId, deletedHiddenId) {
    $(divId).style.display = "none";
    $(deletedHiddenId).value = "true";
    return false;
}

function tableMappingDelete(divName, mappingName) {
    if(confirm('Are you sure you want to delete selected table mapping?')) {
        $(divName).style.display = "none";
        $(divName).value = "true";
        $(mappingName + "deleted").value = "true";
    }
}

function createAddSourceButton(mappingId) {
    return createIconButton('AddTable' + mappingId, '', '', "addTabletoDestionation('" + mappingId + "');", 'fa fa-sitemap', 'Add source table to destination');
}

function addTabletoDestionation(mappingId) {
    stopConfirmation();
    $("form1").appendChild(createInput("hidden", "mappingToAddtableFromMappingTo", "mappingToAddtableFromMappingTo", mappingId, ""));
    $("action").value = "addTableToDestinationSchema";
    $("form1").submit();
    stopConfirmation();
}

function CreateDeleteButton(divName, mappingName) {
    return createIconButton('', '', '', "tableMappingDelete('" + divName + "','" + mappingName + "');", 'fa fa-remove color-danger', 'Delete table mapping');
}

function doCallback(divId, params, onCompleteFunction, argument) {
    if(typeof (argument) == 'undefined') {
        var arg = { target: divId, onComplete: onCompleteFunction, parameters: params }
    }
    else {
        var arg = { target: divId, onComplete: onCompleteFunction, parameters: params, argument: argument }
    }
    Dynamicweb.Ajax.DataLoader.load(arg);
}

function createIconButton(id, name, className, onClick, iconClass, title) {
    var button = document.createElement('span');    
    if (id) button.setAttribute('id', id);
    if (name) button.setAttribute('name', name);
    button.classList.add("input-group-addon");
    if (className) button.classList.add(className);
    if (onClick) button.onclick = function () { eval(onClick); return false };
    if (title) button.setAttribute('title', title);

    iconClass = iconClass || 'fa fa-gear';

    var icon = document.createElement('i');
    icon.setAttribute('class', iconClass);

    button.appendChild(icon);

    return button;
}

function createInput(type, name, id, value, onClick, className, style) {
    return createInput(type, name, id, value, onClick, "", "", className, style);
}

function createInput(type, name, id, value, onClick, src, alt, className, style) {
    var input = document.createElement('input');
    input.type = type;
    input.setAttribute('name', name);

    if(id != "" && id != undefined)
        input.id = id;
    if(value != "" && value != undefined)
        input.setAttribute('value', value);
    if(className != "" && className != undefined) input.setAttribute('class', className);
    if(onClick != "")
        input.onclick = function() { eval(onClick); return false; };
    if(src != "") input.setAttribute('src', src);
    if (style != "") input.setAttribute('style', style);
    input.setAttribute('title', alt);
    return input;
}

function save() {
    stopConfirmation();
    $("action").value = 'save';
    $("form1").submit();
    stopConfirmation();
}
function showColumnMappings(divId, mappingId) {

    if(document.getElementById(divId + "div").style.display != "none") {
        hideCurrentColumnMappings();
        document.getElementById(document.getElementById("activeMapping").value + "div").style.background = "white";
        document.getElementById("activeMapping").value = divId;
        document.getElementById("activeMappingID").value = mappingId;
        var newSelection = document.getElementById("columnMappings" + divId);
        newSelection.style.display = "inline";

        document.getElementById(divId + "div").style.background = "#f5f5f5";
        setCheckAll();
    }
    else {
        if(document.getElementById("activeMapping").value == divId)
            hideCurrentColumnMappings();
    }
}

function hideCurrentColumnMappings() {
    var currentSelection = document.getElementById("columnMappings" + document.getElementById("activeMapping").value);
    currentSelection.style.display = "none";
}

function setCheckAll() {
    $('checkAllCheckbox').checked = true;
    $$("input.ColumnMappingSelectedCheckbox" + document.getElementById("activeMapping").value).each(function(checkbox) {
        if(checkbox.display != "none" && checkbox.checked == false)
            $('checkAllCheckbox').checked = false;
    });

    //if all checkboxes for current tablemapping are checked, check checkall, otherwise uncheck it
}

function saveAndClose() {
    stopConfirmation();
    $("action").value = 'saveAndClose';
    $("form1").submit();
    stopConfirmation();
}

function cancel() {
    stopConfirmation();
    $("action").value = 'cancel';
    $("form1").submit();
    stopConfirmation();
}

function addTableMapping() {
    stopConfirmation();
    $("action").value = 'addTableMapping';
    $("form1").submit();
    stopConfirmation();
}

function SaveAndRun() {
    removeUnloadEvent();
    $("action").value = 'SaveAndRun';
    $("form1").submit();
}

function hideSourceDialog() {
    dialog.hide('SourceEditDialog');
}

function hideDestinationDialog() {
    dialog.hide('DestinationEditDialog');
}

function hideNotificationSettingsDialog() {
    dialog.hide('NotificationSettingsDialog');
}

var conditionalsData = new Array();
var destinationTableKeyColumns = new Array();
function toggleActiveSelection() {
    if($('checkAllCheckbox').checked == true) {
        $$("input.ColumnMappingSelectedCheckbox" + document.getElementById("activeMapping").value).each(function(checkbox) {
            if(checkbox.display != "none")
                checkbox.checked = true;
        });
    }
    else {
        $$("input.ColumnMappingSelectedCheckbox" + document.getElementById("activeMapping").value).each(function(checkbox) {
            if(checkbox.display != "none")
                checkbox.checked = false;
        });
    }
}

function checkSelectAllIfNeeded() {
    if(this.checked) {
        $(this.parentNode).siblings().each(function(mainCheck) { if(mainCheck.type == "checkbox") mainCheck.checked = true; });
        $(this.parentNode).siblings().each(function(item) {
            $(item).childElements().each(function(child) {
                if(child.type == "checkbox" && child.checked == false)
                    $(child.parentNode).siblings().each(function(mainCheck) { if(mainCheck.type == "checkbox") mainCheck.checked = false; });
            });
        });
    }
    else
        $(this.parentNode).siblings().each(function(mainCheck) { if(mainCheck.type == "checkbox") mainCheck.checked = false; });
}

function activateButtons() {
    TableMappingCount = TableMappingCount - 1;
    if(TableMappingCount == 0) {
        $('addTableMapping').removeClassName('disabled');
    }
}

function tableAddColumnMapping() {
    stopConfirmation();
    var mappingid = document.getElementById("activeMappingID").value;
    $("form1").appendChild(createInput("hidden", "mappingToAddColumnMappingTo", "mappingToAddColumnMappingTo", mappingid, ""));
    $("action").value = "addColumnMapping";
    $("form1").submit();
    stopConfirmation();
}

function tableRemoveColumnMapping() {
    stopConfirmation();
    var mappingid = document.getElementById("activeMappingID").value;
    $("form1").appendChild(createInput("hidden", "mappingToRemoveColumnMappingTo", "mappingToRemoveColumnMappingTo", mappingid, ""));
    $("action").value = "removeColumnMapping";
    $("form1").submit();
    stopConfirmation();
}

function addColumnMapping() {
    stopConfirmation();
    var mappingId = document.getElementById("activeMappingID").value;
    $('currentMapping').value = mappingId;
    dialog.show('addColumnDialog');
}

function showSourceDestinationSettingsDialog(dialogId, url) {
    var frame = document.getElementById(dialogId + "Frame");
    if (frame && frame.src) {
        dialog.show(dialogId);
    } else {
        dialog.show(dialogId, url);
    }
}

function showErrorsDialog() {
    stopConfirmation();
    dialog.show('showErrorsDlg');
}

var tableScriptClasses = new Array();
function showTableScriptingDialog(mappingId) {
    $('currentMapping').value = mappingId;
    $('editTableScriptingDiv').innerHTML = "";

    var select = document.createElement("select");
    select.className = "std";
    select.id = "tableScripting" + mappingId;
    select.setAttribute('name', "tableScripting" +mappingId);
    select.options[0] = new Option("None", "none");

    for (var i = 0; i < tableScriptClasses[mappingId].length; i++) {
        if (tableScriptClasses[mappingId][i][2] == true) {
            select.options[select.options.length] = new Option(tableScriptClasses[mappingId][i][1], tableScriptClasses[mappingId][i][0], false, true);
        } else {
            select.options[select.options.length] = new Option(tableScriptClasses[mappingId][i][1], tableScriptClasses[mappingId][i][0], false);
        }
    }

    $('editTableScriptingDiv').appendChild(select);
    stopConfirmation();
    dialog.show('editTableScripting');
}


var queue = new Dynamicweb.Utilities.RequestQueue();

function beginLoadData(controlID, onComplete) {
    Dynamicweb.Ajax.DataLoader.load({
        target: controlID,
        argument: '',
        onComplete: function(data) {
            dataLoaded(data);
            onComplete(data);
        }
    });
}

function addToQueue(id) {
    queue.add(window, beginLoadData, [id, function() { queue.next(); } ]);
}

$(document).observe("dom:loaded", function() {
    queue.executeAll();
});

var askConfirmation = true;
function stopConfirmation() {
    askConfirmation = false;
}

function enableConfirmation(){
    askConfirmation = true;
}

window.onbeforeunload = function() {
    if (askConfirmation) {
        return "This page is asking you to confirm that you want to leave - data you have entered may not be saved.";
        //used to fix the issue when onbeforeunload event is called 2 times
        askConfirmation = false;
        setTimeout("enableConfirmation()", "100");
    }
};

function removeUnloadEvent() {
    window.onbeforeunload = null;
}

function toggleScriptTypeSelection() {
    var scriptType = $('scriptType');
    if (scriptType != null && $('checkScriptValueForInsertDiv') != null) {
        var selectedValue = scriptType.options[scriptType.selectedIndex].value;
        if (selectedValue != null && selectedValue.toLowerCase() == 'constant') {
            $('checkScriptValueForInsertDiv').show();
        } else {
            $('checkScriptValueForInsertDiv').hide();
        }
    }    
}