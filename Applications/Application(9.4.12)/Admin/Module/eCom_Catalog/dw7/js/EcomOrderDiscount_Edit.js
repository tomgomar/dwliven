if (typeof (Dynamicweb) == 'undefined') {
    var Dynamicweb = new Object();
}

if (typeof (Dynamicweb.eCommerce) == 'undefined') {
    Dynamicweb.eCommerce = new Object();
}

Dynamicweb.eCommerce.OrderDiscounts = function () { }

Dynamicweb.eCommerce.OrderDiscounts.AddProduct = function(fieldName) {
    if (fieldName != "") {
        var caller = 'opener.document.forms.formOrderDiscount_edit.' + fieldName;
        window.open("/Admin/Module/eCom_Catalog/dw7/Edit/EcomGroupTree.aspx?CMD=ShowProd&AddCaller=1&caller=" + caller, "", "displayWindow,width=460,height=400,scrollbars=no");
    }
}

Dynamicweb.eCommerce.OrderDiscounts.RemoveProduct = function(fieldName) {
    if (fieldName != "") {
        document.getElementById("ID_" + fieldName).value = '';
        document.getElementById("VariantID_" + fieldName).value = '';
        document.getElementById('Name_' + fieldName).value = '';
    }
}


Dynamicweb.eCommerce.OrderDiscounts.showDiscountType = function(discountType) {
    var sd = $("shopDiv");
    var customFieldsDiv = $("CustomFieldsDiv");
    if (discountType == 1) {
        $("amountDiv").style.display = "";
        $("currencyDiv").style.display = "";
        $("percentageDiv").style.display = "none";
        $("productDiv").style.display = "none";
        if(customFieldsDiv != null){
            customFieldsDiv.style.display = "none";
        }
        if (sd) {
            sd.style.display = "none";
        }
    } else if (discountType == 2) {
        $("amountDiv").style.display = "none";
        $("currencyDiv").style.display = "none";
        $("percentageDiv").style.display = "";
        $("productDiv").style.display = "none";
        if (customFieldsDiv != null) {
            customFieldsDiv.style.display = "none";
        }
        if (sd) {
            sd.style.display = "none";
        }
    } else if (discountType == 3) {
    	$("amountDiv").style.display = "none";
    	$("currencyDiv").style.display = "none";
    	$("percentageDiv").style.display = "none";
    	$("productDiv").style.display = "";
    	if (customFieldsDiv != null) {
    	    customFieldsDiv.style.display = "none";
    	}
    	if (sd) {
    		sd.style.display = "none";
    	}
    } else if (discountType == 5) {
        $("amountDiv").style.display = "none";
        $("currencyDiv").style.display = "none";
        $("percentageDiv").style.display = "none";
        $("productDiv").style.display = "none";
        if (customFieldsDiv != null) {
            customFieldsDiv.style.display = "";
        }
        if (sd) {
            sd.style.display = "none";
        }
    } else {
        $("amountDiv").style.display = "none";
        $("currencyDiv").style.display = "none";
        $("percentageDiv").style.display = "none";
        $("productDiv").style.display = "none";
        if (customFieldsDiv != null) {
            customFieldsDiv.style.display = "none";
        }
        if (sd) {
            sd.style.display = "";
        }
    }

    var discountApplyAs = $("ApplyAs").value;
    var isOrderDiscount = discountApplyAs == 1 || discountApplyAs == 3;
    if (isOrderDiscount && discountType == 2) {
        $("applyToDiv").show();
    } else {
        $("applyToDiv").hide();
    }
}
        
Dynamicweb.eCommerce.OrderDiscounts.showOrderFieldType = function(orderFieldType) {
    if (orderFieldType == 1) {
        $("RadioOrderFieldTypeDiv").style.display = "";
        $("VoucherListsDiv").style.display = "none";
        $("OrderFieldType1").checked = true;
        $("OrderFieldType2").checked = false;
    } else {
        $("RadioOrderFieldTypeDiv").style.display = "none";
        $("VoucherListsDiv").style.display = "";
        $("OrderFieldType1").checked = false;
        $("OrderFieldType2").checked = true;
    }
}

