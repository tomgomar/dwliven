﻿var Dynamo = function () { }
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