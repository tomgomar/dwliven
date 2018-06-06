/*!
  hey, [be]Lazy.js - v1.8.2 - 2016.10.25
  A fast, small and dependency free lazy load script (https://github.com/dinbror/blazy)
  (c) Bjoern Klinggaard - @bklinggaard - http://dinbror.dk/blazy
*/
(function (q, m) { "function" === typeof define && define.amd ? define(m) : "object" === typeof exports ? module.exports = m() : q.Blazy = m() })(this, function () { function q(b) { var c = b._util; c.elements = E(b.options); c.count = c.elements.length; c.destroyed && (c.destroyed = !1, b.options.container && l(b.options.container, function (a) { n(a, "scroll", c.validateT) }), n(window, "resize", c.saveViewportOffsetT), n(window, "resize", c.validateT), n(window, "scroll", c.validateT)); m(b) } function m(b) { for (var c = b._util, a = 0; a < c.count; a++) { var d = c.elements[a], e; a: { var g = d; e = b.options; var p = g.getBoundingClientRect(); if (e.container && y && (g = g.closest(e.containerClass))) { g = g.getBoundingClientRect(); e = r(g, f) ? r(p, { top: g.top - e.offset, right: g.right + e.offset, bottom: g.bottom + e.offset, left: g.left - e.offset }) : !1; break a } e = r(p, f) } if (e || t(d, b.options.successClass)) b.load(d), c.elements.splice(a, 1), c.count--, a-- } 0 === c.count && b.destroy() } function r(b, c) { return b.right >= c.left && b.bottom >= c.top && b.left <= c.right && b.top <= c.bottom } function z(b, c, a) { if (!t(b, a.successClass) && (c || a.loadInvisible || 0 < b.offsetWidth && 0 < b.offsetHeight)) if (c = b.getAttribute(u) || b.getAttribute(a.src)) { c = c.split(a.separator); var d = c[A && 1 < c.length ? 1 : 0], e = b.getAttribute(a.srcset), g = "img" === b.nodeName.toLowerCase(), p = (c = b.parentNode) && "picture" === c.nodeName.toLowerCase(); if (g || void 0 === b.src) { var h = new Image, w = function () { a.error && a.error(b, "invalid"); v(b, a.errorClass); k(h, "error", w); k(h, "load", f) }, f = function () { g ? p || B(b, d, e) : b.style.backgroundImage = 'url("' + d + '")'; x(b, a); k(h, "load", f); k(h, "error", w) }; p && (h = b, l(c.getElementsByTagName("source"), function (b) { var c = a.srcset, e = b.getAttribute(c); e && (b.setAttribute("srcset", e), b.removeAttribute(c)) })); n(h, "error", w); n(h, "load", f); B(h, d, e) } else b.src = d, x(b, a) } else "video" === b.nodeName.toLowerCase() ? (l(b.getElementsByTagName("source"), function (b) { var c = a.src, e = b.getAttribute(c); e && (b.setAttribute("src", e), b.removeAttribute(c)) }), b.load(), x(b, a)) : (a.error && a.error(b, "missing"), v(b, a.errorClass)) } function x(b, c) { v(b, c.successClass); c.success && c.success(b); b.removeAttribute(c.src); b.removeAttribute(c.srcset); l(c.breakpoints, function (a) { b.removeAttribute(a.src) }) } function B(b, c, a) { a && b.setAttribute("srcset", a); b.src = c } function t(b, c) { return -1 !== (" " + b.className + " ").indexOf(" " + c + " ") } function v(b, c) { t(b, c) || (b.className += " " + c) } function E(b) { var c = []; b = b.root.querySelectorAll(b.selector); for (var a = b.length; a--; c.unshift(b[a])); return c } function C(b) { f.bottom = (window.innerHeight || document.documentElement.clientHeight) + b; f.right = (window.innerWidth || document.documentElement.clientWidth) + b } function n(b, c, a) { b.attachEvent ? b.attachEvent && b.attachEvent("on" + c, a) : b.addEventListener(c, a, { capture: !1, passive: !0 }) } function k(b, c, a) { b.detachEvent ? b.detachEvent && b.detachEvent("on" + c, a) : b.removeEventListener(c, a, { capture: !1, passive: !0 }) } function l(b, c) { if (b && c) for (var a = b.length, d = 0; d < a && !1 !== c(b[d], d) ; d++); } function D(b, c, a) { var d = 0; return function () { var e = +new Date; e - d < c || (d = e, b.apply(a, arguments)) } } var u, f, A, y; return function (b) { if (!document.querySelectorAll) { var c = document.createStyleSheet(); document.querySelectorAll = function (a, b, d, h, f) { f = document.all; b = []; a = a.replace(/\[for\b/gi, "[htmlFor").split(","); for (d = a.length; d--;) { c.addRule(a[d], "k:v"); for (h = f.length; h--;) f[h].currentStyle.k && b.push(f[h]); c.removeRule(0) } return b } } var a = this, d = a._util = {}; d.elements = []; d.destroyed = !0; a.options = b || {}; a.options.error = a.options.error || !1; a.options.offset = a.options.offset || 100; a.options.root = a.options.root || document; a.options.success = a.options.success || !1; a.options.selector = a.options.selector || ".b-lazy"; a.options.separator = a.options.separator || "|"; a.options.containerClass = a.options.container; a.options.container = a.options.containerClass ? document.querySelectorAll(a.options.containerClass) : !1; a.options.errorClass = a.options.errorClass || "b-error"; a.options.breakpoints = a.options.breakpoints || !1; a.options.loadInvisible = a.options.loadInvisible || !1; a.options.successClass = a.options.successClass || "b-loaded"; a.options.validateDelay = a.options.validateDelay || 25; a.options.saveViewportOffsetDelay = a.options.saveViewportOffsetDelay || 50; a.options.srcset = a.options.srcset || "data-srcset"; a.options.src = u = a.options.src || "data-src"; y = Element.prototype.closest; A = 1 < window.devicePixelRatio; f = {}; f.top = 0 - a.options.offset; f.left = 0 - a.options.offset; a.revalidate = function () { q(a) }; a.load = function (a, b) { var c = this.options; void 0 === a.length ? z(a, b, c) : l(a, function (a) { z(a, b, c) }) }; a.destroy = function () { var a = this._util; this.options.container && l(this.options.container, function (b) { k(b, "scroll", a.validateT) }); k(window, "scroll", a.validateT); k(window, "resize", a.validateT); k(window, "resize", a.saveViewportOffsetT); a.count = 0; a.elements.length = 0; a.destroyed = !0 }; d.validateT = D(function () { m(a) }, a.options.validateDelay, a); d.saveViewportOffsetT = D(function () { C(a.options.offset) }, a.options.saveViewportOffsetDelay, a); C(a.options.offset); l(a.options.breakpoints, function (a) { if (a.width >= window.screen.width) return u = a.src, !1 }); setTimeout(function () { q(a) }) } });


//Our initializer
var bLazy = new Blazy({
    breakpoints: [{
        width: 420 // Max-width
      , loadInvisible: true
      , src: 'data-src-small'
    }]
});
var Carousel = function () { }

var slideTimer;

document.addEventListener("DOMContentLoaded", function (event) {
    var carousels = document.getElementsByClassName("js-carousel-container");

    for (var i = 0; i < carousels.length; i++) {
        Carousel.SlideShow(carousels[i]);
    }
});

Carousel.prototype.SlideShow = function (currentCarousel) {
    var carouselContainer = currentCarousel;
    var carouselData = carouselContainer.getElementsByClassName('js-carousel-data')[0];
    if (!carouselData) {
        return;
    }
    var currentSlide = carouselData.hasAttribute("data-current-slide") ? carouselData.getAttribute("data-current-slide") : 0;
    var totalSlides = carouselData != null ? carouselData.getAttribute("data-total-slides") : 0;
    var direction = carouselData.hasAttribute("data-direction") ? carouselData.getAttribute("data-direction") : "horizontal";
    var slidingType = carouselData.hasAttribute("data-sliding-type") ? carouselData.getAttribute("data-sliding-type") : "full";

    var slideHeight = carouselContainer.firstElementChild.firstElementChild.firstElementChild.offsetHeight + 5;
    var slideWidth = carouselContainer.firstElementChild.firstElementChild.firstElementChild.offsetWidth + 5;
    var slidesInView = carouselData.hasAttribute("data-slides-in-view") ? carouselData.getAttribute("data-slides-in-view") : 5;
    var slidesLeft = totalSlides - slidesInView;

    if (direction == "vertical") {
        carouselContainer.firstElementChild.style.top = 0;
    } else {
        carouselContainer.firstElementChild.style.left = 0;
    }

    if (slidingType == "items") {
        totalSlides = slidesLeft;
    }

    if (totalSlides > 1 && carouselData.getAttribute("data-carousel-slide-time") > 0) {
        slideTimer = setTimeout(function () {
            Carousel.ShiftSlide(currentCarousel, "next");
        }, carouselData.getAttribute("data-carousel-slide-time") * 1000);
    }

    if (totalSlides <= 1) {
        carouselData.classList.add("u-hidden");
    }

    var event = new CustomEvent('initSlideShow', { 'detail': { 'currentTarget': carouselContainer, 'currentSlide': currentSlide, 'totalSlides': totalSlides, 'direction': direction, "slidingType": slidingType } });
    carouselContainer.dispatchEvent(event);
    document.dispatchEvent(event);
}

Carousel.prototype.GetPreviousSlide = function (thisButton) {
    clearTimeout(slideTimer);
    Carousel.ShiftSlide(thisButton, "prev");
}

Carousel.prototype.GetNextSlide = function (thisButton) {
    clearTimeout(slideTimer);
    Carousel.ShiftSlide(thisButton, "next");
}

Carousel.prototype.GoToSlide = function (thisButton, number) {
    clearTimeout(slideTimer);
    Carousel.ShiftSlide(thisButton, number);
}

Carousel.prototype.ShiftSlide = function (thisButton, slideTo) {
    var carouselContainer = thisButton.closest('.js-carousel-container');
    var carouselData = thisButton.closest('.js-carousel-data') != null ? thisButton.closest('.js-carousel-data') : thisButton.getElementsByClassName('js-carousel-data')[0];
    var currentSlide = carouselData.hasAttribute("data-current-slide") ? carouselData.getAttribute("data-current-slide") : 0;
    var totalSlides = carouselData.getAttribute("data-total-slides");
    var direction = carouselData.hasAttribute("data-direction") ? carouselData.getAttribute("data-direction") : "horizontal";
    var slidingType = carouselData.hasAttribute("data-sliding-type") ? carouselData.getAttribute("data-sliding-type") : "full";

    var slideHeight = carouselContainer.firstElementChild.firstElementChild.firstElementChild.offsetHeight - 5;
    var slideWidth = carouselContainer.firstElementChild.firstElementChild.firstElementChild.offsetWidth + 5;
    var slidesInView = carouselData.hasAttribute("data-slides-in-view") ? carouselData.getAttribute("data-slides-in-view") : 5;
    var slidesLeft = totalSlides - slidesInView;

    //console.log(slideHeight);

    if (slidingType == "items") {
        totalSlides = slidesLeft;
    }

    if (slideTo == "next" || null) {
        if (currentSlide < (totalSlides - 1)) {
            currentSlide++;
        } else {
            currentSlide = 0;
        }
    }

    if (slideTo == "prev") {
        if (currentSlide > 0) {
            currentSlide--;
        } else {
            currentSlide = (totalSlides - 1);
        }
    }

    if (Number.isInteger(slideTo)) {
        currentSlide = slideTo;
    }

    if (direction == "vertical") {
        if (slidingType == "items") {
            carouselContainer.firstElementChild.style.top = -(currentSlide * slideHeight) + "px";
        } else {
            carouselContainer.firstElementChild.style.top = -(currentSlide * 100) + "%";
        }
    } else {
        if (slidingType == "items") {
            carouselContainer.firstElementChild.style.left = -(currentSlide * slideWidth) + "px";
        } else {
            carouselContainer.firstElementChild.style.left = -(currentSlide * 100) + "%";
        }
    }

    if (totalSlides <= 1) {
        carouselData.classList.add("u-hidden");
    }

    if (totalSlides > 1 && carouselData.getAttribute("data-carousel-slide-time") > 0) {
        slideTimer = setTimeout(function () {
            Carousel.ShiftSlide(carouselContainer, "next");
        }, carouselData.getAttribute("data-carousel-slide-time") * 1000);
    }

    carouselData.setAttribute("data-current-slide", currentSlide);

    var currentSlideElement = carouselContainer.getElementsByClassName("carousel__container__slide")[currentSlide];

    var event = new CustomEvent('shiftSlide', { 'detail': { 'currentTarget': carouselContainer, 'slideTo': slideTo, 'currentSlide': currentSlide, 'currentSlideElement': currentSlideElement, 'totalSlides': totalSlides } });
    carouselContainer.dispatchEvent(event);
    document.dispatchEvent(event);
}

var Carousel = new Carousel();
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

var Dynamo = function () { }
var cache = {};

var dynamoConfig = {
    hiddenClass: "u-hidden",
    preloaderClass: "fa fa-circle-o-notch fa-spin preloader",
    preloaderOverlayClass: "preloader-overlay",
    preloaderOverlayIconClass: "preloader-overlay__icon",
    preloaderOverlayLocationID: "content"
};

Dynamo.prototype.GetConfiguration = function () {
    if (typeof DynamoConfig == 'object') {
        dynamoConfig = DynamoConfig.Configuration();
    }
}

//Update the template on the chosen element
Dynamo.prototype.UpdateTemplate = function (id, tmpl) {
    var data = Dynamo.FindDataInCache(id);
    var ajaxContainerElement = document.getElementById(id);

    ajaxContainerElement.setAttribute("data-template", tmpl);

    if (ajaxContainerElement.hasAttribute('data-save-cookie')) {
        var expiryTime = new Date();
        expiryTime.setTime(expiryTime.getTime() + (24 * 3600 * 1000));
        document.cookie = id + "Template=" + tmpl + "; expires=" + expiryTime;
    }

    var event = new CustomEvent('updateTemplate', { 'detail': { 'containerId': id, "templateId": tmpl } });
    ajaxContainerElement.dispatchEvent(event);

    Dynamo.CreateItemsFromJson(data, ajaxContainerElement, false);
}

//Find the temporaily saved data for the selected element
Dynamo.prototype.FindDataInCache = function (id) {
    for (var property in cache) {
        if (property == id) {
            return cache[property];
        }
    }
}

//Create data in the cache object (Must be validated Json)
Dynamo.prototype.SetDataInCache = function (id, data) {
    cache[id] = data;
}

//Update the content on the chosen element + subelements (New data request by url)
Dynamo.prototype.UpdateContent = function (containerId, url, updateUrl) {
    var ajaxContainerElement = document.getElementById(containerId);

    if (ajaxContainerElement) {
        if (url) {
            ajaxContainerElement.setAttribute('data-json-feed', url);
        } else {
            url = ajaxContainerElement.getAttribute('data-json-feed');
        }

        //Update the browser url
        if (updateUrl == true) {
            history.pushState(null, null, url);
        }

        Dynamo.GetContentFromJson(ajaxContainerElement);
    } else {
        console.log("There may be missing an Ajax container element: " + containerId);
    }
}

//Add content to the chosen element + subelements (New data request by url)
Dynamo.prototype.AddContent = function (containerId, url) {
    var ajaxContainerElement = document.getElementById(containerId);
    ajaxContainerElement.setAttribute('data-json-feed', url);

    Dynamo.GetContentFromJson(ajaxContainerElement, true);
}

//Call the Json provider, and show a preloader if it is chosen
Dynamo.prototype.GetContentFromJson = function (container, addToExisting) {
    var feed = container.getAttribute('data-json-feed');
    feed = feed.replace("?debug=true", "");
    feed = feed.replace("&debug=true", "");

    if (container.getAttribute('data-preloader') == "minimal") {
        if (!addToExisting) {
            while (container.firstChild) container.removeChild(container.firstChild);
        }

        container.classList.remove(dynamoConfig.hiddenClass);

        var preloaderElement = document.createElement('i');
        preloaderElement.className = dynamoConfig.preloaderClass;
        preloaderElement.setAttribute('id', (container.getAttribute('id') + "_preloader"));
        container.appendChild(preloaderElement);
    } else if (container.getAttribute('data-preloader') == "overlay") {
        var overlayElement = document.createElement('div');
        overlayElement.className = dynamoConfig.preloaderOverlayClass;
        overlayElement.setAttribute('id', "overlay");
        var overlayElementIcon = document.createElement('div');
        overlayElementIcon.className = dynamoConfig.preloaderOverlayIconClass;
        overlayElementIcon.style.top = window.pageYOffset + "px";
        overlayElement.appendChild(overlayElementIcon);

        if (document.getElementById(dynamoConfig.preloaderOverlayLocationID)) {
            document.getElementById(dynamoConfig.preloaderOverlayLocationID).parentNode.insertBefore(overlayElement, document.getElementById(dynamoConfig.preloaderOverlayLocationID));
        }
    } 

    if (container.hasAttribute('data-pre-render-template') && !container.hasChildNodes()) {
        var preRenderElement = document.createElement('div');
        preRenderElement.innerHTML = Dynamo.LoadTemplate(container.getAttribute('data-pre-render-template'));

        var newElementNodes = preRenderElement.childNodes;
        for (var item = 1; item < newElementNodes.length; item++) {
            container.appendChild(newElementNodes[item]);
        }
    }

    if (/Edge\/\d./i.test(navigator.userAgent)) {
        var currentTime = new Date();
        feed += "&Tick=" + currentTime.getTime();
    }

    var xhr = new XMLHttpRequest();
    xhr.open('GET', feed, true);
    xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var data;

            if (this.response.trim() != "" && Dynamo.IsJsonString(this.response)) {
                if (xhr.responseType === 'json') {
                    data = xhr.response.message;
                } else {
                    data = JSON.parse(this.response);
                }

                if (!addToExisting) {
                    cache[container.getAttribute('id')] = data;
                } else {
                    for (var i = 0; i < data.length; i++) {
                        cache[container.getAttribute('id')].push(data[i]);
                    }
                }

                Dynamo.CreateItemsFromJson(data, container, addToExisting);
            } else {
                if (container.hasAttribute('data-no-result-template')) {
                    while (container.firstChild) container.removeChild(container.firstChild);

                    if (document.getElementById('overlay')) {
                        document.getElementById('overlay').parentNode.removeChild(document.getElementById('overlay'));
                    }

                    var noResultsRenderElement = document.createElement('div');
                    noResultsRenderElement.innerHTML = Dynamo.LoadTemplate(container.getAttribute('data-no-result-template'));

                    var newElementNodes = noResultsRenderElement.childNodes;
                    for (var item = 1; item < newElementNodes.length; item++) {
                        container.appendChild(newElementNodes[item]);
                    }
                }
            }
        } else {
            if (!container.hasAttribute('data-no-result-template')) {
                Dynamo.CleanContainer(container, addToExisting);
            }
        }
    };
    xhr.send();
}

