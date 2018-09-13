var ViewReport = new Object();

ViewReport.Lazy = function (instance) {
    /// <summary>Represents a lazy load wrapper around the given object.</summary>
    /// <param name="instance">Data to be lazy loaded.</param>

    this._instance = instance;
}

ViewReport.Lazy.prototype.get_instance = function () {
    /// <summary>Gets the associated object instance.</summary>

    var ret = null;

    if (this._instance) {
        if (typeof (this._instance) == 'string') {
            if (this._instance.indexOf('#') == 0) {
                ret = document.getElementById(this._instance.substr(1));
            } else {
                try {
                    if (!ret) {
                        ret = eval(this._instance);
                    }
                } catch (ex) { }
            }

            if (ret) {
                this._instance = ret;
            }
        } else {
            ret = this._instance;
        }
    }

    return ret;
}

ViewReport.chart = null;
ViewReport.chartData = null;
ViewReport.filters = [];
ViewReport.applyButton = null;
ViewReport.state = {};
ViewReport.pleaseWaitMessage = '';
ViewReport.exportToFile = false;
ViewReport._originalButtonText = '';

ViewReport.reportID = '';
ViewReport.reportCategoryID = '';
ViewReport.deleteMessageFormat = '';
ViewReport.isExporting = false;

ViewReport.initialize = function () {
    /// <summary>Initializes the instance.</summary>

    var frameInfobar = $$('.report-install-chromeframe div.Infobar');
    var frameInstallButton = $$('.report-install-chromeframe div.Infobar a');

    if (frameInfobar && frameInfobar.length) {
        Event.observe(frameInfobar[0], 'click', function (e) {
            var element = Event.element(e);
            var containerID = element.up('.report-install-chromeframe').id;

            ViewReport.beginInstallChromeFrame(containerID);

            Event.stop(e);
        });
    }

    if (frameInstallButton && frameInstallButton.length) {
        Event.observe(frameInstallButton[0], 'click', function (e) {
            var element = Event.element(e);
            var containerID = element.up('.report-install-chromeframe').id;

            ViewReport.disableChromeFrameNotification(containerID);

            Event.stop(e);
        });
    }
}

ViewReport.applyFilters = function (customQuery, onComplete, params) {
    /// <summary>Applies filters.</summary>
    /// <param name="customQuery">An object that represents a custom query to be passed to the chart.</param>
    /// <param name="onComplete">A callback that is fired when chart data becomes available.</param>
    /// <param name="params">Additional parameters.</param>

    var factID = '';
    var values = [];
    var valuesStr = '';
    var timeoutID = null;
    var callbackResult = null;
    var query = new Dynamicweb.Controls.Charts.DataQuery();

    var enableFilters = function () {
        if (timeoutID) {
            clearTimeout(timeoutID);
            timeoutID = null;
        }

        ViewReport.setEnableFilters(true);
    }

    if (!params) {
        params = {};
    }

    onComplete = onComplete || function () { return true; }

    for (var i = 0; i < ViewReport.filters.length; i++) {
        if (ViewReport.filters[i].get_instance().get_isActive()) {
            factID = ViewReport.filters[i].get_instance().get_factID();

            if (factID) {
                values = ViewReport.filters[i].get_instance().get_selectedValues();
                if (values && values.length) {
                    valuesStr = '';

                    for (var j = 0; j < values.length; j++) {
                        valuesStr += values[j];
                        if (j < (values.length - 1)) {
                            valuesStr += '$'
                        }
                    }

                    query.set_item(factID, valuesStr);
                }
            }
        }
    }

    if (customQuery) {
        for (var prop in customQuery) {
            if (typeof (prop) != 'function' && typeof (customQuery[prop]) != 'undefined') {
                query.set_item(prop, customQuery[prop].toString());
            }
        }
    }

    timeoutID = setTimeout(function () {
        ViewReport.setEnableFilters(false);
    }, 650);

    ViewReport.chart.get_instance().loadData({
        query: query,
        onComplete: function (data, annotations) {
            enableFilters();

            callbackResult = onComplete(data, annotations);

            if (callbackResult == null || !!callbackResult) {
                ViewReport.refreshChart(data, {
                    compatibleRendering: !!params.compatibleRendering,
                    annotations: annotations
                });
            } else {
                enableFilters();
            }
        }
    });
}

