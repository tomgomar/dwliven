function validateAll() {
    for (var i = 0; i < 5; i++) {
        eval('validate' + i + '();');
    }
}

function validate(fieldName, fieldId, fieldCount, phrase1, MinRquiredWordCount) {
    var elementText = document.getElementById("Field_" + fieldId).value;

    if (elementText.length == 0) {
        setInnerText("value_" + fieldId, getInnerText('spNoContent'));
    } else {
        setInnerText("value_" + fieldId, elementText + ' ');
    }
    
	elementText = elementText.toLowerCase();
	elementText = trim(elementText);
	elementText = removeDoubleSpaces(elementText);
	var valid = true;

	document.getElementById("isValid_" + fieldId).value = "false";
	var wCount = 0;
	if (elementText.split(" ").length == 1 && elementText.length == 0) {
		wCount = 0;
	} else {
		wCount = elementText.split(" ").length;
	}

	if (wCount >= MinRquiredWordCount) {
		document.getElementById("wWordcount_" + fieldId).style.display = "none";
	} else {
		document.getElementById("wWordcount_" + fieldId).style.display = "";
		document.getElementById("wWordcount_" + fieldId + "_more").innerHTML = MinRquiredWordCount - wCount;
		document.getElementById("wWordcount_" + fieldId + "_currently").innerHTML = wCount;
		valid = false;
	}

	if (document.getElementById("MaxRequiredWordCount_" + fieldId)) {
		var MaxRequiredWordCount = parseInt(document.getElementById("MaxRequiredWordCount_" + fieldId).value);
		if (wCount <= MaxRequiredWordCount) {
			document.getElementById("wWordcountMax_" + fieldId).style.display = "none";
		} else {
			document.getElementById("wWordcountMax_" + fieldId).style.display = "";
			document.getElementById("wWordcountMax_" + fieldId + "_less").innerHTML = wCount - MaxRequiredWordCount;
			document.getElementById("wWordcountMax_" + fieldId + "_currently").innerHTML = wCount;
			valid = false;
		}
	}

	if (document.getElementById("RequiredCharacterCountMax_" + fieldId)) {
		var MaxCharCount = parseInt(document.getElementById("RequiredCharacterCountMax_" + fieldId).value);
		if (elementText.length > MaxCharCount) {
			document.getElementById("wTooManyCharacters_" + fieldId).style.display = "";
			setInnerText("wTooManyCharacters_" + fieldId + "_current", elementText.length);
			valid = false;
		} else {
			document.getElementById("wTooManyCharacters_" + fieldId).style.display = "none";
		}
	}

	if (document.getElementById("RequiredCharacterCountMin_" + fieldId)) {
		var MinCharCount = parseInt(document.getElementById("RequiredCharacterCountMin_" + fieldId).value);
		if (elementText.length < MinCharCount) {
			document.getElementById("wTooFewCharacters_" + fieldId).style.display = "";
			setInnerText("wTooFewCharacters_" + fieldId + "_current", elementText.length);
			valid = false;
		} else {
			document.getElementById("wTooFewCharacters_" + fieldId).style.display = "none";
		}
	}

	if (phrase1.length = 0 || elementText.indexOf(phrase1.toLowerCase()) > -1) {
		document.getElementById("wFrequency1_" + fieldId).style.display = "none";
		document.getElementById("isValid_" + fieldId).value = "almost"
		if (phrase1.length > 0 && elementText.indexOf(phrase1.toLowerCase()) == 0) {
			document.getElementById("wBeginWithPhrase_" + fieldId).style.display = "none";
		} else {
			document.getElementById("wBeginWithPhrase_" + fieldId).style.display = "";
			valid = false;
		}
	} else {
		document.getElementById("wBeginWithPhrase_" + fieldId).style.display = "none";
		document.getElementById("wFrequency1_" + fieldId).style.display = "";
		valid = false;
	}

	//	if (fieldCount < 1) {
	//		document.getElementById("wFrequency1_" + fieldId).style.display = "none";
	//		document.getElementById("wWordcount_" + fieldId).style.display = "none";
	//		document.getElementById("wBeginWithPhrase_" + fieldId).style.display = "none";
	//		valid = false;
	//	} else {
	document.getElementById("wElementcount_" + fieldId).style.display = "none";
	//	}
	if (valid) {
		document.getElementById("iconOk_" + fieldId).style.display = "";
		document.getElementById("iconOk2_" + fieldId).style.display = "";
		document.getElementById("iconWarning_" + fieldId).style.display = "none";
		document.getElementById("iconWarning2_" + fieldId).style.display = "none";
		document.getElementById("iconErr_" + fieldId).style.display = "none";
		document.getElementById("iconErr2_" + fieldId).style.display = "none";
		document.getElementById("wOk_" + fieldId).style.display = "";
		    
		document.getElementById("isValid_" + fieldId).value = "true";
	} else {
		document.getElementById("iconOk_" + fieldId).style.display = "none";
		document.getElementById("iconOk2_" + fieldId).style.display = "none";
		if (document.getElementById("isValid_" + fieldId).value == "almost") {
			document.getElementById("iconWarning_" + fieldId).style.display = "";
			document.getElementById("iconWarning2_" + fieldId).style.display = "";
			document.getElementById("iconErr_" + fieldId).style.display = "none";
			document.getElementById("iconErr2_" + fieldId).style.display = "none";
		} else {
			document.getElementById("iconWarning_" + fieldId).style.display = "none";
			document.getElementById("iconWarning2_" + fieldId).style.display = "none";
			document.getElementById("iconErr_" + fieldId).style.display = "";
			document.getElementById("iconErr2_" + fieldId).style.display = "";
		}
		document.getElementById("wOk_" + fieldId).style.display = "none";
	}
	calculatePercent();
	return valid;
}
function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g, "");
}
function removeDoubleSpaces(string) {
	return removeTribleSpaces(string).split('  ').join(' ');
}
function removeTribleSpaces(string) {
	return string.split('   ').join(' ');
}

