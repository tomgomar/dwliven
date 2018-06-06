var cartId;
var productsCount = -1;

var Cart = function () { }

Cart.prototype.InitMiniCart = function () {
    var miniCart = document.getElementsByClassName('js-mini-cart')[0];

    if (miniCart) {
        cartId = miniCart.getAttribute('data-cart-id');
    }

    window.onscroll = function () { Cart.toggleFloatingVisibility() };
}

document.addEventListener("DOMContentLoaded", function (event) {
    Cart.InitMiniCart();
});

Cart.prototype.toggleFloatingVisibility = function (e) {
    if (document.getElementById("FloatingMiniCart")) {
        var topHeight = document.getElementById("Top").clientHeight;
        var floatingMiniCart = document.getElementById("FloatingMiniCart");

        if (document.body.scrollTop > topHeight || document.documentElement.scrollTop > topHeight) {
            floatingMiniCart.classList.remove("u-hidden");
        } else {
            floatingMiniCart.classList.add("u-hidden");
        }
    }
}

Cart.prototype.EmptyCart = function(e) {
    e.preventDefault();

    var url = "/Default.aspx?ID=" + cartId;
    Cart.UpdateCart('miniCart', url, "&cartcmd=emptycart", true);
    
    var miniCartDropdowns = document.getElementsByClassName("js-mini-cart");
    for (var i = 0; i < miniCartDropdowns.length; i++) {
        miniCartDropdowns[i].innerHTML = "";

        var event = new CustomEvent('emptyCart');
        document.dispatchEvent(event);
    } 
}

Cart.prototype.AddToCart = function(e, productId, quantity, unitElement, variantElement) {
    e.preventDefault();

    if (quantity > 0) {
        var clickedButton = e.currentTarget;
        var clickedButtonText = clickedButton.innerHTML;
        var clickedButtonWidth = clickedButton.clientWidth;
        clickedButton.classList.add("disabled");
        clickedButton.disabled = true;
        clickedButton.innerHTML = "";
        clickedButton.innerHTML = "<i class=\"fa fa-circle-o-notch fa-spin\"></i>";
        clickedButton.style.width = clickedButtonWidth + "px";

        setTimeout(function () {
            clickedButton.innerHTML = clickedButtonText;
            clickedButton.classList.remove("disabled");
            clickedButton.disabled = false;
            clickedButton.style = "";
        },
        1400);

        var url = "/Default.aspx?ID=" + cartId;
        url += "&Quantity=" + quantity;
        url += "&Redirect=false";

        var variantId = "";
        var unit = "";

        if (document.getElementById(unitElement)) {
            unit = document.getElementById(unitElement).value;
            url += "&UnitID=" + unit;
        }

        if (productId.toLowerCase().indexOf("prod") != -1) {
            url += "&ProductID=" + productId;

            if (window.location.search.indexOf("VariantID") != -1) {
                url += "&VariantID=" + location.search.split('VariantID=')[1];
            } else if (variantElement) {
                var variantIdElement = document.getElementById(variantElement);
                if (variantIdElement) {
                    variantId = variantIdElement.value;
                    url += "&VariantID=" + variantId;
                }
            }
        } else {
            url += "&ProductNumber=" + productId;
        }

        var event = new CustomEvent('addToCart', { 'detail': { 'productId': productId, "variantId": variantId, "unitId": unit, "quantity": quantity } });
        document.dispatchEvent(event);

        Cart.UpdateCart('miniCart', url, "&cartcmd=add", false);
    }
}

