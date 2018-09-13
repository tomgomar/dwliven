(function ($) {
    // Doesn't work without jquery
    if (!$) return;

    // ListView
    function ListView($me) {

        // Generate list from data
        function generateList(data) {
            var self = this;
            // Create a node from a node object
            function createNode(nObj, $target) {
            	var li = "";           	                

                if (nObj.OnClick) {                    
                    li = $('<div class="lv-item"/>').attr('onclick', nObj.OnClick).appendTo($target);
                } else if (nObj.DefaultAction) {
                    var act = "Action.Execute(" + JSON.stringify(nObj.DefaultAction) + ", " + JSON.stringify(nObj) + ");";
                    li = $('<div class="lv-item" data-dataobject="' + nObj.DefaultAction.Url + '">').attr('onclick', act).appendTo($target);
                } else {
                    li = $('<div class="lv-item">').appendTo($target);
                }
                if (nObj.Icon) {
                    li.addClass("with-left-icon");
                    var icon = '<i class="' + nObj.Icon + ' listview-icon"></i>';
                    li.append('<div class="left">' + icon + "</div>");
                }

                liBody = $('<div class="body">').appendTo(li);
                if (nObj.StatusColor) {
                    liBody.addClass("color-" + nObj.StatusColor.toLowerCase());
                }

                var hintEl = $('<small class="lv-small">');
                hintEl.html(nObj.Hint || "")
                hintEl.prop("title", hintEl.text());
                liBody.append(hintEl);
                
                var titleEl = $('<div class="lv-title">');
                liBody.append(titleEl);
                titleEl.html(nObj.Title)
                titleEl.prop("title", titleEl.text());

                if (nObj.RightIcon || nObj.RightText) {
                    var rightBlock = $('<div class="right">').appendTo(li);
                    if (nObj.RightIcon)
                    {
                        li.addClass("with-right-icon");
                        var icon = '<i class="' + nObj.RightIcon + ' listview-icon"></i>';
                        rightBlock.append(icon);
                    }
                    if (nObj.RightText) {
                        li.addClass("with-right-text");
                        rightBlock.html(nObj.RightText);
                    }
                }
                return li;
            }

            var innerList = "";
            innerList = $('<div>').appendTo($me);

            for (var i = 0; i < data.length; i++) {
                createNode(data[i], innerList);
            }
        }

        return {
            //Initialize control
            init: function (options) {
                // Handle undefined error
                options = options || {};
                this.options = options;
                if (this.options.data) {
                    $me.empty();
                    generateList(this.options.data);
                }
                else {
                    this.reload();
                }
            },
            reload: function () {
                var self = this;
                $me.empty();
                $.post(self.options.datasource, { Name: null }, function (data) {
                    if (data != null) {
                        // Generate the list
                        generateList.apply(self, [data]);
                    }
                }, 'json').error(function (response) {
                    var inner = response.responseText.split(/<body[^>]*>|(.*?)<\/body>/igm)[2];
                    $me.html("<div style=\"overflow: scroll;height: 100%;\">" + inner || response.responseText + "</div>");
                });
            }
        }
    }

    //ListView jQuery plugin
    $.fn.ListView = function (options) {
        //If it's a function arguments
        var args = (arguments.length > 1) ? Array.prototype.slice.call(arguments, 1) : undefined;
        var res = [];
        //All the elements by listview
        this.each(function () {
            var $this = $(this);
            var data = $this.data("listview");
            if (!data) {
                $this.data("listview", (data = new ListView($this)));
                data.init(options);
            }
            else if (options == "get") {
                res.push(data);
            }
            else if (data[options]) {
                data[options].apply(data, args);
            }
        });
        if (options == "get") {
            return res;
        }
        return this;
    }

/*
 * Auto link the plugin to any listview
 */
    $(document).ready(function () {
        (function () {
            $(".listview").each(function () {
                var el = $(this);
                if (el.data('datasource') || el.data('data')) {
                    el.ListView(el.data());
                }
            });
        })();
    });
})(window.jQuery);