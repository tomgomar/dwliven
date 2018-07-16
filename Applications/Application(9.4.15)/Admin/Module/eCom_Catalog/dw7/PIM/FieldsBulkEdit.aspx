<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FieldsBulkEdit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.FieldsBulkEdit" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>

<%@ Register TagPrefix="uc" TagName="UCFieldsBulkEdit" Src="~/Admin/Module/eCom_Catalog/dw7/PIM/UCFieldsBulkEdit.ascx" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeRequireJS="True" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Editor/ckeditor/ckeditor/ckeditor.js" />
            <dw:GenericResource Url="/Admin/Link.js" />

            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/Main.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/ProductListEditingExtended.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/productMenu.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/pickadaySetup.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/pickadayBundle.js" />
            <dw:GenericResource Url="/Admin/Filemanager/Browser/FileList.js" />
        </Items>
    </dw:ControlResources>

    <script>

        function initFieldsBulkEditPage(opts) {
            var options = opts;
            var obj = {
                init: function () {
                    Dynamicweb.PIM.BulkEdit.get_current().initialize(options);
                },

                cancel: function () {
                    Action.Execute(options.actions.cancel);
                },
                save: function (saveAndClose) {
                    var currentPage = Dynamicweb.PIM.BulkEdit.get_current();
                    var editedFields = currentPage.getEditedFields();
                    var fieldsNames = [];

                    for (var i = 0; i < editedFields.length; i++) {
                        var lbl = "'" + editedFields[i].label + "'";
                        if (fieldsNames.indexOf(lbl) < 0) {
                            fieldsNames.push(lbl);
                        }
                    }

                    var fieldsListStr = fieldsNames.join(", ");
                    var msg = Action.Transform(options.labels.confirmSaveMessage, { "fields": fieldsListStr })

                    currentPage.showConfirmMessage(msg, function () {
                        currentPage.updateVariantFields(function (fieldDefinition, updatedValue, documentFragment) {
                            currentPage.createMultiEditHiddenField(fieldDefinition, updatedValue, documentFragment);
                        });


                        currentPage.submitFormWithCommand(saveAndClose ? "SaveAndClose" : "Save");
                    }, function () { //oncancel
                        new overlay('__ribbonOverlay').hide();
                    });
                }
            };
            obj.init();
            return obj;
        }
    </script>
</head>

<body class="area-red screen-container">
    <dw:Overlay ID="__ribbonOverlay" runat="server"></dw:Overlay>
    <script type="text/javascript"> 
        new overlay('__ribbonOverlay').show();
    </script>
    <div class="dw8-container fields-bulk-edit-containter">
        <form id="Form1" runat="server">
            <input type="hidden" id="Cmd" name="Cmd" />
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Multiple fields edit" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="true">
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save(true)" ShowWait="true" />
                    <dw:ToolbarButton ID="cmdCancel" Icon="Cancel" IconColor="Danger" Text="Cancel" runat="server" OnClientClick="currentPage.cancel()" />
                </dw:Toolbar>
                <dwc:CardBody runat="server">
                    <uc:UCFieldsBulkEdit runat="server" ID="FieldsValuesMultiEdit" />
                </dwc:CardBody>
            </dwc:Card>
        </form>
    </div>
    <script type="text/javascript">
        new overlay('__ribbonOverlay').hide();
    </script>
</body>
</html>
