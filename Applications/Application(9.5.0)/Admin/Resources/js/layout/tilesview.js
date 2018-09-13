(function ($) {
    function TilesView($me) {
        var getChildListUrl = function (opts, nodeId, aditionalParams) {
            var xref = opts.source;
            if (nodeId) {
                if (xref.lastIndexOf("/") != xref.length - 1) {
                    xref += "/";
                }
                xref += nodeId;
            }
            var params = $.extend({}, opts.sourceParameters, aditionalParams);
            var qs = $.param(params);
            if (qs) {
                xref += "?" + qs;
            }
            return xref;
        };

        var getContextMenuSourceUrl = function (widgetObj, nodeId) {
            return getChildListUrl(widgetObj.options, nodeId, { command: "actions" })
        };

        var generateList = function () {
            var innerList = $('<ul class="tilesview">').appendTo($me);
            for (var i = 0; i < this.options.data.length; i++) {
                createNode(innerList, this.options, this.options.data[i], i);
            }

            attachEventsToChildNodes(this, innerList);
        };

        var createNode = function (listCnt, opts, nodeObj, count) {
            var li = $('<li class="tile" style="opacity: 0">').appendTo(listCnt);
            var icon = "";
            //Add icon
            if (nodeObj.Image != null && nodeObj.Image != "") {
                icon = '<i><img class="img-responsive" src="' + nodeObj.Image + '" /></i>';
            } else if (nodeObj.Icon != null && nodeObj.Icon != 0) {
                icon = nodeObj.Icon.indexOf("<i") == 0 ? nodeObj.Icon : '<i class="' + nodeObj.Icon + '"></i>';
            }

            li.data("node-info", nodeObj);
            var itemWrap = li;
            if (opts.enableMenus && nodeObj.HasActions) {
                var dropdown = $('<div class="dropdown">').appendTo(itemWrap);
                dropdown.append($('<button class="btn btn-link pull-right contextTrigger waves-effect" data-toggle="dropdown" aria-expanded="false">').html("<i class=\"md md-more-vert\"></i>"));
            }

            if (nodeObj.DefaultAction) {
                var cmd = $("<a>").html('<div class="tile-image">' + icon + '</div><div class="tile-text">' + nodeObj.Title + '</div>');
                itemWrap.append(cmd);
                cmd.on("click", function () {
                    Action.Execute(nodeObj.DefaultAction, nodeObj);
                });
            } else {
                itemWrap.append('<div class="tile-image">' + icon + '</div>');
                itemWrap.append('<div class="tile-text">' + nodeObj.Title + '</div>');
            }
            $(li).delay((20 * count)).animate({ opacity: "1" }, 200);

            return li;
        };

        var attachEventsToChildNodes = function (self, nodesCnt) {
            var opts = self.options;
            var items = nodesCnt.find(".tile");

            //Trigger the context-menu
            items.find('.contextTrigger').on('click', function (e) {
                e.preventDefault();
                var itemEl = $(this).closest(".tile");
                var obj = itemEl.data("node-info");
                $(this).contextmenu({
                    source: getContextMenuSourceUrl(self, obj.Id),
                    model: obj,
                    rightAlign: false
                });
            }).on('contextmenu', function (e) {
                e.preventDefault();
                $('.dropdown').removeClass('open');
                $(this).closest('.dropdown').addClass('open');
                $(this).trigger("click");
            });

            items.on("contextmenu", function (e) {
                e.preventDefault();
                var $el = $(this);
                $el.find('.contextTrigger').trigger("click");
            });
        };

        return {
            init: function (options) {
                var opts = this.options = $.extend({
                    enableMenus: true,
                    source: "",
                    data: null
                }, options);
                $.map(opts, function (val, propName) {
                    if (propName == "sourceParameters" && val && typeof val == "string") {
                        opts[propName] = JSON.parse(val);
                    }
                });
                if (!opts.data) {
                    var dataSource = getChildListUrl(opts, opts.rootNode);
                    var self = this;
                    $.get(dataSource, function (data) {
                        opts.data = data;
                        generateList.apply(self);
                    }, 'json');
                } else {
                    generateList.apply(this);
                }
            }
        };
    }

    //TilesView jQuery plugin
    $.fn.tilesView = function (option) {
        //If it's a function arguments
        var args = (arguments.length > 1) ? Array.prototype.slice.call(arguments, 1) : undefined;

        //All the elements by selector
        return this.each(function () {
            var $this = $(this);
            var apiObj = $this.data("tilesview");
            if (!apiObj) {
                $this.data("tilesview", (apiObj = new TilesView($this)));
                apiObj.init(option);
            }
            else if (apiObj[option]) {
                return apiObj[option].apply(apiObj, args);
            }
        });
    }

    $(window).on('load.dw.tilesview.data-api', function () {
        $(".tiles").each(function () {
            var el = $(this);
            el.tilesView(el.data());
        });
    });
})(window.jQuery);