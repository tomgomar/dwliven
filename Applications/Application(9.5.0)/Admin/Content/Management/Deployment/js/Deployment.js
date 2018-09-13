function recursivelyTickCheckBoxes(elementId) {
    var element = document.getElementById(elementId); //checkbox
    var checkboxContainer = element.parentNode.parentNode.parentNode; //closest groupbox parent            
    var checkedOrNot = ':checked';

    if (document.getElementById("cmdTransfer")) {
        Toolbar.setButtonIsDisabled("cmdTransfer", !element.checked);
    }

    if (element.checked) {
        checkedOrNot = ':not(:checked)';
    }
    var query = '[type="checkbox"]:not(:disabled)' + checkedOrNot;
    var descendants = checkboxContainer.querySelectorAll(query);
    for (i = 0; i < descendants.length; ++i) {
        descendants[i].checked = element.checked;
    }
}
function allowTransfer(element) {
    if (document.getElementById("cmdTransfer")) {
        Toolbar.setButtonIsDisabled("cmdTransfer", document.querySelectorAll('[type="checkbox"][name="dataItem"]:checked').length == 0);
    }
}
function SubmitFormWithAction(actionValue) {
    var deploymentAction = document.getElementById("deploymentAction");
    deploymentAction.value = actionValue;
    document.getElementById("dataGroupForm").submit();
}
function CompareButtonClicked() {
    SubmitFormWithAction("Compare");
}
function SelectButtonClicked() {
    SubmitFormWithAction("Transfer");
}
function TransferButtonClicked() {
    SubmitFormWithAction("Transfer");
}
function Cancel() {
    var dataGroupId = document.getElementById("dataGroupId");
    location.href = "DeploymentConfiguration.aspx?dataGroupId=" + dataGroupId.value;
}
function showComparisonDetails(dataGroupId, dataItemTypeId, dataItemId) {
    var destinationId = document.getElementById('destinationId').value;
    dialog.show("ComparisonDetailsDialog", '/Admin/Content/Management/Deployment/ComparisonDetails.aspx?dataGroupId=' + encodeURIComponent(dataGroupId) + '&dataItemTypeId=' + encodeURIComponent(dataItemTypeId) + '&dataItemId=' + encodeURIComponent(dataItemId) + '&destinationId=' + encodeURIComponent(destinationId));
}
