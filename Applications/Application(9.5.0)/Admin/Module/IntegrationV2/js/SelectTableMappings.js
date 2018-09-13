/* File Created: januar 2, 2012 */
function toggleAll() {
    if ($("checkAll").checked) {
        $$('#tableMappings .checkbox').each(
            function (ele) {
                $(ele).checked = true;
            }
        );
        $$('.destinationTableControl').each(function (select) { select.style.visibility = 'visible' });
    }
    else {
        $$('#tableMappings .checkbox').each(
            function (ele) {
                $(ele).checked = false;
            }
        );
        $$('.destinationTableControl').each(function (select) { select.style.visibility = 'hidden' });

    }
}