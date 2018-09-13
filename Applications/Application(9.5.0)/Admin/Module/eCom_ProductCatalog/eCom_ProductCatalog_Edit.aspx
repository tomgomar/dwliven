﻿<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="eCom_ProductCatalog_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eCom_ProductCatalog_Edit" %>

<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>

<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server">
    <Items>
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/functions.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/images/AjaxAddInParameters.js" />
        <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ecomParagraph.js" />
    </Items>
</dw:ControlResources>

<script type="text/javascript">
    var basePath = '/dw7';
    var groupTreeBasePath = '/dw7/Edit';

    function serializeProperties(selectionBoxId) {
        $("Selected" + selectionBoxId).value = SelectionBox.getElementsRightAsArray(selectionBoxId);
    }
</script>

<dw:ModuleHeader ID="ModuleHeader1" runat="server" ModuleSystemName="eCom_ProductCatalog"></dw:ModuleHeader>
<dw:ModuleSettings ID="ModuleSettings1" runat="server" ModuleSystemName="eCom_ProductCatalog" Value="RetrieveMyListsBasedOn,PageSize,ProductListTemplate,ProductTemplate,ShortDescLength,CompareTemplate,IndexQuery,FacetGroups,ShowFacetOptionsWithNoResults,QueryConditions,QuerySortByParams,SelectedPriceProperties,SelectedProductProperties,SelectedProductListProperties,SelectedRelatedProductProperties,SelectedVariantCombinationProperties" />

<dw:GroupBox runat="server" Title="Index">
    <table class="formsTable">
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Query" />
            </td>
            <td>
                <asp:Literal runat="server" ID="QuerySelectLiteral"></asp:Literal>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top;">
                <dw:TranslateLabel runat="server" Text="Facet groups" />
                <input type="hidden" id="facets" name="FacetGroups" value="" />
            </td>
            <td id="selectionBoxContainer">
                <dw:SelectionBox runat="server" ID="selectFacets" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <dw:CheckBox runat="server" ID="ShowFacetOptionsWithNoResults" name="ShowFacetOptionsWithNoResults" IsChecked="True" />
                <label for="ShowFacetOptionsWithNoResults">
                    <dw:TranslateLabel runat="server" Text="Show facet options with no results" />
                </label>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Override standard parameters" />
            </td>
            <td>
                <dw:EditableList ID="QueryConditions" runat="server" AllowPaging="true" AllowSorting="true" AutoGenerateColumns="false" EnableLegacyRendering="True" AllowAddNewRow="False" AllowDeleteRow="False"></dw:EditableList>
                <div style="text-align: right">
                    <span onclick="loadDefaultQueryParameters()" class="btn restore">
                        <%=Translate.Translate("Reset")%>
                    </span>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <dw:TranslateLabel runat="server" Text="Sort By" />
            </td>
            <td>
                <dw:EditableList ID="QuerySortByParams" runat="server" AllowPaging="true" AllowSorting="false" AutoGenerateColumns="false" EnableLegacyRendering="True"></dw:EditableList>
                <div style="text-align: right">
                    <span onclick="loadDefaultSortByParams()" class="btn restore">
                        <%=Translate.Translate("Reset")%>
                    </span>
                </div>
            </td>
        </tr>
    </table>
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Visning">
    <dwc:InputNumber runat="server" Label="Varer pr. side" ID="PageSize" Min="0" />
    <dwc:InputNumber runat="server" Label="Teaser tekst" ID="ShortDescLength" Min="0" />
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Templates">
    <dw:FileManager runat="server" ID="ProductListTemplate" Folder="Templates/eCom/ProductCatalog/" FullPath="True"></dw:FileManager>
    <dw:FileManager runat="server" ID="ProductTemplate" Folder="Templates/eCom/ProductCatalog/" FullPath="True"></dw:FileManager>
    <dw:FileManager runat="server" ID="CompareTemplate" Folder="Templates/eCom/ProductCatalog/" FullPath="True"></dw:FileManager>
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Price">
    <dw:SelectionBox ID="PriceProperties" ContentChanged="serializeProperties('PriceProperties')" Label="Properties" NoDataTextRight="Include all" LeftHeader="Excluded properties" RightHeader="Included properties" ShowSearchBox="true" Height="300" runat="server">
    </dw:SelectionBox>
    <input type="hidden" runat="server" id="SelectedPriceProperties" value="" />
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Product">
    <dw:SelectionBox ID="ProductProperties" ContentChanged="serializeProperties('ProductProperties')" Label="Properties" NoDataTextRight="Include all" LeftHeader="Excluded properties" RightHeader="Included properties" ShowSearchBox="true" Height="300" runat="server">
    </dw:SelectionBox>
    <input type="hidden" runat="server" id="SelectedProductProperties" value="" />
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Products list">
    <dw:SelectionBox ID="ProductListProperties" ContentChanged="serializeProperties('ProductListProperties')" Label="Properties" NoDataTextRight="Include all" LeftHeader="Excluded properties" RightHeader="Included properties" ShowSearchBox="true" Height="300" runat="server">
    </dw:SelectionBox>
    <input type="hidden" runat="server" id="SelectedProductListProperties" value="" />
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Related products">
    <dw:SelectionBox ID="RelatedProductProperties" ContentChanged="serializeProperties('RelatedProductProperties')" Label="Properties" NoDataTextRight="Include all" LeftHeader="Excluded properties" RightHeader="Included properties" ShowSearchBox="true" Height="300" runat="server">
    </dw:SelectionBox>
    <input type="hidden" runat="server" id="SelectedRelatedProductProperties" value="" />
