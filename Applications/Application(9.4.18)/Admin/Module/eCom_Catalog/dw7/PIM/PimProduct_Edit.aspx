<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PimProduct_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.PimProductEdit" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Import Namespace="Dynamicweb.Management.Actions" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeRequireJS="True" IncludeClientSideSupport="true" IncludeUIStylesheet="true" IncludeUtilities="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Resources/vendors/url-search-params/url-search-params.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />

            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/Main.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/ProductListEditingExtended.css" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/productMenu.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/pickadaySetup.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/pickadayBundle.js" />
            <dw:GenericResource Url="/Admin/Filemanager/Browser/FileList.js" />
        </Items>
    </dw:ControlResources>
    <script type="text/javascript">
        function help() {
		    <%=Gui.Help("", "ecom.pimproductedit", "en") %>
        }

        var controlRows = [];
        var currentlyFocused = "";
    </script>
</head>
<body class="area-red">
    <div class="screen-container">
        <div class="card">
            <ecom:Form ID="Form1" runat="server">
                <div class="pcm-content">
                    <dw:Overlay ID="__ribbonOverlay" runat="server"></dw:Overlay>
                    <script type="text/javascript">
                        new overlay('__ribbonOverlay').show();
                    </script>

                    <dw:RibbonBar ID="PCMRibbon" runat="server">
                        <dw:RibbonBarTab ID="TabProducts" Name="Product" runat="server">
                            <dw:RibbonBarGroup Name="Tools" runat="server">
                                <dw:RibbonBarButton ID="btnSaveProduct" Text="Save" Icon="Save" Size="Small" runat="server" ShowWait="true" OnClientClick="Dynamicweb.PIM.BulkEdit.get_current().save();" />
                                <dw:RibbonBarButton ID="btnSaveAndCloseProduct" Text="Save and close" Icon="Save" Size="Small" runat="server" ShowWait="true" OnClientClick="Dynamicweb.PIM.BulkEdit.get_current().save(true);" />
                                <dw:RibbonBarButton ID="BtnCancel" Text="Cancel" Icon="TimesCircle" IconColor="Default" Size="Small" runat="server" ShowWait="true" OnClientClick="Dynamicweb.PIM.BulkEdit.get_current().cancel();" />
                            </dw:RibbonBarGroup>

                            <dw:RibbonBarGroup Name="Options" runat="server">
                                <dw:RibbonBarButton ID="btnAttachRelatedProducts" Text="Related products" Icon="GroupWork" Size="Small" runat="server" OnClientClick="openRelatedProducts();" />
                                <dw:RibbonBarButton ID="btnAttachMultipleProducts" Text="Add to group" Icon="Folder" Size="Small" runat="server" ClientIDMode="Static" />
                                <dw:RibbonBarButton ID="btnPublishMultipleProducts" Text="Publish to Ecom" Icon="ShoppingCart" Size="Small" runat="server" ClientIDMode="Static" />
                                <dw:RibbonBarButton ID="btnVariants" Text="Variants" Icon="HDRWeak" Size="Small" runat="server" OnClientClick="openVariants();" />
                                <dw:RibbonBarButton ID="btnAddProperty" Text="Add property" Icon="Crop7_5" Size="Small" runat="server" OnClientClick="Dynamicweb.PIM.BulkEdit.get_current().openCategoryFieldsDialog();" />
                                <dw:RibbonBarButton ID="ShowProductsFamilyToolButton" Text="Combine products as family" Size="Small" runat="server" Icon="Bank" IconColor="Modules" />
                            </dw:RibbonBarGroup>

                            <dw:RibbonBarGroup ID="ProductNavigationTab" Name="Navigate products" runat="server">
                                <dw:RibbonBarButton runat="server" ID="PreviousProduct" Text="Previous" Icon="ArrowLeft" Size="large" />
                                <dw:RibbonBarButton runat="server" ID="NextProduct" Text="Next" Icon="ArrowRight" Size="large" />
                            </dw:RibbonBarGroup>

                            <dw:RibbonBarGroup Name="Edit" runat="server">
                                <dw:RibbonBarButton runat="server" ID="VisibleFields" Text="Visible fields" Size="Small" Icon="Web" OnClientClick="Dynamicweb.PIM.BulkEdit.get_current().openVisibleFields('FieldsDialog');" />
                                <dw:RibbonBarButton runat="server" ID="BulkEdit" Text="Bulk edit" Size="Small" Icon="Copy" ShowWait="true" />
                                <dw:RibbonBarButton ID="btnExportToExcel" Text="Export to Excel" Icon="SignOut" Size="Small" runat="server" OnClientClick="openExportToExcel();" />
                            </dw:RibbonBarGroup>

                            <dw:RibbonBarGroup Name="View language" runat="server" ID="LanguageRibbonGroup" Columns="5">
                            </dw:RibbonBarGroup>

                            <dw:RibbonBarGroup Name="Help" runat="server">
                                <dw:RibbonBarButton runat="server" ID="Help" Text="Help" Size="Large" Icon="Help" OnClientClick="help();" />
                            </dw:RibbonBarGroup>
                        </dw:RibbonBarTab>

                        <dw:RibbonBarTab ID="WorkflowTab" Active="false" Name="Workflow" runat="server">
                            <dw:RibbonBarGroup ID="WorkflowGroup" runat="server" Name="Workflow" Visible="True">
                                <dw:RibbonBarCheckbox ID="cmdUseDraft" runat="server" Checked="false" Text="Use draft" Icon="FileTextO" OnClientClick="Dynamicweb.PIM.BulkEdit.get_current().useDraft();"></dw:RibbonBarCheckbox>
                                <dw:RibbonBarButton ID="cmdPublish" runat="server" Size="Small" Text="Approve" Icon="CheckBox" OnClientClick="Dynamicweb.PIM.BulkEdit.get_current().publishChanges();"></dw:RibbonBarButton>
                                <dw:RibbonBarButton ID="cmdDiscardChanges" runat="server" Size="Small" Text="Discard changes" Icon="ExitToApp" OnClientClick="Dynamicweb.PIM.BulkEdit.get_current().discardChanges();"></dw:RibbonBarButton>
                            </dw:RibbonBarGroup>
                            <dw:RibbonBarGroup ID="VersionsGroup" runat="server" Name="Versions" Visible="True">
                                <dw:RibbonBarButton ID="cmdVersions" runat="server" ModuleSystemName="VersionControl" Size="Small" Icon="File" Text="Versions" Visible="true" ></dw:RibbonBarButton>
                            </dw:RibbonBarGroup>
                        </dw:RibbonBarTab>
                    </dw:RibbonBar>

                    <div class="breadcrumb">
                        <asp:Literal ID="Breadcrumb" runat="server"/>
                    </div>

                    <dw:Infobar ID="indexNotBuildWarning" runat="server" Message="" Visible="false"></dw:Infobar>
                    <div id="pim-hidden-fields" style="display:none;">
                        <asp:HiddenField ID="productIds" runat="server" Value="" />
                        <asp:HiddenField ID="deletedProductIds" runat="server" Value="" />
                        <asp:HiddenField ID="viewLanguages" ClientIDMode="Static" runat="server" />
                        <asp:HiddenField ID="viewFields" ClientIDMode="Static" runat="server" />

                        <asp:HiddenField ID="GroupsToAdd" ClientIDMode="Static" runat="server" />
                        <asp:HiddenField ID="GroupsToDelete" ClientIDMode="Static" runat="server" />
                        <asp:HiddenField ID="ProductsToAdd" ClientIDMode="Static" runat="server" />
                        <asp:HiddenField ID="PrimaryRelatedGroup" ClientIDMode="Static" runat="server" />

                        <input type="hidden" id="Cmd" name="Cmd" />
                        <input type="hidden" id="GroupsAdded" name="GroupsAdded" value="0" />
                        <input type="hidden" id="ecomShopUpdated" name="ecomShopUpdated" value="false" />

                        <input type="hidden" id="categoryFields" name="categoryFields" />
                    </div>
                    <div id="ProductsContainer" runat="server" class="pcm-wrap" style="height: 100%">
                        <div class="pcm-list-item pcm-wrap-header">
                            <div class="pcm-list-item-body">
                                <div class="pcm-list-left">
                                     <%If cmdUseDraft.Checked Then%>
                                            <div class="pcm-list-fields-header-info pcm-list-item-header-title">
                                            [DRAFT]
                                            </div>
                                     <%End If%>
                                </div>
                                <div class="pcm-list-fields pcm-list-fields--head flag-header">
                                    <table class="pcm-list-fields-table">
                                        <thead>
                                            <tr>
                                                <td></td>
                                                <asp:Repeater ID="LanguagesRepeater" runat="server" EnableViewState="false">
                                                    <ItemTemplate>
                                                        <td>
                                                            <div class="pcm-list-flag">
                                                                <i class="<%#GetFlagIcon(Container.DataItem) %>" title="<%# CType(Container.DataItem, Dynamicweb.Ecommerce.International.Language).Name %>"></i>
                                                                <i class="preview-icon <%=KnownIconInfo.ClassNameFor(KnownIcon.Pageview)%>" onclick="<%#GetPreviewLink(Container.DataItem) %>" title="<%= Translate.Translate("Preview") %>"></i>
                                                            </div>
                                                        </td>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div id="listContainer" class="pcm-list">
                            <div class="pcm-list-item">
                                <div class="pcm-list-item-body">
                                    <div class="pcm-list-state" id="state1"></div>
                                    <div class="pcm-list-left">
                                        <div class="updated-header-fill"></div>
                                        <div class="pcm-list-item-header">
                                            <div class="pcm-list-item-header-info pull-right">
                                            </div>
                                            <div class="pcm-thumb" onclick="Dynamicweb.PIM.BulkEdit.get_current().editProductImages('<%=Product.Id + "_" + Product.VariantId%>');event.stopPropagation();">
                                                <%=GetProductImage() %>
                                            </div>
                                            <div class="pcm-list-left-info pull-left">
                                                #<%=Product.Id%>
                                            </div>
                                            <div class="pcm-list-left-info pull-left">
                                                <%=GetProductCreated() %>
                                            </div>
                                        </div>
                                        <div class="pcm-list-left-info align-center">
                                            <%=GetProductVariansIcon() %>
                                        </div>
                                        <div class="pcm-list-left-info align-center">
                                            <%=GetProductVariantsCount() %>
                                        </div>

                                    </div>
                                    <div style="width: 100%;">
                                        <div class="pcm-list-fields-header-info">
                                            <table class="pcm-list-fields-table">
                                                <thead>
                                                    <tr>
                                                        <td>
                                                            <div class="pcm-list-item-header-title" title="<%=Product.Name%>">
                                                                <%=Product.Name%>
                                                            </div>
                                                        </td>
                                                        <asp:Repeater ID="ProductUpdatedInfo" runat="server" EnableViewState="false">
                                                            <ItemTemplate>
                                                                <td>
                                                                    <div class="product-updated-info">
                                                                        <%#Container.DataItem%>
                                                                    </div>
                                                                </td>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
                                        <div class="pcm-list-fields">
                                            <%=GetProductFieldsOutput() %>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div runat="server" id="VariantContainer" class="pcm-list-item variant">
                                <div class="pcm-list-item-body">
                                    <div class="pcm-list-state" id="state1"></div>
                                    <div class="pcm-list-left">
                                        <div class="pcm-list-left-variants">
                                            <%=GetProductVariantsTree() %>
                                        </div>
                                    </div>
                                    <div style="width: 100%;">
                                        <asp:Repeater runat="server" EnableViewState="false" ID="VariantsRepeater">
                                            <ItemTemplate>
                                                <asp:Panel runat="server" ID="VariantItemContainer" CssClass="variant-item-container" ClientIDMode="Static">
                                                    <div class="pcm-list-fields-header-info">
                                                        <table class="pcm-list-fields-table">
                                                            <thead>
                                                                <tr>
                                                                    <td>
                                                                        <div class="pcm-list-item-header-title" runat="server" id="VariantCombinationWrapper">
                                                                            <asp:Label runat="server" ID="VariantCombinationLabel" />
                                                                        </div>
                                                                    </td>
                                                                    <asp:Repeater ID="ProductVariantUpdatedInfo" runat="server" EnableViewState="false">
                                                                        <ItemTemplate>
                                                                            <td>
                                                                                <div class="pcm-list-flag">
                                                                                    <div class="product-updated-info">
                                                                                        <%#Container.DataItem%>
                                                                                    </div>
                                                                                </div>
                                                                            </td>
                                                                        </ItemTemplate>
                                                                    </asp:Repeater>
                                                                </tr>
                                                            </thead>
                                                        </table>
                                                    </div>

                                                    <div class="pcm-list-variant-fields pcm-list-fields" runat="server" id="ExtendedVariantOutput"></div>

                                                    <div class="pcm-simple-variant-info pcm-list-fields" runat="server" id="SimpleVariantOutput">
                                                        <div class="p-b-25">
                                                            <dw:TranslateLabel Text="This is a simple variant group and does not contain extended information" runat="server" />
                                                        </div>
                                                        <asp:Repeater ID="VariantGroupRepeater" runat="server" EnableViewState="false">
                                                            <ItemTemplate>
                                                                <table class="pcm-list-fields-table formsTable">
                                                                    <tbody>
                                                                        <tr class="pcm-list-table-row">
                                                                            <td>
                                                                                <%# Eval("Name")%>
                                                                            </td>
                                                                            <td>
                                                                                <%# Eval("Text")%>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                        <table class="pcm-list-fields-table formsTable" id="ButtonContainer" >
                                                            <tbody>
                                                                <tr class="pcm-list-table-row">
                                                                    <td></td>
                                                                    <td>
                                                                        <div class="btn btn-flat" runat="server" id="extendVariantButton">
                                                                            <dw:TranslateLabel runat="server" Text="Make this variant Extended" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </asp:Panel>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                            <div class="pcm-list-item pcm-list-fill">
                                <div class="pcm-list-item-body">
                                    <div class="pcm-list-left">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
                </div>

                <dw:Dialog runat="server" Title="Related Ecom groups" ID="RelatedEcomGroupsDialog" Size="Medium" ShowOkButton="True" OkAction="Dynamicweb.PIM.BulkEdit.get_current().closeRelatedGroupsDialog(false);">
                    <%=GetRelatedEcomGroups() %>
                </dw:Dialog>

                <dw:Dialog runat="server" Title="Related PIM warehouse groups" ID="RelatedPimGroupsDialog" Size="Medium" ShowOkButton="True" OkAction="Dynamicweb.PIM.BulkEdit.get_current().closeRelatedGroupsDialog(true);">
                    <%=GetRelatedPimGroups() %>
                </dw:Dialog>

            </ecom:Form>
            <dw:Overlay ID="ProductsLayout" Message="Please wait" runat="server"></dw:Overlay>
            
            <dw:Dialog ID="ProductCategoryFieldsDialog" Title="Hidden fields" ShowOkButton="true" Size="Medium" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PIM.BulkEdit.get_current().changeCategoryFields();" runat="server">
                <dwc:GroupBox runat="server" DoTranslation="true" Title="Product category fields">
                    <dw:Infobar runat="server" TranslateMessage="true" Message="If you move fields from 'Included' to 'Hidden', content will be lost" Type="Warning"></dw:Infobar>
                    <dw:SelectionBox ID="CategoryFieldsList" runat="server" LeftHeader="Hidden fields" RightHeader="Included fields" ShowSortRight="true" ShowSearchBox="true" Height="300"></dw:SelectionBox>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="ProductImagesPicker" Title="Select images" ShowOkButton="true" Size="Medium" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PIM.BulkEdit.get_current().changeImages();" runat="server">
                <dwc:GroupBox runat="server" DoTranslation="true" Title="Product images">
                    <dw:FileManager runat="server" ID="ProductImageSmall" AllowBrowse="true" Extensions="jpg,gif,png,swf,pdf" FullPath="true" ShowPreview="true" />
                    <dw:FileManager runat="server" ID="ProductImageMedium" AllowBrowse="true" Extensions="jpg,gif,png,swf,pdf" FullPath="true" ShowPreview="true" />
                    <dw:FileManager runat="server" ID="ProductImageLarge" AllowBrowse="true" Extensions="jpg,gif,png,swf,pdf" FullPath="true" ShowPreview="true" />
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog ID="FieldsDialog" Title="Fields" ShowOkButton="true" Size="Medium" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PIM.BulkEdit.get_current().changeFields();" runat="server">
                <dwc:GroupBox runat="server" DoTranslation="true" Title="Select Fields">
                    <dw:SelectionBox ID="ViewFieldList" runat="server" LeftHeader="Excluded fields" RightHeader="Included fields" ShowSortRight="true" ShowSearchBox="true" Height="300"></dw:SelectionBox>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="AddGroupsDialog" Size="Medium" HidePadding="True">
                <iframe id="AddGroupsDialogFrame"></iframe>
            </dw:Dialog>

            <dw:Dialog ID="EditorDialog" ShowOkButton="true" Size="large" HidePadding="true" ShowCancelButton="true" ShowClose="true" OkAction="Dynamicweb.PIM.BulkEdit.get_current().closeEditorDialog();" runat="server">
                <dwc:GroupBox runat="server" ClassName="row">
                    <div class="pcm-editor-container">
                        <asp:Repeater ID="EditorDialogRepeater" runat="server" EnableViewState="false">
                            <ItemTemplate>
                                <div class="pcm-editor">
                                    <div class="pcm-editor-flag"><i class="<%#GetFlagIcon(Container.DataItem) %>" title="<%# CType(Container.DataItem, Dynamicweb.Ecommerce.International.Language).Name %>"></i></div>
                                    <div class="pcm-editor-content"><%#GetEditorContent(CType(Container.DataItem, Dynamicweb.Ecommerce.International.Language)) %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </dwc:GroupBox>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="VariantsDialog" Size="Large" HidePadding="True" Title="Variants" OkText="Save" ShowOkButton="true" ShowCancelButton="true" OkAction="saveVariants();">
                <iframe id="VariantsDialogFrame"></iframe>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="RelatedProductsDialog" Size="Large" HidePadding="True" Title="Related products" OkText="Close" ShowOkButton="true" OkAction="closeRelatedProducts();">
                <iframe id="RelatedProductsDialogFrame"></iframe>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ExportToExcelDialog" Size="Medium" HidePadding="True" Title="Export to Excel" OkText="Export" ShowCancelButton="true" ShowOkButton="true" CancelAction="closeExportToExcel();" OkAction="exportToExcel();">
                <iframe id="ExportToExcelDialogFrame"></iframe>
            </dw:Dialog>
                        
            <dw:Dialog ID="QuitDraftDialog" runat="server" Title="Quit draft" ShowOkButton="true" ShowCancelButton="true" ShowClose="true" CancelAction="Dynamicweb.PIM.BulkEdit.get_current().quitDraftCancel();" OkAction="Dynamicweb.PIM.BulkEdit.get_current().quitDraftOk();">
                <dw:Infobar runat="server" Type="Warning" Message="This product has unpublished changes." ></dw:Infobar>
                <dwc:GroupBox runat="server" Title="Choose action">
                    <dwc:RadioButton ID="QuitDraftPublish" Name="QuitDraft" runat="server" FieldName="QuitDraft" Label="Publish" FieldValue="Publish" SelectedFieldValue="Publish" />
                    <dwc:RadioButton ID="QuitDraftDiscard" Name="QuitDraft" runat="server" FieldName="QuitDraft" Label="Discard changes" FieldValue="Discard" />
                </dwc:GroupBox>
            </dw:Dialog>
            
            <dw:Dialog runat="server" ID="ProductVersionsCompareDialog" Size="Large" Title="Compare versions" HidePadding="True">
                <iframe id="ProductVersionsCompareDialogFrame"></iframe>
            </dw:Dialog>

            <dw:Dialog runat="server" ID="ProductVersionsDialog" Size="Medium" HidePadding="True" Title="Versions" ShowCancelButton="false" ShowOkButton="false" >
                <iframe id="ProductVersionsDialogFrame"></iframe>
            </dw:Dialog>

        </div>
    </div>

    <script type="text/javascript">

        function openRelatedProducts() {
            dialog.show('RelatedProductsDialog', "PimRelatedProducts.aspx?ID=<%=ProductIdEncoded%>&VariantID=<%=Product.VariantId%>&GroupId=<%=GroupId%>&QueryId=<%=QueryId%>");
        }

        function closeRelatedProducts() {
            dialog.hide('RelatedProductsDialog');
            dialog.set_contentUrl("RelatedProductsDialog", "");
        }

        function openVariants() {
            dialog.show('VariantsDialog', "PimProductVariants.aspx?ID=<%=ProductIdEncoded%>&VariantID=<%=Product.VariantId%>");
        }

        function saveVariants() {
            var metadataDialogFrame = document.getElementById('VariantsDialogFrame');
            var iFrameDoc = (metadataDialogFrame.contentWindow || metadataDialogFrame.contentDocument);
            
            new iFrameDoc.overlay('ProductEditOverlay').show();
            iFrameDoc.saveVariants();
        }

        function openExportToExcel() {
            dialog.show('ExportToExcelDialog', "PimExportToExcel.aspx?ID=<%=ProductIdEncoded%>&VariantID=<%=Product.VariantId%>&GroupId=<%=GroupId%>&QueryId=<%=QueryId%>");
        }
        function closeExportToExcel() {
            dialog.hide('ExportToExcelDialog');
            dialog.set_contentUrl("ExportToExcelDialog", "");
        }
        function exportToExcel() {
            var metadataDialogFrame = document.getElementById('ExportToExcelDialogFrame');
            var iFrameDoc = (metadataDialogFrame.contentWindow || metadataDialogFrame.contentDocument);
            iFrameDoc.exportToExcel();
        }        

        new overlay('__ribbonOverlay').hide();

        Dynamicweb.PIM.BulkEdit.get_current()._fieldDefinitions = <%=PimMaster.GetFieldDefinitions(Fields) %>
        Dynamicweb.PIM.BulkEdit.get_current().initialize({
            viewMode:'ProductEdit',
            approvalState: <%=Product.ApprovalState%>,
            urls: {
                taskRunner: "/Admin/Module/eCom_Catalog/dw7/PIM/Task.aspx"
            }
        });

        Dynamicweb.PIM.BulkEdit.get_current().terminology["ChangeRelatedGroup"] = "<%=Translate.Translate("Do you want to save group changes on product?")%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["NavigateToVariant"] = "<%=Translate.Translate("Not saved changes will be lost, navigate to %% product?").Replace("%%", Translate.Translate("variant"))%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["NavigateToNext"] = "<%=Translate.Translate("Not saved changes will be lost, navigate to %% product?").Replace("%%", Translate.Translate("next"))%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["NavigateToPrevious"] = "<%=Translate.Translate("Not saved changes will be lost, navigate to %% product?").Replace("%%", Translate.Translate("previous"))%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["NavigateToRelated"] = "<%=Translate.Translate("Not saved changes will be lost, navigate to %% product?").Replace("%%", Translate.Translate("related"))%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["AddToGroup"] = "<%=Translate.Translate("Add product(s) to group.")%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["PublishToEcom"] = "<%=Translate.Translate("Publish product(s) to Ecom.")%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["ConfirmDiscard"] = "<%=Dynamicweb.SystemTools.Translate.JsTranslate("Discard changes")%>?";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["ToggleDraftCommand"] = "<%=VersionControlActionTypes.ToggleDraft.ToString()%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["DiscardChangesCommand"] = "<%=VersionControlActionTypes.DiscardChanges.ToString()%>";
        Dynamicweb.PIM.BulkEdit.get_current().terminology["PublishDraftCommand"] = "<%=VersionControlActionTypes.PublishDraft.ToString()%>";
        
        Dynamicweb.PIM.BulkEdit.get_current().confirmAction = <%=New ConfirmMessageAction(Translate.Translate("Confirm Action"), "").ToJson()%>;
        
        Dynamicweb.PIM.BulkEdit.get_current().openScreenAction = <%=New OpenScreenAction("", "").ToJson()%>;

        var currentRelatedGroupsKind = 0;
        //btnAttachMultipleProducts.removeClassName("disabled");
        btnAttachMultipleProducts.on("click", function () {
            currentRelatedGroupsKind = 1;
            dialog.show('RelatedPimGroupsDialog');
        });  
        
        <%If Dynamicweb.Context.Current.Request("GroupsAdded") = "1" Then%>
        dialog.show('RelatedPimGroupsDialog');
        currentRelatedGroupsKind = 1;
        <%End If%>

        //btnPublishMultipleProducts.removeClassName("disabled");
        btnPublishMultipleProducts.on("click", function () {
            currentRelatedGroupsKind = -1;
            dialog.show('RelatedEcomGroupsDialog');;
        }); 

        <%If Dynamicweb.Context.Current.Request("GroupsAdded") = "-1" Then%>
        dialog.show('RelatedEcomGroupsDialog');
        currentRelatedGroupsKind = -1
        <%End If%>

        document.onkeydown = checkKey;
        
        //upper case due callback from product selector
        function AddGroupRows(id) {
            var theForm = document.forms["Form1"];
            dialog.hide("AddGroupsDialog");
            dialog.set_contentUrl("AddGroupsDialog", "");
            
            $("GroupsAdded").value = currentRelatedGroupsKind;
            ecomShopUpdated
            var products = "<%=ProductIdEncoded%>";
            var groups = theForm.GroupsToAdd.value;
            if (products && groups) {
                theForm.ProductsToAdd.value = products;
                theForm.ecomShopUpdated.value = currentRelatedGroupsKind == -1;
                Dynamicweb.PIM.BulkEdit.get_current().submitFormWithCommand("AddGroups");
            }
        }

        function removeFromField(){

        }

        function CheckDeleteDWRow(rowID, rowCount, layerName, ProductId, prefix, arg1, arg2, message) {
            var delGroupsHidden = $("GroupsToDelete");
            delGroupsHidden.value = delGroupsHidden.value + (delGroupsHidden.value ? "," : "") + rowID;
            var rowIndex = document.getElementById("DWRowLineTR"+prefix+rowCount).rowIndex;
            var table = null;
            if (currentRelatedGroupsKind == 1){
                table = $("RelatedPimGroupsDialog").select("#DWRowLineTable" + prefix)[0];                
            } else if(currentRelatedGroupsKind == -1){
                table = $("RelatedEcomGroupsDialog").select("#DWRowLineTable" + prefix)[0]; 
            }
            if (table) {
                table.deleteRow(rowIndex);
            }
            //var totalGroups = parseInt(document.getElementById("DWRowNextLine"+ prefix).value);
            //if (parseInt(totalGroups) <= 2) {
            //    alert("<%=Dynamicweb.SystemTools.Translate.JsTranslate("Kan ikke slette sidste gruppe!")%>")
            //} else {
            //    DeleteDWRow(rowID,rowCount,layerName,ProductId,prefix,arg1,arg2, message);
            //}
        }

        //upper case due callback from product selector
        function CheckPrimaryDWRow(chk, groupId) {
            var iconEl = chk.select(".state-icon")[0];
            var onCss = iconEl.getAttribute("data-state-on");
            var offCss = iconEl.getAttribute("data-state-off");
            if (!iconEl.hasClassName(onCss)) {
                var inputs = $$("table .state-icon");
                inputs.each(function (item) {
                    item.removeClassName(onCss);
                    item.addClassName(offCss);
                });
                $('PrimaryRelatedGroup').value = groupId;
            }
            else {
                $('PrimaryRelatedGroup').value = "";
            }
            iconEl.toggleClassName(onCss);
            iconEl.toggleClassName(offCss);
        }

        //upper case due callback from product selector
        function addRelatedGroup(event, pimGroupsOnly) {
            var url = "/Admin/Module/Ecom_Catalog/dw7/edit/EcomGroupTree.aspx?CMD=ShowGroupRel&MasterProdID=<%=ProductIdEncoded%>&caller=parent.document.getElementById('Form1').GroupsToAdd";
            url += (pimGroupsOnly ? '&shopsToShow=ProductWarehouseOnly' : '&shopsToShow=ShopOnly');
            
            dialog.setTitle('AddGroupsDialog', '<%=Translate.Translate("Add group relation")%>');
            dialog.show('AddGroupsDialog', url);
        }  
        
        var controlRowsMapped = controlRows.map(function (row) {
            return row.map(function(column) {
                return column.controlId;
            });
        });

        var openScreenAction = <%=New Dynamicweb.Management.Actions.OpenScreenAction("", "Ecommerce").ToJson()%>;

        //controls keyboard navigate handler
        function checkKey(e) {
            e = e || window.event;
            if (document.activeElement && document.activeElement.id) {
                currentlyFocused = document.activeElement.id;
            }
            if (currentlyFocused) {
                if (e.keyCode == '38' || e.keyCode == '40') {
                    // up arrow
                    var index = [-1, -1];

                    controlRowsMapped.some(function (sub, posX) {
                        var posY = sub.indexOf(currentlyFocused);

                        if (posY !== -1) {
                            index[0] = posX;
                            index[1] = posY;
                            return true;
                        }

                        return false;
                    });

                    if (index[0] != -1 && index[1] != -1) {
                        var nextControlIndex = index[0];
                        if (e.keyCode == '40' && index[0] != controlRowsMapped.length - 1) {
                            nextControlIndex = index[0] + 1;
                        } else if (e.keyCode == '38' && index[0] != 0) {
                            nextControlIndex = index[0] - 1;
                        }
                        var nextFocusedControlId = controlRowsMapped[nextControlIndex][index[1]];
                        var nextFocusedControl = $(nextFocusedControlId);
                        if (nextFocusedControl) {
                            currentlyFocused = nextFocusedControlId;
                            if ($$("span.focused")[0]) {
                                $$("span.focused")[0].removeClassName("focused");
                            } else {
                                document.activeElement.blur();
                            }
                            if (nextFocusedControl.tagName == "SPAN") {
                                nextFocusedControl.addClassName("focused");
                            } else {
                                nextFocusedControl.focus();
                            }
                            e.stopPropagation();
                            e.preventDefault();
                        }
                    }
                }
            }
        }
    </script>
</body>
</html>
