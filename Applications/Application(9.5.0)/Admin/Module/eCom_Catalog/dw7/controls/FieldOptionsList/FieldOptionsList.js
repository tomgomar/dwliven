var FieldOptionsList = function() { }

FieldOptionsList.deleteRow = function(link) {
    var optionName = '';
    var row = dwGrid_optionsGrid.findContainingRow(link);

    if (row) {
        optionName = row.findControl('txName').value;

        if (!optionName || optionName.length == 0)
            optionName = '[' + FieldOptionsList._message('message-not-specified') + ']';

        if (confirm(FieldOptionsList._message('message-delete-row').replace('%%', optionName))) {
            dwGrid_optionsGrid.deleteRows([row]);
        }
    }
}

FieldOptionsList._message = function (className) {
    var ret = '';
    var container = null;

    if (className) {
        container = $$('.' + className);
        if (container != null && container.length > 0) {
            ret = container[0].innerHTML;
        }
    }

    return ret;
}