Dynamicweb.eCommerce.OrderDiscounts.showOrderFieldsOption = function() {
    var orderFieldSelect = $("orderFields");
    var index = orderFieldSelect.selectedIndex;
    if (index == 0) {
        $("rbOrderFieldTypeDiv").style.display = "none";
        $("RadioOrderFieldTypeDiv").style.display = "none";
        $("VoucherListsDiv").style.display = "none";
        $("OrderFieldValueDiv").style.display = "none";
    } else if (index == 1) {
        $("rbOrderFieldTypeDiv").style.display = ""
        if ($("OrderFieldType1").checked) {
            $("RadioOrderFieldTypeDiv").style.display = "";
            $("VoucherListsDiv").style.display = "none";
            $("OrderFieldValueDiv").style.display = "none";
            Dynamicweb.eCommerce.OrderDiscounts.showOrderFieldType(1);
        } else {
            $("RadioOrderFieldTypeDiv").style.display = "none";
            $("VoucherListsDiv").style.display = "";
            $("OrderFieldValueDiv").style.display = "none";
            Dynamicweb.eCommerce.OrderDiscounts.showOrderFieldType(2)
        }
    } else {
        $("rbOrderFieldTypeDiv").style.display = "none";
        $("RadioOrderFieldTypeDiv").style.display = "none";
        $("VoucherListsDiv").style.display = "none";
        $("OrderFieldValueDiv").style.display = "";
    }
}

Dynamicweb.eCommerce.OrderDiscounts.checkName = function() {
    var name = $("txName").value;
    if (name.length == 0) {
        alert("Name of discount can't be empty. Please specify name of discount");
        $("txName").focus();
        return false;
    } else {
        return true;
    }
}

Dynamicweb.eCommerce.OrderDiscounts.submit = function (close) {
    if (Dynamicweb.eCommerce.OrderDiscounts.checkName()) {
        document.getElementById("Close").value = close ? 1 : 0;
        __doPostBack();
    }
}

Dynamicweb.eCommerce.OrderDiscounts.redirectToList = function () {
    document.location.href = '/Admin/Module/eCom_Catalog/dw7/lists/EcomOrderDiscount_List.aspx';
}

Dynamicweb.eCommerce.OrderDiscounts.CheckApplyAsState = function () {
    var discountApplyAs = $("ApplyAs").value;
    var discountDiscountType = $("DiscountType").value;
    var flag = discountApplyAs == 2; // order line discount
    var isOrderDiscount = discountApplyAs == 1 || discountApplyAs == 3;
    var percentChecked = discountDiscountType == 2;
    var shipChecked = discountDiscountType == 4;
    var productCustomFieldChecked = discountDiscountType == 5;

    if ((flag && shipChecked) || (!flag && productCustomFieldChecked)) {
        $$("select#DiscountType option[value=1]")[0].selected = true;
        Dynamicweb.eCommerce.OrderDiscounts.showDiscountType(1);
    }
    if (flag) {
        $$("select#DiscountType option[value=5]")[0].show();
        $$("select#DiscountType option[value=4]")[0].hide();
    } else {
        $$("select#DiscountType option[value=5]")[0].hide();
        $$("select#DiscountType option[value=4]")[0].show();
    }
    if (isOrderDiscount && percentChecked) {
        $("applyToDiv").show();
    } else {
        $("applyToDiv").hide();
    }
}

Dynamicweb.eCommerce.OrderDiscounts.init = function () {
    Dynamicweb.eCommerce.OrderDiscounts.CheckApplyAsState();
    document.getElementById('txName').focus();
    Dynamicweb.eCommerce.OrderDiscounts.showDiscountType($("DiscountType").value);
    Dynamicweb.eCommerce.OrderDiscounts.showOrderFieldsOption();

    Event.observe($("ApplyAs"), "change", function (event) {
        Dynamicweb.eCommerce.OrderDiscounts.CheckApplyAsState();
    });
    Event.observe($("DiscountType"), "change", function (event) {
        Dynamicweb.eCommerce.OrderDiscounts.showDiscountType(this.value);
    });
}
