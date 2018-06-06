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