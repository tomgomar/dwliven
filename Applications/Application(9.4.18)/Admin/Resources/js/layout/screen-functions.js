/*
* Layout Screen
*/

$(document).ready(function () {
    var resizeFunction = function () {
        if ($('body').innerWidth() < 768) {
            $('body').addClass('label-top');

            $('body').find('.responsive-table-list-off').addClass('responsive-table-list');
        } else {
            $('body').removeClass('label-top');

            $('body').find('.responsive-table-list-off').removeClass('responsive-table-list');
        }
    };
    $(window).on("resize", dwGlobal.debounce(resizeFunction, 250));

    /*
    * Set the area color
    */
    var areaColor = $(parent.document).find('#sidebar').attr("class");
    if (areaColor != "") {
        $('body').removeClass('area-blue').addClass(areaColor);
    }

    /*
     * Set the deffined input control layout
     */
    SetInputLayout();

    /*
     * Dropdown Menu
     */
    if ($('.dropdown')[0]) {
        //Propagate
        $('body').on('click', '.dropdown.open .dropdown-menu', function (e) {
            e.stopPropagation();
        });

        $('.dropdown').on('shown.bs.dropdown', function (e) {
            if ($(this).attr('data-animation')) {
                $animArray = [];
                $animation = $(this).data('animation');
                $animArray = $animation.split(',');
                $animationIn = 'animated ' + $animArray[0];
                $animationOut = 'animated ' + $animArray[1];
                $animationDuration = ''
                if (!$animArray[2]) {
                    $animationDuration = 500; //if duration is not defined, default is set to 500ms
                }
                else {
                    $animationDuration = $animArray[2];
                }

                $(this).find('.dropdown-menu').removeClass($animationOut)
                $(this).find('.dropdown-menu').addClass($animationIn);
            }
        });

        $('.dropdown').on('hide.bs.dropdown', function (e) {
            if ($(this).attr('data-animation')) {
                e.preventDefault();
                $this = $(this);
                $dropdownMenu = $this.find('.dropdown-menu');

                $dropdownMenu.addClass($animationOut);
                setTimeout(function () {
                    $this.removeClass('open')

                }, $animationDuration);
            }
        });
    }

    /*
     * Waves Animation
     */
    (function () {
        var wavesList = ['.btn'];

        for (var x = 0; x < wavesList.length; x++) {
            if ($(wavesList[x])[0]) {
                if ($(wavesList[x]).is('a')) {
                    $(wavesList[x]).not('.btn-icon, input').addClass('waves-effect waves-button');
                }
                else {
                    $(wavesList[x]).not('.btn-icon, input').addClass('waves-effect');
                }
            }
        }

        setTimeout(function () {
            if ($('.waves-effect')[0]) {
                Waves.displayEffect();
            }
        });
    })();
});



/*
* DW8 Dialog, Pop-ups and Modals
*/

dialog = {};

dialog.show = function (dialogId) {
    $(("#" + dialogId)).css('display', 'block');
    $(("#" + dialogId)).addClass('in');
    $('body').addClass('modal-open overflow-x');

    $('body').append('<div id="dark-overlay" class="modal-backdrop fade in"></div>');

    return false;
}

dialog.showAt = function (dialogId) {
    $(("#" + dialogId)).css('display', 'block');
    $(("#" + dialogId)).addClass('in');
    $('body').addClass('modal-open overflow-x');

    $('body').append('<div id="dark-overlay" class="modal-backdrop fade in"></div>');

    return false;
}

dialog.hide = function (dialogId) {
    $(("#" + dialogId)).css('display', 'none');
    $(("#" + dialogId)).removeClass('in');
    $('body').removeClass('modal-open overflow-x');

    $('#dark-overlay').remove();

    return false;
}

dialog.setTitle = function (dialogId, newTitle) {
    if ($('#T_' + dialogId)) {
        $('#T_' + dialogId).text(newTitle);
    }
}

dialog.getTitle = function (dialogId) {
    return $('#T_' + dialogId).html();
}

/*
* DW8 Bootstrap vs. Prototype fix
*/
var ppt = window.Prototype;
if (ppt && ppt.BrowserFeatures && ppt.BrowserFeatures.ElementExtensions) {
    var disablePrototypeJS = function (method, pluginsToDisable) {
        var handler = function (event) {
            event.target[method] = undefined;
            setTimeout(function () {
                delete event.target[method];
            }, 0);
        };
        pluginsToDisable.each(function (plugin) {
            jQuery(window).on(plugin.replace("{0}", method), handler);
        });
    },

    pluginsToDisable = ["{0}.bs.collapse", "{0}.bs.dropdown", "{0}.bs.modal", "{0}.bs.tooltip", "{0}.bs.popover", "{0}.bs.tab", "dp.{0}"/*bootstrap-datetimepicker.js*/];
    disablePrototypeJS('show', pluginsToDisable);
    disablePrototypeJS('hide', pluginsToDisable);
}


