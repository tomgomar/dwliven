
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