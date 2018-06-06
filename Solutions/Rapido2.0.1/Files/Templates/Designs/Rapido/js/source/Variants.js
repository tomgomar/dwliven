var Variants = function () { }

var productFeedId = 0;
var productUrl = "";
var viewMode = "";


Variants.prototype.VariantGroup = function (id, name, options) {
    this.id = id;
    this.name = name;
    this.VariantOptions = options;
}

Variants.prototype.VariantOption = function (id, productId, variantId, name, selected, disabled, color, image) {
    this.id = id;
    this.productId = productId;
    this.variantId = variantId;
    this.name = name;
    this.selected = selected;
    this.disabled = disabled;
    this.color = color;
    this.image = image;
    if (image) {
        this.template = "VariantOptionImage";
    } else {
        this.template = "VariantOption";
    }
}

Variants.prototype.CombinationItem = function (id) {
    this.id = id;
}

Variants.prototype.VariantObject = function (id, variants, combinations) {
    this.id = id;
    this.Variants = variants;
    this.Combinations = combinations;
}

Variants.prototype.SetVariantOptionStatesForProductList = function (variantContainer) {
    if (variantContainer) {
        var productId = variantContainer.getAttribute("data-product-id");
        var dataId = variantContainer.getAttribute("data-id");

        console.log(HandlebarsBolt.FindDataInCache("Product" + dataId));

        var product = HandlebarsBolt.FindDataInCache("Product" + dataId)[0];
        if (product) {
            var variants = product.Variants;
            var combinations = product.Combinations;

            if (variants.length > 0 && combinations.length > 0) {
                Variants.SetVariantOptionStates(variants, combinations);
                Variants.HandleSelection(variants, productId, dataId, false);
            }
        }
    }
}

Variants.prototype.SetProductFeedId = function (id) {
    productFeedId = id;
}

Variants.prototype.SetProductUrl = function (url) {
    productUrl = url;
}

Variants.prototype.SetViewMode = function (mode) {
    viewMode = mode;
}

Variants.prototype.InitVariants = function (variants, combinations, productId, uniqueId) {
    viewMode = "singleProduct";
    var data = [];
    Variants.SetVariantOptionStates(variants, combinations);
    Variants.HandleSelection(variants, productId, uniqueId, false);
    var obj = new Variants.VariantObject(productId, variants, combinations);
    data.push(obj);
}

Variants.prototype.UpdateVariants = function (selectedVariant, createItemsFromJSON, updateLocation) {
    var data = Variants.ModifyDataByAvailableVariants(selectedVariant, updateLocation);

    if (createItemsFromJSON != false) {
        var dataId = selectedVariant.getAttribute("data-id");
        HandlebarsBolt.CreateItemsFromJson(data, "Variants" + dataId);
    }

    var event = new CustomEvent('variantsUpdate', { 'detail': { 'selectedVariant': selectedVariant, 'createItemsFromJSON': createItemsFromJSON, 'data': data } });
    document.dispatchEvent(event);
}

Variants.prototype.ModifyDataByAvailableVariants = function (selectedVariant, updateLocation) {
    var dataId = selectedVariant.getAttribute("data-id");
    var variantId = selectedVariant.getAttribute("data-variant-id");
    var productId = selectedVariant.getAttribute("data-product-id");
    var variantsData = HandlebarsBolt.FindDataInCache("Variants" + dataId);
    var combinations = HandlebarsBolt.FindDataInCache("Combinations" + dataId);

    Variants.ChangeSelectedOption(variantId, variantsData);
    Variants.SetVariantOptionStates(variantsData, combinations);
    Variants.HandleSelection(variantsData, productId, dataId, true, updateLocation);

    HandlebarsBolt.SetDataInCache(("Variants" + dataId), variantsData);

    return variantsData;
}

Variants.prototype.HandleSelection = function (variants, productId, dataId, updateContent, updateLocation) {
    var selections = Variants.FindSelectedVariants(variants);

    if (selections.length == variants.length) {
        var selectedVariantId = selections.join(".");
        if (viewMode == "singleProduct" && updateLocation) {
            var queryParams = new QueryArray();
            queryParams.setPath(productUrl, true);
            queryParams.setValue("VariantID", selectedVariantId);
            updateContent = false;
            location.href = queryParams.getFullUrl();
        }
        var variantElement = document.getElementById("Variant_" + productId);
        if (variantElement) {
            variantElement.value = selectedVariantId;
        }
        Variants.SelectionComplete(productId, dataId, selections, updateContent);
    } else {
        Variants.SelectionMissing(productId, dataId);
    }
}

