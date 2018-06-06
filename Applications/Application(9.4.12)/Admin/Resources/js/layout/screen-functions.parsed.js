/*
* Layout Screen
*/

jQuery(document).ready(function () {
    var resizeFunction = function () {
        if (jQuery('body').innerWidth() < 768) {
            jQuery('body').addClass('label-top');

            jQuery('body').find('.responsive-table-list-off').addClass('responsive-table-list');
        } else {
            jQuery('body').removeClass('label-top');

            jQuery('body').find('.responsive-table-list-off').removeClass('responsive-table-list');
        }
    };
    jQuery(window).on("resize", dwGlobal.debounce(resizeFunction, 250));

    /*
    * Set the area color
    */
    var areaColor = jQuery(parent.document).find('#sidebar').attr("class");
    if (areaColor != "") {
        jQuery('body').removeClass('area-blue').addClass(areaColor);
    }

    /*
     * Set the deffined input control layout
     */
    SetInputLayout();

    /*
     * Dropdown Menu
     */
    if (jQuery('.dropdown')[0]) {
        //Propagate
        jQuery('body').on('click', '.dropdown.open .dropdown-menu', function (e) {
            e.stopPropagation();
        });

        jQuery('.dropdown').on('shown.bs.dropdown', function (e) {
            if (jQuery(this).attr('data-animation')) {
                jQuery.animArray = [];
                jQuery.animation = jQuery(this).data('animation');
                jQuery.animArray = jQuery.animation.split(',');
                jQuery.animationIn = 'animated ' + jQuery.animArray[0];
                jQuery.animationOut = 'animated ' + jQuery.animArray[1];
                jQuery.animationDuration = ''
                if (!jQuery.animArray[2]) {
                    jQuery.animationDuration = 500; //if duration is not defined, default is set to 500ms
                }
                else {
                    jQuery.animationDuration = jQuery.animArray[2];
                }

                jQuery(this).find('.dropdown-menu').removeClass(jQuery.animationOut)
                jQuery(this).find('.dropdown-menu').addClass(jQuery.animationIn);
            }
        });

        jQuery('.dropdown').on('hide.bs.dropdown', function (e) {
            if (jQuery(this).attr('data-animation')) {
                e.preventDefault();
                jQuery.this = jQuery(this);
                jQuery.dropdownMenu = jQuery.this.find('.dropdown-menu');

                jQuery.dropdownMenu.addClass(jQuery.animationOut);
                setTimeout(function () {
                    jQuery.this.removeClass('open')

                }, jQuery.animationDuration);
            }
        });
    }

    /*
     * Waves Animation
     */
    (function () {
        var wavesList = ['.btn'];

        for (var x = 0; x < wavesList.length; x++) {
            if (jQuery(wavesList[x])[0]) {
                if (jQuery(wavesList[x]).is('a')) {
                    jQuery(wavesList[x]).not('.btn-icon, input').addClass('waves-effect waves-button');
                }
                else {
                    jQuery(wavesList[x]).not('.btn-icon, input').addClass('waves-effect');
                }
            }
        }

        setTimeout(function () {
            if (jQuery('.waves-effect')[0]) {
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
    jQuery(("#" + dialogId)).css('display', 'block');
    jQuery(("#" + dialogId)).addClass('in');
    jQuery('body').addClass('modal-open overflow-x');

    jQuery('body').append('<div id="dark-overlay" class="modal-backdrop fade in"></div>');

    return false;
}

dialog.showAt = function (dialogId) {
    jQuery(("#" + dialogId)).css('display', 'block');
    jQuery(("#" + dialogId)).addClass('in');
    jQuery('body').addClass('modal-open overflow-x');

    jQuery('body').append('<div id="dark-overlay" class="modal-backdrop fade in"></div>');

    return false;
}

dialog.hide = function (dialogId) {
    jQuery(("#" + dialogId)).css('display', 'none');
    jQuery(("#" + dialogId)).removeClass('in');
    jQuery('body').removeClass('modal-open overflow-x');

    jQuery('#dark-overlay').remove();

    return false;
}

dialog.setTitle = function (dialogId, newTitle) {
    if (jQuery('#T_' + dialogId)) {
        jQuery('#T_' + dialogId).text(newTitle);
    }
}

dialog.getTitle = function (dialogId) {
    return jQuery('#T_' + dialogId).html();
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
    jQuery('body').attr("id", layouttype + "-layout");
}

function SetInputLayout() {
    if (localStorage.getItem('input-layout') == "boxed" || localStorage.getItem('input-layout') == null) {
        jQuery('body').addClass('boxed-fields');
    } else {
        jQuery('body').addClass('material-fields');
    }

    if (localStorage.getItem('interface-layout') == "material" || localStorage.getItem('interface-layout') == null) {
        jQuery('body').attr('id', 'material-layout');
    } else {
        jQuery('body').attr('id', 'flemming-layout');
    }

    if (localStorage.getItem('columns-layout') == "material" || localStorage.getItem('columns-layout') == null) {

    } else {
        jQuery('body').addClass('column-boxes');
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
                jQuery.ajax({
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
    jQuery(".chart").each(function () {
        var chartEl = jQuery(this);
        var url = chartEl.data("source");
        if (url) {
            jQuery.getJSON(url, function (data) {
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