function init() {
	for (var i = 0; i < 5; i++) {
		if (document.getElementById("isValid_" + i).value == "false") {
			enable(i);
			return;
		}
	}
	enable(0);
}

function calculatePercent() {
	var p = 0;
	for (var i = 0; i < 5; i++) {
		if (document.getElementById("isValid_" + i)) {
			if (document.getElementById("isValid_" + i).value == "true") {
				p += parseInt(document.getElementById("percent" + i).value);
			}
			if (document.getElementById("isValid_" + i).value == "almost") {
				p += parseInt((parseInt(document.getElementById("percent" + i).value) / 3) * 2);
			}
		}
	}
	setInnerText("percent", p + "%");
}

function enable(id) {
	if (id > 4) {
		id = 0;
    }
    
    updateNavigation(id);
    
	for (var i = 0; i < 5; i++) {
		if (document.getElementById("Container_" + i)) {
			document.getElementById("Container_" + i).style.display = "none";
			document.getElementById("elmctn_" + i).className = 
			    document.getElementById("elmctn_" + i).className.replace(' optimize-summary-active', '');
		}
	}

	eval("validate" + id + "();");

	document.getElementById("Container_" + id).style.display = "";
	document.getElementById("elmctn_" + id).className += ' optimize-summary-active';
}

function choosePhrase() {
	location = 'PhraseSelection.aspx' + location.search + "&choosenew=true";
}

function updateNavigation(id) {
    var cmdNext = document.getElementById('cmdNext' + id);
    var cmdPrev = document.getElementById('cmdPrev' + id);

    if (cmdPrev) {
        cmdPrev.disabled = (id == 0);
    }

    if (cmdNext) {
        cmdNext.disabled = (id == 4);
    }
}

function canNavigate(id, direction) {
    var ret = false;
    var cmd = document.getElementById('cmd' + (direction > 0 ? 'Next' : 'Prev') + id);

    if (cmd) {
        ret = !cmd.disabled;
    }

    return ret;
}

function setInnerText(id, text) {
    var obj = document.getElementById(id);

    if (obj) {
        if (typeof (obj.innerText) != 'undefined') {
            obj.innerText = text;
        } else if (typeof (obj.textContent) != 'undefined') {
            obj.textContent = text;
        }
    }
}

function getInnerText(id) {
    var ret = '';
    var obj = document.getElementById(id);
    
    if(obj) {
        if (typeof (obj.innerText) != 'undefined') {
            ret = obj.innerText;
        } else if (typeof (obj.textContent) != 'undefined') {
            ret = obj.textContent;
        }
    }
    
    return ret;
}