ViewReport.refreshChart = function (data, params) {
    /// <summary>Refreshes the chart area.</summary>
    /// <param name="data">Chart data.</param>
    /// <param name="params">Additional parameters.</param>

    var originalCompatibleRendering = false;
    var originalEmulatedRendering = false;

    if (!params) {
        params = {};
    }

    if (!ViewReport.state.dataTruncatedMessage) {
        ViewReport.state.dataTruncatedMessage = $$('.report-data-truncated')[0];
    }

    ViewReport.chart.get_instance().set_data(data);

    if (ViewReport.chartData != null && ViewReport.chartData.get_instance() != null) {
        ViewReport.chartData.get_instance().set_data(data);
        
        if (data.get_rows().length > 0) {
            ViewReport.chartData.get_instance().set_height((data.get_rows().length * 20) + 40);
        } else {
            ViewReport.chartData.get_instance().set_height(400);
        }
    }

    if (!!params.compatibleRendering) {
        originalCompatibleRendering = ViewReport.chart.get_instance().get_isCompatibleRendering();
        ViewReport.chart.get_instance().set_isCompatibleRendering(true);
    }

    if (!!params.emulate) {
        originalEmulatedRendering = ViewReport.chart.get_instance().get_isEmulatedRendering();
        ViewReport.chart.get_instance().set_isEmulatedRendering(true);
    }

    ViewReport.chart.get_instance().draw();

    if (ViewReport.chartData != null && ViewReport.chartData.get_instance() != null) {
        ViewReport.chartData.get_instance().draw();
    }

    if (!!params.compatibleRendering) {
        ViewReport.chart.get_instance().set_isCompatibleRendering(originalCompatibleRendering);
    }

    if (!!params.emulate) {
        ViewReport.chart.get_instance().set_isEmulatedRendering(originalEmulatedRendering);
    }

    if (ViewReport.state.dataTruncatedMessage) {
        ViewReport.state.dataTruncatedMessage.style.display = (params.annotations && !!params.annotations['DataTruncated'] ? '' : 'none');
    }
}

ViewReport.setEnableFilters = function (enabled) {
    /// <summary>Triggers "Enabled" state of the filter section.</summary>
    /// <param name="enabled">Indicates whether filters are enabled.</param>

    var offset = null;
    var dimensions = null;

    if (!ViewReport.state.filtersContainer) {
        ViewReport.state.filtersContainer = $($$('.omc-report-filters')[0]);
    }

    if (!ViewReport.state.filtersDisableContainer) {
        ViewReport.state.filtersDisableContainer = $($$('.omc-report-filters-disabled')[0]);
    }

    if (ViewReport.applyButton) {
        if (!enabled) {
            ViewReport._originalButtonText = ViewReport.applyButton.get_instance().value;
            ViewReport.applyButton.get_instance().value = ViewReport.pleaseWaitMessage;
            ViewReport.applyButton.get_instance().disabled = true;

            offset = ViewReport.state.filtersContainer.cumulativeOffset();
            dimensions = ViewReport.state.filtersContainer.getDimensions();

            ViewReport.state.filtersDisableContainer.setStyle({
                'top': offset.top + 'px',
                'left': offset.left + 'px',
                'width': dimensions.width + 'px',
                'height': dimensions.height + 'px',
                'display': 'block'
            });
        } else {
            if (ViewReport._originalButtonText) {
                ViewReport.applyButton.get_instance().value = ViewReport._originalButtonText;
            }

            ViewReport.applyButton.get_instance().disabled = false;
            ViewReport.state.filtersDisableContainer.setStyle({ 'display': 'none' });
        }
    }
}

