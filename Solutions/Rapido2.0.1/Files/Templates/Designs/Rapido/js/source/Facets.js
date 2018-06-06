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