Dynamo.prototype.IsJsonString = function (str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}

//Create visual elements from the data provided and with the chosen template
Dynamo.prototype.CreateItemsFromJson = function (data, container, addToExisting, count) {
    Dynamo.CleanContainer(container, addToExisting);

    if (!count) {
        count = 0;
    }

    if (document.body.contains(container)) {

        for (var i = 0; i < data.length; i++) {
            var templateId;

            //Get template from either the data attribute or a 'template' property in the JSON feed
            if (container.hasAttribute('data-template')) {
                templateId = container.getAttribute('data-template');
            } 
            
            for (var property in data[i]) {
                if (property == "template") {
                    if (data[i][property] != null) {
                        templateId = data[i][property];
                        container.setAttribute('data-template', templateId);
                    }
                }
            }

            //If a template setting is found in a cookie, then use that one insted af the above
            if (container.hasAttribute('data-save-cookie')) {
                if (Dynamo.GetCookie(container.getAttribute("id") + "Template")) {
                    templateId = Dynamo.GetCookie(container.getAttribute("id") + "Template");
                }

                var cookieId = container.getAttribute("id") + "Template=";
                if (document.cookie.indexOf(cookieId) != -1) {
                    document.cookie.replace(cookieId, templateId)
                } else {
                    document.cookie = cookieId + templateId;
                }  
            }

            //Create a temporary container to contain the parsed element before rendering
            var temporaryElementType = container.tagName;
            var temporaryElement = document.createElement(temporaryElementType);

            temporaryElement.innerHTML = Dynamo.RenderItem(data[i], templateId);

            //Secure that the element only contains unique IDs
            var uniqueNumber = new Date().getTime();
            temporaryElement.querySelectorAll('*').forEach(function (element) {
                for (var property in data[i]) {
                    if (typeof data[i][property] != 'object') {
                        if (element.getAttribute("id") != null) {
                            if (element.getAttribute("id") != property) {
                                if (document.getElementById(element.getAttribute("id"))) {
                                    element.setAttribute("id", element.getAttribute("id") + "_AutoID" + uniqueNumber);
                                }
                            }
                        }
                    }
                }
            });

            //Add the elements to the container
            var newElementNodes = temporaryElement.childNodes;
            for (var item = 1; item < newElementNodes.length; item++) {
                container.appendChild(newElementNodes[item]);
            }

            var event = new CustomEvent('itemCreated', { 'detail': data[i] });
            container.dispatchEvent(event);

            //Check to see if there is a sub nodelists in the data provided, if so then render new items 
            for (var property in data[i]) {
                if (typeof data[i][property] == 'object') {
                    var subContainer = document.getElementById(property);

                    //Make the ID unique for each sub object
                    var uniqueId = data[i].id ? property + data[i].id : count == 0 ? property : property + count;

                    //Fix for multiple instances of the same element (Fx. multiple mini carts), while supporting different views (Fx. a product list) 
                    if (document.getElementById(uniqueId)) {
                        if (!document.getElementById(uniqueId).hasAttribute('data-save-cookie')) {
                            uniqueId = uniqueId + uniqueNumber;
                        }
                    }

                    cache[uniqueId] = data[i][property];

                    if (subContainer) {
                        subContainer.setAttribute('id', uniqueId);
                        subContainer = document.getElementById(uniqueId);

                        var subData = data[i][property];

                        if (subData != null) {
                            if (subData.length > 0) {
                                Dynamo.CreateItemsFromJson(data[i][property], subContainer, addToExisting, count);
                            } else {
                                subContainer.classList.add(dynamoConfig.hiddenClass);
                            }
                        }
                    }

                    count++;
                }
            }
        }

        Dynamo.ContentCreated(container);
    }
}