</dw:GroupBox>

<dw:GroupBox runat="server" Title="Variant combinations">
    <dw:SelectionBox ID="VariantCombinationProperties" ContentChanged="serializeProperties('VariantCombinationProperties')" Label="Properties" NoDataTextRight="Include all" LeftHeader="Excluded properties" RightHeader="Included properties" ShowSearchBox="true" Height="300" runat="server">
    </dw:SelectionBox>
    <input type="hidden" runat="server" id="SelectedVariantCombinationProperties" value="" />
</dw:GroupBox>

<dw:GroupBox ID="gbSettings" runat="server" Title="Additional settings">
    <dwc:RadioGroup runat="server" ID="RetrieveMyListsBasedOn">
        <dwc:RadioButton runat="server" FieldValue="UseUserID" Label="User id" />
        <dwc:RadioButton runat="server" FieldValue="UseCustomerNumber" Label="Customer number" />
    </dwc:RadioGroup>
</dw:GroupBox>

<script type="text/javascript">
    function indexQueryChanged() {
        var querySelector = document.getElementById("IndexQuery");
        var query = querySelector[querySelector.selectedIndex];
        if (!query.value) {
            hideQueryParameters();
        }

        loadQueryInfo("GetQueryInfo", query.value, function (responseText) {
            document.getElementById("selectionBoxContainer").innerHTML = responseText;
            SelectionBox.setNoDataLeft("selectFacets");
            SelectionBox.setNoDataRight("selectFacets");
            serializeFacets();
            var info = JSON.parse($("query-info").innerHTML);
            fillQueryInfo(info, {
                fetchParameters: true,
                fetchSortBy: true
            });
            toggleQueryParameters(!!query.value);
        });
    }

    function serializeFacets() {
        var facets = SelectionBox.getElementsRightAsArray("selectFacets");
        var values = "";

        for (var i = 0; i < facets.length; i++) {
            if (i > 0)
                values += ",";
            values += facets[i];
        }

        document.getElementById("facets").value = values;
    }

    backend.setBeforeSave();
    serializeFacets();
    SelectionBox.setNoDataLeft("selectFacets");
    SelectionBox.setNoDataRight("selectFacets");
    toggleQueryParameters($("IndexQuery").value);
</script>
