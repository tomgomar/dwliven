<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CombineProducts_SelectCandidates.aspx.vb" EnableViewState="false" Inherits="Dynamicweb.Admin.CombineProducts_SelectCandidates" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title><dw:TranslateLabel runat="server" Text="Variants" /></title>
    <dw:ControlResources runat="server" IncludePrototype="true" IncludeUIStylesheet="true">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="ProductsFamily.js" />
        </Items>
    </dw:ControlResources>

    <script>
        function products_RowDeleting(list, args) {
            var productInfo = args.row.get_properties();
            if (productInfo.DisableDeleteCommand) {
                args.cancel = true;
                ShowImpossibleDeleteMasterProductInfoBox();
                return;
            }
        }
        
        function products_showProductsSelector(list, args) {
            var id = args.row.get_id();
            args.cancel = true;
            if (!id) { // new row
                showProductsSelector(list);
            }
        }

        function initPage(options) {
            var allModes = document.querySelectorAll(".dw-ctrl.radio-group input[name=ModeGroup]");
            var el = document.querySelector(".dw-ctrl.radio-group input[name=ModeGroup]:checked");
            if (!el) {
                el = allModes[0];
            }
            if (options.disableModeSelector) {
                for(var i = 0; i < allModes.length; i++) {
                    allModes[i].setAttribute("disabled", "disabled");
                }
            }
            else if (el) {
                dwGlobal.Dom.triggerEvent(el, "click");
            }
        }
    </script>
</head>
<dwc:DialogLayout runat="server" Title="Variants"  HidePadding="True">
    <Content>
        <div class="col-md-0">
            <dwc:RadioGroup ID="ModeGroup" Name="ModeGroup" Indent="True" runat="server" Label="Mode" SelectedValue="variants" >
                <dwc:RadioButton ID="VariantsMode" Label="Create variants" runat="server" FieldValue="variants" OnClick="javascript:toggleElements(this)"></dwc:RadioButton>
                <dwc:RadioButton ID="FamilyMode" Label="Create family" runat="server" FieldValue="family" OnClick="javascript:toggleElements(this)"></dwc:RadioButton>
            </dwc:RadioGroup>
            <div id="variantGroupWrapper">
                <dw:SelectionBox Label="Variant Groups" ID="VariantGroups" ShowSortRight="true" RightHeader="Selected groups" LeftHeader="All groups" NoDataTextLeft="No groups" NoDataTextRight="No groups" TranslateNoDataText="true" TranslateHeaders="true" runat="server" ClientIDMode="Static"></dw:SelectionBox>
            </div>
                <dwc:GroupBox runat="server" Title="Products">
                <dw:EditableList  ID="SelectedProducts" runat="server" AllowEditing="true" AllowAddNewRow="true" AllowDeleteRow="true" AllowPaging="true" AllowSorting="false" AddNewRowCaption="Click here to add a product" AutoGenerateColumns="false" OnClientDialogOpening="products_showProductsSelector" OnClientRowDeleting="products_RowDeleting">
                    <Pager PageSize="5" />
                </dw:EditableList>
            </dwc:GroupBox>
        </div>
        <input type="hidden" id="json" name="json" value="" />
        <dw:Dialog runat="server" ID="ProductsSelectorDialog" HidePadding="True">
            <iframe id="ProductsSelectorDialogFrame" name="ProductsSelectorDialogFrame" frameborder="0"></iframe>
        </dw:Dialog>
    </Content>
    <Footer>
        <a href="<%= GetNextPageUrl() %>" class="btn btn-link waves-effect" onclick="return nextWizardPage(event);"><dw:TranslateLabel runat="server" Text="Next" /></a>
    </Footer>