Dynamo.prototype.ContentCreated = function (container) {
    container.classList.remove(dynamoConfig.hiddenClass);

    var event = document.createEvent('Event');
    event.initEvent('contentLoaded', true, true);
    container.dispatchEvent(event);

    if (bLazy != null) {
        setTimeout(function () {
            bLazy.revalidate();
        }, 100);
    }
}

//Clean the container for either all the elements or the preloader
Dynamo.prototype.CleanContainer = function (container, addToExisting) {
    if (document.body.contains(container)) {
        if (container.getAttribute('data-preloader') == "minimal" && document.getElementById(container.getAttribute('id') + "_preloader")) {
            container.removeChild(document.getElementById(container.getAttribute('id') + "_preloader"));
        } else if (document.getElementById('overlay')) {
            document.getElementById('overlay').parentNode.removeChild(document.getElementById('overlay'));
        }

        if (!addToExisting) {
            while (container.firstChild) container.removeChild(container.firstChild);
            container.classList.add(dynamoConfig.hiddenClass);
        }
    }
}

//Parse the data properties into the element                            
Dynamo.prototype.RenderItem = function (data, templateId) {
    var template = Dynamo.LoadTemplate(templateId);

    if (template != null) {
        for (var property in data) {
            var item = data[property];
            var nameKey = "{{" + property + "}}";

            if (typeof data[property] == 'object') {
                item = JSON.stringify(data[property]).replace(/\"/g, '\'');
            }

            template = template.replace(new RegExp(nameKey, "gi"), item);
        }
    }

    return template;
}

//Load the chosen template
Dynamo.prototype.LoadTemplate = function (templateId) {
    if (document.getElementById(templateId)) {
        return document.getElementById(templateId).innerHTML;
    } else {
        console.log("Dynamo: Template element not found - " + templateId);
        return null;
    }
}

//Parse to finde the chosen cookie
Dynamo.prototype.GetCookie = function(name) {
    var pattern = RegExp(name + "=.[^;]*"),
        matched = document.cookie.match(pattern);

    if (matched) {
        var cookie = matched[0].split('=')
        return cookie[1]
    }
    return false
}


//Auto initialization
var Dynamo = new Dynamo();

document.addEventListener("DOMContentLoaded", function (event) {
    Dynamo.GetConfiguration();

    var ajaxContainer = document.getElementsByClassName("js-ajax-container");

    for (var i = 0; i < ajaxContainer.length; i++) {
        var ajaxContainerElement = ajaxContainer[i];

        if (!ajaxContainerElement.getAttribute('data-json-feed')) {
            console.log("Ajax element: Please specify json feed via data attribute: data-json-feed");
        }

        if (!ajaxContainerElement.hasAttribute('data-init-onload') || ajaxContainerElement.getAttribute('data-init-onload') == false) {
            Dynamo.GetContentFromJson(ajaxContainerElement);
        } 
    }

    window.addEventListener('popstate', function (event) {
        location.reload();
    });
});
var DynamoConfig = function () { }

DynamoConfig.prototype.Configuration = function () {
  var dynamoConfigObject = {
    hiddenClass: "u-hidden",
    preloaderClass: "fa fa-circle-o-notch fa-spin preloader",
    preloaderOverlayClass: "preloader-overlay",
    preloaderOverlayIconClass: "preloader-overlay__icon",
    preloaderOverlayLocationID: "content"
  };

  return dynamoConfigObject;
}

var DynamoConfig = new DynamoConfig();
var Facets = function () { }
var _listContainerId = "";
var _catalogPageId = "";
var _requestQuery = "";

Facets.prototype.Init = function (listContainerId, catalogPageId, requestQuery) {
    _listContainerId = listContainerId;
    _catalogPageId = catalogPageId;
    _requestQuery = requestQuery == null ? "" : requestQuery;
}

Facets.prototype.UpdateFacets = function (facet) {
    //var path = window.location.pathname;
    var queryParams = new QueryArray(window.location.search);
    queryParams.setPath(window.location.pathname);

    queryParams.remove("ID");
    queryParams.remove("debug");

    queryParams.setValue("PageNum", 1, true);
    queryParams.setValue("pagesize", 30, true);
    queryParams.setValue("ScrollPos", 0, true);

    if (facet.tagName == "SELECT") {
        facet = facet.options[facet.selectedIndex];
    }

    var name = facet.getAttribute("name");
    var value = facet.getAttribute("value");

    if (facet.checked || facet.getAttribute("data-check") == "") {
        Facets.AddFacetToUrl(queryParams, name, value);
        facet.setAttribute("data-check", "checked");
        facet.classList.add("checked");
    } else {
        Facets.RemoveFacetFromUrl(queryParams, name, value);
        facet.setAttribute("data-check", "");
        facet.classList.remove("checked");
    }

    var browserUrl = queryParams.getFullUrl();
    history.pushState(null, null, browserUrl);

    //Remember the groupID
    var reqQueryParams = new QueryArray(_requestQuery);
    if (reqQueryParams.hasParam("groupid")) {
        queryParams.setValue("groupid", reqQueryParams.getValue("groupid"));
    }
    jsonQueryParams = queryParams.copy();
    jsonQueryParams.setValue("ID", _catalogPageId);
    jsonQueryParams.setPath("/Default.aspx");
    if (reqQueryParams.hasParam("feed")) {
        jsonQueryParams.setValue("feed", reqQueryParams.getValue("feed"));
    }
    jsonQueryParams.setValue("redirect", 'false');

    var jsonUrl = jsonQueryParams.getFullUrl();

    HandlebarsBolt.UpdateContent(_listContainerId, jsonUrl, false, document.getElementById(_listContainerId).getAttribute("data-template"), "overlay");

    var event = new CustomEvent("updateFacets", { "detail": { "name": name, "value": value, "url": queryParams.getQueryString() } });
    document.dispatchEvent(event);
    facet.dispatchEvent(event);
}

Facets.prototype.AddFacetToUrl = function (queryParams, name, value) {
    if (queryParams.hasParam(name)) {
        value = queryParams.getValue(name) + "," + value;
    }
    queryParams.setValue(name, value);
}

Facets.prototype.RemoveFacetFromUrl = function (queryParams, name, value) {
    if (queryParams.hasParam(name)) {
        commaArray = queryParams.getValue(name).split(",");
        if (commaArray.length > 1) {
            var i = commaArray.indexOf(value);
            if (i != -1) {
                commaArray.splice(i, 1);
                queryParams.setValue(name, commaArray.join(","));
            }
        } else {
            if (queryParams.getValue(name) == value) {
                queryParams.remove(name);
            }
        }
    }
}

Facets.prototype.ResetFacets = function (facet) {
    var path = window.location.pathname;
    var newParams = new QueryArray("");
    newParams.setValue("PageNum", 1);
    newParams.setValue("pagesize", 30);
    newParams.setValue("redirect", 'false');
    newParams.setPath(path);
    var browserUrl = newParams.getFullUrl();
    history.pushState(null, null, browserUrl);

    //Remember the groupID
    var reqQueryParams = new QueryArray(_requestQuery);
    if (reqQueryParams.hasParam("groupid")) {
        newParams.setValue("groupid", reqQueryParams.getValue("groupid"));
    }
    newParams.setValue("ID", _catalogPageId);
    if (reqQueryParams.hasParam("feed")) {
        newParams.setValue("feed", reqQueryParams.getValue("feed"));
    }
    newParams.setPath("/Default.aspx");

    var jsonUrl = newParams.getFullUrl();

    HandlebarsBolt.UpdateContent(_listContainerId, jsonUrl, false, document.getElementById(_listContainerId).getAttribute("data-template"), "overlay");

    var event = new CustomEvent("resetFacets");
    document.dispatchEvent(event);
}

var Facets = new Facets();
//HandlebarsBolt requires handlebars-v4.0.11 !

var HandlebarsBolt = function () { }
var cache = {};

//Auto initialize the script templates and auto render the templates
document.addEventListener("DOMContentLoaded", function (event) {
    //Register templates
    var scriptTemplate = document.getElementsByTagName("script");

    for (var i = 0; i < scriptTemplate.length; i++) {
        var scriptTemplateElement = scriptTemplate[i];

        if (scriptTemplateElement.getAttribute("type") == "text/x-template") {
            Handlebars.registerPartial(scriptTemplateElement.id, scriptTemplateElement.innerHTML);
        }
    }

    //Initialize ajax elements
    var ajaxContainer = document.getElementsByClassName("js-handlebars-root");

    for (var i = 0; i < ajaxContainer.length; i++) {
        var ajaxContainerElement = ajaxContainer[i];

        if (!ajaxContainerElement.getAttribute('data-json-feed')) {
            console.log("Ajax element: Please specify json feed via data attribute: data-json-feed");
        }

        if (!ajaxContainerElement.hasAttribute('data-init-onload') || ajaxContainerElement.getAttribute('data-init-onload') == false) {
            HandlebarsBolt.UpdateContent(ajaxContainerElement.id, ajaxContainerElement.getAttribute('data-json-feed'), false, ajaxContainerElement.getAttribute('data-template'), ajaxContainerElement.getAttribute('data-preloader'));
        }
    }

    window.addEventListener('popstate', function (event) {
        location.reload();
    });
});

//Update the ajax loaded content using Handlebars to render the template
HandlebarsBolt.prototype.UpdateContent = function (containerId, url, updateUrl, templateId, preloader, addContent) {
    if (document.getElementById(containerId)) {
        var container = document.getElementById(containerId);

        if (url == null) {
            url = container.getAttribute("data-json-feed");
        } else {
            container.setAttribute("data-json-feed", url);
        }

        url = url.replace("?debug=true", "");
        url = url.replace("&debug=true", "");

        preloader = container.hasAttribute("data-preloader") ? container.getAttribute("data-preloader") : preloader;

        //Add a preloader until the template has been rendered (optional)
        if (preloader == "minimal") {
            if (addContent != true) {
                HandlebarsBolt.CleanContainer(containerId);
            }
            var preloaderElement = document.createElement('i');
            preloaderElement.className = "fa fa-circle-o-notch fa-spin preloader";
            preloaderElement.setAttribute('id', (container.getAttribute('id') + "_preloader"));
            container.appendChild(preloaderElement);
        } else if (preloader == "overlay") {
            var overlayElement = document.createElement('div');
            overlayElement.className = "preloader-overlay";
            overlayElement.setAttribute('id', "overlay");
            var overlayElementIcon = document.createElement('div');
            overlayElementIcon.className = "preloader-overlay__icon";
            overlayElementIcon.style.top = window.pageYOffset + "px";
            overlayElement.appendChild(overlayElementIcon);

            if (document.getElementById("content")) {
                document.getElementById("content").parentNode.insertBefore(overlayElement, document.getElementById("content"));
            }
        }

        container.classList.remove("u-hidden");

        //Render a pre-render template, if specified, until the real template is ready
        if (container.hasAttribute('data-pre-render-template') && !container.hasChildNodes()) {
            var preRenderElement = document.createElement('div');
            preRenderElement.innerHTML = document.getElementById(container.getAttribute('data-pre-render-template')).innerHTML;

            var newElementNodes = preRenderElement.childNodes;
            for (var item = 1; item < newElementNodes.length; item++) {
                container.appendChild(newElementNodes[item]);
            }
        }

        //Check if there is requested a template by the data attribute
        if (templateId) {
            container.setAttribute("data-template", templateId);
        } else {
            if (container) {
                templateId = container.getAttribute("data-template");
            } else {
                console.log("The container: " + containerId + " is missing");
            }
        }

        //Save a template setting cookie for later use
        var cookieId = container.getAttribute("id") + "Template=";
        if (document.cookie.indexOf(cookieId) != -1) {
            document.cookie.replace(cookieId, templateId)
        } else {
            document.cookie = cookieId + templateId;
        }

        //Make the script template ready using Handlebars
        var scriptTemplate = document.getElementById(templateId).innerHTML;
        var template = Handlebars.compile(scriptTemplate);

        //get the data from the requested JSON feed
        var xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var data;

                if (xhr.responseType === 'json') {
                    data = xhr.response.message;
                } else {
                    try {
                        if (!this.response.includes("<!DOCTYPE html>")) {
                            data = JSON.parse(this.response);
                        } else {
                            data = "{}";
                            console.warn(url + ": URL returned HTML instead of JSON");
                        }
                    } catch (e) {
                        if (this.response.trim() != "") {
                            console.error(e);
                        } else {
                            console.warn(url + ": Response is empty");
                        }
                        HandlebarsBolt.RevalidateImages();
                        HandlebarsBolt.RemovePreloaders(containerId);
                        return false;
                    }
                }

                var compiledHtml = template(data);

                if (!addContent) {
                    HandlebarsBolt.CreateCache(data);

                    container.innerHTML = compiledHtml;
                } else {
                    HandlebarsBolt.CreateCache(data);
                    HandlebarsBolt.AddToCache(data, containerId);

                    container.insertAdjacentHTML('beforeend', compiledHtml);
                }

                var event = new CustomEvent('contentLoaded', { 'detail': { 'containerId': containerId, "url": url, "templateId": templateId, "addContent": addContent, "data": data } });
                document.dispatchEvent(event);
                container.dispatchEvent(event);

                HandlebarsBolt.RevalidateImages();
                HandlebarsBolt.RemovePreloaders(containerId);
            }
        };
        xhr.send();

        //Update the browser url
        if (updateUrl == true) {
            history.pushState(null, null, url);
        }
    } else {
        console.log("Element could not be found: " + containerId);
    }
}

