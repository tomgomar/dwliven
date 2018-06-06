<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PimExportToExcel.aspx.vb" Inherits="Dynamicweb.Admin.PimExportToExcel" %>

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
    <dwc:ScriptLib runat="server" ID="ScriptLib">
    </dwc:ScriptLib>
    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeScriptaculous="true" IncludeClientSideSupport="true" IncludeUIStylesheet="true" runat="server">
        <Items>
            <dw:GenericResource Url="/Admin/Content/JsLib/dw/Utilities.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/dwglobal.js" />
            <dw:GenericResource Url="/Admin/Resources/js/layout/Actions.js" />
            <dw:GenericResource Url="/Admin/Images/Ribbon/UI/Dialog/Dialog.js" />
            <dw:GenericResource Url="/Admin/Module/eCom_Catalog/dw7/js/ProductListEditingExtended.js" />
        </Items>
    </dw:ControlResources>
    <style type="text/css">
        .form-group .control-label{
            width: 100px !important;
        }
    </style>
</head>
<body class="area-red">
    <form id="form1" runat="server">
        <dw:Infobar runat="server" ID="WarningBar" Visible="false" Type="Warning" />
        <asp:HiddenField ID="viewLanguages" ClientIDMode="Static" runat="server" />
        <asp:HiddenField ID="viewFields" ClientIDMode="Static" runat="server" />
        <input type="hidden" id="Cmd" name="Cmd" />

        <div class="groupbox">            
            <dw:SelectionBox ID="LanguagesList" runat="server" Width="200" Label="Languages" LeftHeader="Excluded languages" RightHeader="Included languages" ShowSortRight="true" Height="250"></dw:SelectionBox>            
            <dw:SelectionBox ID="FieldList" runat="server"  Width="200"  Label="Fields" LeftHeader="Excluded fields" RightHeader="Included fields" ShowSortRight="true" Height="250"></dw:SelectionBox>            
        </div>
    </form>

    <script type="text/javascript">
        function LanguagesList_onChange() {
            var defaultLanguageId = '<%=DefaultLanguageId%>';
            var selectionBoxID = "LanguagesList";
            var lstLeft = document.getElementById(selectionBoxID + "_lstLeft");
            var lstRight = document.getElementById(selectionBoxID + "_lstRight");
            var arrIndex = new Array;

            for (var i = 0; i < lstLeft.length; i++) {
                var option = lstLeft.options[i];
                if (option.value == defaultLanguageId) {
                    SelectionBox.insertOption(option, lstRight);
                    arrIndex.push(i);
                }
            }
            var length = arrIndex.length;
            for (var i = 0; i < length; i++) {
                lstLeft.remove(arrIndex.pop());
            }
            
            SelectionBox.setNoDataRight(selectionBoxID);            
        }
        function exportToExcel() {
            $("viewFields").value = SelectionBox.getElementsRightAsArray("FieldList").join();
            $("viewLanguages").value = SelectionBox.getElementsRightAsArray("LanguagesList").join();
            var theForm = document.forms["form1"];
            theForm.submit();
        }
    </script>
</body>
</html>
