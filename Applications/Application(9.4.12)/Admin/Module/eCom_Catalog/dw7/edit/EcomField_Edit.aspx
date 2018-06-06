<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomField_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomFieldEdit" %>

<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" TagName="FieldOptionsList" Src="~/Admin/Module/eCom_Catalog/dw7/controls/FieldOptionsList/FieldOptionsList.ascx" %>
<%@ Import Namespace="Dynamicweb" %>
<%@ Import Namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />

    <dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />

    <script type="text/javascript" src="/Admin/FormValidation.js"></script>

    <script type="text/javascript">
        var listTypeID = <%=ListTypeID %>;

        $(document).observe('dom:loaded', function () {
            window.focus(); // for ie8-ie9 
            document.getElementById('NameStr').focus();

            Event.observe('ddTypes', 'change', function () {
                displayStyleValue = $('ddTypes').value == listTypeID ? '' : 'none';
                $$('tr.row-presentation-type')[0].setStyle({display: displayStyleValue});
                $$('div.row-options')[0].setStyle({display: displayStyleValue});
            });
        });

        function checkfield(field){
            var result		= true;
            var fieldTmp	= field.toLowerCase();
            var validChars 	= "0123456789abcdefghijklmnopqrstuvwxyz";

            for (var i = 0; i < fieldTmp.length; i++) {
                if (validChars.indexOf(fieldTmp.charAt(i)) == -1) {
                    result = false;
                }
            }
        
            return result;
        }

        

        function save(close) {
            document.getElementById("Close").value = close ? 1 : 0;
            document.getElementById('Form1').SaveButton.click();
        }

        var deleteMsg = '<%= DeleteMessage %>';
        function deleteProductField() {
                <%If FieldType = Admin.eComBackend.EcomFieldEdit.RequestFieldType.Products Then %>
                if (confirm(deleteMsg)) document.getElementById('Form1').DeleteButton.click(); 
		        <% Else%>
                document.getElementById('Form1').DeleteButton.click();
		        <% End If%>
            }
    </script>
    <style>
        .richselectitem .description {
            font-size: 11px;
            margin-top: 4px;
        }
    </style>
</head>
<body class="area-pink screen-container">
    <div class="card">
        <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
        <form id="Form1" method="post" runat="server">
            <input id="Close" type="hidden" name="Close" value="0" />
            <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
            <asp:Literal ID="NoFieldsExistsForLanguageBlock" runat="server"></asp:Literal>
            <dwc:GroupBox runat="server" Title="Indstillinger">
                <table class="formsTable">
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelName" runat="server" Text="Navn" />
                        </td>
                        <td>
                            <asp:TextBox ID="NameStr" CssClass="std" runat="server" />
                            <small class="help-block error" id="errNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelSystemName" runat="server" Text="Systemnavn" />
                        </td>
                        <td>
                            <asp:TextBox ID="SystemNameStr" CssClass="std" runat="server" />
                            <small class="help-block error" id="errSystemNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelTemplatName" runat="server" Text="Template tag" />
                        </td>
                        <td>
                            <asp:TextBox ID="TemplateNameStr" CssClass="std" runat="server" />
                            <small class="help-block error" id="errTemplateNameStr"></small>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <dw:TranslateLabel ID="tLabelType" runat="server" Text="Felttype" />
                        </td>
                        <td>
                            <dwc:SelectPicker runat="server" ID="ddTypes" ClientIDMode="Static"></dwc:SelectPicker>                           
                        </td>
                    </tr>
                    <tr id="doNotRenderRow" runat="server">
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="DoNotRenderCheckBox" Label="Do not render" />
                        </td>
                    </tr>
                    <tr id="requiredRow" runat="server">
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="ValidationRequiredCheckBox" Label="Validation required" />
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td></td>
                        <td>
                            <dw:CheckBox runat="server" ID="Locked" Label="Lås felt" />
                        </td>
                    </tr>
                    <tr id="rowPresentationType" class="row-presentation-type" style="display: none" runat="server">
                        <td>
                            <dw:TranslateLabel ID="lbDisplayAs" Text="Visning_som" runat="server" />
                        </td>
                        <td>
                            <dw:Richselect runat="server" ID="ddPresentations" Height="0" Itemwidth="400" Width="400"></dw:Richselect>
                        </td>
                    </tr>
                </table>
            </dwc:GroupBox>
            <div id="rowOptions" class="row-options" style="display: none" runat="server">
                <dwc:GroupBox runat="server" Title="Options">
                    <ecom:FieldOptionsList ID="optionsList" runat="server" />
                </dwc:GroupBox>
            </div>

            <asp:Button ID="SaveButton" Style="display: none" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" runat="server"></asp:Button>
        </form>
    </div>
    <asp:Literal ID="BoxEnd" runat="server"></asp:Literal>

    <script type="text/javascript">
        addMinLengthRestriction('NameStr', 1, '<%=Translate.JsTranslate("A name is needed")%>');
        addMinLengthRestriction('SystemNameStr', 1, '<%=Translate.JsTranslate("A system name is needed")%>');
        addMinLengthRestriction('TemplateNameStr', 1, '<%=Translate.JsTranslate("A templatetag-name is needed")%>');
        activateValidation('Form1');
    </script>
    <%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
