
function showLoad() {
    if ($('DW_Ecom_GroupTree').style.display == "") {
        $('DW_Ecom_GroupTree').style.display = "none";
        $('GroupWaitDlg').style.display = "";
    }
}

function hideLoad() {
    $('GroupWaitDlg').style.display = "none";
}
