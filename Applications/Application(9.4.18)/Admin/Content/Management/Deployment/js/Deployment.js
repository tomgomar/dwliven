function recursivelyTickCheckBoxes(elementId) {
    var element = document.getElementById(elementId); //checkbox
    var checkboxContainer = element.parentNode.parentNode.parentNode; //closest groupbox parent            
    var checkedOrNot = ':checked';
    if (element.checked) {
        checkedOrNot = ':not(:checked)';
    }
    var query = '[type="checkbox"]' + checkedOrNot;
    var descendants = checkboxContainer.querySelectorAll(query);
    for (i = 0; i < descendants.length; ++i) {
        descendants[i].checked = element.checked;
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
function showComparisonDetails(dataGroupId,dataItemTypeId,dataItemId)
{
    var destinationId = document.getElementById('destinationId').value;
    dialog.show("ComparisonDetailsDialog", '/Admin/Content/Management/Deployment/ComparisonDetails.aspx?dataGroupId=' + encodeURIComponent(dataGroupId) + '&dataItemTypeId=' + encodeURIComponent(dataItemTypeId) + '&dataItemId=' + encodeURIComponent(dataItemId) + '&destinationId=' + encodeURIComponent(destinationId));
}