</dwc:DialogLayout>
    <script>
        var MODE_VARIANTS = <%=Dynamicweb.Admin.CombineProductsData.CombineProductsMode.Variants%>;
        var MODE_FAMILY = <%=Dynamicweb.Admin.CombineProductsData.CombineProductsMode.Family%>
        function nextWizardPage(e) {
            e.stopPropagation();
            var variantGroups = SelectionBox.getElementsRightAsArray("VariantGroups");
            var mode = getSelectedMode();
            if (mode == MODE_VARIANTS && !variantGroups.length) {
                ShowVariantGroupsIsNotSelectedInfoBox();
                return false;
            }
            var jsonObj = <%=GetDataJson()%>;
            jsonObj.VariantGroupsIds = variantGroups;
            jsonObj.Mode = mode;
            var prods = getSelectedProducts();
            jsonObj.Products = prods;
            var jsonData = toQueryString(jsonObj, false);
            document.getElementById("json").value = jsonData;
            var url = "<%= GetNextPageUrl() %>";
            window.document.forms[0].setAttribute("action", url);
            Action.Execute({'Name':'Submit'})
            return false;
        }

        function showProductsSelector() {
            var disabledProducts = getSelectedProducts().collect(function(prod) {
                return prod.ProductId + "." + prod.VariantId;
            });
            var model = {
                DisabledProducts: disabledProducts.join()
            };
            var action = "<%=ShowProductSelector()%>";
            Action.openWindowWithVerb("POST", action, model, "ProductsSelectorDialogFrame")
            showLoader("ProductsSelectorDialogFrame");
            dialog.setTitle("ProductsSelectorDialog", "<%=Translate.Translate("Add products")%>");
            dialog.show("ProductsSelectorDialog");
        }

        function showLoader(windowName) {
            const wnd = window.frames[windowName];
            if (!wnd.document.getElementById("screenLoaderOverlay")) {
                const cnt = wnd.document.body;
                if (cnt) {
                    const overlayHtml = '<link href="/Admin/Resources/css/dw8stylefix.css" type="text/css" /><div class="overlay-container" id="screenLoaderOverlay"><div class="overlay-panel"><i class="fa fa-refresh fa-3x fa-spin"></i></div></div> ';
                    cnt.insertAdjacentHTML("afterbegin", overlayHtml);
                }
            }
        }

        function addNewProductToList(products) {
            var idx = {};
            products.each(function (p) {
                var autoId = p.autoId;
                var prodId = p.id;
                var variantId = p.variantId;
                var name = p.name;
                var number = p.number;
                var pid = prodId + "." + variantId;
                if (!idx[pid]) {
                    idx[pid] = true;
                    <%=SelectedProducts.ClientInstanceName%>.addRow({
                        AutoId: autoId,
                        ProductId: prodId,
                        VariantId: variantId,
                        Name: name,
                        Number: number
                    });
                }
            });

            dialog.hide('ProductsSelectorDialog');
        }

        function getSelectedProducts(deletedItemFn) {
            deletedItemFn = deletedItemFn || function() {};
            var list = <%=SelectedProducts.ClientInstanceName%>;
            var rows = list.get_dataSource();
            var items = [];
            rows.each(function(row, index) {
                if (row.get_state() == Dynamicweb.Controls.EditableList.Enums.ModelState.DELETED)
                {
                    deletedItemFn(row);
                    return;
                }
                var obj = row.get_properties();
                items.push(obj);
            });
            return items;
        }

        function ShowImpossibleDeleteMasterProductInfoBox() {
            showMessageBox("<%=Translate.JsTranslate("Impossible delete master product")%>", "<%=Translate.JsTranslate("Information")%>");
        }

        function ShowVariantGroupsIsNotSelectedInfoBox() {
            showMessageBox("<%=Translate.JsTranslate("At least one variant group should be selected")%>", "<%=Translate.JsTranslate("Information")%>");
        }

        document.observe("dom:loaded", function() {
            document.body.select(".modal-dialog.dialog-md")[0].className = "modal-dialog dialog-lg";
        });    

        function toggleElements(radioButton){
            var selectedValue = radioButton.value;
            var variantGroupSelector = document.getElementById("variantGroupWrapper");

            if(selectedValue == MODE_FAMILY){
                if(variantGroupSelector != null){
                    variantGroupSelector.style.display = "none";
                }
            }
            else
            {
                if(variantGroupSelector != null){
                    variantGroupSelector.style.display = "block";
                }
            }
        }  
        
        function getSelectedMode()
        {
            var results = document.getElementsByName("ModeGroup");

            if(results != null && results.length >= 1)
            {
                for(var i = 0; i < results.length; i++)
                {       
                    if(results[i].checked == true){
                        return results[i].value;
                    }
                }
            }

            return MODE_VARIANTS;
        }
    </script>
</html>
<%
    Dynamicweb.SystemTools.Translate.GetEditOnlineScript()
%>