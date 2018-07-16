/// <reference path="/Admin/Resources/js/layout/Actions.js" />

Action.Submit = function (action) {
    window.document.forms[0].submit();
};

Action.Cancel = function (action) {
    Action.Execute({ Name: 'CloseDialog', Result: 'cancel' });
};

Action.Select = function (action) {

};

Action.ModalResult = function (action) {
    var _action = Action._getCurrentDialogAction();
    var _model = Action._getCurrentDialogModel();
    var _opener = Action._getCurrentDialogOpener();
    var nextAction = null;

    if (_action) {
        if (action.Result === "Submitted") {
            nextAction = _action.OnSubmitted;
        }

        if (action.Result === "Rejected") {
            nextAction = _action.OnRejected;
        }

        if (action.Result === "Cancelled") {
            nextAction = _action.OnCancelled;
        }

        if (action.Result === "Selected") {
            nextAction = _action.OnSelected;
        }
    }
    if (!nextAction || nextAction.Name != "OpenDialog") {
        Action.Execute({ Name: 'CloseDialog' });
    }

    if (nextAction) {
        _opener.Action.Execute(nextAction, action.Model || _model);
    }
};