Variants.prototype.ChangeSelectedOption = function (selectedVariantId, variants) {
    for (var i = 0; i < variants.length; i++) {
        var groupOptions = variants[i]['VariantOptions'];
        if (groupOptions.some(function (option) {
            return option.variantId == selectedVariantId;
        })) {
            groupOptions.forEach(function (option) {
                var selected = (option.variantId == selectedVariantId ? (option.selected == "checked" ? "" : "checked") : "");
                option.selected = selected;
                if (viewMode == "singleProduct") {
                    if (selected == "checked") {
                        if (document.getElementById(option.productId + option.variantId)) {
                            document.getElementById(option.productId + option.variantId).classList.add("checked");
                        } else {
                            document.getElementById(option.id + option.variantId).classList.add("checked");
                        } 
                    } else {
                        if (document.getElementById(option.productId + option.variantId)) {
                            document.getElementById(option.productId + option.variantId).classList.remove("checked");
                        } else {
                            document.getElementById(option.id + option.variantId).classList.remove("checked");
                        }
                    }
                    if (document.getElementById(option.productId + option.variantId)) {
                        document.getElementById(option.productId + option.variantId).setAttribute("data-check", selected);
                    } else {
                        document.getElementById(option.id + option.variantId).setAttribute("data-check", selected);
                    }
                }
            });
        }
    }
}

