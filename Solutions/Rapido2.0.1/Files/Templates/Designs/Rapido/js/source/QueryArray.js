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