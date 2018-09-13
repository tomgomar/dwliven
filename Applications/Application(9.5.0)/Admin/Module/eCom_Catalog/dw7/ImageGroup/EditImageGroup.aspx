<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="EditImageGroup.aspx.vb" Inherits="Dynamicweb.Admin.EditImageGroup" EnableViewState="false" ViewStateMode="Disabled" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title></title>
    <dw:ControlResources ID="ctrlResources" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/ObjectSelector.css" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Contextmenu/Contextmenu.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/images/layermenu.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Content/Management/Deployment/css/iconselector.css" />
        </Items>
    </dw:ControlResources>
    <script>
        function createEditImageGroupPage(opts) {
            var options = opts;
            var imageGroupNameEl = document.getElementById(options.ids.name);
            var imageGroupSystemNameEl = document.getElementById(options.ids.systemName);
            var imageGroupNameIni = imageGroupNameEl.value;
            var hasValue = function (el) {
                return !!el.value;
            };
            var validate = function () {
                var isValid = true;
                if (!hasValue(imageGroupNameEl)) {
                    dwGlobal.showControlErrors(imageGroupNameEl, options.labels.emptyName);
                    isValid || imageGroupNameEl.focus();
                    isValid = false;
                }
                if (!hasValue(imageGroupSystemNameEl)) {
                    dwGlobal.showControlErrors(imageGroupSystemNameEl, options.labels.emptySystemName);
                    isValid || imageGroupNameEl.focus();
                    isValid = false;
                }
                return isValid;
            };

            var obj = {
                init: function (opts) {
                    this.options = opts;
                    this.icon = options.icon;
                    this.iconColor = options.iconColor;
                    this.selectIcon();
                    this.initIconPicker();
                    this.initSystemNameObervers();
                },

                save: function(close) {
                    if (validate()) {
                        if (close) {
                            document.getElementById('RedirectTo').value = "list";
                        }
                        var iconEl = document.getElementById('SmallIcon');
                        iconEl.value = this.icon;
                        var iconColorEl = document.getElementById('IconColor');
                        iconColorEl.value = this.iconColor;
                        var cmd = document.getElementById('cmdSubmit');
                        cmd.value = "Save";
                        cmd.click();
                    }
                },

                cancel: function () {
                    Action.Execute(this.options.actions.list);
                },

                confirmDeleteImageGroup: function (evt) {
                    evt.stopPropagation();
                    var self = this;
                    var confirmStr = imageGroupNameIni;
                    confirmStr = confirmStr.replace('&nbsp;', "");
                    confirmStr = confirmStr.replace('&qout;', "");
                    confirmStr = "\'" + confirmStr + "\'";
                    Action.Execute(this.options.actions.delete, {
                        ids: self.options.imageGroupId,
                        names: confirmStr
                    });
                },

                initIconPicker: function () {
                    var self = this;
                    Event.observe($('dlgIconSettings').select('#IconColorSelect')[0], 'change', function (e) {
                        var newColor = e.target.value;
                        var colorClass = e.target.options[e.target.selectedIndex].className;
                        var iconBlocks = $('dlgIconSettings').select("div.icon-block");
                        iconBlocks.forEach(function (block) {
                            var classes = block.select('i')[0].classList;
                            if (classes.length > 3) {
                                classes.remove(classes[classes.length - 1]);
                            }
                            classes.add(colorClass);
                        });
                        self.iconColor = newColor;
                    });

                    var iconBlocks = $('dlgIconSettings').select("div.icon-block");
                    iconBlocks.forEach(function (block) {
                        Event.observe(block, 'click', function (e) {
                            $('dlgIconSettings').select('div[class="icon-block selected"]')[0].className = "icon-block";
                            this.classList.add("selected")
                            self.icon = this.select('span')[0].textContent;
                            self.selectIcon();
                        });
                    });

                    var iconSearch = function (e) {
                        var searchText = e.target.value.toLowerCase();
                        iconBlocks.forEach(function (block) {
                            if (!searchText || block.select('span')[0].textContent.toLowerCase().indexOf(searchText) > -1) {
                                block.show();
                            } else {
                                block.hide();
                            }
                        });
                    }

                    Event.observe($('IconSearch'), 'change', iconSearch);
                    Event.observe($('IconSearch'), 'keyup', iconSearch);
                },

                selectIcon: function () {
                    var iconSelector = document.getElementById('IconSelector');
                    iconSelector.className = $('dlgIconSettings').select('div[class="icon-block selected"]')[0].select('i')[0].className;
                    iconSelector.title = iconSelector.className;
                    iconSelector.style.display = (this.icon === "None" || !this.icon) ? "none" : "";
                    dialog.hide('dlgIconSettings');
                },

                initSystemNameObervers: function () {
                    var self = this;
                    Event.observe(document.getElementById("ImageGroupName"), 'blur', self.setSystemName);
                    Event.observe(document.getElementById("ImageGroupSystemName"), 'blur', self.setSystemName);
                },
                

                setSystemName: function (e) {
                    var nameBox = document.getElementById("ImageGroupName");
                    var sysNameBox = document.getElementById("ImageGroupSystemName");

                    var sysName = sysNameBox.value;
                    if (sysName.strip().empty()) {
                        sysName = nameBox.value;
                    }
                    sysNameBox.value = sysName.strip().replace(/\s+/g, "_").replace(/[^a-zA-Z0-9_]+/g, "");
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
                <dwc:CardHeader runat="server" DoTranslate="true" Title="Edit image category" />
                <dw:Toolbar ID="MainToolbar" runat="server" ShowStart="true" ShowEnd="false">
                    <dw:ToolbarButton ID="cmdSave" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save();" />
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save and close" runat="server" OnClientClick="currentPage.save(close);" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="TimesCircle" Text="Cancel" runat="server" OnClientClick="currentPage.cancel();"></dw:ToolbarButton>
                    <dw:ToolbarButton ID="cmdDelete" Icon="Delete" Text="Delete" runat="server" Disabled="true" OnClientClick="currentPage.confirmDeleteImageGroup(event);" />
                </dw:Toolbar>
                <div class="breadcrumb">
                    <%= GetBreadCrumb()%>
                </div>
                <dw:Infobar ID="WrongLanguageForNewGroup" runat="server" Message="" Visible="false" TranslateMessage="false" />
                <dwc:CardBody runat="server">
                    <dwc:GroupBox ID="gbSettings" Title="Settings" runat="server">
                        <dwc:InputText ID="ImageGroupName" runat="server" Label="Name" ValidationMessage="" />
                        <dwc:InputText ID="ImageGroupSystemName" runat="server" Label="System name" ValidationMessage="" />
                        <dwc:RadioGroup ID="ImageGroupInheritance" runat="server" Label="Inheritance Type">
                            <Items></Items>
                        </dwc:RadioGroup>
                        <div class="dw-ctrl form-group">
                            <label class="control-label"><dw:TranslateLabel ID="lbIcon" Text="Icon" runat="server" /></label>	
                            <div class="form-group-input">
                                <i id="IconSelector" class="size-3x"></i>                            
                                <input type="hidden" id="SmallIcon" name="SmallIcon" value="<%=ImageGroupIcon.ToString()%>" />
                                <input type="hidden" id="IconColor" name="IconColor" value="<%=ImageGroupIconColor%>" />
                                <dwc:Button runat="server" ID="EditIcon" OnClick="dialog.show('dlgIconSettings');" Title="Edit" />
	                        </div>
                        </div>                        
                    </dwc:GroupBox>
                </dwc:CardBody>
            </dwc:Card>
            <dw:Dialog ID="dlgIconSettings" Title="Icon Settings" Size="Large" OkAction="currentPage.selectIcon();" ShowOkButton="true" ShowCancelButton="false" runat="server">
                <div class="filters">
                    <div class="form-group">
                        <label class="control-label"><dw:TransLateLabel runat="server" Text="Color" /></label>
                        <select class="selectpicker" ID="IconColorSelect">
                            <asp:Repeater runat="server" ID="IconColorSelectItems">
                                <ItemTemplate>
                                    <option value="<%#Container.DataItem.ToString()%>" <%#If(CType(Container.DataItem, Core.UI.KnownColor) = ImageGroupIconColor, "selected", "")%> class="<%#Core.UI.KnownColorInfo.ClassNameFor(CType(Container.DataItem, Core.UI.KnownColor))%>"><%#CType(Container.DataItem, Core.UI.KnownColor).ToString()%></option>
                                </ItemTemplate>
                            </asp:Repeater>
                        </select>
                    </div>
                    <dwc:InputText Label="Filter" ID="IconSearch" runat="server" />
                </div>
                <div class="icon-settings">
                    <asp:Repeater runat="server" ID="IconsRepeater">
                        <ItemTemplate>
                            <div class="icon-block<%#If(CType(Container.DataItem, KnownIcon) = ImageGroupIcon, " selected", "")%>">
                                <i class="size-3x <%#KnownIconInfo.ClassNameFor(CType(Container.DataItem, KnownIcon), True, ImageGroupIconColor)%>" title="<%#KnownIconInfo.ClassNameFor(CType(Container.DataItem, KnownIcon), True)%>"></i>
                                <span class="icon-block-label"><%#CType(Container.DataItem, KnownIcon).ToString()%></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                <div class="separator-10">&nbsp;</div>
            </dw:Dialog>
            <input type="submit" id="cmdSubmit" name="cmdSubmit" value="Submit" style="display: none" />
            <input type="hidden" id="RedirectTo" name="RedirectTo" value="" />
        </form>
    </div>
    <%Translate.GetEditOnlineScript()%>
</body>
</html>