//Add content to an already used container
HandlebarsBolt.prototype.AddContent = function (containerId, url, updateUrl) {
    HandlebarsBolt.UpdateContent(containerId, url, updateUrl, null, "minimal", true);
}

//Render the template using a JSON data object, instead of getting it using a server request
HandlebarsBolt.prototype.CreateItemsFromJson = function (data, containerId, templateId) {
    var container = document.getElementById(containerId);

    if (templateId) {
        container.setAttribute("data-template", templateId);
    } else {
        if (container) {
            templateId = container.getAttribute("data-template");
        } else {
            console.log("The container: " + containerId + " is missing");
        }
    }

    var scriptTemplate = document.getElementById(templateId).innerHTML;
    var template = Handlebars.compile(scriptTemplate);

    HandlebarsBolt.CreateCache(data);

    var compiledHtml = template(data);
    container.innerHTML = compiledHtml;

    var event = new CustomEvent('itemsCreatedFromJson', { 'detail': { 'containerId': containerId, "templateId": templateId, "data": data } });
    container.dispatchEvent(event);

    HandlebarsBolt.RevalidateImages();
}

//Remove the preloaders
HandlebarsBolt.prototype.RemovePreloaders = function (containerId) {
    var container = document.getElementById(containerId);
    if (document.body.contains(container)) {
        if (container.getAttribute('data-preloader') == 'overlay') {
            if (document.getElementById('overlay')) {
                document.getElementById('overlay').parentNode.removeChild(document.getElementById('overlay'));
            }
        } else {
            if (document.getElementById(container.getAttribute('id') + "_preloader")) {
                container.removeChild(document.getElementById(container.getAttribute('id') + "_preloader"));
            }
        }

        var event = new CustomEvent('removePreloaders');
        container.dispatchEvent(event);
    }
}

//Clean the container for either all the elements or the preloader
HandlebarsBolt.prototype.CleanContainer = function (containerId) {
    HandlebarsBolt.RemovePreloaders();

    if (document.getElementById(containerId)) {
        while (document.getElementById(containerId).firstChild) document.getElementById(containerId).removeChild(document.getElementById(containerId).firstChild);
        document.getElementById(containerId).classList.add("u-hidden");
    }

    var event = new CustomEvent('cleanContainer');
    document.dispatchEvent(event);
}

//Update the template (Used for shifting views - Remember to work with the cookie, if you wish to use the update after page reload)
HandlebarsBolt.prototype.UpdateTemplate = function (containerId, templateId) {
    var container = document.getElementById(containerId);

    var scriptTemplate = document.getElementById(templateId).innerHTML;
    var template = Handlebars.compile(scriptTemplate);
    var dataFromCache = HandlebarsBolt.FindDataInCache(containerId);
    var compiledHtml = template(dataFromCache);

    container.setAttribute("data-template", templateId);

    var expiryTime = new Date();
    expiryTime.setTime(expiryTime.getTime() + (24 * 3600 * 1000));
    document.cookie = containerId + "Template=" + templateId + "; expires=" + expiryTime;

    container.innerHTML = compiledHtml;

    HandlebarsBolt.RevalidateImages();

    var event = new CustomEvent('updateTemplate', { 'detail': { 'containerId': containerId, "templateId": templateId, "data": dataFromCache } });
    container.dispatchEvent(event);
    document.dispatchEvent(event);
}

//If using bLazy to render images, revalidate when the template is fully rendered
HandlebarsBolt.prototype.RevalidateImages = function () {
    if (bLazy != null) {
        setTimeout(function () {
            bLazy.revalidate();
        }, 100);
    }
}

//Create a full data cache for reuse and fast template shifting
HandlebarsBolt.prototype.CreateCache = function (data, count) {
    if (!count) {
        count = 0;
    }

    if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
            HandlebarsBolt.CreateCacheObject(data[i], count);
        }
    } else {
        HandlebarsBolt.CreateCacheObject(data, count);
    }
}

