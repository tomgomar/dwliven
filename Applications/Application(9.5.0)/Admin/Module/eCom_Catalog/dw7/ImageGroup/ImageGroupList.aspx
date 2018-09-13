<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImageGroupList.aspx.vb" Inherits="Dynamicweb.Admin.ImageGroupList" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/layermenu.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        .dis {
            opacity: .4;
        }
        .icon {
            padding: 0;
            margin: 0;
        }
        .icon > i {
            line-height: 26px;
        }
    </style>
    <script>
        function createImageGroupListPage(opts) {
            var obj = {
                init: function (opts) {
                    this.options = opts;
                },
                confirmDeleteImageGroups: function (evt, rowID) {
                    evt.stopPropagation();
                    var self = this;
                    var ids = window.List.getSelectedRows(this.options.ids.list);
                    var row = null;
                    var confirmStr = "";
                    rowID = rowID || window.ContextMenu.callingID;
                    var imageGroupIds = [];
                    if (rowID) {
                        row = window.List.getRowByID(this.options.ids.list, 'row' + rowID);
                        if (row) {
                            confirmStr = row.children[2].innerText ? row.children[2].innerText : row.children[2].innerHTML;
                            confirmStr = confirmStr.replace('&nbsp;', "");
                            confirmStr = confirmStr.replace('&qout;', "");
                            imageGroupIds.push(rowID);
                        }
                    } else if (ids.length > 0) {
                        for (var i = 0; i < ids.length; i++) {
                            if (i != 0) {
                                confirmStr += " ' , '";
                            }
                            row = window.List.getRowByID(this.options.ids.list, ids[i].id);
                            if (row) {
                                confirmStr += row.children[2].innerText ? row.children[2].innerText : row.children[2].innerHTML;
                                confirmStr = confirmStr.replace('&nbsp;', "");
                                confirmStr = confirmStr.replace('&qout;', "");
                                imageGroupIds.push(ids[i].readAttribute("itemid"));
                            }
                        }
                    }
                    confirmStr = "\'" + confirmStr + "\'";
                    Action.Execute(this.options.actions.delete, {
                        ids: imageGroupIds,
                        names: confirmStr
                    });
                },

                imageGroupsSelected: function () {
                    if (List && List.getSelectedRows('lstImageGroupList').length > 0) {
                        Toolbar.setButtonIsDisabled('cmdDelete', false);
                    } else {
                        Toolbar.setButtonIsDisabled('cmdDelete', true);
                    }
                },

                createImageGroup: function () {
                    Action.Execute(this.options.actions.create);
                },

                editImageGroup: function (evt, imageGroupId) {
                    Action.Execute(this.options.actions.edit, { id: imageGroupId });
                }
            };
            obj.init(opts);
            return obj;
        }
    </script>
</head>

<body class="area-teal screen-container">
    <div class="dw8-container">
        <form id="MainForm" runat="server">
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Image categories" />
                <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdNew" Icon="PlusSquare" Text="New image category" runat="server" OnClientClick="currentPage.createImageGroup();" />
                    <dw:ToolbarButton ID="cmdDelete" Icon="Delete" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeleteImageGroups(event);" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:List runat="server" ID="lstImageGroupList" AllowMultiSelect="true" HandleSortingManually="false" ShowPaging="true" ShowTitle="false" PageSize="25" NoItemsMessage="No image categories found" OnClientSelect="currentPage.imageGroupsSelected();">
                    <Columns>
                        <dw:ListColumn ID="colIcon" ItemAlign="Center" EnableSorting="false" Name="" Width="18" runat="server" />
                        <dw:ListColumn ID="colName" EnableSorting="true" Name="Name" runat="server" />
                        <dw:ListColumn ID="colSystemName" EnableSorting="true" Name="System Name" runat="server" />
                        <dw:ListColumn ID="colInheritance" ItemAlign="Center" EnableSorting="false" Name="Inheritance Type" Width="150" runat="server" />
                        <dw:ListColumn ID="colDelete" ItemAlign="Center" HeaderAlign="Right" Name="Slet" Width="45" runat="server" />
                    </Columns>
                </dw:List>
            </dwc:Card>
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>
