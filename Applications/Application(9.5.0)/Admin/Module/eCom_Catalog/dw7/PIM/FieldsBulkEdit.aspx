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
                    var selectedLanguages = [].slice.call(document.querySelectorAll("input[type=checkbox][name=MultiEditLanguages]:checked")).map(function (checkbox) { return checkbox.value; }).filter(function (selectedLang) { return selectedLang != "none" });
                    var existingLanguages = document.getElementById("ExistingLanguages").value.split(",");
                    var newLanguages = selectedLanguages.filter(function (selectedLang) { return existingLanguages.indexOf(selectedLang) == -1; });
                    var createNewLanguages = document.getElementById("CreateNonExistingLanguageProducts").checked;

                    var fieldsNames = [];
                    
                    var productsToChangeCount = 0;

                <%If IsMultiProductsEdit Then%>

                    var affectVariants = false;

                    for (var i = 0; i < editedFields.length; i++) {
                        var field = editedFields[i];
                        affectVariants = affectVariants || field.variantEditing;
                        var lbl = "'" + field.label + "'";
                        if (fieldsNames.indexOf(lbl) < 0) {
                            fieldsNames.push(lbl);
                        }
                    }

                    var selectedProducts = currentPage.getSelectedProducts();
                    for (var i = 0; i < selectedProducts.length; i++) {
                        var productid = selectedProducts[i];
                        if (productid == "none") {
                            continue;
                        }
                        var productsInFamily = 1;
                        if (affectVariants) {
                            var productsVariantCountHidden = document.getElementById("variantCount" + productid);
                            if (productsVariantCountHidden){
                                var productsVariantCount = parseInt(productsVariantCountHidden.value);
                                productsInFamily += productsVariantCount;
                            }
                        }

                        if (createNewLanguages) {
                            productsInFamily = productsInFamily * selectedLanguages.length;
                        } else {
                            productsInFamily = productsInFamily * (selectedLanguages.length - newLanguages.length);
                        }

                        productsToChangeCount = productsToChangeCount + productsInFamily;
                    }
        
                <%End If%>

                    var showTooManyProductsWarning = productsToChangeCount > 500;
                    var showNewLanguagesWarning = !createNewLanguages && newLanguages.length > 0;

                    var fieldsListStr = fieldsNames.join(", ");
                    var msg = Action.Transform(options.labels.confirmSaveMessage, { "fields": fieldsListStr });
                    if (showTooManyProductsWarning) {
                        msg = options.labels.tooManyProducts;
                    }else if (showNewLanguagesWarning) {
                        msg = options.labels.newLanguagesConfirmMessage;
                    }
                    currentPage.showConfirmMessage(msg, function () {
                        new overlay('__ribbonOverlay').show();
                        currentPage.updateVariantFields(function (fieldDefinition, updatedValue, documentFragment) {                            
                            currentPage.createMultiEditHiddenField(fieldDefinition, updatedValue, documentFragment);
                        });

                        currentPage.submitFormWithCommand(saveAndClose ? "SaveAndClose" : "Save");
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
            <input type="hidden" id="Ids" name="ids" runat="server" />
            <dwc:Card runat="server">
                <dwc:CardHeader runat="server" Title="Multiple fields edit" />
                <dw:Toolbar ID="commands" runat="server" ShowStart="true" ShowEnd="true">
                    <dw:ToolbarButton ID="cmdSaveAndClose" Icon="Save" Text="Save" runat="server" OnClientClick="currentPage.save(true)" />
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