//Make the cache for each object
HandlebarsBolt.prototype.CreateCacheObject = function (data, count) {
    for (var property in data) {
        if (typeof data[property] == 'object') {
            //Make the ID unique for each sub object
            var uniqueId = data.id ? property + data.id : count == 0 ? property : property + count;
            var uniqueNumber = new Date().getTime();

            //Fix for multiple instances of the same element (Fx. multiple mini carts), while supporting different views (Fx. a product list) 
            if (document.getElementById(uniqueId)) {
                if (!document.getElementById(uniqueId).hasAttribute('data-save-cookie')) {
                    uniqueId = uniqueId + uniqueNumber;
                }
            }

            cache[uniqueId] = data[property];

            if (data[property] != null) {
                if (data[property].length > 0) {
                    for (var i = 0; i < data[property].length; i++) {
                        HandlebarsBolt.CreateCache(data[property][i], count);
                    }
                }
            }

            count++;
        }
    }
}

//Create a full data cache for reuse and fast template shifting
HandlebarsBolt.prototype.AddToCache = function (data, id) {
    for (var i = 0; i < data.length; i++) {
        cache[id].push(data[i]);
    }
}

//Create data in the cache object (Must be validated Json)
HandlebarsBolt.prototype.SetDataInCache = function (id, data) {
    cache[id] = data;
}

//Get a single cached data object by ID
HandlebarsBolt.prototype.FindDataInCache = function (id) {
    for (var property in cache) {
        if (property == id) {
            return cache[property];
        }
    }
}

//Parse to find the chosen cookie
HandlebarsBolt.prototype.GetCookie = function (name) {
    var pattern = RegExp(name + "=.[^;]*"),
        matched = document.cookie.match(pattern);

    if (matched) {
        var cookie = matched[0].split('=')
        return cookie[1]
    }
    return false
}

//Conditional helper for Handlebars
Handlebars.registerHelper('ifCond', function (v1, operator, v2, options) {
    switch (operator) {
        case '==':
            return (v1 == v2) ? options.fn(this) : options.inverse(this);
        case '===':
            return (v1 === v2) ? options.fn(this) : options.inverse(this);
        case '!==':
            return (v1 !== v2) ? options.fn(this) : options.inverse(this);
        case '<':
            return (v1 < v2) ? options.fn(this) : options.inverse(this);
        case '<=':
            return (v1 <= v2) ? options.fn(this) : options.inverse(this);
        case '>':
            return (v1 > v2) ? options.fn(this) : options.inverse(this);
        case '>=':
            return (v1 >= v2) ? options.fn(this) : options.inverse(this);
        case '&&':
            return (v1 && v2) ? options.fn(this) : options.inverse(this);
        case '||':
            return (v1 || v2) ? options.fn(this) : options.inverse(this);
        default:
            return options.inverse(this);
    }
});

Handlebars.registerHelper('toJSON', function(object){
    return new Handlebars.SafeString(JSON.stringify(object).replace(/\"/g, '\''));
});


//Auto initialization
var HandlebarsBolt = new HandlebarsBolt();
var ImageList = function () { }

ImageList.prototype.GetImage = function (thumb) {
    var galleryImage = document.getElementById(thumb.getAttribute("data-for"));
    var number = parseInt(thumb.getAttribute("data-number"));
    var galleryContainer = galleryImage.closest('.js-gallery-slider');
    var images = galleryContainer.getAttribute("data-images").split(",");
    var totalImages = galleryContainer.getAttribute("data-total-images");

    if (galleryImage) {
        galleryImage.setAttribute("data-number", number);
        galleryContainer.setAttribute("data-current-image", number);
    } else {
        return;
    }

    if (number >= 0 && number < totalImages) {
        galleryImage.src = images[number];
        galleryContainer.setAttribute("data-current-image", number);

        var counter = galleryContainer.getElementsByClassName("js-image-list-counter");
        if (counter.length > 0) {
            counter[0].innerHTML = (number + 1);
        }
    }

    //thumb
    if (thumb.closest(".js-thumb-btn")) {
        var thumbButtons = document.getElementsByClassName("js-thumb-btn");

        for (var i = 0; i < thumbButtons.length; i++) {
            var thumbBtn = thumbButtons[i];
            if (thumbBtn.getAttribute('data-for') == thumb.getAttribute('data-for')) {
                thumbBtn.classList.remove('thumb-list__item--active');
            }
        }

        thumb.closest(".js-thumb-btn").classList.add('thumb-list__item--active');
    }

    var event = new CustomEvent('imageListOpenImage', { 'detail': { 'currentTarget': galleryImage, 'galleryContainer': galleryContainer, 'src': images[number], 'number': number, 'totalImages': totalImages } });
    document.dispatchEvent(event);
}

ImageList.prototype.GetPreviousImage = function (thisButton) {
    var galleryContainer = thisButton.closest('.js-gallery-slider');
    var galleryImage = galleryContainer.getElementsByClassName("js-gallery-image")[0];
    var images = galleryContainer.getAttribute("data-images").split(",");
    var currentImage = galleryContainer.getAttribute("data-current-image");
    var totalImages = galleryContainer.getAttribute("data-total-images");

    if (currentImage > 0) {
        currentImage--;
    } else {
        currentImage = (totalImages - 1);
    }

    galleryImage.src = images[currentImage];
    galleryContainer.setAttribute("data-current-image", currentImage);


    var counter = galleryContainer.getElementsByClassName("js-image-list-counter");
    if (counter.length > 0) {
        counter[0].innerHTML = (currentImage + 1);
    }

    var event = new CustomEvent('imageListPreviousImage', { 'detail': { 'currentTarget': galleryImage, 'galleryContainer': galleryContainer, 'src': images[currentImage], 'currentImage': currentImage, 'totalImages': totalImages } });
    document.dispatchEvent(event);
}

ImageList.prototype.GetNextImage = function (thisButton) {
    var galleryContainer = thisButton.closest('.js-gallery-slider');
    var galleryImage = galleryContainer.getElementsByClassName("js-gallery-image")[0];
    var images = galleryContainer.getAttribute("data-images").split(",");
    var currentImage = galleryContainer.getAttribute("data-current-image");
    var totalImages = galleryContainer.getAttribute("data-total-images");

    if (currentImage < (totalImages-1)) {        
        currentImage++;
    } else {
        currentImage = 0;
    }

    galleryImage.src = images[currentImage];
    galleryContainer.setAttribute("data-current-image", currentImage);
    var counter = galleryContainer.getElementsByClassName("js-image-list-counter");
    if (counter.length > 0) {
        counter[0].innerHTML = (currentImage + 1);
    }

    var event = new CustomEvent('imageListNextImage', { 'detail': { 'currentTarget': galleryImage, 'galleryContainer': galleryContainer, 'src': images[currentImage], 'currentImage': currentImage, 'totalImages': totalImages } });
    document.dispatchEvent(event);
}

var ImageList = new ImageList();
var LoadMore = function () { }

LoadMore.prototype.Next = function (selected) {
    var pagesize = parseInt(selected.getAttribute("data-page-size"));
    var queryParams = new QueryArray(window.location.search);
    var containerId = selected.getAttribute("data-container");
    var container = document.getElementById(containerId);
    var currentPage = selected.getAttribute("data-current");
    var totalPages = selected.getAttribute("data-total");

    queryParams.setValue("feedType", "productsOnly");
    queryParams.setPath(selected.getAttribute("data-feed-url"), true);
    queryParams.setValue("pagesize", pagesize, true);
    
    currentPage++;

    selected.setAttribute("data-current", currentPage);

    queryParams.setValue("pagenum", currentPage);
    queryParams.setValue("redirect", "false");

    if (currentPage <= totalPages) {

        HandlebarsBolt.AddContent(containerId, queryParams.getFullUrl());

        queryParams = new QueryArray(window.location.search);

        if (queryParams.hasParam("pagesize")) {
            pagesize += parseInt(queryParams.getValue("pagesize"));
        } else {
            pagesize *= 2;
        }

        queryParams.setPath(window.location.pathname);
        queryParams.setValue("pagesize", pagesize);

        history.pushState(null, null, queryParams.getFullUrl());
    }

    if (currentPage == totalPages) {
        selected.classList.add('u-hidden');
    }

    var event = new CustomEvent('loadMore', { 'detail': { 'currentPage': currentPage, "totalPages": totalPages, "url": queryParams.getFullUrl(), "container": containerId } });
    document.dispatchEvent(event);
    container.dispatchEvent(event);
}

var LoadMore = new LoadMore();
// Multiple Markers
var markersArray = new Array();

var Maps = function () { }

Maps.prototype.Init = function (containerId, locationsList, markerCallback, selectionCallback, buttonText) {
    if (document.getElementById(containerId) && !document.getElementById(containerId).hasAttribute('data-initialized')) {
        if (locationsList.length > 0) {
            var map;
            var bounds = new google.maps.LatLngBounds();
            var mapOptions = {
                mapTypeId: 'roadmap'
            };

            // Display a map on the page
            map = new google.maps.Map(document.getElementById(containerId), mapOptions);
            map.setTilt(45);

            var markers = new Array();
            var infoWindowContent = [];

            for (var i = 0; i < locationsList.length; i++) {
                var locationArray = [locationsList[i].company, locationsList[i].latitude.replace(",", "."), locationsList[i].longitude.replace(",", ".")];
                var locationCallback = selectionCallback ? '<button class="btn btn--primary dw-mod" onclick="' + selectionCallback + '()">' + buttonText + '</button>' : "";
                var locationDetails = locationsList[i].address ? '<p>' + locationsList[i].address + '</p>' + '<p>' + locationsList[i].zip + ' ' + locationsList[i].city + ' ' + locationsList[i].country + locationsList[i].description + '</p>' : "<p>" + locationsList[i].description + "</p>";
                var locationInfo = ['<div class="map-container__canvas__location-info">' + '<h5>' + locationsList[i].company + '</h5>' + locationDetails + locationCallback + '</div>'];
                markers.push(locationArray);
                infoWindowContent.push(locationInfo);
            }

            // Display multiple markers on a map
            var infoWindow = new google.maps.InfoWindow(), marker, i;

            // Loop through our array of markers & place each one on the map
            for (i = 0; i < markers.length; i++) {
                var position = new google.maps.LatLng(markers[i][1], markers[i][2]);
                bounds.extend(position);

                marker = new google.maps.Marker({
                    position: position,
                    map: map,
                    title: markers[i][0]
                });

                markersArray.push(marker);

                // Allow each marker to have an info window
                google.maps.event.addListener(marker, 'click', (function (marker, i) {
                    return function () {
                        infoWindow.setContent(infoWindowContent[i][0]);
                        infoWindow.open(map, marker);

                        if (markerCallback) {
                            markerCallback(locationsList[i]);
                        }

                        var event = new CustomEvent('mapMarkerOnClick', { 'detail': { 'data': locationsList[i] } });
                        document.dispatchEvent(event);
                        this.dispatchEvent(event);
                    }
                })(marker, i));

                // Automatically center the map fitting all markers on the screen
                map.fitBounds(bounds);
            }

            // Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
            var boundsListener = google.maps.event.addListener((map), 'bounds_changed', function (event) {
                if (markers.length == 1) {
                    map.setZoom(10);
                }

                google.maps.event.removeListener(boundsListener);
            });

            document.getElementById(containerId).setAttribute("data-initialized", "True");
        }
    }
}

Maps.prototype.OpenInfo = function (markerId) {
    google.maps.event.trigger(markersArray[markerId], 'click');

    var event = new CustomEvent('mapOpenInfo', { 'detail': { 'markerId': markerId } });
    document.dispatchEvent(event);
}

var Maps = new Maps();



//IE Polyfill for CustomEvents
(function () {

    if (typeof window.CustomEvent === "function") return false;

    function CustomEvent(event, params) {
        params = params || { bubbles: false, cancelable: false, detail: undefined };
        var evt = document.createEvent('CustomEvent');
        evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
        return evt;
    }

    CustomEvent.prototype = window.Event.prototype;

    window.CustomEvent = CustomEvent;
})();

//Polyfill for Closest()
if (window.Element && !Element.prototype.closest) {
    Element.prototype.closest =
    function (s) {
        var matches = (this.document || this.ownerDocument).querySelectorAll(s),
            i,
            el = this;
        do {
            i = matches.length;
            while (--i >= 0 && matches.item(i) !== el) { };
        } while ((i < 0) && (el = el.parentElement));
        return el;
    };
}
function QueryArray(queryStr) {
    this.queryArray = {};
    if (queryStr != null && queryStr != "") {
        var queryArr = queryStr.replace("?", "").split("&");
        for (var q = 0, qArrLength = queryArr.length; q < qArrLength; q++) {
            var qArr = queryArr[q].split("=");
            this.setValue(decodeURIComponent(qArr[0]), decodeURIComponent(qArr[1]));
        }
    }
}

QueryArray.prototype.setPath = function(path, saveQueryParams) {
    if (path.indexOf('?') != -1) {
        url = path.split('?');
        this.path = url[0];
        
        if (saveQueryParams) {
            newParams = new QueryArray(url[1]);
            this.combineWith(newParams);
        }
    } else {
        this.path = path;
    }
}

QueryArray.prototype.combineWith = function (queryParams) {
    var queryArr = queryParams.queryArray;
    for (var key in queryArr) {
        if (queryParams.hasParam(key)) {
            this.setValue(key, queryArr[key]);
        }
    }
}

QueryArray.prototype.getQueryString = function() {
    var arr = [];
    //fix because ID should be always first in query
    if (this.hasParam("ID")) {
        arr.push("ID" + "=" + this.getValue("ID"));
        this.remove("ID");
    }//

    for (var key in this.queryArray) {
        if (this.hasParam(key)) {
            arr.push(encodeURIComponent(key) + "=" + encodeURIComponent(this.queryArray[key]));
        }
    }
    return arr.length > 0 ? "?" + arr.join("&") : "";
}

QueryArray.prototype.getFullUrl = function () {
    return this.path + this.getQueryString();
}

QueryArray.prototype.copy = function() {
    return new QueryArray(this.getQueryString());
}

QueryArray.prototype.getValue = function(key) {
    return this.queryArray[key];
}

QueryArray.prototype.setValue = function(key, newValue, setIfExist) {
    if (!setIfExist || this.hasParam(key)) {
        this.queryArray[decodeURIComponent(key)] = decodeURIComponent(newValue);
    }
}

QueryArray.prototype.hasParam = function(key) {
    return this.queryArray.hasOwnProperty(key);
}

QueryArray.prototype.remove = function(key) {
    delete this.queryArray[key];
}
//The RapidoHook is a simple wrapper for the Javascript event listeners. They exist to make the methods strong and simplify the code when you use it for extending. 
//You are still free to just use the classic event listeneres, as you are used to.


var RapidoHook = function () { }

//The base event wrapper method
RapidoHook.prototype.event = function (callback, callbackType, eventName, targetElement) {
    targetElement = targetElement != null ? targetElement : document;

    if (callbackType != "attach" && callbackType != "detach" && callbackType != null) {
        console.log("RapidoHook: The type must be either \"attach\" or \"detach\"");
    }

    if (!targetElement) {
        console.log("RapidoHook: The target element does not exist. The fallback is the \"document\" element.");
        targetElement = document;
    }

    if (eventName) {
        if (callbackType == null || callbackType == "attach") {
            targetElement.addEventListener(eventName, function (e) {
                callback(e);
            }, false);
        }

        if (callbackType == "detach") {
            targetElement.removeEventListener(eventName, function (e) {
                callback(e);
            }, false);
        }
    } else {
        console.log("RapidoHook: You must specify an event name");
    }
}


//Available hooks that you could use

//Buttons.js
RapidoHook.prototype.buttonIsLocked = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'buttonIsLocked', targetElement);
}

