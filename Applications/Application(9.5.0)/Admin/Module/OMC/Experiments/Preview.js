
window.onbeforeunload = previewDisableProfileTest

function test(variation) {
	document.getElementById("link1").className = "";
	document.getElementById("link2").className = "";

	document.getElementById("link" + variation).className = "active";

	var url = document.getElementById("testurl").value + '&variation=' + variation
	document.getElementById("previewFrame").src = url;
}

function updateQueryStringParameter(a, k, v) {
    var re = new RegExp("([?|&])" + k + "=.*?(&|$)", "i"),
        separator = a.indexOf('?') !== -1 ? "&" : "?";

    if (a.match(re)) return a.replace(re, '$1' + k + "=" + v + '$2');
    else return a + separator + k + "=" + v;
}


function previewProfileTest() {

    var profile = document.getElementById("profilesList").value;
    var currentUrl = document.getElementById("previewFrame").contentDocument.location.href;
    var url = updateQueryStringParameter(currentUrl, "profile", profile);
    document.getElementById("testurl").value = url;
    document.getElementById("previewFrame").src = url;
}

function previewDisableProfileTest() {
    var url = document.getElementById("testurl").value + '&profile_stop=true';
    new Ajax.Request(url,
  {
      method: 'get',
      onSuccess: function (transport) {
          var i = 0;
      },
      onFailure: function () { alert('Something went wrong... Will retry'); previewDisableProfileTest() }
  });

}

