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