//Carousel.js
RapidoHook.prototype.initSlideShow = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'initSlideShow', targetElement);
}

RapidoHook.prototype.shiftSlide = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'shiftSlide', targetElement);
}

//Cart.js
RapidoHook.prototype.addToCart = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'addToCart', targetElement);
}

RapidoHook.prototype.emptyCart = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'emptyCart', targetElement);
}

RapidoHook.prototype.cartUpdated = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'cartUpdated', targetElement);
}

//Facets.js
RapidoHook.prototype.updateFacets = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'updateFacets', targetElement);
}

RapidoHook.prototype.resetFacets = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'resetFacets', targetElement);
}

//LoadMore.js
RapidoHook.prototype.loadMore = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'loadMore', targetElement);
}

//Maps.js
RapidoHook.prototype.mapMarkerOnClick = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'mapMarkerOnClick', targetElement);
}

RapidoHook.prototype.mapOpenInfo = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'mapOpenInfo', targetElement);
}

//Scroll.js
RapidoHook.prototype.saveScrollPosition = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'saveScrollPosition', targetElement);
}

RapidoHook.prototype.setScrollPosition = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'setScrollPosition', targetElement);
}

RapidoHook.prototype.savePagePosition = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'savePagePosition', targetElement);
}

//HandlebarsBolt.js (Targeted to specific Rapido elements)
RapidoHook.prototype.contentLoaded = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', targetElement);
}

RapidoHook.prototype.itemsCreatedFromJson = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'itemsCreatedFromJson', targetElement);
}

RapidoHook.prototype.removePreloaders = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'removePreloaders', targetElement);
}

RapidoHook.prototype.updateTemplate = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'updateTemplate', targetElement);
}

RapidoHook.prototype.productListLoaded = function (callback, callbackType) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', document.getElementById("productList"));
}

RapidoHook.prototype.productListUpdated = function (callback, callbackType) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', document.getElementById("ProductsContainer"));
}

RapidoHook.prototype.productListViewChange = function (callback, callbackType) {
    RapidoHook.event(callback, callbackType, 'updateTemplate', document.getElementById("ProductsContainer"));
}

RapidoHook.prototype.miniCartLoaded = function (callback, callbackType) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', document.getElementById("miniCart"));
}

RapidoHook.prototype.cartLoaded = function (callback, callbackType) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', document.getElementById("Cart"));
}

RapidoHook.prototype.customProductListLoaded = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', targetElement);
}

RapidoHook.prototype.customProductListUpdated = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', targetElement);
}

RapidoHook.prototype.customProductListViewChange = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'updateTemplate', targetElement);
}

RapidoHook.prototype.customMiniCartLoaded = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', targetElement);
}

RapidoHook.prototype.customCartLoaded = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'contentLoaded', targetElement);
}

//ImageList.js
RapidoHook.prototype.imageListLoadImage = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'imageListLoadImage', targetElement);
}

RapidoHook.prototype.imageListOpenImage = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'imageListOpenImage', targetElement);
}

RapidoHook.prototype.imageListPreviousImage = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'imageListPreviousImage', targetElement);
}

RapidoHook.prototype.imageListNextImage = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'imageListNextImage', targetElement);
}

//Variants.js
RapidoHook.prototype.variantsUpdate = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'variantsUpdate', targetElement);
}

RapidoHook.prototype.variantsSelectionComplete = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'variantsSelectionComplete', targetElement);
}

//Wireframe.js
RapidoHook.prototype.wireframeInit = function (callback, callbackType, targetElement) {
    RapidoHook.event(callback, callbackType, 'wireframeInit', targetElement);
}


var RapidoHook = new RapidoHook();


var RememberState = function () { }
var loadedRememberStateElements = [];
var observer = new MutationObserver(function (mutations) { });
var config = { attributes: true, childList: false, characterData: false }

document.addEventListener("DOMContentLoaded", function (event) {
    RememberState.GetState();

    //Make it work with Ajax loaded content
    var ajaxContainer = document.getElementsByClassName("js-handlebars-root");
    if (ajaxContainer.length > 0) {
        for (var i = 0; i < ajaxContainer.length; i++) {
            ajaxContainer[i].addEventListener('contentLoaded', function (e) {
                RememberState.GetState();
            }, false);
        }
    }
});