ViewReport.beginInstallChromeFrame = function (notificationContainer) {
    /// <summary>Opens the new window that navigates to Chrome Frame installation page.</summary>
    /// <param name="notificationContainer">An ID of the notification container that must be hidden.</param>

    var container = null;

    if (notificationContainer && notificationContainer.length) {
        container = document.getElementById(notificationContainer);
        if (container) {
            container.style.display = 'none';
        }
    }

    window.open('http://code.google.com/chrome/chromeframe/', 'ChromeFrameInstall');
}

ViewReport.disableChromeFrameNotification = function (notificationContainer) {
    /// <summary>Prevents the module to show the warning regarding installing Chrome Frame in future.</summary>
    /// <param name="notificationContainer">An ID of the notification container that must be hidden.</param>

    var c = null;
    var container = null;
    var date = new Date();

    // Current date plus one year
    date.setTime(date.getTime() + 86400000 * 31 * 12);

    c = 'OMC_HideChromeFrameNotification=True; expires=' + date.toUTCString() + '; path=/; domain=' + document.domain;

    document.cookie = c;

    if (notificationContainer && notificationContainer.length) {
        container = document.getElementById(notificationContainer);
        if (container) {
            container.style.display = 'none';
        }
    }
}

ViewReport.editReport = function () {
    /// <summary>Brings up "Edit report" dialog.</summary>

    if (!ViewReport.isExporting) {
        if (parent != null && parent.OMC != null && parent.OMC.MasterPage != null) {
            parent.OMC.MasterPage.get_current().editReport(ViewReport.reportID, ViewReport.reportCategoryID);
        }
    }
}

ViewReport.exportReportData = function (format) {
    /// <summary>Exports the current report to Excel spreadsheet.</summary>
    /// <param name="format">Export format.</param>

    var form = null;
    var timeoutID = null;
    var imgExportProgress = null;
    var isCompatibleRendering = false;

    if (typeof (format) == 'undefined' || format == null) {
        format = '';
    } else {
        format = format.toString().toLowerCase();
    }

    imgExportProgress = $('imgExportProgress' + (format.length ? ('_' + format) : ''));
    isCompatibleRendering = format == 'pdf';

    var stripHash = function (url) {
        var result = url;
        var hashIndex = -1;

        if (result && result.length) {
            hashIndex = result.indexOf('#');
            if (hashIndex > 0) {
                result = result.substr(0, hashIndex);
            }
        }

        return result;
    }

    if (!ViewReport.isExporting) {
        ViewReport.isExporting = true;

        timeoutID = setTimeout(function () {
            imgExportProgress.show();
        }, 650);
        
        ViewReport.applyFilters({ Export: true }, function (data, annotations) {
            var result = true;

            if (timeoutID) {
                clearTimeout(timeoutID);
                timeoutID = null;
            }

            imgExportProgress.hide();

            if (isCompatibleRendering) {
                /* Causing the chart to rebuild its contents but not to populate them - the output will be passed to PDF generator */
                ViewReport.refreshChart(data, {
                    emulate: true,
                    compatibleRendering: true,
                    annotations: annotations
                });
            }

            if (annotations && annotations['ExportToken']) {
                result = false;

                setTimeout(function () {
                    form = new Element('form', { method: 'post', action: stripHash(window.location.href) });

                    if (format == 'pdf') {
                        form.appendChild(new Element('input', { type: 'hidden', name: 'ExportData', value: ViewReport.getPdfExportData() }));
                    } else {
                        form.appendChild(new Element('input', { type: 'hidden', name: 'ExportToken', value: annotations['ExportToken'] }));
                    }

                    document.body.appendChild(form);
                    form.submit();

                    document.body.removeChild(form);
                }, 50);
            }

            ViewReport.isExporting = false;

            return result;
        }, { compatibleRendering: isCompatibleRendering ? true : false });
    }
}