Cart.prototype.UpdateCart = function (containerId, url, command, preloader) {
    if (containerId) {
        if (preloader == true) {
            var overlayElement = document.createElement('div');
            overlayElement.className = "preloader-overlay";
            overlayElement.setAttribute('id', "CartOverlay");
            var overlayElementIcon = document.createElement('div');
            overlayElementIcon.className = "preloader-overlay__icon";
            overlayElementIcon.style.top = window.pageYOffset + "px";
            overlayElement.appendChild(overlayElementIcon);

            document.getElementById('content').parentNode.insertBefore(overlayElement, document.getElementById('content'));
        }

        var miniCartButtons = document.getElementsByClassName("js-mini-cart-button");
        for (var i = 0; i < miniCartButtons.length; i++) {
            var cartButton = document.getElementsByClassName("js-mini-cart-button")[i];
            cartButton.classList.add("mini-cart-update");
            setCartAnimationDelay(cartButton);
        }

        function setCartAnimationDelay(cartButton) {
            setTimeout(function () {
                cartButton.classList.remove("mini-cart-update");
            }, 2800);
        }

        var xhr = new XMLHttpRequest();
        xhr.open('POST', url + command + "&feedtype=Counter");
        xhr.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                if (preloader == true) {
                    var overlayNode = document.getElementById('CartOverlay');
                    overlayNode.parentNode.removeChild(overlayNode);
                }

                if (document.getElementById(containerId) && containerId != "miniCart") {
                    HandlebarsBolt.UpdateContent(containerId, url);
                }

                var miniCartCounters = document.getElementsByClassName("js-mini-cart-counter");
                var dataObject = "";
                for (var i = 0; i < miniCartCounters.length; i++) {
                    var cartCounter = document.getElementsByClassName("js-mini-cart-counter")[i];

                    if (cartCounter && Cart.IsJsonString(this.response)) {
                        cartCounter.innerHTML = "";
                        dataObject = JSON.parse(this.response);
                        HandlebarsBolt.CreateItemsFromJson(JSON.parse(this.response), cartCounter.getAttribute("id"));
                    }
                }

                var event = new CustomEvent('cartUpdated', { 'detail': { "command": command, "containerId": containerId, "url": url, "preloader": preloader, "data": dataObject } });
                document.dispatchEvent(event);
            }
            if (this.readyState == 4 && this.status == 200 && Cart.IsJsonString(this.response) == false) {
                location.reload();
            }
        };
        xhr.send();
    } else {
        console.log("Cart: The container does not exist");
    }
}

Cart.prototype.IsJsonString = function (str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}

var updateDelay;

Cart.prototype.UpdateQuantity = function (containerId, url, action, preloader) {
    clearTimeout(updateDelay);

    updateDelay = setTimeout(function () {
        Cart.UpdateCart(containerId, url, action, preloader);
    }, 800);
}

var hideTimeOut;

Cart.prototype.UpdateMiniCart = function (e, containerId, url) {
    clearTimeout(hideTimeOut);
    var miniCartCounter = e.currentTarget.getElementsByClassName("js-mini-cart-counter-content")[0];

    if (document.getElementById(containerId) && document.getElementById(containerId).style.display != "block") {
        if (miniCartCounter.innerText > 0) {
            HandlebarsBolt.UpdateContent(containerId, url);
        }

        document.getElementById(containerId).style.display = "block";

        document.getElementById(containerId).onmouseleave = function (e) {
            if (e.relatedTarget.id == "miniCartCounterWrap") {
                return;
            }
            var miniCartDropdown = e.currentTarget;
            hideTimeOut = setTimeout(function () {
                miniCartDropdown.style.display = "none";
            }, 1000);
        }

        e.currentTarget.onmouseleave = function (e) {
            clearTimeout(hideTimeOut);

            if (e.relatedTarget.id == "miniCartCounterWrap") {
                return;
            }

            var miniCartDropdown = document.getElementById(containerId);
            hideTimeOut = setTimeout(function () {
                miniCartDropdown.style.display = "none";
            }, 1000);
        }

        document.getElementById(containerId).onmouseenter = function (e) {
            clearTimeout(hideTimeOut);
        }
    }
}

Cart.prototype.EnableCheckoutButton = function () {
    var stepButtonId = document.getElementById("CartV2.GotoStep3") ? "CartV2.GotoStep3" : "CartV2.GotoStep1";

    if (document.getElementById("EcomOrderCustomerAccepted").checked) {
        document.getElementById(stepButtonId).disabled = false;
        document.getElementById(stepButtonId).classList.remove('disabled');
    } else {
        document.getElementById(stepButtonId).disabled = true;
        document.getElementById(stepButtonId).classList.add('disabled');
    }
}

Cart.prototype.DeselectRadioGroup = function (radioGroupName) {
    var radioList = document.getElementsByName(radioGroupName);
    for (var i = 0; i < radioList.length; i++) {
        if (radioList[i].checked) radioList[i].checked = false;
    }
}

Cart.prototype.SubmitCart = function () {
    document.getElementById('OrderSubmit').submit();
}

Cart.prototype.SelectParcelShop = function (locationData) {
    document.getElementById(locationData.fieldPrefix + "ParcelShopNumber_" + locationData.number).checked = true;
}

var Cart = new Cart();
