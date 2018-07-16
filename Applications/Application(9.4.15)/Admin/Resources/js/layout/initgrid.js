(function ($) {
    $(function () {
        //Selection
        $("[data-toggle=\"dw-bootgrid\"]").each(function () {
            var gridEl = $(this);
            var keepSelection = !!gridEl.data("keepSelection");

            var onRowClick = gridEl.data("onRowClick");
            var onRowClickAction = onRowClick ? JSON.parse(onRowClick.replace(/'/g, '"')) : null;

            var onSelect = gridEl.data("onSelect");
            var onSelectAction = onSelect ? JSON.parse(onSelect.replace(/'/g, '"')) : null;

            var onDeselect = gridEl.data("onDeselect");
            var onDeselectAction = onDeselect ? JSON.parse(onDeselect.replace(/'/g, '"')) : null;

            var onSelectionChanged = gridEl.data("onSelectionChanged");
            var onSelectionChangedAction = onSelectionChanged ? JSON.parse(onSelectionChanged.replace(/'/g, '"')) : null;

            var navigateToSelectedItem = keepSelection;
            var columnsMeta = {};
            var multiSelect = !!gridEl.data("multiSelect");
            var enableSortableRows = !!gridEl.data("sortableRows");
            var tilesViewActive = false;

            gridEl.find("thead > tr").children().each(function (idx, colEl) {
                var info = $(colEl).data();
                if (info.columnId) {
                    columnsMeta[info.columnId] = info;
                }
            });
            var cssObj = {
                icon: 'icon',
                iconColumns: 'md md-view-module',
                iconDown: 'md md-expand-more',
                iconRefresh: 'fa fa-refresh',
                iconUp: 'md md-expand-less',
                actions: 'actions pull-right'
            };

            var templatesObj = {
                actionButton: "<button class=\"btn\" type=\"button\" title=\"{{ctx.text}}\">{{ctx.content}}</button>",
                header: "<div id=\"{{ctx.id}}\" class=\"{{css.header}}\"><div class=\"row\"><div class=\"col-sm-12 actionBar\"><p class=\"{{css.actions}}\"></p><p class=\"{{css.search}}\"></p></div></div></div>",
                paginationItem: "<li class=\"{{ctx.css}}\"><a href=\"{{ctx.uri}}\" class=\"{{css.paginationButton}} btn\">{{ctx.text}}</a></li>",
                search: "<div class=\"{{css.search}}\"><div class=\"input-group\"><input type=\"text\" class=\"{{css.searchField}} std\" placeholder=\"{{lbl.search}}\" /><span class=\"input-group-addon\"><i class=\"fa fa-search\"></i></span></div></div>",
                select: "<input name=\"select\" type=\"{{ctx.type}}\" class=\"checkbox {{css.selectBox}}\" id=\"select-{{ctx.value}}\" value=\"{{ctx.value}}\" {{ctx.checked}} /><label for=\"select-{{ctx.value}}\"></label>",
            };

            var rowCountSelect = "<select id=\"rowCount\" class=\"std row-count-select\"><option value=\"10\">10</option><option value=\"15\" selected>15</option><option value=\"20\">20</option><option value=\"25\">25</option><option value=\"-1\">All</option></select>"

            if (!!gridEl.data("tiles-view")) {
                templatesObj.actions = "<div class=\"{{css.actions}}\"><div class=\"btn-group\"><button type=\"button\" title=\"Grid view\" class=\"btn" + (!tilesViewActive ? " active" : "") + " gridViewBtn\"><i class=\"md  md-toc\"></i></button><button type=\"button\" title=\"Tiles view\" class=\"btn" + (tilesViewActive ? " active" : "") + " tilesViewBtn\"><i class=\"fa fa-th-large\"></i></button></div>" + rowCountSelect + "</div>";
            } else {
                templatesObj.actions = "<div class=\"{{css.actions}}\">" + rowCountSelect + "</div>";
            }

            if (multiSelect) {
                cssObj.selected = "dw-multi-active"
                cssObj.selectCell = "dw-select-cell"
            }
            var dataSource = gridEl.data("url");
            var isAjax = gridEl.data("ajax");
            if (isAjax) {
                $(document).ajaxError(function (event, jqxhr, settings, exception) {
                    if (jqxhr.statusText !== "abort" && settings.url == dataSource) {
                        var inner = jqxhr.responseText.split(/<body[^>]*>|(.*?)<\/body>/igm)[2];
                        gridEl.html("<div style=\"overflow: scroll;height: 100%;\">" + inner || jqxhr.responseText + "</div>");
                    }
                });
            }
            
            gridEl.bootgrid({
                css: cssObj,
                templates: templatesObj,
                keepSelection: keepSelection,
                post: function () {
                    var sourceParams = gridEl.data("sourceParameters");
                    if (sourceParams && sourceParams && typeof sourceParams == "string") {
                        sourceParams = JSON.parse(sourceParams);
                    }
                    if (keepSelection) {
                        var selectedItem = gridEl.data("selectedItem");
                        if (selectedItem) {
                            sourceParams = sourceParams || {
                            };
                            sourceParams.selectedItem = selectedItem;
                            sourceParams.navigateToSelectedItem = navigateToSelectedItem;
                            if (navigateToSelectedItem) {
                                var gridObj = gridEl.data(".rs.jquery.bootgrid");
                                gridObj.selectedRows = gridObj.selectedRows || [];
                                gridObj.selectedRows.push(selectedItem.toString());
                                navigateToSelectedItem = false;
                            }
                        }
                    }

                    return sourceParams;
                },
                formatters: {
                    "link": function (column, row) {
                        var colData = row[column.id];
                        //var colInfo = columnsMeta[column.id];
                        var xref = row[column.id + "Link"] || document.location.pathname + "/" + row.Id;
                        column.tooltipSource = colData;
                        return "<a href=\"" + xref + "\" target=\"_self\">" + colData + "</a>";
                    },
                    "action-link": function (column, row) {
                        var colInfo = columnsMeta[column.id];
                        var result = "";
                        var meta = row.ActionsMetadata || {};
                        if (colInfo.actions) {
                            var actions = JSON.parse(colInfo.actions.replace(/'/g, "\""));
                            if (actions && actions.length)
                            {
                                var actionInfo = actions[0];
                                var showAction = meta["Show" + actionInfo.Id];
                                if (showAction == null) {
                                    showAction = meta[actionInfo.Id] && !meta[actionInfo.Id].Visible ? false : true;
                                }
                                if (showAction) {
                                    result = '<a onclick=\'event.stopPropagation(); Action.Execute(' + JSON.stringify(actionInfo) + ', ' + JSON.stringify(row) + '); return false;\' title=\'' + actionInfo.Title + '\' href=\'#\'>' + row[column.id] + '</a>';
                                    column.tooltipSource = row[column.id];
                                }
                                else {
                                    result = row[column.id];
                                }
                            }
                        }
                        return result;
                    },
                    "package": function (column, row) {
                        return "<a href=\"/Admin/Packages/Package/" + row.Id + "/" + row.Version + "\" target=\"_self\">" + row.Id + "</a>";
                    },
                    "actions": function (column, row) {
                        var colInfo = columnsMeta[column.id];
                        var result = "";
                        var meta = row.ActionsMetadata || {};
                        if (colInfo.actions) {
                            var actions = JSON.parse(colInfo.actions.replace(/'/g, "\""));
                            $.each(actions, function (idx, actionInfo) {
                                var showAction = meta["Show" + actionInfo.Id];
                                if (showAction == null) {
                                    showAction = meta[actionInfo.Id] && !meta[actionInfo.Id].Visible ? false : true;
                                }
                                if (showAction) {
                                    result += '<a onclick=\' event.stopPropagation(); Action.Execute(' + JSON.stringify(actionInfo) + ', ' + JSON.stringify(row) + '); return false;\' title=\'' + actionInfo.Title + '\' href=\'#\' class=\'list-icon m-r-5\'><i class=\'' + actionInfo.Icon + ' ' + actionInfo.IconColor + '\'></i></a>';
                                }
                            });
                        }
                        return result;
                    }
                }
            }).on("loaded.rs.jquery.bootgrid", function () {
                var grid = gridEl.data(".rs.jquery.bootgrid");
                
                if (grid.footer) {
                    var pagination = grid.footer.find(".pagination");
                    pagination.find("li[class^=page]").remove();
                    pagination.find("li.first i.md").attr("class", "fa fa-angle-double-left");
                    pagination.find("li.prev i.md").attr("class", "fa fa-angle-left");
                    pagination.find("li.next i.md").attr("class", "fa fa-angle-right");
                    pagination.find("li.last i.md").attr("class", "fa fa-angle-double-right");

                    $('<li class="pg-label">Page ' + grid.current + ' of ' + grid.totalPages + '</li>').insertAfter(pagination.find("li.prev"));
                    if (grid.totalPages > 1) {
                        grid.footer.find(".pagination").parent().removeClass("hidden").next().removeClass("col-sm-offset-8");
                    } else {
                        grid.footer.find(".pagination").parent().addClass("hidden").next().addClass("col-sm-offset-8");
                    }
                }

                if (multiSelect) {
                    $headerCheckbox = gridEl.find("thead > tr input[type=checkbox]");
                    $headerCheckbox.next().attr("for", $headerCheckbox.attr("id"));
                }

                if (!!gridEl.data("tiles-view")) {

                    grid.header.find(".icon.fa.fa-refresh").parent().remove();
                    var tilesId = gridEl.attr("id") + "Tiles";
                    var initialization = $("#" + tilesId).length > 0;
                    $("#" + tilesId).remove();

                    $("<div id=\"" + tilesId + "\" class=\"grid-view-tiles\" " + (tilesViewActive ? "" : "style=\"display:none;\"") + "></div>").insertAfter(gridEl);

                    var tilesData = [];
                    if (grid.currentRows && grid.currentRows.length > 0) {
                        tilesData = $.map(grid.currentRows, function (row) {
                            return $.extend({ DefaultAction: onSelectAction }, row);
                        });
                    }
                    $("#" + tilesId).tilesView({ data: tilesData });

                    grid.header.find(".tilesViewBtn").off("click").on("click", function () {
                        if (!tilesViewActive) {
                            gridEl.hide();
                            $("#" + tilesId).show();
                            $(this).toggleClass("active");
                            $(".gridViewBtn").toggleClass("active");
                            tilesViewActive = !tilesViewActive;
                        }
                    });

                    grid.header.find(".gridViewBtn").off("click").on("click", function () {
                        if (tilesViewActive) {
                            $("#" + tilesId).hide();
                            gridEl.show();
                            $(this).toggleClass("active");
                            $(".tilesViewBtn").toggleClass("active");
                            tilesViewActive = !tilesViewActive;
                        }
                    });
                }

                var gridContainer = $(gridEl).closest(".grid-container");

                gridContainer.find(".search-field").off("keydown").on("keydown", function (e) {
                    return e.which !== 13;
                });

                gridContainer.find("#rowCount").off("change").on("change", function (e) {
                    grid.rowCount = $(this).val();
                    grid.reload();
                });
                //loadData
                if (enableSortableRows) {
                    var onRowsSortCompleted = gridEl.data("onRowsSortCompleted");
                    var onRowsSortCompletedAction = onRowsSortCompleted ? JSON.parse(onRowsSortCompleted.replace(/'/g, '"')) : null;

                    var sortedRowsStorage = $('<input>').attr({
                        type: 'hidden',
                        name: gridEl.attr("id") + "_rows_orders"
                    }).appendTo(gridContainer);
                    var rowsContainer = $("tbody", grid.origin.context)[0];

                    var sortedFn = function () {
                        var ids = $(rowsContainer).children().map(function () {
                            return $(this).data("row-id");
                        });
                        var rowsIds = JSON.stringify($.makeArray(ids));
                        sortedRowsStorage.val(rowsIds);
                        if (onRowsSortCompletedAction) {
                            Action.Execute(onRowsSortCompletedAction, {
                                Rows: rowsIds
                            })
                        }
                        return false;
                    };
                    Sortable.create(rowsContainer, {
                        animation: 150,
                        onSort: sortedFn
                    });
                }
            });

            var selectedRows = [];

            var addToSelectedRows = function (rows) {
                selectedRows = selectedRows.concat(rows);
                return selectedRows;
            };

            var removeFromSelectedRows = function (rows) {
                for (var i = 0; i < rows.length; i++) {
                    var idx = selectedRows.indexOf(rows[i]);
                    if (idx > -1) {
                        selectedRows.splice(idx, 1);
                    }
                }
                return selectedRows;
            };
            if (onRowClickAction) {
                gridEl.on("click.rs.jquery.bootgrid", function (e, columns, selectedRows) {
                    if ($(e.target).parents(".dw-select-cell").length > 0 || !selectedRows)
                    {
                        return;
                    }
                    Action.Execute(onRowClickAction, selectedRows);
                });
            }
            if (onSelectAction || onSelectionChangedAction) {
                gridEl.on("selected.rs.jquery.bootgrid", function (e, selectedRows) {
                    e.stopPropagation();
                    var totalSelectedRows = addToSelectedRows(selectedRows);
                    if (onSelectAction) {
                        Action.Execute(onSelectAction, selectedRows[0]);
                    }
                    if (onSelectionChangedAction) {
                        Action.Execute(onSelectionChangedAction, totalSelectedRows);
                    }
                    return false;
                });
            }
            if (onDeselectAction || onSelectionChangedAction) {
                gridEl.on("deselected.rs.jquery.bootgrid", function (e, deselectedRows) {
                    e.stopPropagation();
                    var totalSelectedRows = removeFromSelectedRows(deselectedRows);
                    if (onDeselectAction) {
                        Action.Execute(onDeselectAction, deselectedRows[0]);
                    }
                    if (onSelectionChangedAction) {
                        Action.Execute(onSelectionChangedAction, totalSelectedRows);
                    }
                    return false;
                });
            }
        });
    });
})(jQuery);