ViewReport.getPdfExportData = function () {
    /// <summary>Returns PDF export data (encoded HTML string).</summary>

    var ret = '';
    var c = null;
    var range = null;
    var dummy = null;
    var fragment = null;
    var containers = [];
    var reportData = null;
    var chartContainer = '';
    var chartOutput = ViewReport.chart.get_instance().get_lastOutput();

    if (chartOutput && chartOutput.length) {
        chartContainer = ViewReport.chart.get_instance().get_container();

        if (typeof (document.createRange) == 'function') {
            range = document.createRange();

            range.selectNodeContents(document.body);
            fragment = range.cloneContents();

            if (typeof (fragment.querySelector) == 'function') {
                c = fragment.querySelector('#' + chartContainer);
                reportData = fragment.querySelector('.omc-report-data');
            }

            if (reportData) {
                reportData.style.display = '';
            }

            if (c) {
                while (c.firstChild) {
                    c.removeChild(c.firstChild);
                }

                c.innerHTML = chartOutput;

                dummy = document.createElement('div');
                dummy.appendChild(fragment);

                ret = dummy.innerHTML;
            } else {
                ret = document.body.innerHTML;
            }
        } else {
            dummy = document.createElement('div');

            dummy.innerHTML = document.body.innerHTML;
            containers = dummy.getElementsByTagName('div');

            for (var i = 0; i < containers.length; i++) {
                if (containers[i].id == chartContainer) {
                    c = containers[i];

                    if (reportData) {
                        break;
                    }
                }

                if (containers[i].className == 'omc-report-data') {
                    reportData = containers[i];

                    if (c) {
                        break;
                    }
                }
            }

            if (reportData) {
                reportData.style.display = '';
            }

            if (c) {
                while (c.firstChild) {
                    c.removeChild(c.firstChild);
                }

                c.innerHTML = chartOutput;
                ret = dummy.innerHTML;
            }
        }
    } else {
        if (typeof (document.createRange) == 'function') {
            range = document.createRange();

            range.selectNodeContents(document.body);
            fragment = range.cloneContents();

            if (typeof (fragment.querySelector) == 'function') {
                reportData = fragment.querySelector('.omc-report-data');

                if (reportData) {
                    reportData.style.display = '';
                }
            }

            dummy = document.createElement('div');
            dummy.appendChild(fragment);

            ret = dummy.innerHTML;
        } else {
            dummy = document.createElement('div');

            dummy.innerHTML = document.body.innerHTML;
            containers = dummy.getElementsByTagName('div');

            for (var i = 0; i < containers.length; i++) {
                if (containers[i].className == 'omc-report-data') {
                    reportData = containers[i];
                    break;
                }
            }

            if (reportData) {
                reportData.style.display = '';
            }

            ret = dummy.innerHTML;
        }
    }

    if (ret && ret.length) {
        ret = ret.replace(/<!--([^#][^>]+)-->/gi, '');

        ret = ret.replace(/<!--#comment_start#-->/gi, '<!--');
        ret = ret.replace(/<!--#comment_end#-->/gi, '-->');
        ret = ret.replace(/<!--#uncomment_start#/gi, '');
        ret = ret.replace(/#uncomment_end#-->/gi, '');

        ret = ret.replace(/"/gi, '&quot;');
        ret = ret.replace(/</gi, '&lt;');
        ret = ret.replace(/>/gi, '&gt;');
    }

    return ret;
}

ViewReport.deleteReport = function () {
    /// <summary>Deletes the current report.</summary>

    if (!ViewReport.isExporting) {
        if (parent != null && parent.OMC != null && parent.OMC.MasterPage != null) {
            parent.OMC.MasterPage.get_current().confirmDeleteReport(ViewReport.deleteMessageFormat.replace(/&quot;/gi, '"'),
            parent.OMC.MasterPage.get_current().get_tree().get_dynamic().combinePath(ViewReport.reportCategoryID, ViewReport.reportID));
        }
    }
}