Variants.prototype.SetVariantOptionStates = function (variants, combinations) {
    var availableVariants = [];

    var selectedCombination = variants.map(function (vg) {
        var selectedOption = vg['VariantOptions'].filter(function (option) {
            return option.selected == "checked";
        })[0];
        return selectedOption ? selectedOption.variantId : "";
    });

    combinations = combinations.map(function (combination) { return combination.id.split("."); });

    if (combinations.length > 0) {
        var combinationsByGroup = [];
        combinations.forEach(function (arr, key) {
            arr.forEach(function (val, arrkey) {
                if (!combinationsByGroup[arrkey]) { combinationsByGroup[arrkey] = []; }
                combinationsByGroup[arrkey].push(val);
            });
        });

        for (currentVariantGroup = 0; currentVariantGroup < variants.length; currentVariantGroup++) {
            var disabledOptions = [];
            var otherOptionsSelected = false;
            for (otherVariantGroup = 0; otherVariantGroup < variants.length; otherVariantGroup++) {
                if (selectedCombination[otherVariantGroup] != "") {
                    if (otherVariantGroup != currentVariantGroup) {
                        otherOptionsSelected = true;
                        var otherGroupAvailableCombinations = combinationsByGroup[otherVariantGroup];

                        var availableOptions = []
                        for (var i = 0; i < otherGroupAvailableCombinations.length ; i++) {
                            var otherAvailableCombination = otherGroupAvailableCombinations[i];
                            if (otherAvailableCombination == selectedCombination[otherVariantGroup]) {
                                availableOptions.push(combinationsByGroup[currentVariantGroup][i]);
                            }
                        }

                        for (property in variants[currentVariantGroup]) {
                            var groupProperty = variants[currentVariantGroup][property];

                            if (typeof groupProperty == 'object') {
                                var otherGroupProperty = variants[otherVariantGroup][property];
                                for (variantOption = 0; variantOption < groupProperty.length; variantOption++) {
                                    //var found = false;
                                    var otherGroupOption = otherGroupProperty[variantOption];
                                    var groupOption = groupProperty[variantOption];

                                    if (availableOptions.indexOf(groupOption.variantId) == -1) {
                                        disabledOptions.push(groupOption.variantId);
                                        if (viewMode == "singleProduct") {
                                            if (document.getElementById(groupOption.productId + groupOption.variantId)) {
                                                document.getElementById(groupOption.productId + groupOption.variantId).disabled = true;
                                                document.getElementById(groupOption.productId + groupOption.variantId).classList.add("disabled");
                                            } else {
                                                document.getElementById(groupOption.id + groupOption.variantId).disabled = true;
                                                document.getElementById(groupOption.id + groupOption.variantId).classList.add("disabled");
                                            }
                                        }
                                        groupOption.disabled = "disabled";
                                    } else if (disabledOptions.indexOf(groupOption.variantId) == -1) {
                                        if (viewMode == "singleProduct") {
                                            if (document.getElementById(groupOption.productId + groupOption.variantId)) {
                                                document.getElementById(groupOption.productId + groupOption.variantId).disabled = false;
                                                document.getElementById(groupOption.productId + groupOption.variantId).classList.remove("disabled");
                                            } else {
                                                document.getElementById(groupOption.id + groupOption.variantId).disabled = false;
                                                document.getElementById(groupOption.id + groupOption.variantId).classList.remove("disabled");
                                            }
                                        }
                                        groupOption.disabled = "";
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (!otherOptionsSelected) {
                variants[currentVariantGroup]['VariantOptions'].forEach(function (option) {
                    if (viewMode == "singleProduct") {
                        if (document.getElementById(option.productId + option.variantId)) {
                            document.getElementById(option.productId + option.variantId).disabled = false;
                            document.getElementById(option.productId + option.variantId).classList.remove("disabled");
                        } else {
                            document.getElementById(option.id + option.variantId).disabled = false;
                            document.getElementById(option.id + option.variantId).classList.remove("disabled");
                        }
                    }
                    option.disabled = "";
                });
            }
        }
    }

    return variants;
}

Variants.prototype.FindSelectedVariants = function (variants) {
    var selections = [];
    for (variantGroup = 0; variantGroup < variants.length; variantGroup++) {
        for (property in variants[variantGroup]) {
            if (typeof variants[variantGroup][property] == 'object') {
                for (variantOption = 0; variantOption < variants[variantGroup][property].length; variantOption++) {
                    if (variants[variantGroup][property][variantOption].selected == "checked") {
                        selections.push(variants[variantGroup][property][variantOption].variantId);
                    }
                }
            }
        }
    }
    return selections;
}

Variants.prototype.ResetSelections = function (variants) {
    for (variantGroup = 0; variantGroup < variants.length; variantGroup++) {
        for (property in variants[variantGroup]) {
            if (typeof variants[variantGroup][property] == 'object') {
                for (variantOption = 0; variantOption < variants[variantGroup][property].length; variantOption++) {
                    variants[variantGroup][property][variantOption].selected = "";
                    variants[variantGroup][property][variantOption].disabled = "";
                }
            }
        }
    }
    return variants;
}

Variants.prototype.SelectionMissing = function (productId, dataId) {
    var cartButton = document.getElementById('CartButton_' + dataId);
    var helpText = document.getElementById('helpText_' + dataId);
    var variantElement = document.getElementById('Variant_' + productId);
    var favorite = document.getElementById('Favorite' + productId);

    if (cartButton) {
        cartButton.disabled = true;
        cartButton.classList.add('disabled');
    }

    if (helpText) {
        helpText.classList.remove('u-visibility-hidden');
    }

    if (variantElement) {
        variantElement.value = '';
    }

    if (favorite) {
        favorite.classList.add('disabled');
    }
}

Variants.prototype.SelectionComplete = function (productId, dataId, selections, updateContent) {
    var cartButton = document.getElementById('CartButton_' + dataId);
    var helpText = document.getElementById('helpText_' + dataId);
    var variantElement = document.getElementById('Variant_' + productId);
    var favorite = document.getElementById('Favorite' + productId);
    
    if (cartButton) {
        cartButton.disabled = false;
        cartButton.classList.remove('disabled');
    }

    if (helpText) {
        helpText.classList.add('u-visibility-hidden');
    }

    var selectedVatiantId = selections.join(".");

    if (variantElement) {
        variantElement.value = selectedVatiantId;
    }

    if (favorite) {
        favorite.classList.remove('disabled');
    }

    if (updateContent) {
    	var feedUrl = "/Default.aspx?ID=" + productFeedId + "&ProductID=" + productId + "&VariantID=" + selectedVatiantId + "&rid=" + dataId + "&feed=true&redirect=false";
        var containerId = "Product" + dataId;

        HandlebarsBolt.UpdateContent(containerId, feedUrl);

        document.getElementById(containerId).addEventListener("contentLoaded", function (e) {
            viewMode = "singleProduct";

            var variantContainer = document.getElementById(e.detail.containerId).getElementsByClassName("js-variants-wrap")[0];
            Variants.SetVariantOptionStatesForProductList(variantContainer);
        });

        var event = new CustomEvent('variantsSelectionComplete', { 'detail': { 'currentTarget': document.getElementById(containerId), 'feedUrl': feedUrl } });
        document.dispatchEvent(event);
    }
}

var Variants = new Variants();