RememberState.prototype.SaveState = function () {
    var rememberStateElements = document.getElementsByClassName("js-remember-state");

    for (var elm = 0; elm < rememberStateElements.length; elm++) {
        var target = rememberStateElements[elm];

        if (RememberState.ElementExists(target.id) == false) {

            //Save cookie when an attribute changes on the element
            observer = new MutationObserver(function (mutations) {
                var stateCookie = "StateCookie_" + mutations[0].target.id + "=[{";

                if (target.getAttribute("type") != "checkbox") {
                    var count = 0;

                    mutations.forEach(function (mutation) {
                        stateCookie += '"' + mutation.attributeName + '": "' + mutation.target.getAttribute(mutation.attributeName) + '"';
                        if (count != mutations.length - 1) {
                            stateCookie += ",";
                        }
                        count++;
                    });
                } else {
                    stateCookie += '"checked": "' + mutations[0].target.checked + '"';
                }

                stateCookie += "}]";

                document.cookie = stateCookie;
            });

            if (target.getAttribute("type") == "checkbox") {
                target.addEventListener('click', function (e) {
                    e.target.setAttribute('checked', e.target.checked);
                });
            }

            observer.observe(target, config);
        }

        loadedRememberStateElements.push(target.id);
    }
}

RememberState.prototype.GetState = function () {
    var rememberStateElements = document.getElementsByClassName("js-remember-state");

    for (var elm = 0; elm < rememberStateElements.length; elm++) {
        var target = rememberStateElements[elm];

        //Get the cookie and set the saved attributes
        var resultCookie = RememberState.GetCookie("StateCookie_" + target.id);

        if (resultCookie) {
            resultCookie = JSON.parse(resultCookie);

            for (var crumb = 0; crumb < resultCookie.length; crumb++) {
                for (property in resultCookie[crumb]) {
                    target.setAttribute(property, resultCookie[crumb][property]);

                    if (property == "checked") {
                        if (resultCookie[crumb][property] == "false") {
                            target.removeAttribute("checked");
                        } else {
                            target.checked = true;
                        }
                    }
                }
            }
        } 
    }

    //Set up remember state again after the last state is set
    RememberState.SaveState();
}

//Parse to find the chosen cookie
RememberState.prototype.ElementExists = function (elementId) {
    var condition = false;

    for (var i = 0; i < loadedRememberStateElements.length; i++) {
        if (loadedRememberStateElements[i] == elementId) {
            condition = true;
        }
    }

    return condition
}

//Parse to find the chosen cookie
RememberState.prototype.GetCookie = function (name) {
    var pattern = RegExp(name + "=.[^;]*"),
        matched = document.cookie.match(pattern);

    if (matched) {
        var cookie = matched[0].split('=')
        return cookie[1]
    }
    return false
}


//Set simple checkbox state by url parameter (js-remember-state class not required)
RememberState.prototype.getSearchParameters = function() {
    var paramstring = window.location.search.substr(1);
    return paramstring != null && paramstring != "" ? RememberState.transformToAssocArray(paramstring) : {};
}

RememberState.prototype.transformToAssocArray = function (paramstring) {
    var params = {};
    var paramsarray = paramstring.split("&");
    for (var i = 0; i < paramsarray.length; i++) {
        var tmparray = paramsarray[i].split("=");
        params[tmparray[0]] = tmparray[1];
    }
    return params;
}

document.addEventListener("DOMContentLoaded", function (event) {
    var params = RememberState.getSearchParameters();

    for (property in params) {
        if (document.getElementById(property)) {
            var element = document.getElementById(property);

            if (element.type === 'checkbox') {
                element.checked = params[property];
            }
        }
    }
});

var RememberState = new RememberState();

var Scroll = function () { }

document.addEventListener("DOMContentLoaded", function (event) {
    var ajaxContainer = document.getElementsByClassName("js-handlebars-root");

    if (ajaxContainer.length > 0) {
        for (var i = 0; i < ajaxContainer.length; i++) {
            ajaxContainer[i].addEventListener('contentLoaded', function (e) {
                Scroll.SetPosition();
                Scroll.SetPagePosition();
            }, false);
        }
    }

    Scroll.SetPagePosition();
});

Scroll.prototype.SavePosition = function (e) { 
    e.preventDefault();

    var url = window.location.href;

    var seperator = "?";
    if (url.indexOf("?") != -1) {
        seperator = "&";
    }

    var scrollPos = document.documentElement.scrollTop || document.body.scrollTop;

    if (Scroll.getURLParameter("ScrollPos")) {
        url = url.replace(/\bScrollPos=[^&#]+/g, "ScrollPos=" + Math.round(scrollPos));
    } else {
        url = window.location + seperator + "ScrollPos=" + Math.round(scrollPos);
    }
    
    history.replaceState(null, null, url);

    var event = new CustomEvent('saveScrollPosition', { 'detail': { 'scrollPos': scrollPos } });
    document.dispatchEvent(event);

    window.location.href = e.currentTarget.getAttribute("href");
}

Scroll.prototype.SetPosition = function () {
    var scrollPos = Scroll.getURLParameter("ScrollPos");

    if (scrollPos != null) {
        window.scroll(0, scrollPos);

        var event = new CustomEvent('setScrollPosition', { 'detail': { 'scrollPos': scrollPos } });
        document.dispatchEvent(event);

        if (bLazy != null) {
            bLazy.revalidate();
        }
    }
}

Scroll.prototype.SetPagePosition = function () {
    if (document.getElementById("Page").classList.contains("js-page-pos")) {
        var topHeight = document.getElementById("Top").clientHeight;
        var scrollDelay = 1;

        if (/Edge\/\d./i.test(navigator.userAgent)) {
            scrollDelay = 500;
        }

        var event = new CustomEvent('savePagePosition', { 'detail': { 'scrollPos': topHeight } });

        if (topHeight > 0) {
            document.getElementById("Page").style.marginTop = topHeight + "px";
            document.dispatchEvent(event);
        } else {
            setTimeout(function () {
                topHeight = document.getElementById("Top").clientHeight;
                document.getElementById("Page").style.marginTop = topHeight + "px";
                document.dispatchEvent(event);
            }, scrollDelay);
        }
    }
}

Scroll.prototype.getURLParameter = function (name) {
    return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [null, ''])[1].replace(/\+/g, '%20')) || null;
}


var Scroll = new Scroll();

var Search = function () { }

function debounce(method, delay) {
    var timer;
    return function () {
        clearTimeout(timer);
        timer = setTimeout(function () {
            method();
        }, delay);
    };
}

Search.prototype.Init = function () {
    var searchElements = document.querySelectorAll(".js-typeahead");
    var nodesArray = [].slice.call(searchElements);
    nodesArray.forEach(function (searchElement) {
        const groupsBtn         = searchElement.querySelector(".js-typeahead-groups-btn"),
              groupsContent     = searchElement.querySelector(".js-typeahead-groups-content"),
              searchField       = searchElement.querySelector(".js-typeahead-search-field"),
              searchContent     = searchElement.querySelector(".js-typeahead-search-content"),
              enterBtn          = searchElement.querySelector(".js-typeahead-enter-btn"),
              options           = {
                  pageSize:       searchElement.getAttribute("data-page-size"),
                  searchPageId:   searchElement.getAttribute("data-search-page-id"),
                  listId:         searchElement.getAttribute("data-list-id"),
                  resultPageId:   searchElement.getAttribute("data-result-page-id"),
                  groupsPageId:   searchElement.getAttribute("data-groups-page-id"),
                  searchTemplate: searchContent.getAttribute("data-template")
              };
        var   selectionPosition = -1;

        if (groupsBtn) {
            groupsBtn.onclick = function () {
            	HandlebarsBolt.UpdateContent(groupsContent.getAttribute("id"), '/Default.aspx?ID=' + options.groupsPageId + '&feedType=' + 'productGroups' + '&redirect=false');
            }
        }

        searchField.onkeyup = debounce(function () {
            var query = searchField.value;
            selectionPosition = -1

            if (groupsBtn) {
            	if (groupsBtn.getAttribute("data-group-id") != "all" && groupsBtn.getAttribute("data-group-id") != "") {
                    query += "&GroupID=" + groupsBtn.getAttribute("data-group-id");
                }
            }

            if (query.length > 0) {
                HandlebarsBolt.UpdateContent(searchContent.getAttribute("id"),
                                     '/Default.aspx?ID='   + options.searchPageId +
                                     '&feedType='          + 'productsOnly' +
                                     '&pagesize='          + options.pageSize +
                                     '&Search=' + query +
									 '&redirect=' + 'false' +
                                     '&&DoNotShowVariantsAsSingleProducts=True' +
                                     (options.listId ?         '&ListID='   + options.listId : '') +
                                     (options.searchTemplate ? '&Template=' + options.searchTemplate : ''));
                document.getElementsByTagName('body')[0].addEventListener('keydown', keyPress, false);
            } else {
                HandlebarsBolt.CleanContainer(searchContent.getAttribute("id"));
            }
        }, 500);

        function clickedOutside(e) {
            if (searchContent.contains(e.target)) {
                document.getElementsByTagName('body')[0].removeEventListener('keydown', keyPress, false);
                return;
            }

            if (e.target != searchField && !e.target.classList.contains("js-ignore-click-outside")) {
                HandlebarsBolt.CleanContainer(searchContent.getAttribute("id"));
            }

            if (groupsBtn) {
                if (e.target != groupsBtn && !groupsContent.contains(e.target)) {
                    HandlebarsBolt.CleanContainer(groupsContent.getAttribute("id"));
                }
            }

            document.getElementsByTagName('body')[0].removeEventListener('keydown', keyPress, false);
        }

        function keyPress(e) {
            const KEY_CODE = {
                LEFT:   37,
                TOP:    38,
                RIGHT:  39,
                BOTTOM: 40,
                ENTER:  13
            };

            if ([KEY_CODE.LEFT, KEY_CODE.TOP, KEY_CODE.RIGHT, KEY_CODE.BOTTOM].indexOf(e.keyCode) > -1) {
                e.preventDefault();
            }

            if (e.keyCode == KEY_CODE.BOTTOM && selectionPosition < (options.pageSize - 1)) {
                selectionPosition++;
                searchField.blur();
            }

            if (e.keyCode == KEY_CODE.TOP && selectionPosition > 0) {
                selectionPosition--;
                searchField.blur();
            }

            console.log(searchContent.childElementCount);

            if (searchContent.childElementCount > 0) {
                console.log(searchContent.firstElementChild)

                var selectedElement = searchContent.children[selectionPosition];

                if (e.keyCode == KEY_CODE.TOP || e.keyCode == KEY_CODE.BOTTOM) {
                    for (var i = 0; i < searchContent.children.length; i++) {
                        searchContent.children[i].classList.remove("active");
                    }

                    if (selectedElement && selectedElement.getElementsByClassName("js-typeahead-name")[0]) {
                        selectedElement.classList.add("active");
                        searchField.value = selectedElement.getElementsByClassName("js-typeahead-name")[0].innerHTML;
                    }
                }

                if (selectedElement && e.keyCode == KEY_CODE.ENTER) {
                    selectedElement.click();
                    document.getElementsByTagName('body')[0].removeEventListener('keydown', keyPress, false);
                }

                if (e.keyCode == KEY_CODE.ENTER) {
                    if (selectedElement) {
                        GetLinkBySelection(selectedElement);
                    } else {
                        showSearchResults();
                    }
                }
            }
        }

        function GetLinkBySelection(selectedElement) {
            var jslink = selectedElement.getElementsByClassName("js-typeahead-link");
            if (jslink) {
                window.location.href = jslink[0].getAttribute("href");
            }
        }

        function showSearchResults() {
            if (options.resultPageId) {
                window.location.href = '/Default.aspx?ID=' + options.resultPageId +
                                        '&Search=' + searchField.value +
                                        (options.listId ? '&ListID=' + options.listId : '');
            }
        }

        if (enterBtn) {
            enterBtn.onclick = showSearchResults;
        }

        document.getElementsByTagName('body')[0].addEventListener('click', clickedOutside, true);
    });
}