/*
* Layout switcher
*/

function SwitchLayout(layouttype) {
    $('body').attr("id", layouttype + "-layout");
}

function SetInputLayout() {
    if (localStorage.getItem('input-layout') == "boxed" || localStorage.getItem('input-layout') == null) {
        $('body').addClass('boxed-fields');
    } else {
        $('body').addClass('material-fields');
    }

    if (localStorage.getItem('interface-layout') == "material" || localStorage.getItem('interface-layout') == null) {
        $('body').attr('id', 'material-layout');
    } else {
        $('body').attr('id', 'flemming-layout');
    }

    if (localStorage.getItem('columns-layout') == "material" || localStorage.getItem('columns-layout') == null) {

    } else {
        $('body').addClass('column-boxes');
    }
}

document.addEventListener("DOMContentLoaded", function (event) {
    var buttons = document.getElementsByClassName("groupbox-button-collapse");
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].onclick = function () {
            var elm = this;
            var collapsedContent = elm.parentNode.getElementsByClassName("groupbox-content")[0];
            collapsedContent.classList.toggle('collapsed');

            elm.getElementsByClassName("groupbox-icon-collapse")[0].classList.toggle('fa-minus');
            elm.getElementsByClassName("groupbox-icon-collapse")[0].classList.toggle('fa-plus');

            if (elm.getElementsByClassName("gbSubtitle")[0]) {
                elm.getElementsByClassName("gbSubtitle")[0].classList.toggle('hidden');
            }

            // Save group box collapsed state to PersonalSettings        
            var postBackId = document.querySelectorAll('input[id*=' + elm.parentNode.parentNode.id + ']')[0];
            if (postBackId) {
                var id = postBackId.id;
                $.ajax({
                    type: 'POST',
                    data: {
                        __EVENTTARGET: id || "",
                        __EVENTARGUMENT: "Collapsed:" + collapsedContent.hasClassName("collapsed")
                    }
                });
            }
        };
    }

    var initChart = function (chartCnt, chartData, undefined) {
        chartData = chartData || {};
        var chartType = chartData.chartType || chartCnt.data("type") || "Line";
        var strokeColor = chartData.strokeColor || chartCnt.data("stroke-color");
        var options = {};
        var chartEl = chartCnt.find(".ct-chart");
        if (!chartData.data) {
            chartData.data = chartEl.data("data") || {};
        }
        var responsiveOptions = null;
        if (chartType !== "Pie") {
            var arr = [];
            if (chartData.data.series) {
                arr.push(chartData.data.series);
            }
            chartData.data.series = arr;
        } else {
            if (Chartist.plugins && Chartist.plugins.pieChartLegend) {
                options = {
                    chartPadding: 20,
                    labelOffset: 80,
                    ignoreEmptyValues: true,
                    chartValues: chartData.data.series,
                    labelInterpolationFnc: function (value, idx) {
                        return this.chartValues[idx];
                    }
                };
                options.plugins = [Chartist.plugins.pieChartLegend()];
            }
        }

        var chartCtrl = new Chartist[chartType](chartEl[0], chartData.data, options, responsiveOptions);
        chartEl.data("chart", chartCtrl);
        if (strokeColor) {
            chartCtrl.on('draw', function (context) {
                if (chartType == "Line" && (context.type === 'point' || context.type === 'line')) {
                    context.element.attr({ style: 'stroke: ' + strokeColor + ';' });
                }
                else if (chartType == "Bar" && context.type === 'bar') {
                    context.element.attr({ style: 'stroke: ' + strokeColor + ';' });
                }
            });
        }
    };

    /* Chartist init */
    $(".chart").each(function () {
        var chartEl = $(this);
        var url = chartEl.data("source");
        if (url) {
            $.getJSON(url, function (data) {
                initChart(chartEl, data);
            }).error(function (response) {
                var inner = response.responseText.split(/<body[^>]*>|(.*?)<\/body>/igm)[2];
                chartEl.html("<div style=\"overflow: scroll;height: 100%;\">" + inner || response.responseText + "</div>");
            });
        } else {
            initChart(chartEl);
        }
    });
});