function showMessageBox(msg, title) {
    Action.ShowMessage({
        Caption: title,
        Message: msg
    });
}

function toQueryString(obj, urlEncode) {
    var str = JSON.stringify(obj);
    if (urlEncode) {
        str = encodeURIComponent(str);
    }
    return str;
}