Search.prototype.UpdateGroupSelection = function (selectedElement) {
    const groupsContent = selectedElement.parentNode,
          groupsBtn     = groupsContent.parentNode.querySelector(".js-typeahead-groups-btn");

    groupsBtn.setAttribute("data-group-id", selectedElement.getAttribute("data-group-id"));
    groupsBtn.innerHTML = selectedElement.innerText;

    HandlebarsBolt.CleanContainer(groupsContent.getAttribute("id"));
}

Search.prototype.UpdateFieldValue = function (selectedElement) {
    const searchContent = selectedElement.parentNode,
          searchField   = searchContent.parentNode.querySelector(".js-typeahead-search-field");

    searchField.value = selectedElement.querySelector(".js-typeahead-name").innerText;

    HandlebarsBolt.CleanContainer(searchContent.getAttribute("id"));
}

Search.prototype.ResetExpressSearch = function () {
    const searchField   = document.getElementById("ExpressBuyProductSearchField"),
          quantityField = document.getElementById("ExpressBuyProductCount");

    if (searchField && quantityField) {
        searchField.value = "";
        quantityField.value = "1";
        searchField.focus();
    }
}

var Search = new Search();

document.addEventListener("DOMContentLoaded", Search.Init);
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


var Wireframe = function () { }

var wireframeConfig = {
    cssFilesToRemove: ["rapidoCss", "igniteCss"],
    hasTemplateEngine: true,
    paragraphContainerClass: "paragraph-container",
    backgroundImageContainers: ["paragraph-container", "multiple-paragraphs-container", "layered-image"],
    mediaContainers: ["google-map", "map-container", "video-wrapper"],
    hiddenClass: "u-hidden",
    visuallyHiddenClass: "u-visually-hidden",
    wireImageClass: "wire-image",
    wireBackgroundImageClass: "wire-image-lines",
    wireGrayscaleClass: "wire-grayscale",
    lightBoxImageClass: "lightbox__image",
    elementsWithColorClasses: ["u-color-warning"],
    replacementColorClass: "u-color-light-gray",
    elementsWithBackgroundColorClasses: ["u-color-warning--bg"],
    replacementBackgroundColorClass: "u-color-light-gray--bg"
};

Wireframe.prototype.GetConfiguration = function () {
    if (typeof WireframeConfig == 'object') {
        wireframeConfig = WireframeConfig.Configuration();
    }
}

var _wireframeMode = false;

Wireframe.prototype.Init = function (wireframeMode) {
    if (wireframeMode == true) {
        //Render as Wireframe
        document.addEventListener("DOMContentLoaded", function (event) {
            Wireframe.GetConfiguration();

            Wireframe.WireImages();

            for (var i = 0; i < wireframeConfig.cssFilesToRemove.length; i++) {
                document.getElementById(wireframeConfig.cssFilesToRemove[i]).setAttribute("href", "");
            }
            document.body.classList.remove(dynamoConfig.hiddenClass);
        });

        document.body.classList.add(dynamoConfig.hiddenClass);
        
        if (wireframeConfig.hasTemplateEngine == true) {
            var ajaxContainer = document.getElementsByClassName("js-handlebars-root");
            for (var i = 0; i < ajaxContainer.length; i++) {
                ajaxContainer[i].addEventListener('contentLoaded', function (e) {
                    Wireframe.WireImages();
                }, false);
            }

            document.addEventListener('updateTemplate', function (e) {
                Wireframe.WireImages();
            }, false);
        }

        var event = new CustomEvent('wireframeInit');
        document.dispatchEvent(event);
    }

    _wireframeMode = wireframeMode;
}

//Render all images as 'abstract' symbolized images
Wireframe.prototype.WireImages = function () {
    if (_wireframeMode == true) {
        var imgElements = document.getElementsByTagName("IMG");

        for (var i = 0; i < imgElements.length; i++) {
            var imageElement = imgElements[i];

            if (!imageElement.classList.contains(dynamoConfig.hiddenClass) && !imageElement.classList.contains(wireframeConfig.lightBoxImageClass)) {
                var imageWireframe = document.createElement("DIV");
                imageWireframe.classList.add(wireframeConfig.wireImageClass);
                imageElement.parentElement.insertBefore(imageWireframe, imageElement.parentNode.firstChild);
            }

            if (imageElement.classList.contains(wireframeConfig.lightBoxImageClass)) {
                imageElement.classList.add(wireframeConfig.visuallyHiddenClass);
            }

            imageElement.classList.add(dynamoConfig.hiddenClass);
            imageElement.classList.remove("b-lazy");
        }

        for (var i = 0; i < wireframeConfig.backgroundImageContainers.length; i++) {
            var imgBgElements = document.getElementsByClassName(wireframeConfig.backgroundImageContainers[i]);

            for (var elm = 0; elm < imgBgElements.length; elm++) {
                var imgBgElement = imgBgElements[elm];

                if (imgBgElement.style.backgroundImage != "") {
                    imgBgElement.setAttribute("style", "");
                    imgBgElement.classList.add(wireframeConfig.wireBackgroundImageClass);
                }
            }
        }

        var imgBgElements = document.getElementsByClassName(wireframeConfig.paragraphContainerClass);

        for (var i = 0; i < imgBgElements.length; i++) {
            var imgBgElement = imgBgElements[i];

            if (imgBgElement.getAttribute("style") != "") {
                imgBgElement.setAttribute("style", "");
                imgBgElement.classList.add(wireframeConfig.wireBackgroundImageClass);
            }
        }

        for (var i = 0; i < wireframeConfig.mediaContainers.length; i++) {
            var mediaElement = document.getElementsByClassName(wireframeConfig.mediaContainers[i]);

            for (var elm = 0; elm < mediaElement.length; elm++) {
                mediaElement[elm].classList.add(wireframeConfig.wireGrayscaleClass);
            }
        }

        for (var i = 0; i < wireframeConfig.elementsWithColorClasses.length; i++) {
            var warningColor = document.getElementsByClassName(wireframeConfig.elementsWithColorClasses[i]);

            for (var i = 0; i < warningColor.length; i++) {
                var warningElement = warningColor[i];

                warningElement.classList.remove(wireframeConfig.elementsWithColorClasses[i]);
                warningElement.classList.add(wireframeConfig.replacementColorClass);
            }
        }

        for (var i = 0; i < wireframeConfig.elementsWithBackgroundColorClasses.length; i++) {
            var warningColor = document.getElementsByClassName(wireframeConfig.elementsWithBackgroundColorClasses[i]);

            for (var i = 0; i < warningColor.length; i++) {
                var warningElement = warningColor[i];

                warningElement.classList.remove(wireframeConfig.elementsWithBackgroundColorClasses[i]);
                warningElement.classList.add(wireframeConfig.replacementBackgroundColorClass);
            }
        }

        for (var i = 0; i < document.getElementsByClassName("responsive-image").length; i++) {
            document.getElementsByClassName("responsive-image")[i].classList.remove("responsive-image--1-1");
            document.getElementsByClassName("responsive-image")[i].classList.remove("responsive-image--16-9");
            document.getElementsByClassName("responsive-image")[i].classList.remove("responsive-image--4-3");
        }
    }
}

var Wireframe = new Wireframe();
var WireframeConfig = function () { }

WireframeConfig.prototype.Configuration = function () {
    var wireframeConfigObject = {
        cssFilesToRemove: ["rapidoCss", "igniteCss"],
        hasDynamo: true,
        backgroundImageContainers: ["paragraph-container", "multiple-paragraphs-container", "layered-image"],
        mediaContainers: ["google-map", "map-container", "video-wrapper"],
        hiddenClass: "u-hidden",
        visuallyHiddenClass: "u-visually-hidden",
        wireImageClass: "wire-image",
        wireBackgroundImageClass: "wire-image-lines",
        wireGrayscaleClass: "wire-grayscale",
        lightBoxImageClass: "lightbox__image",
        elementsWithColorClasses: ["u-color-warning"],
        replacementColorClass: "u-color-light-gray",
        elementsWithBackgroundColorClasses: ["u-color-warning--bg"],
        replacementBackgroundColorClass: "u-color-light-gray--bg"
    };

  return wireframeConfigObject;
}

var WireframeConfig = new WireframeConfig();