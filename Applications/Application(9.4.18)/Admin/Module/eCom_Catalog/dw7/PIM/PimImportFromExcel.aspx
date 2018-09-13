<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PimImportFromExcel.aspx.vb" Inherits="Dynamicweb.Admin.PimImportFromExcel" %>

<%@ Import Namespace="Dynamicweb.Core.UI.Icons" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>
<%@ Import Namespace="Dynamicweb.Core.Helpers" %>
<%@ Import Namespace="Dynamicweb.Core" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Assembly="Dynamicweb.UI.Controls" Namespace="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" Namespace="Dynamicweb.Admin.eComBackend" Assembly="Dynamicweb.Admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludejQuery="true" IncludeScriptaculous="true" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/css/ProductListEditingExtended.css" />
        </Items>
    </dw:ControlResources>    
    <script type="text/javascript">
        var controlRows = [];
    </script>
</head>
<body>
    <div class="card">
        <form id="form1" runat="server">
            <asp:HiddenField ID="Cmd" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="HdSelectedFile" ClientIDMode="Static" runat="server" />
            <asp:HiddenField ID="ImportLanguages" ClientIDMode="Static" runat="server" />

            <dw:Infobar runat="server" ID="WarningBar" Visible="false" Type="Error" TranslateMessage="false" />

            <div id="gbSelectFile" runat="server" class="groupbox">
                <fieldset>
                    <div class="form-group">
                        <label class="control-label">
                            <dw:Label runat="server" Title="Select file" />
                        </label>

                        <%=Gui.FileManager(SelectedFile, "Files", "UploadFile", "UploadFile", "xlsx", True, "importFromExcel()", False, True)%>
                    </div>
                </fieldset>
            </div>

            <dwc:GroupBox runat="server" ID="gbImportFields" Visible="false">
                <dw:Infobar runat="server" ID="LanguageSelectionWarningBar" Visible="false" Type="Warning" TranslateMessage="false" Message="Select at least one language to import" />

                <div class="form-group">
                    <label class="control-label">
                        <dw:Label runat="server" Title="File" />
                    </label>
                    <div class="form-group-input">
                        <dw:Label runat="server" ID="CurrentFile" doTranslation="false" />
                    </div>
                </div>
                <dw:SelectionBox ID="LanguagesList" runat="server" Width="200" Label="Languages" LeftHeader="Excluded languages" RightHeader="Included languages" ShowSortRight="true" Height="250"></dw:SelectionBox>
                <div class="form-group">
                    <label class="control-label">
                        <dw:Label runat="server" Title="Data validation" />
                    </label>
                    <div class="form-group-input">
                        <dw:List runat="server" ID="FieldsList" ShowTitle="false">
                        </dw:List>
                    </div>
                </div>
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="gbFailedVariants" DoTranslation="true" Title="Simple variants that need to be extended for import data to" Visible="false">
                <dw:List ID="SimpleVariantsList" runat="server" ShowTitle="false">
                    <Columns>                        
                        <dw:ListColumn ID="VariantName" Name="Variant name" runat="server" WidthPercent="40" />
                        <dw:ListColumn ID="VariantLanguages" Name="Languages" runat="server" WidthPercent="60" />
                    </Columns>
                </dw:List>
                <dwc:CheckBox ID="AutoCreateExtendedVariants" runat="server" Label="Create extended variants for the listed simple variants" />
            </dwc:GroupBox>
            <dwc:GroupBox runat="server" ID="gbImportStatus" DoTranslation="true" Title="Import status" Visible="false">
                <dw:Infobar ID="infoStatus" runat="server" />
            </dwc:GroupBox>
        </form>
    </div>
    <script type="text/javascript">
        function importFromExcel() {
            if ($("Cmd").value != 'importAfterVariantsDialog') {
                $("ImportLanguages").value = SelectionBox.getElementsRightAsArray("LanguagesList").join();
            }
            var theForm = document.forms["form1"];
            theForm.submit();
        }
    </script>
</body>
</html>
