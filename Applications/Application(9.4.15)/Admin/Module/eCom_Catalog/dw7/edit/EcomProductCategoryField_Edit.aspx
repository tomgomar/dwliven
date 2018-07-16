<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomProductCategoryField_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomProductCategoryField_Edit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" TagName="FieldOptionsList" Src="~/Admin/Module/eCom_Catalog/dw7/controls/FieldOptionsList/FieldOptionsList.ascx" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
		<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
		
		<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
		

		<style>
            .richselectitem .description {
                font-size: 11px;
                margin-top: 4px;
            }

		    .warning-icon {
		        width: 16px;
		        height: 16px;
                display: inline-block;
                vertical-align: middle;
		        background-repeat: no-repeat;
		        background-image: url(/Admin/Images/Ribbon/Icons/Small/warning.png);
		    }
		</style>

		<script type="text/javascript">
            var listTypeID = <%= ListTypeID %>;
            var checkBoxTypeID = <%= CheckBoxTypeID %>;

            $(document).observe('dom:loaded', function () {
                window.focus(); // for ie8-ie9 
                document.getElementById('NameStr').focus();
                findInvalidValues();

                Event.observe('ddTypes', 'change', function () {
                    displayStyleValue = $('ddTypes').value == listTypeID ? '' : 'none';
                    $$('tr.row-presentation-type')[0].setStyle({display: displayStyleValue});
                    $$('div.row-options')[0].setStyle({display: displayStyleValue});

                    displayStyleValue = $('ddTypes').value == checkBoxTypeID ? '' : 'none';
                    $$('tr.row-checkbox')[0].setStyle({display: displayStyleValue});
                });
            });

            function findInvalidValues() {
                var optionRows = document.getElementById('optionsList_optionsGrid').rows;

                if (!optionRows) return 0;

                for (var i = 2; i < optionRows.length - 1; i++) 
                {                    
                    var oValue = document.getElementById(optionRows[i].id + '_txValue').value;
                    var oDisabled = document.getElementById(optionRows[i].id + '_txValue').disabled;
                                            
                    if (oValue && oValue.match(/[^a-z0-9_]+/i) && oDisabled){
                        var errorMessage = '<div class="warning-icon" title="<%= Translate.Translate("Option value has one or more invalid characters") %>"></div>';
                        var td = $(optionRows[i].id + '_txValue').up(0);

                        td.innerHTML += errorMessage;
                    }
                }
            }
		</script>
</head>
<body>
    <form id="fieldForm" runat="server">
        <dwc:GroupBox runat="server" Title="Indstillinger">
			<table class="formsTable disableMedia">
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
                        <dw:TranslateLabel id="tLabelTemplatName" runat="server" Text="Template tag" />
					</td>
					<td>
				        <asp:Textbox id="TemplateNameStr" CssClass="std" runat="server" />
                        <small class="help-block error" id="errTemplateNameStr"></small>
				    </td>
				</tr>
                <tr>
                    <td>
                        <dw:TranslateLabel ID="TranslateLabel1" runat="server" Text="Felttype" />
                    </td>
                    <td>
                        <dwc:SelectPicker runat="server" ID="ddTypes" ClientIDMode="Static"></dwc:SelectPicker>                           
                    </td>
                </tr>
                <tr id="rowPresentationType" class="row-presentation-type" style="display:none" runat="server">
                    <td>
                        <dw:TranslateLabel ID="lbDisplayAs" Text="Visning_som" runat="server" />
                    </td>
                    <td>
                        <dw:Richselect runat="server" ID="ddPresentations" Itemwidth="300" Width="300"></dw:Richselect>
                    </td>
                </tr>
                <tr id="rowCheckbox" class="row-checkbox" style="display: none" runat="server">
                    <td></td>
					<td><dw:CheckBox runat="server" ID="chkDefaultValue" Label="Default value" /></td>
                </tr>

			</table>
            </dwc:GroupBox>
            <div id="rowOptions" class="row-options" style="display: none" runat="server">
                <dwc:GroupBox runat="server" Title="Options">
                    <div id="errFieldOptions" style="color: Red;"></div>
                    <ecom:FieldOptionsList ID="optionsList" runat="server" />
                </dwc:GroupBox>
            </div>
    </form>

		<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
