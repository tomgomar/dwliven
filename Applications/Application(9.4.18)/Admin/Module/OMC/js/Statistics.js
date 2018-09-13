if (typeof (OMC) == 'undefined') {
    var OMC = new Object();
}

if (typeof (OMC.SMP) == 'undefined') {
    OMC.SMP = new Object();
}

OMC.SMP.Statistics = {
    terminology: {},

    initialize: function () {
        document.observe('dom:loaded', function () {
            $($$('.smp-stats')[0]).observe('click', function (e) {
                OMC.SMP.Statistics.filterByAdapter(Event.element(e).id);
            });

            $($$('a.export-to-csv')[0]).observe('click', function (e) {
                dialog.show('dlgExport');
            });

            $($$('div.export-to-csv ul.csv-source')[0]).observe('click', function (e) {
                var t = $(Event.element(e));
                var tag = (t.tagName || t.nodeName).toLowerCase();

                if (tag == 'label' || tag == 'input' && (!t.disabled && !t.hasClassName('disabled'))) {
                    var collapseAll = function () {
                        $$('input[data-expandable]').each(function (elm) {
                            $($(elm).next('ul')).hide();
                        });
                    }

                    if (t.readAttribute('data-expandable') == 'true') {
                        collapseAll();

                        $(t.next('ul')).show();
                    } else if (!t.up('ul.csv-source-category')) {
                        collapseAll();
                    }
                }
            });
        });
    },

    filterByAdapter: function (adapter) {
        var prefix = '';

        var getPrefix = function (t) {
            var result = t.indexOf(':') > 0 ? t.substr(0, t.indexOf(':')) : '';

            if (result.length > 1) {
                result = '';
            }

            return result;
        }

        var setClass = function (t) {
            var ad = '';

            t = $(t);
            ad = t.readAttribute('data-adapter');

            if (getPrefix(ad) == prefix) {
                if (ad == adapter) {
                    t.addClassName('active');
                } else {
                    t.removeClassName('active');
                }
            }
        }

        prefix = getPrefix(adapter);

        if (adapter && adapter.length && prefix.length) {
            $$('.smp-stats div[data-adapter]').each(setClass);
        }
    },

    exportToCsv: function () {
        var o = null;
        var isChecked = false;
        
        $$('input[name="CsvSource"]').each(function (rd) {
            if (!isChecked) {
                isChecked = rd.checked;
            }
        });

        if (isChecked) {
            o = new overlay('WaitSpinner');

            o.show();

            if (typeof (__doPostBack) == 'function') {
                __doPostBack('', '');
            } else if (document.forms.length > 0) {
                document.forms[0].submit();
            }

            setTimeout(function () {
                o.hide();
                dialog.hide('dlgExport');
            }, 3000);
        } else {
            alert(OMC.SMP.Statistics.terminology.selectExportSource);
        }
    }
}