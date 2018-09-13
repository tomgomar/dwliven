<%@ Page Language="vb" ValidateRequest="false" AutoEventWireup="false" CodeBehind="EcomFieldType_Edit.aspx.vb" Inherits="Dynamicweb.Admin.eComBackend.EcomFieldType_Edit" %>
<%@ Register TagPrefix="dw" Namespace="Dynamicweb.Controls" Assembly="Dynamicweb.Controls" %>
<%@ Register TagPrefix="dwc" Namespace="Dynamicweb.UI.Controls" Assembly="Dynamicweb.UI.Controls" %>
<%@ Register TagPrefix="ecom" TagName="FieldOptionsList" Src="~/Admin/Module/eCom_Catalog/dw7/controls/FieldOptionsList/FieldOptionsList.ascx" %>
<%@ Register TagPrefix="de" Namespace="Dynamicweb.Extensibility" Assembly="Dynamicweb" %>
<%@ Import namespace="Dynamicweb" %>
<%@ Import namespace="Dynamicweb.SystemTools" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title></title>
		<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
		
		<dw:ControlResources ID="ctrlResources" IncludePrototype="true" IncludeUIStylesheet="true" runat="server" />
		 <%= FieldTypeProviderSelector.Jscripts%>

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
            function save(close) {
                document.getElementById("Close").value = close ? 1 : 0;
                document.getElementById('fieldForm').SaveButton.click();
            }
		</script>
</head>
<body>
    <form id="fieldForm" runat="server">
        <asp:Literal ID="BoxStart" runat="server"></asp:Literal>
                    <input id="Close" type="hidden" name="Close" value="0" />
            <asp:Literal ID="TableIsBlocked" runat="server"></asp:Literal>
            <asp:Literal ID="NoFieldsExistsForLanguageBlock" runat="server"></asp:Literal>
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
                        <dw:TranslateLabel id="tLabelDynamicwebAlias" runat="server" Text="Dynamicweb alias" />
					</td>
					<td>
				        <asp:Textbox id="DynamicwebAliasStr" CssClass="std" runat="server" />
                        <small class="help-block error" id="errDynamicwebAliasStr"></small>
				    </td>
				</tr>
                <tr>
                    <td>
                        <dw:TranslateLabel ID="tLabelDBSQL" runat="server" Text="DB SQL" />
                    </td>
                    <td>
                        <asp:Textbox id="DBSQLStr" CssClass="std" runat="server" />
                        <small class="help-block error" id="errDBSQLStr"></small>                         
                    </td>
                </tr>
			</table>
            </dwc:GroupBox>

        <de:AddInSelector ID="FieldTypeProviderSelector" runat="server" AddInTypeName="Dynamicweb.Extensibility.Provider.FieldTypeProvider, Dynamicweb"/>
        <%= FieldTypeProviderSelector.LoadParameters %>

            <asp:Button ID="SaveButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
            <asp:Button ID="DeleteButton" Style="display: none" UseSubmitBehavior="true" runat="server"></asp:Button>
    </form>

		<%Dynamicweb.SystemTools.Translate.GetEditOnlineScript()%>
</body>
</html>
